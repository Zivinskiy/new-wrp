	//����� �������
	if(!strcmp(cmd,"/makeleader",true))
	{
		if(pData[playerid][pAdmin] < 5) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /makeleader [ID ������]");
		new actplayerid = strval(tmp);
		if(!IsPlayerConnected(actplayerid)) return SendClientMessage(playerid,CGRAY,"�������� ID ������");
		if(pData[actplayerid][pWarn]) return SendClientMessage(playerid,CGRAY,"� ������ ���� ����");
		SetPVarInt(playerid,"actplayerid",actplayerid);
		new mes[256];
		for(new i;i<FRACTION_COUNT;i++)
		{
			format(mes,sizeof(mes),"%s%s\n",mes,gFractionName[i]);
		}
		ShowPlayerDialog(playerid,dLeaderskin,2,pData[actplayerid][pNickname],mes,"�����","������");
	}
	if(!strcmp(cmd,"/auninvite",true))
	{
		if(pData[playerid][pAdmin] < 3) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /auninvite [ID ������]");
		new actplayerid = strval(tmp);
		if(!IsPlayerConnected(actplayerid)) return SendClientMessage(playerid,CGRAY,"�������� ID ������");
		if(!pData[actplayerid][pFraction]) return SendClientMessage(playerid,CGRAY,"����� �� ������� �� �������");
		new query[128];
		format(query,sizeof(query),"UPDATE `accounts` SET `fraction` = '0', `rank` = '0', `fractionskin` = '0', `subfraction` = '0' WHERE `id` = '%d'",pData[actplayerid][pMysqlID]);
		mysql_query(query);
		if(mysql_errno()) return SendClientMessage(playerid,CRED,"������ MySQL");
		pData[actplayerid][pFraction] = 0;
		pData[actplayerid][pRank] = 0;
		pData[actplayerid][pFractionSkin] = 0;
		pData[actplayerid][pSubfraction] = 0;
		SetPlayerColor(actplayerid,0xFFFFFF11);
		new houseid = pData[actplayerid][pHouse]-1;
		if(!(houseid+1) || ((houseid+1) > 0 && pData[actplayerid][pMysqlID] != gHouses[houseid][houseOwnerID])) SetPlayerSkin(actplayerid,pData[actplayerid][pSkin]);
		else if(!gHouses[houseid][houseImprove][3]) SetPlayerSkin(actplayerid,pData[actplayerid][pSkin]);
		else
		{
			for(new x; x < 3; x ++) {
				if(!gHouses[houseid][houseSkin]) continue;
				pData[actplayerid][pSkin] = gHouses[houseid][houseSkin];
				if(GetPlayerSkin(actplayerid) == gHouses[houseid][houseSkin][3]) SetPlayerSkin(actplayerid,pData[actplayerid][pSkin]);
			}
			gHouses[houseid][houseSkin][3] = 0;
		}
		new mes[128];
		format(mes,sizeof(mes),"�� ���� ������� �� ����������� ��������������� %s",pData[playerid][pNickname]);
		SendClientMessage(actplayerid,CBADINFO,mes);
		format(mes,sizeof(mes),"%s ��� ������ �� �����������",pData[actplayerid][pNickname]);
		SendClientMessage(playerid,CINFO,mes);
	}
	if(!strcmp(cmd,"/kick",true))
	{
		if(pData[playerid][pAdmin] < 2) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /kick [ID ������] [�������]");
		new id = strval(tmp);
		if(!IsPlayerConnected(id) || IsKicked(id)) return SendClientMessage(playerid,CGRAY,"�������� ID");
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /kick [ID ������] [�������]");
		new mes[128], nick[24];
		GetPlayerName(id,nick,24);
		format(mes,sizeof(mes),"������������� %s ������ ������ %s. �������: %s",pData[playerid][pNickname],nick,tmp);
		SendAdminMessage(CADMIN,mes,id);
		NewKick(id);
	}
	if(!strcmp(cmd,"/ban",true))
	{
		if(pData[playerid][pAdmin] < 3) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /ban [ID ������] [�-�� ����] [�������]");
		new id = strval(tmp);
		if(!IsPlayerConnected(id) || IsKicked(id)) return SendClientMessage(playerid,CGRAY,"�������� ID");
		if(!pData[id][pMysqlID])
		{
			NewKick(id);
			return SendClientMessage(playerid,CGRAY,"���� ����� �� ���������������, ������� ��� ������");
		}
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /ban [ID ������] [�-�� ����] [�������]");
		new time = strval(tmp);
		if(time < 1 || time > 30 && pData[playerid][pAdmin] < 5) return SendClientMessage(playerid,CGRAY,"�� ������ �-�� ����");
		if(time < 0 || time > 30 && pData[playerid][pAdmin] >= 5) return SendClientMessage(playerid,CGRAY,"�� ������ �-�� ����");
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /ban [ID ������] [�-�� ����] [�������]");
		new mes[128];
		new nick[24];
		if(ServerBan(playerid,id,time,tmp)) return SendClientMessage(playerid,CRED,"������ MySQL");
		GetPlayerName(id,nick,24);
		format(mes,sizeof(mes),"������������� %s ������� ������ %s. �-�� ����: %d. �������: %s",pData[playerid][pNickname],nick,time,tmp);
		SendAdminMessage(CADMIN,mes,id);
		NewKick(id);
	}
	if(!strcmp(cmd,"/warn",true))
	{
		if(pData[playerid][pAdmin] < 3) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /warn [ID ������] [�������]");
		new id = strval(tmp);
		if(!IsPlayerConnected(id) || IsKicked(id)) return SendClientMessage(playerid,CGRAY,"�������� ID");
		if(!pData[id][pMysqlID]) return SendClientMessage(playerid,CGRAY,"���� ����� �� ���������������");
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /warn [ID ������] [�������]");
		new mes[128];
		format(mes,sizeof(mes),"/auninvite %d",id);
		OnPlayerCommandText(playerid,mes);
		new level = floatround(float(pData[id][pWarn] - gCurDay) / WARN_TIME,floatround_ceil);
		if(!pData[playerid][pWarn] || level <= 2)
		{
			if(pData[id][pWarn] > gCurDay) pData[id][pWarn] += WARN_TIME;
			else pData[id][pWarn] = gCurDay + WARN_TIME;
			UpdatePlayerData(id,"warn",pData[id][pWarn]);
			format(mes,sizeof(mes),"������������� %s ����� warn ������ %s. �������: %s",pData[playerid][pNickname],pData[id][pNickname],tmp);
		}
		else
		{
			pData[id][pWarn] = 0;
			UpdatePlayerData(id,"warn",pData[id][pWarn]);
			format(mes,sizeof(mes),"������������� %s ������� ������ %s (3 �������������). �������: %s",pData[playerid][pNickname],pData[id][pNickname],tmp);
			ServerBan(playerid,id,5,tmp);
		}
		SendAdminMessage(CADMIN,mes,id);
		NewKick(id);
	}
	if(!strcmp(cmd,"/unwarn",true))
	{
		if(pData[playerid][pAdmin] < 3) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /unwarn [ID ������]");
		new id = strval(tmp);
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid,CGRAY,"�������� ID");
		if(!pData[id][pMysqlID]) return SendClientMessage(playerid,CGRAY,"���� ����� �� ���������������");
		if(!pData[id][pWarn]) return SendClientMessage(playerid,CGRAY,"� ������ ��� ������");
		pData[id][pWarn] = 0;
		UpdatePlayerData(id,"warn",pData[id][pWarn]);
		new mes[128];
		format(mes,sizeof(mes),"[A] %s ����(�) warn %s",pData[playerid][pNickname],pData[id][pNickname]);
		AdminChat(CORANGE,mes);
		format(mes,sizeof(mes),"������������� %s ���� ��� warn",pData[playerid][pNickname]);
		SendClientMessage(id,CADMIN,mes);
	}
	if(!strcmp(cmd,"/unmute",true))
	{
		if(!pData[playerid][pAdmin]) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /unmute [ID ������]");
		new id = strval(tmp);
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid,CGRAY,"�������� ID");
		if(!pData[id][pMysqlID]) return SendClientMessage(playerid,CGRAY,"���� ����� �� ���������������");
		pData[id][pMut] = 0;
		UpdatePlayerData(id,"mut",0);
		new mes[128];
		format(mes,sizeof(mes),"[A] %s ����(�) �������� %s",pData[playerid][pNickname],pData[id][pNickname]);
		AdminChat(CORANGE,mes);
		format(mes,sizeof(mes),"������������� %s ���� ��� ��������",pData[playerid][pNickname]);
		SendClientMessage(playerid,CADMIN,mes);
	}
	if(!strcmp(cmd,"/unban",true))
	{
		if(pData[playerid][pAdmin] < 4) return 1;
		tmp = strrest(cmdtext,idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /unmute [������� ������]");
		mysql_real_escape_string(tmp,tmp);
		new query[128],result[12];
		format(query,sizeof(query),"SELECT `id` FROM `accounts` WHERE `nickname` = '%s'",tmp);
		mysql_query(query);
		mysql_store_result();
		if(!mysql_num_rows()) return SendClientMessage(playerid,CGRAY,"�������� �������");
		mysql_fetch_row(result);
		new id = strval(result);
		mysql_free_result();
		format(query,sizeof(query),"DELETE FROM `ban` WHERE `takeid` = '%d'",id);
		mysql_query(query);
		if(!mysql_affected_rows()) return SendClientMessage(playerid,CGRAY,"����� �� �������");
		else
		{
			format(query,sizeof(query),"[A] %s �������� %s",pData[playerid][pNickname],tmp);
			AdminChat(CORANGE,query);
			printf("%s unbanned %s",pData[playerid][pNickname],tmp);
		}
	}
	if(!strcmp(cmd,"/sp",true))
	{
		if(pData[playerid][pAdmin] < 1) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /sp [ID ������]");
		new id = strval(tmp);
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid,CGRAY,"�������� ID");
		if((pData[playerid][pAdmin] < 5 && pData[id][pAdmin] >= 5) || pData[id][pMysqlID] == 39854) return SendClientMessage(playerid, CADMIN, "������ �������!");
		if(pTemp[id][pSpectator] != INVALID_PLAYER_ID)
		{
			new mes[128];
			format(mes,sizeof(mes),"%s ��� ������ �� ���� �������",pData[pTemp[id][pSpectator]][pNickname]);
			SendClientMessage(playerid,CGRAY,mes);
		}
		TogglePlayerSpectating(playerid,1);
		new pstate = GetPlayerState(id);
		new vehicleid = GetPlayerVehicleID(id);
		new Float:x,Float:y, Float:z;
		GetPlayerPos(playerid,x,y,z);
		SetPVarFloat(playerid,"oldx",x);
		SetPVarFloat(playerid,"oldy",y);
		SetPVarFloat(playerid,"oldz",z);
		SetPVarInt(playerid,"oldint",GetPlayerInterior(playerid));
		SetPVarInt(playerid,"oldworld",GetPlayerVirtualWorld(playerid));
		pTemp[playerid][pSpectating] = true;
		pTemp[id][pSpectator] = playerid;
		pTemp[playerid][pSpectatee] = id;
		SetPlayerInterior(playerid,GetPlayerInterior(id));
		SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(id));
		if(pstate == PLAYER_STATE_DRIVER || pstate == PLAYER_STATE_PASSENGER) PlayerSpectateVehicle(playerid,vehicleid);
		else PlayerSpectatePlayer(playerid,id);
	}
	if (!strcmp(cmd,"/id",true))
	{
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /id [��� ������]");
		new id=-1,name[24];
		if(!isNumeric(tmp))
		{
			for(new i;i<MAX_PLAYERS;i++)
			{
				if(!IsPlayerConnected(i)) continue;
				GetPlayerName(i,name,24);
				if(strfind(name,tmp,true) != -1) {id = i; break;}
			}
			if(id == -1) return SendClientMessage(playerid,CGRAY,"�� �������");
		}
		else
		{
			id = strval(tmp);
			if(!IsPlayerConnected(id)) return SendClientMessage(playerid,CGRAY,"�� ������ ID");
			GetPlayerName(id,name,24);
		}
		new mes[128];
		format(mes,sizeof(mes),"%s [%d]",name,id);
		SendClientMessage(playerid,CWHITE,mes);
		return 1;
	}
	if(!strcmp(cmd,"/ans",true))
	{
		if(pData[playerid][pAdmin] < 1) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /ans [ID ������] [�����]");
		new id = strval(tmp);
		tmp = strrest(cmdtext, idx);
		new mes[128];
		format(mes,sizeof(mes),"����� �� %s: %s",pData[playerid][pNickname],tmp);
		SendClientMessage(id,CYELLOW,mes);
		format(mes,sizeof(mes),"[A] %s �������(�) %s: %s",pData[playerid][pNickname],pData[id][pNickname],tmp);
		AdminChat(CORANGE,mes);
	}
	if(!strcmp(cmd,"/admin",true))
	{
		if(pData[playerid][pAdmin] < 3) return 1;
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /admin [���������]");
		new mes[128];
		format(mes,sizeof(mes),"������������� %s: %s",pData[playerid][pNickname],tmp);
		SendClientMessageToAll(CADMIN,mes);
	}
	if(!strcmp(cmd,"/admins",true))
	{
		if(pData[playerid][pAdmin] < 3) return 1;
		SendClientMessage(playerid,CINFO,"�������������� ������:");
		for(new i;i<MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i) || !pData[i][pAdmin]) continue;
			new mes[40];
			format(mes,sizeof(mes),"%s [%d] Level: %d",pData[i][pNickname],i,pData[i][pAdmin]);
			SendClientMessage(playerid,CSYSTEM,mes);
		}
	}
	if(!strcmp(cmd,"/sethp",true))
	{
		if(pData[playerid][pAdmin] < 3) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /sethp [ID ������] [��������]");
		new id = strval(tmp);
		tmp = strtok(cmdtext, idx);
		new Float:health;
		health = floatstr(tmp);
		if(health > 100.0) return SendClientMessage(playerid,CGRAY,"������ ������ 100");
		SetPlayerHealthEx(id,health);
	}
	if(!strcmp(cmd,"/mute",true))
	{
		if(!pData[playerid][pAdmin]) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /mut [ID ������] [�-�� �����] [�������]");
		new id = strval(tmp);
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid,CGRAY,"�������� ID");
		if(!pData[id][pMysqlID]) return SendClientMessage(playerid,CGRAY,"���� ����� �� ���������������");
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /mut [ID ������] [�-�� �����] [�������]");
		new time = strval(tmp);
		if(time < 1 || time > 600) return SendClientMessage(playerid,CGRAY,"�� ������ �-�� �����");
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /mut [ID ������] [�-�� �����] [�������]");
		pData[id][pMut] = time;
		UpdatePlayerData(id,"mut",time);
		new mes[128];
		format(mes,sizeof(mes),"������������� %s ����� ������� ������ %s �� %d �����(�). �������: %s",pData[playerid][pNickname],pData[id][pNickname],time,tmp);
		SendAdminMessage(CADMIN,mes,id);
	}
	if(!strcmp(cmd,"/respawn",true))
	{
		if(pData[playerid][pAdmin] < 3) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /respawn [ID ����]");
		new id = strval(tmp);
		for(new i;i<MAX_PLAYERS;i++)
		{
			if(pTemp[i][pBusID] == id) pTemp[i][pBusID] = INVALID_PLAYER_ID;
		}
		SetVehicleToRespawn(id);
	}
	if(!strcmp(cmd,"/givemoney",true))
	{
		if(!IsPlayerAdmin(playerid)) return 1;
		if(pData[playerid][pAdmin] < 7) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /givemoney [ID ������] [�-�� �����]");
		new id = strval(tmp);
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid,CGRAY,"�������� ID ������");
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /givemoney [ID ������] [�-�� �����]");
		new money = strval(tmp);
		if(money < 1 || money > 5000000) return SendClientMessage(playerid,CGRAY,"�������� �����");
		TransferMoney(-1,id,money,"admingive");
		//GivePlayerMoneyEx(id,money,"admingive");
	}
	if(!strcmp(cmd,"/fillcar",true))
	{
		if(pData[playerid][pAdmin] < 3) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /fillcar [ID ����]");
		new vid = strval(tmp);
		new model = GetVehicleModel(vid);
		if(!model) return SendClientMessage(playerid,CGRAY,"�������� ID ����");
		gVehicles[vid-1][vFuel] = gTransport[model - 400][trTank];
	}
	if(!strcmp(cmd,"/gtv",true))
	{
		if(pData[playerid][pAdmin] < 3) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /gtv [ID ����]");
		new id = strval(tmp);
		new Float:x, Float:y, Float:z;
		GetVehiclePos(id,x,y,z);
		x += 2.0;
		SetPlayerPos(playerid,x,y,z);
	}
	if(!strcmp(cmd,"/stats",true))
	{
		tmp = strtok(cmdtext, idx);
		new id = strval(tmp);
		if(!strlen(tmp)) id = playerid;
		if(!pData[playerid][pAdmin] && id != playerid) return 1;
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid,CGRAY,"�������� ID");
		if(!pData[id][pMysqlID]) return SendClientMessage(playerid,CGRAY,"���� ����� �� �����-�");
		new sex[12],spouse[MAX_PLAYER_NAME],query[64],fraction[32],job[32],rank[32],classname[20],bussiness[32],housenumber[12];
		if(pData[id][pSpouse])
		{
			format(query,sizeof(query),"SELECT `nickname` FROM `accounts` WHERE `id` = '%d'",pData[id][pSpouse]);
			mysql_query(query);
			mysql_store_result();
			mysql_fetch_row(spouse);
			mysql_free_result();
		}
		else strcat(spouse,"�����������");
		if(pData[id][pSex] == 2) sex = "�������";
		else sex = "�������";
		new wanted,warn;
		if(pData[id][pWanted]) wanted = del(pData[id][pWanted],WANTED_TIME);
		if(pData[id][pWarn]) warn = del(pData[id][pWarn]-gCurDay,WARN_TIME);
		new fractionid = pData[id][pFraction]-1;
		if(!pData[id][pFraction]) {fraction = "�����������"; rank="�����������";}
		else
		{
			strcat(fraction,gFractionName[fractionid]);
			strcat(rank,gFractionRankName[fractionid][pData[id][pRank]-1]);
		}
		if(pData[id][pSubfraction])
		{
			new frid = GetSubfractionID(fractionid);
			new subid = pData[id][pSubfraction] - 1;
			if(pData[id][pSubfraction]) strcat(job,gSubfractionName[frid][subid]);
			else if(pData[id][pRank] == 10) job = "������������";
			else job = "����������";
		}
		else if(pData[id][pJob]) strcat(job,gJobNames[pData[id][pJob]-1]);
		else job = "�����������";
		if(pData[id][pHouse])
		{
			format(housenumber,sizeof(housenumber),"%d",pData[id][pHouse]);
			switch(gHouses[pData[id][pHouse]-1][houseClass])
			{
				case 0:classname = "[������]";
				case 1:classname = "[C������]";
				case 2:classname = "[�������]";
				case 3:classname = "[�������]";
				default: classname = "[����������]";
			}
		}
		else format(housenumber,sizeof(housenumber),"�����������");
		if(!pData[id][pBusiness]) bussiness = "�����������";
		else
		{
			new businessid = pData[id][pBusiness] - 1;
			if(businessid < FILLING_ID_OFFSET) format(bussiness,sizeof(bussiness),"%s",gBusiness[businessid][busiName]);
			else format(bussiness,sizeof(bussiness),"���");
		}
		new str[166],sctring[1450];
		format(str,sizeof(str),"{ffffff}_______________________________________________________________\n\n");
		strcat(sctring,str);
		format(str,sizeof(str),"\t{ffffff}���: \t\t\t\t\t%s \n\n",pData[id][pNickname]);
		strcat(sctring,str);
		format(str,sizeof(str),"\t{ffffff}�������: \t\t\t\t%d \n",pData[id][pLevel]);
		strcat(sctring,str);
		format(str,sizeof(str),"\t{ffffff}EXP: \t\t\t\t\t%d / %d \n",pData[id][pExp],pData[id][pLevel]*6);
		strcat(sctring,str);
		format(str,sizeof(str),"\t{ffffff}WARN: \t\t\t\t\t%s \n\n",warn); ///
		strcat(sctring,str);
		format(str,sizeof(str),"\t{ffffff}���: \t\t\t\t\t%s \n",sex);
		strcat(sctring,str);
		format(str,sizeof(str),"\t{ffffff}������� �������: \t\t\t%d \n",wanted);
		strcat(sctring,str);
		format(str,sizeof(str),"\t{ffffff}�������: \t\t\t\t%d \n",pData[id][pKillings]);
		strcat(sctring,str);
		format(str,sizeof(str),"\t{ffffff}�������: \t\t\t\t%d \n",pData[id][pDeaths]);
		strcat(sctring,str);
		format(str,sizeof(str),"{ffffff}______________________________________________________\n\n");
		strcat(sctring,str);
		format(str,sizeof(str),"\t{ffffff}������: \t\t\t\t%s \n",job);
		strcat(sctring,str);
		format(str,sizeof(str),"\t{ffffff}�����������: \t\t\t\t%s \n",fraction);
		strcat(sctring,str);
		format(str,sizeof(str),"\t{ffffff}����: \t\t\t\t\t%s \n\n",rank); ///
		strcat(sctring,str);
		format(str,sizeof(str),"\t{ffffff}���: \t\t\t\t\t%s  %s\n",housenumber, classname);
		strcat(sctring,str);
		format(str,sizeof(str),"\t{ffffff}������: \t\t\t\t%s \n",bussiness);
		strcat(sctring,str);
		format(str,sizeof(str),"{ffffff}______________________________________________________\n\n");
		strcat(sctring,str);
		format(str,sizeof(str),"\t{ffffff}����� ��������: \t\t\t%d \n",pData[id][pPhone]);
		strcat(sctring,str);
		format(str,sizeof(str),"\t{ffffff}���� ��������: \t\t\t%d \n",pData[id][pPhoneMoney]);
		strcat(sctring,str);
		format(str,sizeof(str),"\t{ffffff}������ ������: \t\t\t%d \n",pData[id][pGunAmount]);
		strcat(sctring,str);
		format(str,sizeof(str),"\t{ffffff}�������: \t\t\t\t%d \n",pData[id][pAmmo]);
		strcat(sctring,str);
		format(str,sizeof(str),"\t{ffffff}�������: \t\t\t\t%d \n",pData[id][pDrugs]);
		strcat(sctring,str);
		format(str,sizeof(str),"{ffffff}______________________________________________________\n\n");
		strcat(sctring,str);
		ShowPlayerDialog(playerid,0,0,"����������",sctring,"OK","");
	}
	if(!strcmp(cmd,"/clear",true))
	{
		if(pData[playerid][pAdmin] < 2) return 1;
		tmp = strtok(cmdtext, idx);
		new id = strval(tmp);
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid,CGRAY,"�������� ID");
		if(!pData[id][pWanted]) return SendClientMessage(playerid,CGRAY,"� ������ ��� �������");
		pData[id][pWanted] = 0;
		UpdatePlayerData(id,"wanted",0);
		SetPlayerWantedLevel(id,0);
		new mes[128];
		format(mes,sizeof(mes),"[A] %s ���� ������ %s",pData[playerid][pNickname],pData[id][pNickname]);
		AdminChat(CORANGE,mes);
		format(mes,sizeof(mes),"������������� %s ���� ��� ������",pData[playerid][pNickname]);
		SendClientMessage(id,CDEPARTMENT,mes);
	}
	if(!strcmp(cmd,"/logfreez1",true))
	{
		if(pData[playerid][pAdmin] < 3) return 1;
		logExit = true;
		logFreez = true;
	}
	if(!strcmp(cmd,"/logfreez2",true))
	{
		if(pData[playerid][pAdmin] < 3) return 1;
		logExit = false;
		logFreez = false;
	}
	if(!strcmp(cmd,"/loggang1",true))
	{
		if(pData[playerid][pAdmin] < 3) return 1;
		logGang = true;
	}
	if(!strcmp(cmd,"/loggang0",true))
	{
		if(pData[playerid][pAdmin] < 3) return 1;
		logGang = false;
	}
	if(!strcmp(cmd,"/showeconomic",true))
	{
		if(pData[playerid][pAdmin] < 3) return 1;
		if(!pTemp[playerid][pEconomicLog])
		{
			pTemp[playerid][pEconomicLog] = true;
			SendClientMessage(playerid,CSYSTEM,"��� �������");
		}
		else
		{
			pTemp[playerid][pEconomicLog] = false;
			SendClientMessage(playerid,CSYSTEM,"��� ��������");
		}
	}
	if(!strcmp(cmd,"/updateeconomic",true))
	{
		if(pData[playerid][pAdmin] < 3) return 1;
		UpdateEconomic();
		SendClientMessage(playerid,CSYSTEM,"������ ��������� ���������");
	}
	if(!strcmp(cmd,"/cb",true))
	{
		if(pData[playerid][pAdmin] < 8 || !IsPlayerAdmin(playerid)) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /cb [type] [bint] [price] [name]");
		new type = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /cb [type] [bint] [price] [name]");
		new bint = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /cb [type] [bint] [price] [name]");
		new price = strval(tmp);
		new name[128];
		name = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /cb [type] [bint] [price] [name]");
		mysql_real_escape_string(name,name);
		new Float:x, Float:y, Float:z, Float:r;
		GetPlayerPos(playerid,x,y,z);
		GetPlayerFacingAngle(playerid,r);
		new query[256];
		format(query,sizeof(query),"INSERT INTO `business` VALUES('','%s','%d','%d','0','%d','0','0','0','1','%f','%f','%f','%f','','')",name,type,bint,price,x,y,z,r);
		mysql_query(query);
		if(mysql_errno()) return SendClientMessage(playerid,CGRAY,"������ MySQL");
		CreateDynamicPickup(19132,1,x,y,z);
		SendClientMessage(playerid,CGREEN,"������ ������");
	}
	if(!strcmp(cmd,"/bints",true))
	{
		if(pData[playerid][pAdmin] < 8 || !IsPlayerAdmin(playerid)) return 1;
		if(!GetPVarFloat(playerid,"oldx"))
		{
			new mes[350];
			for(new i;i<BINT_COUNT;i++)
			{
				format(mes,sizeof(mes),"%s[%d] %s\n",mes,i+1,gBints[i][bintName]);
			}
			ShowPlayerDialog(playerid,dBints,2,"�����",mes,"OK","������");
		}
		else
		{
			new Float:x, Float:y, Float:z;
			x = GetPVarFloat(playerid,"oldx");
			y = GetPVarFloat(playerid,"oldy");
			z = GetPVarFloat(playerid,"oldz");
			SetPlayerInterior(playerid,0);
			SetPlayerVirtualWorld(playerid,0);
			SetPlayerPos(playerid,x,y,z);
			DeletePVar(playerid,"oldx");
			DeletePVar(playerid,"oldy");
			DeletePVar(playerid,"oldz");
		}
	}
	if(!strcmp(cmd,"/drestart",true))
	{
		if(!IsPlayerAdmin(playerid) || pData[playerid][pAdmin] != 8) return 1;
		RestartTime = 600;
		SendClientMessageToAll(CADMIN, "������� ������� ����� 10 �����!");
		SendClientMessageToAll(CWHITE, "����������� ��������� ������ � �������� �������� ����� �������.");
	}
	if(!strcmp(cmd,"/dnorestart",true))
	{
		if(!IsPlayerAdmin(playerid) || pData[playerid][pAdmin] != 8) return 1;
		RestartTime = 0;
	}
	
	if(!strcmp(cmdtext, "/giveplayerweapon", true, 17)) {
	    if(!IsPlayerAdmin(playerid)) return 1;
		new weapon;
		sscanf(cmdtext, "{s[17] }i", weapon);
		GivePlayerWeaponEx(playerid, weapon, 100);
	}
	if(!strcmp(cmdtext, "/setplayerammo", true, 14)) {
	    if(!IsPlayerAdmin(playerid)) return 1;
		new ammo;
		sscanf(cmdtext, "{s[14] }i", ammo);
		new weapon = GetPlayerWeapon(playerid);
		SetPlayerAmmo(playerid, weapon, ammo);
	}
	
	if(!strcmp(cmd,"/cv",true))
	{
		if(pData[playerid][pAdmin] < 8) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CRED,"������� ������ ����");
		new c1,c2,vehmod;
		vehmod = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(strlen(tmp)) c1 = strval(tmp);
		else c1 = random(128);
		tmp = strtok(cmdtext, idx);
		if(strlen(tmp)) c2 = strval(tmp);
		else c2 = random(128);
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid,x,y,z);
		x += 1.5;
		new vehid = CreateVehicle(vehmod,x,y,z,0.0,c1,c2,-1);
		LinkVehicleToInterior(vehid,GetPlayerInterior(playerid));
		SFCM(playerid,CWHITE,"���������� %d ������",vehid);
		gVehicles[vehid-1][vX] = x;
		gVehicles[vehid-1][vY] = y;
		gVehicles[vehid-1][vZ] = z;
		gVehicles[vehid-1][vDrived] = 0;
		gVehicles[vehid-1][vFuel] = gTransport[vehmod-400][trTank];
		gVehicles[vehid-1][vHealth] = 1000.0;
		gVehicles[vehid-1][vOwnerid] = INVALID_PLAYER_ID;
		gVehicles[vehid-1][vLock] = 0;
		return 1;
	}
	if(!strcmp(cmd,"/anim",true))
	{
		if(!IsPlayerAdmin(playerid)) return 1;
		new lib[24],animname[24],Float:speed,loop,lockx,locky,freez,time,force;
		lib = strtok(cmdtext, idx);
		if(!strlen(lib)) return SendClientMessage(playerid,CRED,"/anim [animlib] [animname] [spped] [loop] [lockx] [locky] [freez] [time] [force]");
		animname = strtok(cmdtext, idx);
		if(!strlen(animname)) return SendClientMessage(playerid,CRED,"/anim [animlib] [animname] [spped] [loop] [lockx] [locky] [freez] [time] [force]");
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CRED,"/anim [animlib] [animname] [spped] [loop] [lockx] [locky] [freez] [time] [force]");
		speed = floatstr(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CRED,"/anim [animlib] [animname] [spped] [loop] [lockx] [locky] [freez] [time] [force]");
		loop = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CRED,"/anim [animlib] [animname] [spped] [loop] [lockx] [locky] [freez] [time] [force]");
		lockx = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CRED,"/anim [animlib] [animname] [spped] [loop] [lockx] [locky] [freez] [time] [force]");
		locky = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CRED,"/anim [animlib] [animname] [spped] [loop] [lockx] [locky] [freez] [time] [force]");
		freez = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CRED,"/anim [animlib] [animname] [spped] [loop] [lockx] [locky] [freez] [time] [force]");
		time = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CRED,"/anim [animlib] [animname] [spped] [loop] [lockx] [locky] [freez] [time] [force]");
		force = strval(tmp);
		ApplyAnimation(playerid,lib,animname,speed,loop,lockx,locky,freez,time,force);
	}
	if(!strcmp(cmd,"/gunwh",true))
	{
		if(pData[playerid][pAdmin] < 5) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CRED,":: ������� /gunwh [gun1] [gun2] [gun3] [coal] [wood]");
		gGunWorkWH[0] = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CRED,":: ������� /gunwh [gun1] [gun2] [gun3] [coal] [wood]");
		gGunWorkWH[1] = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CRED,":: ������� /gunwh [gun1] [gun2] [gun3] [coal] [wood]");
		gGunWorkWH[2] = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CRED,":: ������� /gunwh [gun1] [gun2] [gun3] [coal] [wood]");
		gCoalWH = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CRED,":: ������� /gunwh [gun1] [gun2] [gun3] [coal] [wood]");
		gWoodWH = strval(tmp);
		gArmyWarehouse[0][0] = 50000;
		gArmyWarehouse[1][0] = 50000;
		gArmyWarehouse[0][1] = 50000;
		gArmyWarehouse[1][1] = 50000;
		return 1;
	}
	if(!strcmp(cmd,"/createhouse",true))
	{
		if(!IsPlayerAdmin(playerid)) return 1;
		ShowHintsDialog(playerid,dCreatehouse1,"�����","������");
		return 1;
	}
	if(!strcmp(cmd,"/hcar",true))
	{
		if(!IsPlayerAdmin(playerid)) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /hcar [ID ����]");
		new houseid = strval(tmp);
		if(houseid < 1 || houseid > MAX_HOUSE_COUNT) return SendClientMessage(playerid,CGRAY,"�������� ������� �� ���������� �������");
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,CGRAY,"�� ������ ���� � ������");
		new vehicleid = GetPlayerVehicleID(playerid);
		new Float:x, Float:y, Float:z, Float:r;
		GetVehiclePos(vehicleid,x,y,z);
		GetVehicleZAngle(vehicleid,r);
		new query[512];
		format(query,sizeof(query),"UPDATE `houses` SET `parkx`='%.4f', `parky`='%.4f', `parkz`='%.4f', `parkr`='%.4f' WHERE `id`='%d'",x,y,z,r,houseid);
		mysql_query(query);
		if(mysql_errno()) ShowPlayerDialog(playerid,dMes,0,"������ MySQL","��������� ������ mysql","��","");
		else
		{
			SendClientMessage(playerid,CGREEN,"����������� ����� � ���� �����������");
			new i = houseid - 1;
			gHouses[i][houseParkX] = x;
			gHouses[i][houseParkY] = y;
			gHouses[i][houseParkZ] = z;
			gHouses[i][houseParkR] = r;
		}
	}
	if(!strcmp(cmd,"/hints",true))
	{
		if(!IsPlayerAdmin(playerid)) return 1;
		if(!GetPVarFloat(playerid,"oldx"))ShowHintsDialog(playerid,dHints,"����������","������");
		else
		{
			new Float:x, Float:y, Float:z;
			x = GetPVarFloat(playerid,"oldx");
			y = GetPVarFloat(playerid,"oldy");
			z = GetPVarFloat(playerid,"oldz");
			SetPlayerInterior(playerid,0);
			SetPlayerVirtualWorld(playerid,0);
			SetPlayerPos(playerid,x,y,z);
			DeletePVar(playerid,"oldx");
			DeletePVar(playerid,"oldy");
			DeletePVar(playerid,"oldz");
		}
		return 1;
	}
	if(!strcmp(cmd,"/tptest",true))
	{
		return SetPlayerPos(playerid, 2426.4575,-2101.8687,13.5469);
	}


	if(!strcmp(cmd,"/createhint",true))
	{
		if(!IsPlayerAdmin(playerid)) return 1;
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /createhint [��������]");
		new Float:x, Float:y, Float:z, Float:r, interior;
		GetPlayerPos(playerid,x,y,z);
		GetPlayerFacingAngle(playerid,r);
		interior = GetPlayerInterior(playerid);
		new query[512];
		//format(query,sizeof(query),"INSERT INTO `hints` VALUES ('','%.4f','%.4f','%.4f','%.4f','0.0','0.0','0.0','0.0','%d','%s')",x,y,z,r,interior,tmp);
		format(query,sizeof(query),"INSERT INTO `hints` VALUES ('','%.4f','%.4f','%.4f','%.4f','0.0','0.0','0.0','0.0','%d','%s')",x,y,z,r,interior,tmp);
		mysql_query(query);
		if(mysql_errno()) ShowPlayerDialog(playerid,dMes,0,"������ MySQL","��������� ������ mysql","��","");
		else SPFD(playerid,dMes,0,"���������","��","","������ hint. ID: {"#cGREEN"} %d",mysql_insert_id());
		return 1;
	}
	if(!strcmp(cmd,"/setspawn",true))
	{
		if(!IsPlayerAdmin(playerid)) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,CGRAY,":: ������� /setspawn [Hint ID]");
		new Float:x, Float:y, Float:z, Float:r, hintid;
		GetPlayerPos(playerid,x,y,z);
		GetPlayerFacingAngle(playerid,r);
		hintid = strval(tmp);
		new query[512];
		format(query,sizeof(query),"UPDATE `hints` SET `sx`='%f', `sy`='%f', `sz`='%f', `sr`='%f' WHERE `id`='%d'",x,y,z,r,hintid);
		mysql_query(query);
		return 1;

	}
	if(!strcmp(cmd,"/restart",true))
	{
		if(!IsPlayerAdmin(playerid)) return 1;
		SaveServerData();
		SetTimer("GameModeExitDelay",2000,false);
	}
	
