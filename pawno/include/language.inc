	if(!strcmp(cmd,"/jp",true))
	{
		if(pData[playerid][pLanguage] & LANG_JAPAN == 0) return SendClientMessage(playerid,CGRAY,"�� �� ������ �������� ����");
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /jp [�����]");
		Speech(playerid,tmp,LANG_JAPAN);
	}
	if(!strcmp(cmd,"/it",true))
	{
		if(pData[playerid][pLanguage] & LANG_ITALIAN == 0) return SendClientMessage(playerid,CGRAY,"�� �� ������ ����������� ����");
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /it [�����]");
		Speech(playerid,tmp,LANG_ITALIAN);
	}
	if(!strcmp(cmd,"/fr",true))
	{
		if(pData[playerid][pLanguage] & LANG_FRENCH == 0) return SendClientMessage(playerid,CGRAY,"�� �� ������ ����������� ����");
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /mx [�����]");
		Speech(playerid,tmp,LANG_FRENCH);
	}
	if(!strcmp(cmd,"/pt",true))
	{
		if(pData[playerid][pLanguage] & LANG_PORTUGAL == 0) return SendClientMessage(playerid,CGRAY,"�� �� ������ ������������� ����");
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /mx [�����]");
		Speech(playerid,tmp,LANG_PORTUGAL);
	}
	if(!strcmp(cmd,"/is",true))
	{
		if(pData[playerid][pLanguage] & LANG_SPAIN == 0) return SendClientMessage(playerid,CGRAY,"�� �� ������ ��������� ����");
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /mx [�����]");
		Speech(playerid,tmp,LANG_SPAIN);
	}
	if(!strcmp(cmd,"/ru",true))
	{
		if(pData[playerid][pLanguage] & LANG_RUSSIAN == 0)  return SendClientMessage(playerid,CGRAY,"�� �� ������ ������� ����");
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /mx [�����]");
		Speech(playerid,tmp,LANG_RUSSIAN);
	}

