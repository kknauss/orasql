/* ******************************************************************************
 * ****************************************************************************** */
#include <windows.h>
#include <stdio.h>

#define   MAXSTRLEN      1024

BOOL CtrlHandler( DWORD ); 

int main (int argc, char **argv)
{
	char	*fdir  =  "-",
		pgm[MAXSTRLEN] = "sqlplus";

	if( SetConsoleCtrlHandler( (PHANDLER_ROUTINE) CtrlHandler, TRUE ) ) { 
		printf( "\nThe Control Handler is installed.\n" ); 
	} 

	if ( fdir == NULL )
		(int)ShellExecute(NULL, "open", pgm, NULL, NULL, SW_SHOWNORMAL);
	else
		(int)ShellExecute(NULL, "open", pgm, NULL, fdir, SW_SHOWNORMAL);
}


BOOL CtrlHandler( DWORD fdwCtrlType ) 
{ 
	return TRUE ;
}   
