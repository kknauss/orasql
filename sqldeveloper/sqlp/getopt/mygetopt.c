#include <stdio.h>     /* for printf */
#include <stdlib.h>    /* for exit */

int myoptind=0;
int mygetopt (int , char **, char *);

int main (int argc, char **argv)
{
	int c;

	while (1)
	{
		c = mygetopt (argc, argv, "abc:d:");

		if (c == -1) break;

		switch (c)
		{
			case 'a':
				printf ("option a\n");
				break;
			case 'b':
				printf ("option b\n");
				break;
			case 'c':
				printf ("option c\n");
				break;
			case 'd':
				printf ("option d\n");
				break;
			default:
				printf ("?? getopt returned character code 0%o ??\n", c);
		}
	}
	exit (0);
}

int mygetopt (int n, char **v, char *f)
{
	myoptind++;

	if (myoptind == n)
		return -1;

	//printf("V: %s\n", v[myoptind] );
	//printf("V: %c\n", v[myoptind][0] );
	//printf("V: %c\n", v[myoptind][1] );

	if ( v[myoptind][0] == '-' )
		if ( isprint( v[myoptind][1] ) )
			printf("V: %c\n", v[myoptind][1] );
	
	return 'a';
}
