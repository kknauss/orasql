/* ******************************************************************************
 *  ASSUMPTIONS
 *
 *	TNS connections
 *		has form:                    jdbc:oracle:oci8:@SID
 *
 *	BASIC connections
 *		using SID has form:          jdbc:oracle:thin:@aix22:1521:IDB
 *		using service name has form: jdbc:oracle:thin:@aix22:1521/IDB.world
 *
 *	JDBC connections 
 *		has form:                    jdbc:oracle:thin:@(DESCRCIPTION...
 *
 * ****************************************************************************** */
#include <windows.h>
#include <unistd.h>
#include <stdio.h>
#include <ctype.h>

#define   TRUE           1
#define   FALSE          0
#define   MAXSTRLEN      1024
#define   SQLD_ARGS     "-g -u ${sqldev.dbuser} -c ${sqldev.conn} -f ${file.name} -d ${file.dir}"
#define   SQLD_RUNDIR   "LEAVE THIS FIELD BLANK"

char * removews  (char *);
char * uppercase (char *);
void show_params (char *);

int main (int argc, char **argv)
{
	int	 c, 
		 i=0, 
		 isServiceName = FALSE;

	char	*token =  "-",
		*fdir  =  "-",
		*fname =  "-",
		*usern =  "-",
		*delim =  " ",
		*uppertoken =  "-",
		 pgm[MAXSTRLEN] = "sqlplus",
		 connectstr[MAXSTRLEN] = "",
		 sid[MAXSTRLEN] = "";


	while ((c = getopt (argc, argv, ":gpc:d:f:u:")) != -1)
	{
		switch (c)
		{
			case 'g':
					strcpy(pgm, "sqlplusw");
					break;
			case 'c':
					token = optarg;
					break;
			case 'u':
					usern = optarg;
					break;
			case 'f':
					fname = optarg;
					break;
			case 'd':
					fdir = optarg;
					break;
			case 'p':
					show_params(argv[0]);
					return 0;
			case ':':
					fprintf (stderr, "Option -%c requires an argument.\n", optopt);
					return 1;
			case '?':
					fprintf (stderr, "Unknown option `-%c'.\n", optopt);
					return 1;
			default:
					return -1;
		}
	}

	if (token[0] == '-') token = NULL;
	if (usern[0] == '-') usern = NULL;
	if ( fdir[0] == '-') fdir  = NULL;
	if (fname[0] == '-') fname = NULL;

	if (token != NULL)
	{
		token = removews(token);

		if ((strchr(token, '@')) != NULL)
		{
			token = (char *)strtok(token, "@");

			if ( (strcmp(token, "jdbc:oracle:oci8:")) == 0)
			{
				/*
				 *  Parse TNS configured connection...
				*/
				delim = ":";
				token = (char *)strtok(NULL, delim);
				strcat(sid, token);
			}

			if ( (strcmp(token, "jdbc:oracle:thin:")) == 0)
			{
				delim = "";
				token = (char *)strtok(NULL, delim);
				c = token[0];

				if (c == '(')
				{
					/*
 	 				*  Parse JDBC configured connection...
 					*/
					sid[0] = '"';
					strcat(sid, token);
					strcat(sid, (char *)"\"");
				}
				else
				{
					/*
 	 				*  Parse BASIC configured connection (build JDBC string)...
 					*/
					delim = ":";
					token = (char *)strtok(token, delim);
		
					while (token != NULL)
					{
						i++; 
						if (i == 1)
						{
							strcpy(sid, (char *)"(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=");
							strcat(sid, token);
						}

						if (i == 2)
						{
							if (  (strchr(token, '/')) != NULL)
							{
								isServiceName = TRUE;
								delim = "/";
								token = (char *)strtok(token, delim);
							}
							strcat(sid, (char *)")(PORT=");
							strcat(sid, token);
						}
		
						if (i == 3) 
						{

							if (  isServiceName == TRUE )
								strcat(sid, (char *)"))(CONNECT_DATA=(SERVICE_NAME=");
							else
								strcat(sid, (char *)"))(CONNECT_DATA=(SID=");
		
							strcat(sid, token);
							strcat(sid, (char *)")))");
						}
		
						token = (char *)strtok(NULL, delim);
					}
				}
			}
		}
		else
		{
			uppertoken = token;
			uppertoken = uppercase(uppertoken);
			if ( (strncmp(uppertoken, "(DESCRIPTION", 12)) == 0)
			{
				strcpy(sid, "\"");
				strcat(sid, token);
				strcat(sid, "\"");
			}
		}
	}

	if ( (fname == NULL) || (fdir == NULL) )
	{
		if ( (usern == NULL) || ((strcmp(sid, "")) == 0) )
			connectstr[0] = 0;
		else
			sprintf(connectstr, "%s@%s", usern, sid );
	}
	else
	{
		if ( (usern == NULL) || ((strcmp(sid, "")) == 0) )
			connectstr[0] = 0;
		else
			sprintf(connectstr, "%s@%s @%s", usern, sid, fname );
	}

#ifdef DEBUG
	printf("Program:        %s\n", pgm);
	printf("User name:      %s\n", usern);
	printf("File directory: %s\n", fdir);
	printf("File name:      %s\n", fname);
        printf("Connection:     %s\n", connectstr);
#endif

#ifndef NOEXEC
        if ( (fname == NULL) || (fdir == NULL) )
                (int)ShellExecute(NULL, "open", pgm, connectstr, NULL, SW_SHOWNORMAL);
        else
                (int)ShellExecute(NULL, "open", pgm, connectstr, fdir, SW_SHOWNORMAL);
#endif
}
	

/* ************************************************************************** *\
|                                                                              | 
\* ************************************************************************** */
char * uppercase (char *s)
{
	int i, j=-1;
	char d[MAXSTRLEN], c;

	for (i=0; i<strlen(s); i++)
	{
		c = s[i];
		d[++j] = toupper( c );
	}

	d[++j]='\0';
	s = d;
	return s ;
}

/* ************************************************************************** *\
|                                                                              | 
\* ************************************************************************** */
char * removews (char *thestring)
{
	int i, j=-1;
	char newstring[MAXSTRLEN];

	for (i=0; i<strlen(thestring); i++)
		if (thestring[i] != ' ')
			newstring[++j] = thestring[i];

	newstring[++j]='\0';
	thestring = newstring;
	return thestring ;
}

/* ************************************************************************** *\
|                                                                              | 
\* ************************************************************************** */
void show_params (char *thepgm)
{
	printf("Program Executable:    %s\n", thepgm);
	printf("Arguments:             %s\n", SQLD_ARGS);
	printf("Run Directory:         %s\n", SQLD_RUNDIR);
}
