#include <a_samp>


// ----------===== [Inventory] =====----------
#define D_INV          200
#define MAX_ITEMS      74
#define ALL_ITEMS_SIZE 30
#define MAX_OBJECT     1000
#define itDS InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot") ]
new Text:LEGALINV[68];
new Text: BUTTONS[11];

enum PlayerInv
{
	invName[MAX_PLAYER_NAME],
	invSlot[MAX_ITEMS],
	invKol[MAX_ITEMS],
};
new InventoryPlayer[MAX_PLAYERS][PlayerInv];

enum invPlayer
{
	invName[50],
    invSize,
    invObject,
    invText[200],
};
new Items_All[ALL_ITEMS_SIZE][invPlayer] = {
    {"Пусто",0,19461,""},
	{"Клюшка для гольфа",1,333,"Ипользуется для игры в гольф, а так же как оружие ближнего боя"},
	{"Полицейская дубинка",2,334,"Используется полицейскими, при задержании кого-либо"},
	{"Охотничий нож",3,335,"Используется охотниками, для разделки животных"},
	{"Бейсбольная бита",4,336,"Используется для игры в бейсбол"},
	{"Большая лопата",5,337,"Используется для копания чего-либо в земле"},
	{"Катана",6,339,""},
	{"Букет цветов",7,325,"Хороший подарок на свадьбу или просто так"},
	{"Пистолет 9мм",8,346,"Огнестрельное оружие с малым весом"},
	{"Пистолет 9мм ( С глушителем )",9,347,"Огнестрельное, тихое оружие с малым весом"},
	{"Пустынный Орёл",10,348,"Огнестрельное, мощное оружие с малым весом"},
	{"Дробовик 'Shotgun'",11,349,""},
	{"Дробовик 'Combat Shotgun'",12,351,""},
	{"Пистолет - пулимёт 'Micro UZI'",13,352,""},
	{"Пистолет - пулимёт 'MP5'",14,353,""},
	{"Пистолет - пулимёт 'Tec 9'",15,372,""},
	{"Штурмовая винтовка 'AK-47'",16,355,""},
	{"Штурмовая винтовка 'M4'",17,356,""},
	{"Охотнячья винтовка",18,357,""},
	{"Охотнячья винтовка ( С Оптикой )",19,358,""},
	{"Парашют",20,371,""},
	{"Балончик с краской",21,365,""},
	{"Огнетушитель",22,366,""},
	{"Фото-камера",23,367,""},
	{"Бронижелет",24,1242,""},
	{"Свёрток с наркотиками",25,1279,""},
	{"Одежда",26,2704,""},
	{"Коробка с пиццей",27,2814,""},
	{"Шаурма",28,2769,""},
	{"Гамбургер",29,2768,""}
};

enum ObjInv
{
	obiDrop[2],
	Float:obiDropPos[3],
	obiObject,
};

new ObjectInv[MAX_OBJECT][ObjInv];




stock LoadInventory(playerid)
{
    new str[512];
	FMQ("SELECT * FROM `inventory` WHERE `Name`='%s' LIMIT 1",pData[playerid][pNickname]);
	mysql_store_result();
	if(mysql_num_rows() != 0)
	{
		for(new x; x != MAX_ITEMS; x++)
	    {
            new str1[100],str2[100],buffer[32];
            format(str1,100,"Inv%d",x);
            format(str2,100,"InvKol%d",x);
            mysql_fetch_field_row(buffer, str1), InventoryPlayer[playerid][invSlot][x] = strval(buffer);
            mysql_fetch_field_row(buffer, str2), InventoryPlayer[playerid][invKol][x] = strval(buffer);
			//printf(" [invSlot][x]", InventoryPlayer[playerid][invSlot][x]);
            //printf(" [invKol][x]",  InventoryPlayer[playerid][invSlot][x]);

		}
		print("[x]");  //mysql_fetch_field_row(buffer, str1), InventoryPlayer[playerid][invSlot][x] = strval(buffer);
	}
	else
	{
	    format(str,sizeof(str),"INSERT INTO `inventory` (`Name`) VALUES ('%s')", pData[playerid][pNickname]);
	    mysql_query(str);
	    for(new x; x != MAX_ITEMS; x++)
        {
            InventoryPlayer[playerid][invSlot][x] = 0;
		    InventoryPlayer[playerid][invKol][x] = 0;
        }
        print("ANON");
        SaveInventory(playerid);
        LoadInventory(playerid);
	}
	mysql_free_result();
	return 1;
}

stock SaveInventory(playerid)
{
	for(new x; x != MAX_ITEMS; x++)
    {
		new query[128];
		format(query,sizeof(query),"UPDATE `inventory` SET `Inv%d` = '%d', `InvKol%d` = '%d' WHERE `Name` = '%s'",
		x,
		InventoryPlayer[playerid][invSlot][x],
		x,
		InventoryPlayer[playerid][invKol][x],
		pData[playerid][pNickname]);
		mysql_query(query);
 	}
 	print("SAVEINV");
	return 1;
}



stock OpenInventory(playerid)
{
	print("YES");
	print("YES1");
	TextDrawSetPreviewModel(LEGALINV[15], GetPlayerSkin(playerid));
	for(new i = 16; i < sizeof(LEGALINV); i++)
	{
        if(InventoryPlayer[playerid][invSlot][i] == 0) {
			TextDrawSetPreviewModel(LEGALINV[i], 19461),
			TextDrawSetPreviewRot(LEGALINV[i], 0.000000, 0.000000, 90.000000, 0.100000);
		}
        else  {
			TextDrawSetPreviewModel(LEGALINV[i],
			Items_All[InventoryPlayer[playerid][invSlot][i]][invObject]),
			TextDrawSetPreviewRot(LEGALINV[i], -16.000000, -20.000000, -55.000000, 1.100000);
		}
	}
	for(new j; j < sizeof(LEGALINV); j ++) TextDrawShowForPlayer(playerid,LEGALINV[j]);
	for(new i; i < sizeof(BUTTONS); i++) TextDrawShowForPlayer(playerid, BUTTONS[i]);
	SetPVarInt(playerid,"InvH",1);
	SetPVarInt(playerid,"SelectSlot",0);
	SetPVarInt(playerid,"ChangeSlot",0);
	return 1;
}


stock GiveInventory(playerid, item, amount)
{
 	for(new k = 32; k < sizeof(LEGALINV); k++)
	{
		if(InventoryPlayer[playerid][invSlot][k] == 0)
		{
			InventoryPlayer[playerid][invSlot][k] = item;
			InventoryPlayer[playerid][invKol][k] = amount;
			SetPVarInt(playerid,"SelectSlot",0);
        	SetPVarInt(playerid,"ChangeSlot",0);
			return true;
		}
	}
	return false;
}


stock DropInventory(playerid, Float:x, Float:y, Float:z)
{
    for(new i = 0; i < sizeof(ObjectInv); i++)
    {
		if( ObjectInv[i][obiDropPos][0] == 0.0 &&  ObjectInv[i][obiDropPos][1] == 0.0 &&  ObjectInv[i][obiDropPos][2] == 0.0)
        {
		    ObjectInv[i][obiDrop][0] = InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")];
		    ObjectInv[i][obiDrop][1] = InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"SelectSlot")];
		    ObjectInv[i][obiDropPos][0] = x;
		    ObjectInv[i][obiDropPos][1] = y;
		    ObjectInv[i][obiDropPos][2] = z;
		    ObjectInv[i][obiObject] = CreateObject(Items_All[InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")]][invObject], ObjectInv[i][obiDropPos][0], ObjectInv[i][obiDropPos][1], ObjectInv[i][obiDropPos][2]-1, 80.0, 0.0, 0.0);
		    InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] = 0;
	        InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"SelectSlot")] = 0;
	        SetPVarInt(playerid,"SelectSlot",0);
	        SetPVarInt(playerid,"ChangeSlot",0);
			OpenInventory(playerid);
			SFCM(playerid,0xffffffff," i = %d  %d  %d  ", i, ObjectInv[i][obiDrop][0], ObjectInv[i][obiDrop][1]);
		    return 1;
		}
	}
	return 1;
}

stock ObjInventory(playerid)
{
    if(GetPVarInt(playerid,"ChangeSlot") == GetPVarInt(playerid,"SelectSlot")) return SetPVarInt(playerid,"ChangeSlot",0);
	if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] != 0 && InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] != InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"ChangeSlot")]) return SetPVarInt(playerid,"ChangeSlot",0);
    if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] == InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"ChangeSlot")])
	{
        InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"ChangeSlot")] = 0;
        InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"SelectSlot")] += InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"ChangeSlot")];
        InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"ChangeSlot")] = 0;
    }
	if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] == 0)
	{
        InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] = InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"ChangeSlot")];
        InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"SelectSlot")] = InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"ChangeSlot")];
        InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"ChangeSlot")] = 0;
        InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"ChangeSlot")] = 0;
    }
	return 1;
}

stock UpdateInventory(playerid)
{
    if(GetPVarInt(playerid,"ChangeSlot") == GetPVarInt(playerid,"SelectSlot")) return SetPVarInt(playerid,"ChangeSlot",0);
	if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] != 0 && InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] != InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"ChangeSlot")]) return SetPVarInt(playerid,"ChangeSlot",0);
    if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"ChangeSlot")] != 0)
	{
	    TextDrawSetPreviewModel(LEGALINV[GetPVarInt(playerid,"ChangeSlot")], 19461),TextDrawSetPreviewRot(LEGALINV[GetPVarInt(playerid,"ChangeSlot")], 0.000000, 0.000000, 90.000000, 0.100000);
	    TextDrawSetPreviewModel(LEGALINV[GetPVarInt(playerid,"SelectSlot")], Items_All[InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"ChangeSlot")]][invObject]),TextDrawSetPreviewRot(LEGALINV[GetPVarInt(playerid,"SelectSlot")], -16.000000, -20.000000, -55.000000, 1.100000);
	    TextDrawShowForPlayer(playerid,LEGALINV[GetPVarInt(playerid,"ChangeSlot")]);
	    TextDrawShowForPlayer(playerid,LEGALINV[GetPVarInt(playerid,"SelectSlot")]);
	}
	return 1;
}

public OnGameModeExit()
{
	for(new x; x < sizeof(Textd); ++x) TextDrawHideForAll(Textd[x]), TextDrawDestroy(Textd[x]);
	return 1;
}



public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(_:clickedid == INVALID_TEXT_DRAW)
	{
	    if( pTemp[playerid][pSHOWtext] == 1)
	    {
	    	for(new x; x < sizeof(Textd); ++x)
			{
				TextDrawHideForPlayer(playerid, Textd[x]);
	    		pTemp[playerid][pSHOWtext] = 0;
	    	}
	    	if(GetPVarInt(playerid,"InvH") == 1)
			{
				for(new i; i < sizeof(LEGALINV); i++) TextDrawHideForPlayer(playerid,LEGALINV[i]);
				for(new i; i < sizeof(BUTTONS); i++) TextDrawHideForPlayer(playerid, BUTTONS[i]);
				CancelSelectTextDraw(playerid);
				DeletePVar(playerid,"InvH");
			}
		}
	}
	for(new i = 16; i < sizeof(LEGALINV); i++)
	{
    	if(clickedid == LEGALINV[15]) {SFCM(playerid,0xffffffff, "id %d", i ); return 1; }
        if(clickedid == LEGALINV[i])
        {
			SFCM(playerid,0xffffffff, "id %d", i );

			if(GetPVarInt(playerid,"ChangeSlot") == 0)
			{
                SetPVarInt(playerid,"SelectSlot",i);
                if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] == 0) { }
				else
				{
                    SetPVarInt( playerid,"ChangeSlot", GetPVarInt(playerid,"SelectSlot") );
				    TextDrawBackgroundColor( LEGALINV[ GetPVarInt(playerid,"ChangeSlot") ], 0xddddddff);
				    TextDrawShowForPlayer(playerid,  LEGALINV[ GetPVarInt(playerid,"ChangeSlot")] );
				}
			}
			else if(GetPVarInt(playerid,"ChangeSlot") != 0)
			{
				SetPVarInt(playerid,"SelectSlot",i);
                TextDrawBackgroundColor(LEGALINV[GetPVarInt(playerid,"ChangeSlot")], -86);
                TextDrawShowForPlayer(playerid,LEGALINV[GetPVarInt(playerid,"ChangeSlot")]);
                UpdateInventory(playerid);
                ObjInventory(playerid);
                SetPVarInt(playerid,"ChangeSlot",0);
                SetPVarInt(playerid,"SelectSlot",0);
                return 1;
			}
        }
    }
	if(clickedid == BUTTONS[0]) // = TextDrawCreate(105.000000, 411.000000, "CRAFT");
	{
		if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] == 0 && InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"SelectSlot")] == 0) return 1;
	}
	if(clickedid == BUTTONS[1]) // = TextDrawCreate(427.000000, 410.000000, "DROP");
	{
		if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] == 0 && InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"SelectSlot")] == 0) return 1;
        new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid,x,y,z);
		DropInventory(playerid, x, y, z);
	}
	if(clickedid == BUTTONS[2]) // = TextDrawCreate(484.000000, 410.000000, "DELETE");
	{
		if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] == 0 && InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"SelectSlot")] == 0) return 1;
		InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] = 0;
        InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"SelectSlot")] = 0;
        SetPVarInt(playerid,"SelectSlot",0);
        SetPVarInt(playerid,"ChangeSlot",0);
		OpenInventory(playerid);
	}
	if(clickedid == BUTTONS[3]) // = TextDrawCreate(569.000000, 410.000000, "i");
	{
		if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] == 0 && InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"SelectSlot")] == 0) return 1;
        new string[200];
		format(string,sizeof(string),"{ffffff}???????: {32CD32}%s{ffffff}\n?????????????: {32CD32}%s{ffffff}\n?????????? ( ??????? ): {32CD32}%d",Items_All[InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")]][invName],Items_All[InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")]][invText],InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"SelectSlot")]);
        ShowPlayerDialog(playerid,999,0,"?????????",string,"???????","");
	}
	if(clickedid == BUTTONS[4]) // = TextDrawCreate(588.000000, 410.000000, "X");
	{
		if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] == 0 && InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"SelectSlot")] == 0) return 1;
    	for(new i; i < sizeof(LEGALINV); i++) TextDrawHideForPlayer(playerid,LEGALINV[i]);
    	for(new i; i < sizeof(BUTTONS); i++) TextDrawHideForPlayer(playerid, BUTTONS[i]);
    	CancelSelectTextDraw(playerid);
		DeletePVar(playerid,"InvH");
	}
	if(clickedid == BUTTONS[5]) // = TextDrawCreate(429.000000, 127.000000, "GIVE");
	{
		if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] == 0 && InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"SelectSlot")] == 0) return 1;
		ShowPlayerDialog(playerid,D_INV,1,"?????????","{ffffff}??????? ID ?????? ? ????? - ???-?? ????????, ??????? ?????? ????????!","??????","???????");
	}
	if(clickedid == BUTTONS[6]) // = TextDrawCreate(497.000000, 127.000000, "BUY");
	{
		if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] == 0 && InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"SelectSlot")] == 0) return 1;
	}
	if(clickedid == BUTTONS[7]) // = TextDrawCreate(557.000000, 127.000000, "SELL");
	{
		if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] == 0 && InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"SelectSlot")] == 0) return 1;
	}
	if(clickedid == BUTTONS[8]) // = TextDrawCreate(435.000000, 147.000000, "INV");
	{
		if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] == 0 && InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"SelectSlot")] == 0) return 1;
        if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] != 0 && InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"SelectSlot")] != 0)
        {
            if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] == 29)
            {
				// ?????????? ???????? ???? ????? ?????????? ???? 29, ?????? ?????????
            }
        }
	}
	if(clickedid == BUTTONS[9]) // = TextDrawCreate(495.000000, 147.000000, "CAR");
	{
		if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] == 0 && InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"SelectSlot")] == 0) return 1;
	}
	if(clickedid == BUTTONS[10]) // = TextDrawCreate(549.000000, 147.000000, "HOUSE");
	{
		if(InventoryPlayer[playerid][invSlot][GetPVarInt(playerid,"SelectSlot")] == 0 && InventoryPlayer[playerid][invKol][GetPVarInt(playerid,"SelectSlot")] == 0) return 1;
	}
    return 0;
}





