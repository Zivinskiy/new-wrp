	if(!strcmp(cmd,"/jp",true))
	{
		if(pData[playerid][pLanguage] & LANG_JAPAN == 0) return SendClientMessage(playerid,CGRAY,"Вы не знаете японский язык");
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: Введите /jp [текст]");
		Speech(playerid,tmp,LANG_JAPAN);
	}
	if(!strcmp(cmd,"/it",true))
	{
		if(pData[playerid][pLanguage] & LANG_ITALIAN == 0) return SendClientMessage(playerid,CGRAY,"Вы не знаете итальянский язык");
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: Введите /it [текст]");
		Speech(playerid,tmp,LANG_ITALIAN);
	}
	if(!strcmp(cmd,"/fr",true))
	{
		if(pData[playerid][pLanguage] & LANG_FRENCH == 0) return SendClientMessage(playerid,CGRAY,"Вы не знаете французский язык");
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: Введите /mx [текст]");
		Speech(playerid,tmp,LANG_FRENCH);
	}
	if(!strcmp(cmd,"/pt",true))
	{
		if(pData[playerid][pLanguage] & LANG_PORTUGAL == 0) return SendClientMessage(playerid,CGRAY,"Вы не знаете португальский язык");
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: Введите /mx [текст]");
		Speech(playerid,tmp,LANG_PORTUGAL);
	}
	if(!strcmp(cmd,"/is",true))
	{
		if(pData[playerid][pLanguage] & LANG_SPAIN == 0) return SendClientMessage(playerid,CGRAY,"Вы не знаете испанский язык");
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: Введите /mx [текст]");
		Speech(playerid,tmp,LANG_SPAIN);
	}
	if(!strcmp(cmd,"/ru",true))
	{
		if(pData[playerid][pLanguage] & LANG_RUSSIAN == 0)  return SendClientMessage(playerid,CGRAY,"Вы не знаете русский язык");
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: Введите /mx [текст]");
		Speech(playerid,tmp,LANG_RUSSIAN);
	}

