// This is a comment
// uncomment the line below if you want to write a filterscript
#include <a_samp>
#include <gl_common>
#include <streamer>
#include <sscanf2>
#include <strlib>

#define CGRAY 0xAFAFAFAA
#define CGREEN 0x33AA33AA
#define CRED 0xFF0000AA
#define CLIGHTRED 0xFF0033FF
#define CYELLOW 0xFFFF00AA
#define CWHITE 0xFFFFFFFF
#define CBLUE 0x4682B4AA
#define CLIGHTBLUE 0x33CCFFAA
#define CORANGE 0xFF9900AA
#define CSYSTEM 0xEFEFF7AA
#define CPINK 0xE75480FF
#define CBRIGHTRED 0xB2222200
#define CDARKGREEN 0x004400AA
#define CLIGHTGREEN 0x00FF00AA
#define CCON_GREEN 0x00FF00FF
#define CBROWN 0x8b4513FF
#define CINFO 0x269BD8FF
#define CBADINFO 0xFF182DFF
#define CADMIN 0xF36223FF
#define CDEPARTMENT 0x007FFFFF
#define cGRAY AFAFAF
#define cGREEN 33AA33
#define cRED FF0000
#define cLIGHTRED FF0033
#define cYELLOW FFFF00
#define cWHITE FFFFFF
#define cBLUE 4682B4
#define cLIGHTBLUE 33CCFF
#define cORANGE FF9900
#define cSYSTEM EFEFF7
#define cPINK E75480
#define cBRIGHTRED B22222
#define cDARKGREEN 004400
#define cLIGHTGREEN 00FF00
#define cCON_GREEN 00FF00
#define cBROWN 8b4513
#define cINFO 269BD8
#define cBADINFO FF182D
#define cDEPARTMENT 007FFF


new Groups[500][25];

new RestartTime, RestartTimer;



public OnFilterScriptInit()
{
	for(new i;i<500;i++)
	{
		for(new k;k<25;k++) Groups[i][k] = INVALID_OBJECT_ID;
	}
	print("\n--------------------------------------");
	print(" Object Editor v2.0 by Sanbody");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{	
	new cmd[128], idx, tmp[128];
	cmd = strtok(cmdtext, idx);
	if (!strcmp("/tp", cmd))
	{
		if(!IsPlayerAdmin(playerid)) return 0;
		new tmp1[25],tmp2[25];
		tmp1 = strtok(cmdtext, idx);
		tmp2 = strtok(cmdtext, idx);
		new id;
		if(!isNumeric(tmp1))
		{
			if(!strcmp(tmp1,"me") && strlen(tmp1) > 0) id = playerid;
			else return SendClientMessage(playerid,CRED,"Неверный ID телепортируемого игрока");
		}
		else
		{
			id = strval(tmp1);
			if(!IsPlayerConnected(id)) return SendClientMessage(playerid,CRED,"Неверный ID телепортируемого игрока");
		}
		if(strlen(tmp2) > 0)
		{
			if(isNumeric(tmp2))
			{
				new id2 = strval(tmp2);
				new Float:x,Float:y,Float:z;
				GetPlayerPos(id2,x,y,z);
				x += 0.3;
				CallRemoteFunction("SetPlayerPosExA","ifff",id,x,y,z);
				new mes[128];
				format(mes,sizeof(mes),"Вы были телепортированы к %s");
				SendClientMessage(id,CGREEN,mes);
				if(id != playerid) SendClientMessage(playerid,CGREEN,"Игрок телепортирован");
			}			
		}		
		return 1;
	}	
	
	if (!strcmp(cmd,"/des",true))
	{
		if(!IsPlayerAdmin(playerid)) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,0x00000000,"Укажите ID авто");
		new id = strval(tmp);
		DestroyVehicle(id);
	}
	if (!strcmp(cmd,"/trailer",true))
	{
		if(!IsPlayerAdmin(playerid)) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,0x00000000,"Укажите ID авто");
		new id = strval(tmp);		
		AttachTrailerToVehicle(id,GetPlayerVehicleID(playerid));
	}
	
	/*if(!strcmp(cmd,"/gun",true))
	{
		GivePlayerWeapon(playerid,24,100);
	}*/
	/*if (!strcmp(cmd,"/id",true))
	{
		tmp = strrest(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,0xCCCCCCFF,"/id [Ник игрока]");
		new id=-1,name[24];
		for(new i;i<MAX_PLAYERS;i++)
		{		
			if(!IsPlayerConnected(i)) continue;
			GetPlayerName(i,name,24);
			if(strfind(name,tmp,true) != -1) {id = i; break;}
		}
		if(id == -1) return SendClientMessage(playerid,0xFFFFFFFF,"Не найдено");
		new mes[128];
		format(mes,sizeof(mes),"%s [%d]",name,id);
		SendClientMessage(playerid,0xFFFFFFFF,mes);
		return 1;
	}*/
	if(!strcmp(cmd,"/arepair",true))
	{
		if(!IsPlayerAdmin(playerid)) return 1;
		tmp = strtok(cmdtext,idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,0xCCCCCCFF,"/arepair [ID авто]");
		new vid = strval(tmp);
		new model = GetVehicleModel(vid);
		if(!model) return SendClientMessage(playerid,0xCCCCCCFF,"Неверный ID авто");
		RepairVehicle(vid);
	}
	if (!strcmp(cmd,"/unlocka",true))
	{
		if(!IsPlayerAdmin(playerid)) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,0x00000000,"Укажите модель авто");
		new id = strval(tmp);
		for(new i;i<MAX_PLAYERS;i++) SetVehicleParamsForPlayer(id,i,0,0);
	}	
	if (!strcmp(cmd,"/dds",true))
	{
		if(!IsPlayerAdmin(playerid)) return 1;
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_CUFFED);
	}
	if(!strcmp(cmd,"/myarea",true)) 
	{
		if(!IsPlayerAdmin(playerid)) return 1;
		if(IsPlayerInAnyDynamicArea(playerid)) 
		{
			SendClientMessage(playerid,0xFFFFFFFF,"Находишься в зоне");
			new mes[128];
			for(new i;i<CountDynamicAreas()+1;i++)
			{				
				if(IsPlayerInDynamicArea(playerid,i)) format(mes,sizeof(mes),"%s %d",mes,i);
			}
			format(mes,sizeof(mes),"%s carrygun: %d; carryammo: %d",mes,GetPVarInt(playerid,"carrygun"),GetPVarInt(playerid,"carryammo"));
			SendClientMessage(playerid,0xFFFFFFFF,mes);
		}
	}
	if(!strcmp(cmd,"/myhealth",true)) 
	{
		new Float:health;
		GetPlayerHealth(playerid,health);
		printf("%f",health);
	}
	if(!strcmp(cmd,"/drestart",true))
	{
		if(!IsPlayerAdmin(playerid)) return 1;
		RestartTime = 600;
		SendClientMessageToAll(CRED,"Рестарт сервера через 10 минут!");
		RestartTimer = SetTimer("RestartInfo",1000,true);
	}
	if(!strcmp(cmd,"/dnorestart",true)) 
	{
		if(!IsPlayerAdmin(playerid)) return 1;
		KillTimer(RestartTimer);
		RestartTime = 0;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 0;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

forward RestartInfo();
public RestartInfo()
{
	if(RestartTime) RestartTime--;
	new mes[24];
	format(mes,sizeof(mes),"RESTART %d SEC",RestartTime);
	GameTextForAll(mes,2000,3);
	if(!RestartTime)
	{
		SendRconCommand("gmx");
		KillTimer(RestartTimer);
		RestartTime = 0;
	}
}
