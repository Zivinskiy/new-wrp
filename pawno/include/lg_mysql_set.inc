stock LoadMySQLSettings()
{
	new FileID = ini_openFile("mysql_settings.ini"),errCode;
	if(FileID < 0)
	{
		printf("Error while opening MySQL settings file. Error code: %d",FileID);
		return 0;
	}
	errCode = ini_getString(FileID,"host",MySQLSettings[HOST]);
	if(errCode < 0) printf("Error while reading MySQL settings file (host). Error code: %d",errCode);
	errCode = ini_getString(FileID,"username",MySQLSettings[USERNAME]);
	if(errCode < 0) printf("Error while reading MySQL settings file (username). Error code: %d",errCode);
	errCode = ini_getString(FileID,"password",MySQLSettings[PASSWORD]);
	if(errCode < 0) printf("Error while reading MySQL settings file (password). Error code: %d",errCode);
	errCode = ini_getString(FileID,"database",MySQLSettings[DATABASE]);
	if(errCode < 0) printf("Error while reading MySQL settings file (database). Error code: %d",errCode);
	ini_closeFile(FileID);
	return 1;
}
