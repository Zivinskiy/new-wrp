/*
Защита от флуда OnPlayerRequestClass
Защита от флуда OnPlayerSpawn
Защита от флуда OnPlayerDeath
Защита от флуда OnVehicleDeath
Защита от флуда OnPlayerText
Защита от флуда OnPlayerCommandText
Защита от флуда OnPlayerEnterVehicle
Защита от флуда OnPlayerExitVehicle
Защита от флуда OnPlayerStateChange
Защита от флуда OnPlayerEnterCheckpoint
Защита от флуда OnPlayerLeaveCheckpoint
Защита от флуда OnPlayerEnterRaceCheckpoint
Защита от флуда OnPlayerLeaveRaceCheckpoint
Защита от флуда OnPlayerRequestSpawn
Защита от флуда OnPlayerPickUpPickup
Защита от флуда OnVehicleMod
Защита от флуда OnVehiclePaintjob
Защита от флуда OnVehicleRespray
Защита от флуда OnPlayerSelectedMenuRow
Защита от флуда OnPlayerExitedMenu
Защита от флуда OnPlayerInteriorChange
Защита от флуда OnDialogResponse
Защита от флуда OnPlayerClickPlayer
Защита от флуда OnPlayerWeaponShot
Защита от флуда OnPlayerGiveDamage
Защита от флуда OnPlayerTakeDamage
Защита от флуда OnPlayerClickMap
Защита от флуда OnPlayerClickTextDraw
Защита от флуда OnPlayerClickPlayerTextDraw
Защита от Dos'a на сетевом уровне
Защита от частого Reconnect'a
Защита от Bot's
Защита от Dos'a(Caypen,PizDdos,BabaShura,DedaVanya,Vnuchok,SimpleBot,ZetaB,RakSamp и т.д)
Защита от краша неправильным тюнингом
Защита от Vehicle Hack
Защита от высокого пинга
Защита от 2x Ip's
Защита от Unknown SA-MP version
Защита от крашнутых символов,замена на #
*/

#include <a_samp>
#include <mxINI>

#define IP_GO_ADREAS "0.0.0.0"
#define IP_GO_PORT   7777

#undef MAX_PLAYERS
#define MAX_PLAYERS 1000

new FP_TimerPlayer[MAX_PLAYERS];
//
new FP_OnPlayerRequestClass[MAX_PLAYERS];
new FP_OnPlayerSpawn[MAX_PLAYERS];
new FP_OnPlayerDeath[MAX_PLAYERS];
new FP_OnVehicleDeath[MAX_PLAYERS];
new FP_OnPlayerText[MAX_PLAYERS];
new FP_OnPlayerCommandText[MAX_PLAYERS];
new FP_OnPlayerEnterVehicle[MAX_PLAYERS];
new FP_OnPlayerExitVehicle[MAX_PLAYERS];
new FP_OnPlayerStateChange[MAX_PLAYERS];
new FP_OnPlayerEnterCheckpoint[MAX_PLAYERS];
new FP_OnPlayerLeaveCheckpoint[MAX_PLAYERS];
new FP_OnPlayerEnterRaceCheckpoint[MAX_PLAYERS];
new FP_OnPlayerLeaveRaceCheckpoint[MAX_PLAYERS];
new FP_OnPlayerRequestSpawn[MAX_PLAYERS];
new FP_OnPlayerPickUpPickup[MAX_PLAYERS];
new FP_OnVehicleMod[MAX_PLAYERS];
new FP_OnVehiclePaintjob[MAX_PLAYERS];
new FP_OnVehicleRespray[MAX_PLAYERS];
new FP_OnPlayerSelectedMenuRow[MAX_PLAYERS];
new FP_OnPlayerExitedMenu[MAX_PLAYERS];
new FP_OnPlayerInteriorChange[MAX_PLAYERS];
new FP_OnDialogResponse[MAX_PLAYERS];
new FP_OnPlayerClickPlayer[MAX_PLAYERS];
new FP_OnPlayerWeaponShot[MAX_PLAYERS];
new FP_OnPlayerGiveDamage[MAX_PLAYERS];
new FP_OnPlayerTakeDamage[MAX_PLAYERS];
new FP_OnPlayerClickMap[MAX_PLAYERS];
new FP_OnPlayerClickTextDraw[MAX_PLAYERS];
new FP_OnPlayerClickPlayerTextDraw[MAX_PLAYERS];
//
new FP_ConnectTimed[MAX_PLAYERS];
new FP_IsConnected[MAX_PLAYERS];
new FP_VehicleHack[MAX_PLAYERS];
new FP_LoadStats[MAX_PLAYERS][400];
new FP_Packets[MAX_PLAYERS];
new FP_MessagesAll[MAX_PLAYERS];
new FP_VersionClient[MAX_PLAYERS][40];
//
new FP_Port;
new FP_Ip_Adreas[18];
new FP_For_No_Ip_Adreas=5;
new FP_Yes_Ip_Adreas[18]=IP_GO_ADREAS;
new FP_Yes_Port=IP_GO_PORT;
//
new MF_OnPlayerRequestClass;
new MF_OnPlayerSpawn;
new MF_OnPlayerDeath;
new MF_OnVehicleDeath;
new MF_OnPlayerText;
new MF_OnPlayerCommandText;
new MF_OnPlayerEnterVehicle;
new MF_OnPlayerExitVehicle;
new MF_OnPlayerStateChange;
new MF_OnPlayerEnterCheckpoint;
new MF_OnPlayerLeaveCheckpoint;
new MF_OnPlayerEnterRaceCheckpoint;
new MF_OnPlayerLeaveRaceCheckpoint;
new MF_OnPlayerRequestSpawn;
new MF_OnPlayerPickUpPickup;
new MF_OnVehicleMod;
new MF_OnVehiclePaintjob;
new MF_OnVehicleRespray;
new MF_OnPlayerSelectedMenuRow;
new MF_OnPlayerExitedMenu;
new MF_OnPlayerInteriorChange;
new MF_OnDialogResponse;
new MF_OnPlayerClickPlayer;
new MF_OnPlayerWeaponShot;
new MF_OnPlayerGiveDamage;
new MF_OnPlayerTakeDamage;
new MF_OnPlayerClickMap;
new MF_OnPlayerClickTextDraw;
new MF_OnPlayerClickPlayerTextDraw;
new MF_Reconnect;
new MF_Bot;
new MF_Dos;
new MF_VehicleHack;
new MF_Ping;
//
forward OnPlayerUpdateProtection(playerid);

main(){print("Freedom Project | Protection(АнтиDos)");}

public OnFilterScriptInit()
{
    AntiDeAMX();
    FP_Port=GetServerVarAsInt("port");
    GetServerVarAsString("bind",FP_Ip_Adreas,sizeof(FP_Ip_Adreas));
    if((strcmp(FP_Ip_Adreas,FP_Yes_Ip_Adreas,true,18)!=0||strlen(FP_Ip_Adreas)==0)&&(FP_Port!=FP_Yes_Port||FP_Port==0)){
	}else{
		while(FP_For_No_Ip_Adreas<10){
		    OnFilterScriptExit();
        }
	}
	LoadingSetting();
	return 1;
}

AntiDeAMX()
{
    new a[][]={"Unarmed (Fist)","Brass K"};
    #pragma unused a
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    FP_OnPlayerRequestClass[playerid]++;
    if(FP_OnPlayerRequestClass[playerid]>MF_OnPlayerRequestClass){
        PlayerMessageBan(playerid,"Бан по причине: флуд OnPlayerRequestClass");
    }
	return 1;
}

public OnPlayerConnect(playerid)
{
    if((GetTickCount()-FP_ConnectTimed[playerid])<MF_Reconnect){
        PlayerMessageBan(playerid,"Бан по причине: частый Reconnect");
    }
	FP_ConnectTimed[playerid]=GetTickCount();
	//
	if(FP_IsConnected[playerid]>MF_Bot){
        PlayerMessageBan(playerid,"Бан по причине: Bot's");
	}
	FP_IsConnected[playerid]+=1;
	//
	for(new i=0;i<MAX_PLAYERS;i++){
		if(i==playerid||!IsPlayerConnected(i))continue;
		if(!strcmp(PlayerIP(i),PlayerIP(playerid),true)){
            PlayerMessageBan(playerid,"Бан по причине: 2x Ip's");
	    }
	}
	//
    GetPlayerVersion(playerid,FP_VersionClient[playerid],40);
	if(!strcmp(FP_VersionClient[playerid],"unknown",true)){
        PlayerMessageBan(playerid,"Бан по причине: Unknown SA-MP version");
    }
	//
    FP_OnPlayerRequestClass[playerid]=0;
    FP_OnPlayerSpawn[playerid]=0;
    FP_OnPlayerDeath[playerid]=0;
    FP_OnVehicleDeath[playerid]=0;
    FP_OnPlayerText[playerid]=0;
    FP_OnPlayerCommandText[playerid]=0;
    FP_OnPlayerEnterVehicle[playerid]=0;
    FP_OnPlayerExitVehicle[playerid]=0;
    FP_OnPlayerStateChange[playerid]=0;
    FP_OnPlayerEnterCheckpoint[playerid]=0;
    FP_OnPlayerLeaveCheckpoint[playerid]=0;
    FP_OnPlayerEnterRaceCheckpoint[playerid]=0;
    FP_OnPlayerLeaveRaceCheckpoint[playerid]=0;
    FP_OnPlayerRequestSpawn[playerid]=0;
    FP_OnPlayerPickUpPickup[playerid]=0;
    FP_OnVehicleMod[playerid]=0;
    FP_OnVehiclePaintjob[playerid]=0;
    FP_OnVehicleRespray[playerid]=0;
    FP_OnPlayerSelectedMenuRow[playerid]=0;
    FP_OnPlayerExitedMenu[playerid]=0;
    FP_OnPlayerInteriorChange[playerid]=0;
    FP_OnDialogResponse[playerid]=0;
    FP_OnPlayerClickPlayer[playerid]=0;
    FP_OnPlayerWeaponShot[playerid]=0;
    FP_OnPlayerGiveDamage[playerid]=0;
    FP_OnPlayerTakeDamage[playerid]=0;
    FP_OnPlayerClickMap[playerid]=0;
    FP_OnPlayerClickTextDraw[playerid]=0;
    FP_OnPlayerClickPlayerTextDraw[playerid]=0;
    //
    FP_TimerPlayer[playerid]=SetTimerEx("OnPlayerUpdateProtection",950,true,"d",playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	FP_IsConnected[playerid]=0;
	//
    KillTimer(FP_TimerPlayer[playerid]);
    //
    if(reason<2)Kick(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
    FP_OnPlayerSpawn[playerid]++;
    if(FP_OnPlayerSpawn[playerid]>MF_OnPlayerSpawn){
	    PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerSpawn");
    }
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    FP_OnPlayerDeath[playerid]++;
    if(FP_OnPlayerDeath[playerid]>MF_OnPlayerDeath){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerDeath");
    }
	if(killerid!=65535){
        FP_OnPlayerDeath[killerid]++;
        if(FP_OnPlayerDeath[killerid]>MF_OnPlayerDeath){
		    PlayerMessageBan(killerid,"Бан по причине: Флуд OnPlayerDeath");
        }
    }
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
    FP_OnVehicleDeath[killerid]++;
    if(FP_OnVehicleDeath[killerid]>MF_OnVehicleDeath){
		PlayerMessageBan(killerid,"Бан по причине: Флуд OnVehicleDeath");
    }
	return 1;
}

public OnPlayerText(playerid, text[])
{
    FP_OnPlayerText[playerid]++;
    if(FP_OnPlayerText[playerid]>MF_OnPlayerText){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerText");
		return 0;
    }
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    FP_OnPlayerCommandText[playerid]++;
    if(FP_OnPlayerCommandText[playerid]>MF_OnPlayerCommandText){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerCommandText");
		return 0;
    }
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    FP_OnPlayerEnterVehicle[playerid]++;
    if(FP_OnPlayerEnterVehicle[playerid]>MF_OnPlayerEnterVehicle){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerEnterVehicle");
    }
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    FP_OnPlayerExitVehicle[playerid]++;
    if(FP_OnPlayerExitVehicle[playerid]>MF_OnPlayerExitVehicle){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerExitVehicle");
    }
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    FP_OnPlayerStateChange[playerid]++;
    if(FP_OnPlayerStateChange[playerid]>MF_OnPlayerStateChange){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerStateChange");
    }
  	if(FP_VehicleHack[playerid]>MF_VehicleHack){
		PlayerMessageBan(playerid,"Бан по причине: Vehicle Hack");
    }
	if(newstate==PLAYER_STATE_DRIVER||newstate==PLAYER_STATE_PASSENGER){
	    FP_VehicleHack[playerid]++;
    }
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    FP_OnPlayerEnterCheckpoint[playerid]++;
    if(FP_OnPlayerEnterCheckpoint[playerid]>MF_OnPlayerEnterCheckpoint){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerEnterCheckpoint");
    }
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
    FP_OnPlayerLeaveCheckpoint[playerid]++;
    if(FP_OnPlayerLeaveCheckpoint[playerid]>MF_OnPlayerLeaveCheckpoint){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerLeaveCheckpoint");
    }
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
    FP_OnPlayerEnterRaceCheckpoint[playerid]++;
    if(FP_OnPlayerEnterRaceCheckpoint[playerid]>MF_OnPlayerEnterRaceCheckpoint){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerEnterRaceCheckpoint");
    }
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
    FP_OnPlayerLeaveRaceCheckpoint[playerid]++;
    if(FP_OnPlayerLeaveRaceCheckpoint[playerid]>MF_OnPlayerLeaveRaceCheckpoint){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerLeaveRaceCheckpoint");
    }
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    FP_OnPlayerRequestSpawn[playerid]++;
    if(FP_OnPlayerRequestSpawn[playerid]>MF_OnPlayerRequestSpawn){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerRequestSpawn");
    }
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
    FP_OnPlayerPickUpPickup[playerid]++;
    if(FP_OnPlayerPickUpPickup[playerid]>MF_OnPlayerPickUpPickup){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerPickUpPickup");
    }
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
    FP_OnVehicleMod[playerid]++;
    if(FP_OnVehicleMod[playerid]>MF_OnVehicleMod){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnVehicleMod");
    }
	//
    switch(componentid){
	    case 1008..1010:{
		    if(IsPlayerInInvalidNosVehicle(playerid)){
			    RemoveVehicleComponent(vehicleid,componentid);
			}
		}
    }
    if(!IsComponentidCompatible(GetVehicleModel(vehicleid),componentid)){
	    RemoveVehicleComponent(vehicleid,componentid);
		PlayerMessageBan(playerid,"Бан по причине: краш неправильным тюнингом");
	}
	//
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
    FP_OnVehiclePaintjob[playerid]++;
    if(FP_OnVehiclePaintjob[playerid]>MF_OnVehiclePaintjob){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnVehiclePaintjob");
    }
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    FP_OnVehicleRespray[playerid]++;
    if(FP_OnVehicleRespray[playerid]>MF_OnVehicleRespray){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnVehicleRespray");
    }
	return 1;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
	return 1;
}

public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
    FP_OnPlayerSelectedMenuRow[playerid]++;
    if(FP_OnPlayerSelectedMenuRow[playerid]>MF_OnPlayerSelectedMenuRow){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerSelectedMenuRow");
    }
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
    FP_OnPlayerExitedMenu[playerid]++;
    if(FP_OnPlayerExitedMenu[playerid]>MF_OnPlayerExitedMenu){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerExitedMenu");
		return 0;
    }
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
    FP_OnPlayerInteriorChange[playerid]++;
    if(FP_OnPlayerInteriorChange[playerid]>MF_OnPlayerInteriorChange){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerInteriorChange");
		return 0;
    }
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
    FP_OnDialogResponse[playerid]++;
    if(FP_OnDialogResponse[playerid]>MF_OnDialogResponse){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnDialogResponse");
    }
  	new FP_Text=strlen(inputtext);
	for(new i=0;i<FP_Text;++i){
		if(inputtext[i]=='%'){
	    	inputtext[i]='#';
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    FP_OnPlayerClickPlayer[playerid]++;
    if(FP_OnPlayerClickPlayer[playerid]>MF_OnPlayerClickPlayer){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerClickPlayer");
    }
	return 1;
}

public OnPlayerGiveDamage(playerid,damagedid,Float:amount,weaponid,bodypart)
{
    FP_OnPlayerGiveDamage[playerid]++;
    if(FP_OnPlayerGiveDamage[playerid]>MF_OnPlayerGiveDamage){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerGiveDamage");
    }
    FP_OnPlayerGiveDamage[damagedid]++;
    if(FP_OnPlayerGiveDamage[damagedid]>MF_OnPlayerGiveDamage){
		PlayerMessageBan(damagedid,"Бан по причине: Флуд OnPlayerGiveDamage");
    }
    return 1;
}

public OnPlayerTakeDamage(playerid,issuerid,Float:amount,weaponid,bodypart)
{
    FP_OnPlayerTakeDamage[playerid]++;
    if(FP_OnPlayerTakeDamage[playerid]>MF_OnPlayerTakeDamage){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerTakeDamage");
    }
    if(issuerid!=65535){
        FP_OnPlayerTakeDamage[issuerid]++;
        if(FP_OnPlayerTakeDamage[issuerid]>MF_OnPlayerTakeDamage){
		    PlayerMessageBan(issuerid,"Бан по причине: Флуд OnPlayerTakeDamage");
        }
    }
    return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    FP_OnPlayerClickMap[playerid]++;
    if(FP_OnPlayerClickMap[playerid]>MF_OnPlayerClickMap){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerClickMap");
    }
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    FP_OnPlayerClickTextDraw[playerid]++;
    if(FP_OnPlayerClickTextDraw[playerid]>MF_OnPlayerClickTextDraw){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerClickTextDraw");
    }
	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    FP_OnPlayerClickPlayerTextDraw[playerid]++;
    if(FP_OnPlayerClickPlayerTextDraw[playerid]>MF_OnPlayerClickPlayerTextDraw){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerClickPlayerTextDraw");
    }
	return 1;
}

public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid,Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ,Float:fRotX, Float:fRotY, Float:fRotZ,Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	return 1;
}

public OnPlayerSelectObject(playerid, type, objectid, modelid, Float:fX, Float:fY, Float:fZ)
{
	return 1;
}

public OnPlayerWeaponShot(playerid,weaponid,hittype,hitid,Float:fX,Float:fY,Float:fZ)
{
    FP_OnPlayerWeaponShot[playerid]++;
    if(FP_OnPlayerWeaponShot[playerid]>25){
		PlayerMessageBan(playerid,"Бан по причине: Флуд OnPlayerWeaponShot");
    }
    return 1;
}

public OnPlayerUpdateProtection(playerid)
{
    FP_OnPlayerRequestClass[playerid]=0;
    FP_OnPlayerSpawn[playerid]=0;
    FP_OnPlayerDeath[playerid]=0;
    FP_OnVehicleDeath[playerid]=0;
    FP_OnPlayerText[playerid]=0;
    FP_OnPlayerCommandText[playerid]=0;
    FP_OnPlayerEnterVehicle[playerid]=0;
    FP_OnPlayerExitVehicle[playerid]=0;
    FP_OnPlayerStateChange[playerid]=0;
    FP_OnPlayerEnterCheckpoint[playerid]=0;
    FP_OnPlayerLeaveCheckpoint[playerid]=0;
    FP_OnPlayerEnterRaceCheckpoint[playerid]=0;
    FP_OnPlayerLeaveRaceCheckpoint[playerid]=0;
    FP_OnPlayerRequestSpawn[playerid]=0;
    FP_OnPlayerPickUpPickup[playerid]=0;
    FP_OnVehicleMod[playerid]=0;
    FP_OnVehiclePaintjob[playerid]=0;
    FP_OnVehicleRespray[playerid]=0;
    FP_OnPlayerSelectedMenuRow[playerid]=0;
    FP_OnPlayerExitedMenu[playerid]=0;
    FP_OnPlayerInteriorChange[playerid]=0;
    FP_OnDialogResponse[playerid]=0;
    FP_OnPlayerClickPlayer[playerid]=0;
    FP_OnPlayerWeaponShot[playerid]=0;
    FP_OnPlayerGiveDamage[playerid]=0;
    FP_OnPlayerTakeDamage[playerid]=0;
    FP_OnPlayerClickMap[playerid]=0;
    FP_OnPlayerClickTextDraw[playerid]=0;
    FP_OnPlayerClickPlayerTextDraw[playerid]=0;
    FP_VehicleHack[playerid]=0;
    //
    if(GetPlayerPing(playerid)>MF_Ping){
		PlayerMessageKick(playerid,"Кик по причине: высокий пинг");
    }
    //
	GetPlayerNetworkStats(playerid,FP_LoadStats[playerid],400);
	FP_MessagesAll[playerid]=GetMessages(FP_LoadStats[playerid][strfind(FP_LoadStats[playerid],"Messages received: ",false,180) + 0x13]);
	if(FP_MessagesAll[playerid]-FP_Packets[playerid]>MF_Dos){//799
        PlayerMessageBan(playerid,"Бан по причине: Dos");
	}
	FP_Packets[playerid]=FP_MessagesAll[playerid];
	//
	return 1;
}

stock GetMessages(const string[])
{
    for(new i,index,str[50];i!=50;i++){
        if(string[i]>='0'&&string[i]<='9'){
            str[index]=string[i];
            index++;
        }
        else return strval(str);
    }
    return -1;
}

PlayerIP(playerid)
{
    new FP_Ip[18];
	GetPlayerIp(playerid,FP_Ip,18);
	return FP_Ip;
}

stock PlayerMessageKick(playerid,string[])
{
    new FP_Name[MAX_PLAYER_NAME];
    GetPlayerName(playerid,FP_Name,MAX_PLAYER_NAME);
	printf("[ID %i | NAME %s]:%s",playerid,FP_Name,string);
    Kick(playerid);
	return 1;
}

stock PlayerMessageBan(playerid,string[])
{
    new FP_Name[MAX_PLAYER_NAME];
    GetPlayerName(playerid,FP_Name,MAX_PLAYER_NAME);
	printf("[ID %i | NAME %s]:%s",playerid,FP_Name,string);
    BanEx(playerid,string);
	return 1;
}

stock IsPlayerInInvalidNosVehicle(playerid){
 	if(IsPlayerInAnyVehicle(playerid)){
        switch(GetVehicleModel(GetPlayerVehicleID(playerid))){
            case 417,425,430,432,446,447,448,449,452,453,454,460,461,462,463,468,469,472,473,476,481,484,487,488,493,497,509,510,511,512,513,519,520,521,522,523,533,537,538,548,563,569,570,577,581,586,590,592,593,595:return true;
        }
   	}
   	return false;
}

stock IsComponentidCompatible(modelid,FP_C){
    if(FP_C==1025||FP_C==1073||FP_C==1074||FP_C==1075||FP_C==1076||FP_C==1077||FP_C==1078||FP_C==1079||FP_C==1080||FP_C==1081||FP_C==1082||FP_C==1083||FP_C==1084||FP_C==1085||FP_C==1096||FP_C==1097||FP_C==1098||FP_C==1087||FP_C==1086)return true;
    switch(modelid){
        case 400:return(FP_C==1020||FP_C==1021||FP_C==1019||FP_C==1018||FP_C==1013||FP_C==1024||FP_C==1008||FP_C==1009||FP_C==1010);
        case 401:return(FP_C==1005||FP_C==1004||FP_C==1142||FP_C==1143||FP_C==1144||FP_C==114||FP_C==1020||FP_C==1019||FP_C==1013||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1006||FP_C==1001||FP_C==1003||FP_C==1017||FP_C==1007);
        case 402:return(FP_C==1009||FP_C==1009||FP_C==1010);
        case 404:return(FP_C==1020||FP_C==1021||FP_C==1019||FP_C==1013||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1002||FP_C==1016||FP_C==1000||FP_C==1017||FP_C==1007);
        case 405:return(FP_C==1020||FP_C==1021||FP_C==1019||FP_C==1018||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1001||FP_C==1014||FP_C==1023||FP_C==1000);
        case 409:return(FP_C==1009);
        case 410:return(FP_C==1019||FP_C==1021||FP_C==1020||FP_C==1013||FP_C==1024||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1001||FP_C==1023||FP_C==1003||FP_C==1017||FP_C==1007);
        case 411:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 412:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 415:return(FP_C==1019||FP_C==1018||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1001||FP_C==1023||FP_C==1003||FP_C==1017||FP_C==1007);
        case 418:return(FP_C==1020||FP_C==1021||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1006||FP_C==1002||FP_C==1016);
        case 419:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 420:return(FP_C==1005||FP_C==1004||FP_C==1021||FP_C==1019||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1001||FP_C==1003);
        case 421:return(FP_C==1020||FP_C==1021||FP_C==1019||FP_C==1018||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1014||FP_C==1023||FP_C==1016||FP_C==1000);
        case 422:return(FP_C==1020||FP_C==1021||FP_C==1019||FP_C==1013||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1017||FP_C==1007);
        case 426:return(FP_C==1005||FP_C==1004||FP_C==1021||FP_C==1019||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1006||FP_C==1001||FP_C==1003);
        case 429:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 436:return(FP_C==1020||FP_C==1021||FP_C==1022||FP_C==1019||FP_C==1013||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1006||FP_C==1001||FP_C==1003||FP_C==1017||FP_C==1007);
        case 438:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 439:return(FP_C==1003||FP_C==1023||FP_C==1001||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1017||FP_C==1007||FP_C==1142||FP_C==1143||FP_C==1144||FP_C==1145||FP_C==1013);
        case 442:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 445:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 451:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 458:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 466:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 467:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 474:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 475:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 477:return(FP_C==1020||FP_C==1021||FP_C==1019||FP_C==1018||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1006||FP_C==1017||FP_C==1007);
        case 478:return(FP_C==1005||FP_C==1004||FP_C==1012||FP_C==1020||FP_C==1021||FP_C==1022||FP_C==1013||FP_C==1024||FP_C==1008||FP_C==1009||FP_C==1010);
        case 479:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 480:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 489:return(FP_C==1005||FP_C==1004||FP_C==1020||FP_C==1019||FP_C==1018||FP_C==1013||FP_C==1024||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1006||FP_C==1002||FP_C==1016||FP_C==1000);
        case 491:return(FP_C==1142||FP_C==1143||FP_C==1144||FP_C==1145||FP_C==1020||FP_C==1021||FP_C==1019||FP_C==1018||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1014||FP_C==1023||FP_C==1003||FP_C==1017||FP_C==1007);
        case 492:return(FP_C==1005||FP_C==1004||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1006||FP_C==1016||FP_C==1000);
        case 496:return(FP_C==1006||FP_C==1017||FP_C==1007||FP_C==1011||FP_C==1019||FP_C==1023||FP_C==1001||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1003||FP_C==1002||FP_C==1142||FP_C==1143||FP_C==1020);
        case 500:return(FP_C==1020||FP_C==1021||FP_C==1019||FP_C==1013||FP_C==1024||FP_C==1008||FP_C==1009||FP_C==1010);
        case 506:return(FP_C==1009);
        case 507:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 516:return(FP_C==1004||FP_C==1020||FP_C==1021||FP_C==1019||FP_C==1018||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1002||FP_C==1015||FP_C==1016||FP_C==1000||FP_C==1017||FP_C==1007);
        case 517:return(FP_C==1142||FP_C==1143||FP_C==1144||FP_C==1145||FP_C==1020||FP_C==1019||FP_C==1018||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1002||FP_C==1023||FP_C==1016||FP_C==1003||FP_C==1017||FP_C==1007);
        case 518:return(FP_C==1005||FP_C==1142||FP_C==1143||FP_C==1144||FP_C==1145||FP_C==1020||FP_C==1018||FP_C==1013||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1006||FP_C==1001||FP_C==1023||FP_C==1003||FP_C==1017||FP_C==1007);
        case 526:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 527:return(FP_C==1021||FP_C==1020||FP_C==1018||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1001||FP_C==1014||FP_C==1015||FP_C==1017||FP_C==1007);
        case 529:return(FP_C==1012||FP_C==1011||FP_C==1020||FP_C==1019||FP_C==1018||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1006||FP_C==1001||FP_C==1023||FP_C==1003||FP_C==1017||FP_C==1007);
        case 533:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 534:return(FP_C==1126||FP_C==1127||FP_C==1179||FP_C==1185||FP_C==1100||FP_C==1123||FP_C==1125||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1180||FP_C==1178||FP_C==1101||FP_C==1122||FP_C==1124||FP_C==1106);
        case 535:return(FP_C==1109||FP_C==1110||FP_C==1113||FP_C==1114||FP_C==1115||FP_C==1116||FP_C==1117||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1120||FP_C==1118||FP_C==1121||FP_C==1119);
        case 536:return(FP_C==1104||FP_C==1105||FP_C==1182||FP_C==1181||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1184||FP_C==1183||FP_C==1128||FP_C==1103||FP_C==1107||FP_C==1108);
        case 540:return(FP_C==1004||FP_C==1142||FP_C==1143||FP_C==1144||FP_C==1145||FP_C==1020||FP_C==1019||FP_C==1018||FP_C==1024||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1006||FP_C==1001||FP_C==1023||FP_C==1017||FP_C==1007);
        case 541:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 542:return(FP_C==1144||FP_C==1145||FP_C==1020||FP_C==1021||FP_C==1019||FP_C==1018||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1014||FP_C==1015);
        case 545:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 546:return(FP_C==1004||FP_C==1142||FP_C==1143||FP_C==1144||FP_C==1145||FP_C==1019||FP_C==1018||FP_C==1024||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1006||FP_C==1002||FP_C==1001||FP_C==1023||FP_C==1017||FP_C==1007);
        case 547:return(FP_C==1142||FP_C==1143||FP_C==1020||FP_C==1021||FP_C==1019||FP_C==1018||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1016||FP_C==1003||FP_C==1000);
        case 549:return(FP_C==1012||FP_C==1011||FP_C==1142||FP_C==1143||FP_C==1144||FP_C==1145||FP_C==1020||FP_C==1019||FP_C==1018||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1001||FP_C==1023||FP_C==1003||FP_C==1017||FP_C==1007);
        case 550:return(FP_C==1005||FP_C==1004||FP_C==1142||FP_C==1143||FP_C==1144||FP_C==1145||FP_C==1020||FP_C==1019||FP_C==1018||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1006||FP_C==1001||FP_C==1023||FP_C==1003);
        case 551:return(FP_C==1005||FP_C==1020||FP_C==1021||FP_C==1019||FP_C==1018||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1006||FP_C==1002||FP_C==1023||FP_C==1016||FP_C==1003);
        case 555:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 558:return(FP_C==1092||FP_C==1089||FP_C==1166||FP_C==1165||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1168||FP_C==1167||FP_C==1088||FP_C==1091||FP_C==1164||FP_C==1163||FP_C==1094||FP_C==1090||FP_C==1095||FP_C==1093);
        case 559:return(FP_C==1065||FP_C==1066||FP_C==1160||FP_C==1173||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1159||FP_C==1161||FP_C==1162||FP_C==1158||FP_C==1067||FP_C==1068||FP_C==1071||FP_C==1069||FP_C==1072||FP_C==1070||FP_C==1009);
        case 560:return(FP_C==1028||FP_C==1029||FP_C==1169||FP_C==1170||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1141||FP_C==1140||FP_C==1032||FP_C==1033||FP_C==1138||FP_C==1139||FP_C==1027||FP_C==1026||FP_C==1030||FP_C==1031);
        case 561:return(FP_C==1064||FP_C==1059||FP_C==1155||FP_C==1157||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1154||FP_C==1156||FP_C==1055||FP_C==1061||FP_C==1058||FP_C==1060||FP_C==1062||FP_C==1056||FP_C==1063||FP_C==1057);
        case 562:return(FP_C==1034||FP_C==1037||FP_C==1171||FP_C==1172||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1149||FP_C==1148||FP_C==1038||FP_C==1035||FP_C==1147||FP_C==1146||FP_C==1040||FP_C==1036||FP_C==1041||FP_C==1039);
        case 565:return(FP_C==1046||FP_C==1045||FP_C==1153||FP_C==1152||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1150||FP_C==1151||FP_C==1054||FP_C==1053||FP_C==1049||FP_C==1050||FP_C==1051||FP_C==1047||FP_C==1052||FP_C==1048);
        case 566:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 567:return(FP_C==1129||FP_C==1132||FP_C==1189||FP_C==1188||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1187||FP_C==1186||FP_C==1130||FP_C==1131||FP_C==1102||FP_C==1133);
        case 575:return(FP_C==1044||FP_C==1043||FP_C==1174||FP_C==1175||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1176||FP_C==1177||FP_C==1099||FP_C==1042);
        case 576:return(FP_C==1136||FP_C==1135||FP_C==1191||FP_C==1190||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1192||FP_C==1193||FP_C==1137||FP_C==1134);
        case 579:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 580:return(FP_C==1020||FP_C==1018||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1006||FP_C==1001||FP_C==1023||FP_C==1017||FP_C==1007);
        case 585:return(FP_C==1142||FP_C==1143||FP_C==1144||FP_C==1145||FP_C==1020||FP_C==1019||FP_C==1018||FP_C==1013||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1006||FP_C==1001||FP_C==1023||FP_C==1003||FP_C==1017||FP_C==1007);
        case 587:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 589:return(FP_C==1005||FP_C==1004||FP_C==1144||FP_C==1145||FP_C==1020||FP_C==1018||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1024||FP_C==1013||FP_C==1006||FP_C==1016||FP_C==1000||FP_C==1017||FP_C==1007);
        case 600:return(FP_C==1005||FP_C==1004||FP_C==1020||FP_C==1022||FP_C==1018||FP_C==1013||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1006||FP_C==1017||FP_C==1007);
        case 602:return(FP_C==1008||FP_C==1009||FP_C==1010);
        case 603:return(FP_C==1144||FP_C==1145||FP_C==1142||FP_C==1143||FP_C==1020||FP_C==1019||FP_C==1018||FP_C==1024||FP_C==1008||FP_C==1009||FP_C==1010||FP_C==1006||FP_C==1001||FP_C==1023||FP_C==1017||FP_C==1007);
    }
    return false;
}

stock LoadingSetting()
{
    if(fexist("FP_Protection_AD.ini")){
	    new iniFile=ini_openFile("FP_Protection_AD.ini");
        ini_getInteger(iniFile,"MF_OnPlayerRequestClass",MF_OnPlayerRequestClass);
        ini_getInteger(iniFile,"MF_OnPlayerSpawn",MF_OnPlayerSpawn);
        ini_getInteger(iniFile,"MF_OnPlayerDeath",MF_OnPlayerDeath);
        ini_getInteger(iniFile,"MF_OnVehicleDeath",MF_OnVehicleDeath);
        ini_getInteger(iniFile,"MF_OnPlayerText",MF_OnPlayerText);
        ini_getInteger(iniFile,"MF_OnPlayerCommandText",MF_OnPlayerCommandText);
        ini_getInteger(iniFile,"MF_OnPlayerEnterVehicle",MF_OnPlayerEnterVehicle);
        ini_getInteger(iniFile,"MF_OnPlayerExitVehicle",MF_OnPlayerExitVehicle);
        ini_getInteger(iniFile,"MF_OnPlayerStateChange",MF_OnPlayerStateChange);
        ini_getInteger(iniFile,"MF_OnPlayerEnterCheckpoint",MF_OnPlayerEnterCheckpoint);
        ini_getInteger(iniFile,"MF_OnPlayerLeaveCheckpoint",MF_OnPlayerLeaveCheckpoint);
        ini_getInteger(iniFile,"MF_OnPlayerEnterRaceCheckpoint",MF_OnPlayerEnterRaceCheckpoint);
        ini_getInteger(iniFile,"MF_OnPlayerLeaveRaceCheckpoint",MF_OnPlayerLeaveRaceCheckpoint);
        ini_getInteger(iniFile,"MF_OnPlayerRequestSpawn",MF_OnPlayerRequestSpawn);
        ini_getInteger(iniFile,"MF_OnPlayerPickUpPickup",MF_OnPlayerPickUpPickup);
        ini_getInteger(iniFile,"MF_OnVehicleMod",MF_OnVehicleMod);
        ini_getInteger(iniFile,"MF_OnVehiclePaintjob",MF_OnVehiclePaintjob);
        ini_getInteger(iniFile,"MF_OnVehicleRespray",MF_OnVehicleRespray);
        ini_getInteger(iniFile,"MF_OnPlayerSelectedMenuRow",MF_OnPlayerSelectedMenuRow);
        ini_getInteger(iniFile,"MF_OnPlayerExitedMenu",MF_OnPlayerExitedMenu);
        ini_getInteger(iniFile,"MF_OnPlayerInteriorChange",MF_OnPlayerInteriorChange);
        ini_getInteger(iniFile,"MF_OnDialogResponse",MF_OnDialogResponse);
        ini_getInteger(iniFile,"MF_OnPlayerClickPlayer",MF_OnPlayerClickPlayer);
        ini_getInteger(iniFile,"MF_OnPlayerWeaponShot",MF_OnPlayerWeaponShot);
        ini_getInteger(iniFile,"MF_OnPlayerGiveDamage",MF_OnPlayerGiveDamage);
        ini_getInteger(iniFile,"MF_OnPlayerTakeDamage",MF_OnPlayerTakeDamage);
        ini_getInteger(iniFile,"MF_OnPlayerClickMap",MF_OnPlayerClickMap);
        ini_getInteger(iniFile,"MF_OnPlayerClickTextDraw",MF_OnPlayerClickTextDraw);
        ini_getInteger(iniFile,"MF_OnPlayerClickPlayerTextDraw",MF_OnPlayerClickPlayerTextDraw);
        ini_getInteger(iniFile,"MF_Reconnect",MF_Reconnect);
        ini_getInteger(iniFile,"MF_Bot",MF_Bot);
        ini_getInteger(iniFile,"MF_Dos",MF_Dos);
        ini_getInteger(iniFile,"MF_VehicleHack",MF_VehicleHack);
        ini_getInteger(iniFile,"MF_Ping",MF_Ping);
        ini_closeFile(iniFile);
		print("Open FP_Protection_AD.ini");
    }else{
	    new iniFile=ini_createFile("FP_Protection_AD.ini");
	    ini_setInteger(iniFile,"MF_OnPlayerRequestClass",MF_OnPlayerRequestClass=7);
	    ini_setInteger(iniFile,"MF_OnPlayerSpawn",MF_OnPlayerSpawn=5);
	    ini_setInteger(iniFile,"MF_OnPlayerDeath",MF_OnPlayerDeath=5);
	    ini_setInteger(iniFile,"MF_OnVehicleDeath",MF_OnVehicleDeath=5);
	    ini_setInteger(iniFile,"MF_OnPlayerText",MF_OnPlayerText=5);
	    ini_setInteger(iniFile,"MF_OnPlayerCommandText",MF_OnPlayerCommandText=5);
	    ini_setInteger(iniFile,"MF_OnPlayerEnterVehicle",MF_OnPlayerEnterVehicle=5);
	    ini_setInteger(iniFile,"MF_OnPlayerExitVehicle",MF_OnPlayerExitVehicle=5);
	    ini_setInteger(iniFile,"MF_OnPlayerStateChange",MF_OnPlayerStateChange=5);
	    ini_setInteger(iniFile,"MF_OnPlayerEnterCheckpoint",MF_OnPlayerEnterCheckpoint=5);
	    ini_setInteger(iniFile,"MF_OnPlayerLeaveCheckpoint",MF_OnPlayerLeaveCheckpoint=5);
	    ini_setInteger(iniFile,"MF_OnPlayerEnterRaceCheckpoint",MF_OnPlayerEnterRaceCheckpoint=5);
	    ini_setInteger(iniFile,"MF_OnPlayerLeaveRaceCheckpoint",MF_OnPlayerLeaveRaceCheckpoint=5);
	    ini_setInteger(iniFile,"MF_OnPlayerRequestSpawn",MF_OnPlayerRequestSpawn=5);
	    ini_setInteger(iniFile,"MF_OnPlayerPickUpPickup",MF_OnPlayerPickUpPickup=5);
	    ini_setInteger(iniFile,"MF_OnVehicleMod",MF_OnVehicleMod=5);
	    ini_setInteger(iniFile,"MF_OnVehiclePaintjob",MF_OnVehiclePaintjob=5);
	    ini_setInteger(iniFile,"MF_OnVehicleRespray",MF_OnVehicleRespray=5);
	    ini_setInteger(iniFile,"MF_OnPlayerSelectedMenuRow",MF_OnPlayerSelectedMenuRow=5);
	    ini_setInteger(iniFile,"MF_OnPlayerExitedMenu",MF_OnPlayerExitedMenu=5);
	    ini_setInteger(iniFile,"MF_OnPlayerInteriorChange",MF_OnPlayerInteriorChange=5);
	    ini_setInteger(iniFile,"MF_OnDialogResponse",MF_OnDialogResponse=5);
	    ini_setInteger(iniFile,"MF_OnPlayerClickPlayer",MF_OnPlayerClickPlayer=5);
	    ini_setInteger(iniFile,"MF_OnPlayerWeaponShot",MF_OnPlayerWeaponShot=25);
	    ini_setInteger(iniFile,"MF_OnPlayerGiveDamage",MF_OnPlayerGiveDamage=25);
	    ini_setInteger(iniFile,"MF_OnPlayerTakeDamage",MF_OnPlayerTakeDamage=25);
	    ini_setInteger(iniFile,"MF_OnPlayerClickMap",MF_OnPlayerClickMap=5);
	    ini_setInteger(iniFile,"MF_OnPlayerClickTextDraw",MF_OnPlayerClickTextDraw=5);
	    ini_setInteger(iniFile,"MF_OnPlayerClickPlayerTextDraw",MF_OnPlayerClickPlayerTextDraw=5);
	    ini_setInteger(iniFile,"MF_Reconnect",MF_Reconnect=501);
	    ini_setInteger(iniFile,"MF_Bot",MF_Bot=1);
	    ini_setInteger(iniFile,"MF_Dos",MF_Dos=799);
		ini_setInteger(iniFile,"MF_Ping",MF_Ping=1299);
		ini_closeFile(iniFile);
		print("Create FP_Protection_AD.ini");
    }
}
