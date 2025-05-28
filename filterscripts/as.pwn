#include <a_samp>
new Fallen[MAX_PLAYERS];
main() {}
public OnFilterScriptInit()
{
	return true;
}
public OnPlayerDisconnect(playerid, reason)
{
    KillTimer(Fallen[playerid]);
    return true;
}
public OnPlayerSpawn(playerid)
{
    if(GetPVarInt(playerid, "proverkaoff") < 1)
    {
        TogglePlayerControllable(playerid,0);
    	SetPVarInt(playerid,"connecttime",GetPVarInt(playerid, "connecttime") + 1);
    	Fallen[playerid] = SetTimerEx("CheckClient", 1600+(GetPlayerPing(playerid)*2), 0, "ii", playerid);
		TogglePlayerControllable(playerid,0);
	}
	return true;
}
forward CheckClient(playerid);
public CheckClient(playerid)
{
    if(GetPVarInt(playerid, "connecttime") > 1) return Kick(playerid);
	new Float:pos[6];
	GetPlayerCameraPos(playerid, pos[0], pos[1], pos[2]), GetPlayerPos(playerid, pos[3], pos[4], pos[5]);
	if(floatabs(pos[2] - pos[5]) > 1.3) SetTimerEx("KickSob",5000,false,"i",playerid);
	SetPVarInt(playerid,"connecttime",0), SetPVarInt(playerid,"proverkaoff",1);
	TogglePlayerControllable(playerid,1);
	return true;
}
forward KickSob(playerid);
public KickSob(playerid)
{
	if(!IsPlayerConnected(playerid)) return true;
	SendClientMessage(playerid, 0x703A3AFF, "Вы были кикнуты за использование чит программ. (cod: Программа Sobeit)");
	SendClientMessage(playerid, 0x703A3AFF, "Удалите файл в папке с игрой: \"d3d9.dll\"");
	SetTimerEx("KickSob1",1000,false,"i",playerid);
	return true;
}
forward KickSob1(playerid);
public KickSob1(playerid) return Kick(playerid);
