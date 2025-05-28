// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>
#include <gl_common>

#define CCOUNT 23

#define COLOR_INTERFACE 0xFFFFFFFF

new Float:C[CCOUNT][6] = {
{1809.5001,-1879.9326,600.0,1789.6129,-1909.9594,13.3964},
{1809.5001,-1879.9326,60.0,1789.6129,-1909.9594,13.3964},
{1777.9127,-1876.2391,60.0,1789.6129,-1909.9594,13.3964},
{1748.8058,-1886.2682,60.0,1789.6129,-1909.9594,13.3964},
{1750.9515,-1934.2048,60.0,1789.6129,-1909.9594,13.3964},
{1787.7444,-1939.9906,60.0,1755.0529,-1894.1108,13.5568},
{1802.2534,-1923.6000,300.0,579.2227,890.3305,-43.5379},
{878.4709,782.3186,40.0,816.8671,856.7813,12.7891},
{671.3151,975.7813,20.0,579.2227,890.3305,-43.5379},
{483.6328,889.4773,-15.0,579.2227,890.3305,-43.5379},
{483.6328,889.4773,600.0,-1983.6453,-2380.3425,30.6250},
{-1945.1439,-2377.2119,65.0,-1983.6453,-2380.3425,30.6250},
{-1945.1439,-2377.2119,65.0,-1983.6453,-2380.3425,30.6250},
{-1945.1439,-2377.2119,600.0,-1030.8287,-687.4454,32.0078},
{-933.8494,-742.1143,300.0,-1030.8287,-687.4454,32.0078},
{-997.0070,-648.4550,60.0,-1030.8287,-687.4454,32.0078},
{-1994.7119,-60.8747,60.0,-2034.8817,-100.1375,35.1641},
{-2064.5833,-90.7193,35.0,-2064.4204,-74.2049,35.1719},
{-2093.3811,-92.6768,35.0,-2093.7485,-71.1859,35.1719},
{1409.8151,-1319.4252,130.0,1786.4451,-1296.6067,13.4042},
{1783.8922,-1270.6921,20.0,1786.4451,-1296.6067,13.4042},
{1802.8007,-1297.4825,23.0,1816.5016,-1296.9034,23.0},
{1802.8007,-1297.4825,300.0,1816.5016,-1296.9034,300.0}
};

new gCurPos[MAX_PLAYERS];
new gDelay[CCOUNT] = {6000,6000,6000,6000,6000,6000,3000,6000,5000,5000,2000,4000,2000,2000,6000,2000,4000,6000,5000,7000,3000,15000};
new gTimer[MAX_PLAYERS][2];

public OnFilterScriptInit()
{	
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
	if(gTimer[playerid][0]) KillTimer(gTimer[playerid][0]), gTimer[playerid][0] = 0;
	if(gTimer[playerid][1]) KillTimer(gTimer[playerid][1]), gTimer[playerid][1] = 0;
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

forward GoIntro(playerid);
public GoIntro(playerid)
{
	gCurPos[playerid] = 0;		
	PlayAudioStreamForPlayer(playerid,"http://nsaadfs.googlecode.com/files/ready.mp3");
	SetPlayerWeather(playerid,1);
	gTimer[playerid][0] = SetTimerEx("StartIntro",2000,false,"i",playerid);
}

/*public OnPlayerCommandText(playerid, cmdtext[])
{	
	new cmd[128], idx, tmp[128];
	cmd = strtok(cmdtext, idx);	
	if(!strcmp(cmd,"/animlist",true))
	{
	    tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)||strval(tmp)<0||strval(tmp)>2) return SendClientMessage(playerid,COLOR_INTERFACE,"Неверный ID списка анимаций. Доступные: 1, 2.");
		switch(strval(tmp))
	    {
	        case 1:
	        {
				SendClientMessage(playerid,COLOR_INTERFACE,"/animairport, /animattractors, /animbar, /animbaseball, /animbdfire, /animbeach");
		        SendClientMessage(playerid,COLOR_INTERFACE,"/animbenchpress, /animbf, /animbiked, /animbikeh, /animbikeleap, /animbikes");
		        SendClientMessage(playerid,COLOR_INTERFACE,"/animbikev, /animbikedbz, /animbmx, /animbomber, /animbox, /animbsktball");
		        SendClientMessage(playerid,COLOR_INTERFACE,"/animbuddy, /animbus, /animcamera, /animcar, /animcarry, /animcarchat, /animcasino");
		        SendClientMessage(playerid,COLOR_INTERFACE,"/animchainsaw, /animchoppa, /animclothes, /animcoach, /animcolt, /animcopambient");
		        SendClientMessage(playerid,COLOR_INTERFACE,"/animcopdvbyz, /animcrack, /animcrib, /animdamjump, /animdancing, /animdealer");
		        SendClientMessage(playerid,COLOR_INTERFACE,"/animdildo, /animdodge, /animdozer, /animdrivebys, /animfat, /animfightb, /animfightc");
		        SendClientMessage(playerid,COLOR_INTERFACE,"/animfightd, /animfighte, /animfinale, /animfinale2, /animflame, /animflowers, /animfood, /animfreeweights");
		        SendClientMessage(playerid,COLOR_INTERFACE,"/animgangs, /animghands, /animghetto, /animgog, /animgraffity, /animgraveyard, /animgrenade, /animgym");
		        SendClientMessage(playerid,COLOR_INTERFACE,"/animhaircut, /animheist, /animinthouse, /animintoffice, /animintshop, /animjst, /animkart, /animkissing");
			}
			case 2:
			{
				SendClientMessage(playerid,COLOR_INTERFACE,"/animknife, /animlapdan1, /animlapdan2, /animlapdan3, /animlowrider, /animmdchase");
				SendClientMessage(playerid,COLOR_INTERFACE,"/animmddend, /animmedic, /animmisc, /animmtb, /animmusculcar, /animnevada");
				SendClientMessage(playerid,COLOR_INTERFACE,"/animonlookers, /animotb, /animparachute, /animpark, /animpaulnmac, /animped");
				SendClientMessage(playerid,COLOR_INTERFACE,"/animplayerdvbys, /animplayidles, /animpolice, /animpool, /animpoor, /animpython");
				SendClientMessage(playerid,COLOR_INTERFACE,"/animquad, /animquadbz, /animrapping, /animrifle, /animriot, /animrobbank");
				SendClientMessage(playerid,COLOR_INTERFACE,"/animrocket, /animrustler, /animryder, /animscratching, /animshamal, /animshop");
				SendClientMessage(playerid,COLOR_INTERFACE,"/animshotgun, /animsilenced, /animskate, /animsmoking, /animsniper, /animspraycan");
				SendClientMessage(playerid,COLOR_INTERFACE,"/animstrip, /animsunbathe, /animswat, /animsweet, /animswim, /animsword, /animtank, /animtattoos");
		        SendClientMessage(playerid,COLOR_INTERFACE,"/animtec, /animtrain, /animtruck, /animuzi, /animvan, /animvending, /animvortex, /animwayfarer");
		        SendClientMessage(playerid,COLOR_INTERFACE,"/animweap, /animwuzi, /animsex, /animsnm, /animblowjob, /handsup, /dance, /phone");
			}
		}
		return 1;
	}
  	if(!strcmp(cmd,"/arepair",true)) // работает только с изменённым файлом samp.dll (скачать: http://gta-news.org/load/31-1-0-40)
	{
		if(!IsPlayerAdmin(playerid)) return 1;
		tmp = strtok(cmdtext,idx);
		if(!strlen(tmp) || !isNumeric(tmp)) return SendClientMessage(playerid,0xCCCCCCFF,"/arepair [ID авто]");
		new vid = strval(tmp);
		new model = GetVehicleModel(vid);
		if(!model) return SendClientMessage(playerid,0xCCCCCCFF,"Неверный ID авто");
		RepairVehicle(vid);
	}
	return 0;
}*/

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

forward StartIntro(playerid);
public StartIntro(playerid)
{
	SetPlayerInterior(playerid,0);
	SetPlayerVirtualWorld(playerid,0);
	TogglePlayerControllable(playerid,0);
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid,x,y,z);
	SetPVarFloat(playerid,"oldx",x);
	SetPVarFloat(playerid,"oldy",y);
	SetPVarFloat(playerid,"oldz",z);	
	CallRemoteFunction("SetPlayerPosExA","ifff",playerid,1751.5311,-1899.4009,13.5576);
	//SetPlayerPos(playerid,1755.0529,-1894.1108,13.5568);
	new p = gCurPos[playerid];
	new d = gDelay[p];
	if(p < CCOUNT-1) 
	{
		InterpolateCameraPos(playerid,C[p][0],C[p][1],C[p][2],C[p+1][0],C[p+1][1],C[p+1][2],d,CAMERA_MOVE);
		InterpolateCameraLookAt(playerid,C[p][3],C[p][4],C[p][5],C[p+1][3],C[p+1][4],C[p+1][5],d,CAMERA_MOVE);
		gTimer[playerid][1] = SetTimerEx("NextPoint",d,false,"i",playerid);
	}
}

forward NextPoint(playerid);
public NextPoint(playerid)
{
	if(gTimer[playerid][0]) KillTimer(gTimer[playerid][0]), gTimer[playerid][0] = 0;
	gCurPos[playerid]++;
	new p = gCurPos[playerid];	
	if(p < CCOUNT-1) 
	{
		new d = gDelay[p];
		if(p == 7) CallRemoteFunction("SetPlayerPosExA","ifff",playerid,583.1791,873.0995,-38.5527);
		if(p == 11) CallRemoteFunction("SetPlayerPosExA","ifff",playerid,-1935.6278,-2361.3521,30.9381);
		if(p == 13) CallRemoteFunction("SetPlayerPosExA","ifff",playerid,-1005.7562,-714.7416,32.0078);
		if(p == 16) CallRemoteFunction("SetPlayerPosExA","ifff",playerid,-2035.5417,-103.2102,35.1719);
		if(p == 19) CallRemoteFunction("SetPlayerPosExA","ifff",playerid,1777.7246,-1296.6393,13.6328);
		InterpolateCameraPos(playerid,C[p][0],C[p][1],C[p][2],C[p+1][0],C[p+1][1],C[p+1][2],d,CAMERA_MOVE);
		InterpolateCameraLookAt(playerid,C[p][3],C[p][4],C[p][5],C[p+1][3],C[p+1][4],C[p+1][5],d,CAMERA_MOVE);
		if(gTimer[playerid][1]) {
			KillTimer(gTimer[playerid][1]);
			gTimer[playerid][1] = SetTimerEx("NextPoint",d,false,"i",playerid);
		}
	}
	else
	{
		new Float:x, Float:y, Float:z;
		x = GetPVarFloat(playerid,"oldx");
		y = GetPVarFloat(playerid,"oldy");
		z = GetPVarFloat(playerid,"oldz");
		CallRemoteFunction("SetPlayerPosExA","ifff",playerid,x,y,z);
		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid,1);
		if(gTimer[playerid][1]) {
			KillTimer(gTimer[playerid][1]);
			gTimer[playerid][1] = 0;
		}
	}
}
