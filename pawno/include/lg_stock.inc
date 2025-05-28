
stock CreateVehicleEx(modelid, Float: X, Float: Y, Float: Z, Float: A, Color1, Color2, SpawnDelay)
{
	new id = CreateVehicle(modelid, X, Y, Z, A, Color1, Color2, SpawnDelay);
	gVehicles[id - 1][vCheckDelay] = true;
	gVehicles[id - 1][vX] = X;
	gVehicles[id - 1][vY] = Y;
	gVehicles[id - 1][vZ] = Z;
	gVehicles[id - 1][vA] = A;
	gVehicles[id - 1][vSpawned] = true;
	gVehicles[id - 1][vCheckDelay] = true;
	return id;
}

stock AddStaticVehicleExEx(modelid, Float: X, Float: Y, Float: Z, Float: A, Color1, Color2, SpawnDelay)
{
	new id = AddStaticVehicleEx(modelid, X, Y, Z, A, Color1, Color2, SpawnDelay);
	gVehicles[id - 1][vCheckDelay] = true;
	gVehicles[id - 1][vX] = X;
	gVehicles[id - 1][vY] = Y;
	gVehicles[id - 1][vZ] = Z;
	gVehicles[id - 1][vA] = A;
	gVehicles[id - 1][vSpawned] = true;
	gVehicles[id - 1][vCheckDelay] = true;
	return id;
}

stock AddStaticVehicleExx(modelid, Float: X, Float: Y, Float: Z, Float: A, Color1, Color2)
{
	new id = AddStaticVehicle(modelid, X, Y, Z, A, Color1, Color2);
	gVehicles[id - 1][vCheckDelay] = true;
	gVehicles[id - 1][vX] = X;
	gVehicles[id - 1][vY] = Y;
	gVehicles[id - 1][vZ] = Z;
	gVehicles[id - 1][vA] = A;
	gVehicles[id - 1][vSpawned] = true;
	gVehicles[id - 1][vCheckDelay] = true;
	return id;
}

stock SetVehiclePosEx(vehicleid, Float: X, Float: Y, Float: Z) {
	gVehicles[vehicleid - 1][vCheckDelay] = true;
	gVehicles[vehicleid - 1][vX] = X;
	gVehicles[vehicleid - 1][vY] = Y;
	gVehicles[vehicleid - 1][vZ] = Z;
	SetVehiclePos(vehicleid, X, Y, Z);
	gVehicles[vehicleid - 1][vCheckDelay] = true;
	return 1;
}

stock SetVehicleZAngleEx(vehicleid, Float: Angle) {
	gVehicles[vehicleid - 1][vCheckDelay] = true;
	gVehicles[vehicleid - 1][vA] = Angle;
	SetVehicleZAngle(vehicleid, Angle);
	gVehicles[vehicleid - 1][vCheckDelay] = true;
	return 1;
}

stock RemovePlayerFromVehicleEx(playerid)
{
	SetTimerEx("CarHack",3000,false,"ii",playerid,GetPlayerVehicleID(playerid));
	return RemovePlayerFromVehicle(playerid);
}

stock PutPlayerInVehicleEx(playerid,vehicleid,seatid)
{
	pTemp[playerid][pEnterVehicle] = vehicleid;
	PutPlayerInVehicle(playerid,vehicleid,seatid);
}

stock TogglePlayerControllableEx(playerid,toggle)
{
	pTemp[playerid][pControllable] = toggle;
	TogglePlayerControllable(playerid,toggle);
}

stock SetPlayerVirtualWorldEx(playerid,worldid)
{
	pTemp[playerid][pWorld] = worldid;
	SetPlayerVirtualWorld(playerid,worldid);
}

stock SetVehicleParamsExEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective)
{
	if(engine == 1) gVehicles[vehicleid-1][vEngine] = true;
	else gVehicles[vehicleid-1][vEngine] = false;
	SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
}

stock SetPlayerSkinEx(playerid,skinid)
{
	pTemp[playerid][pCSkin] = skinid;
	SetPlayerSkin(playerid,skinid);
}

stock SetPlayerSkinNA(playerid,skinid)
{
	SetPlayerSkin(playerid,skinid);
}

stock SetPlayerPosEx(playerid,Float:x,Float:y,Float:z, control = 1)
{
	pTemp[playerid][pAbletoTP] = true;
	if(control) TogglePlayerControllableEx(playerid,1);
	pTemp[playerid][pX] = x;
	pTemp[playerid][pY] = y;
	pTemp[playerid][pZ] = z;
	return SetPlayerPos(playerid,x,y,z);
}

stock ResetPlayerWeaponsEx(playerid)
{
	pTemp[playerid][pAbletoGun] = 2;
	ResetPlayerWeapons(playerid);
	for(new i;i<13;i++)
	{
		gGuns[playerid][i] = 0;
		gAmmos[playerid][i] = 0;
	}
	pTemp[playerid][pAbletoGun] = 2;
}

stock ShowPlayerDialogEx(playerid,dialogid,style,caption[],info[],button1[],button2[])
{
	pTemp[playerid][pDialog] = true;
	return ShowPlayerDialog(playerid,dialogid,style,caption,info,button1,button2);
}

stock ChangeVehicleColorEx(vehicleid,color1,color2)
{
	gVehicles[vehicleid-1][vColor][0] = color1+1;
	gVehicles[vehicleid-1][vColor][1] = color2+1;
	ChangeVehicleColor(vehicleid,color1,color2);
}

stock PlayerTextDrawDestroyEx(playerid,PlayerText:textdraw)
{
	PlayerTextDrawDestroy(playerid,textdraw);
	textdraw = PlayerText:INVALID_TEXT_DRAW;
}

#define CreateVehicle CreateVehicleEx
#define AddStaticVehicleEx AddStaticVehicleExEx
#define AddStaticVehicle AddStaticVehicleExx
#define SetVehiclePos SetVehiclePosEx
#define SetVehicleZAngle SetVehicleZAngleEx
#define RemovePlayerFromVehicle RemovePlayerFromVehicleEx
#define PutPlayerInVehicle PutPlayerInVehicleEx
#define TogglePlayerControllable TogglePlayerControllableEx
#define SetPlayerVirtualWorld SetPlayerVirtualWorldEx
#define SetVehicleParamsEx SetVehicleParamsExEx
#define SetPlayerSkin SetPlayerSkinEx
#define SetPlayerPos SetPlayerPosEx
#define ResetPlayerWeapons ResetPlayerWeaponsEx
#define ShowPlayerDialog ShowPlayerDialogEx
#define ChangeVehicleColor ChangeVehicleColorEx
#define PlayerTextDrawDestroy PlayerTextDrawDestroyEx

stock DestroyDynamic3DTextLabelEx(&Text3D:text)
{
	DestroyDynamic3DTextLabel(text);
	text = Text3D:INVALID_3DTEXT_ID;
}

stock IsValid3DTextLabel(Text3D:textid)
{
	if(textid != Text3D:INVALID_3DTEXT_ID) return 1;
	else return 0;
}
