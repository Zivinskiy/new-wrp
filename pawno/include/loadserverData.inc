	new result[1000];
	mysql_query("UPDATE `accounts` SET `status` = '0'");
	mysql_query("SELECT * FROM `hints`");
	mysql_store_result();
	if(mysql_num_rows() != HINTS_COUNT) print("Hints count difference");
	else
	{
		for(new i;i<mysql_num_rows();i++)
		{
			mysql_fetch_row(result);
			sscanf(result,"p<|>e<iffffffffis[51]>",gHints[i]);
			gHintStoreArea[i] = CreateDynamicSphere(gHintStore[i][0],gHintStore[i][1],gHintStore[i][2],2.0);
			gHintSafeArea[i] = CreateDynamicSphere(gHintSafe[i][0],gHintSafe[i][1],gHintSafe[i][2],2.0);
			gHintFreezArea[i] = CreateDynamicSphere(gHintFreez[i][0],gHintFreez[i][1],gHintFreez[i][2],2.0);
			//CreateDynamicObject(2708,gHintStore[i][0],gHintStore[i][1],gHintStore[i][2],gHintStore[i][3],gHintStore[i][4],gHintStore[i][5],i+500);
			if(i < HINTS_COUNT)
			{
				for(new k;k<9;k++)
				{
					//if(!k) CreateDynamicObject(2689,gHintDress[i][k][0],gHintDress[i][k][1],gHintDress[i][k][2],gHintDress[i][k][3],gHintDress[i][k][4],gHintDress[i][k][5],i+500);
					//if(k==1) CreateDynamicObject(2704,gHintDress[i][k][0],gHintDress[i][k][1],gHintDress[i][k][2],gHintDress[i][k][3],gHintDress[i][k][4],gHintDress[i][k][5],i+500);
					//if(k==2) CreateDynamicObject(2705,gHintDress[i][k][0],gHintDress[i][k][1],gHintDress[i][k][2],gHintDress[i][k][3],gHintDress[i][k][4],gHintDress[i][k][5],i+500);
					CreateDynamicObject(gHintGunID[k],gHintGun[i][k][0],gHintGun[i][k][1],gHintGun[i][k][2],gHintGun[i][k][3],gHintGun[i][k][4],gHintGun[i][k][5],i+500);
				}
			}
		}
	}
	mysql_free_result();
	mysql_query("SELECT * FROM `houses` ORDER BY `id`");
	mysql_store_result();
	if(mysql_num_rows() >= MAX_HOUSE_COUNT) print("Кол-во домов в базе больше максимального");
	else if(!mysql_num_rows()) print("Домов в базе не найдено");
	else
	{
		gHouseCount = mysql_num_rows();
		for(new i;i<mysql_num_rows();i++)
		{
			mysql_fetch_row(result);
			sscanf(result,"p<|>iiiia<i>[5]a<i>[9]a<i>[4]iiiiiffffffffis[24]a<i>[3]s[24]s[24]s[24]",gHouses[i][houseID],gHouses[i][houseClass],gHouses[i][housePrice],gHouses[i][houseHint],gHouses[i][houseImprove],gHouses[i][houseGun],gHouses[i][houseSkin],gHouses[i][houseSafeCode],gHouses[i][houseSafeMoney],gHouses[i][houseDrugs],gHouses[i][houseProducts],gHouses[i][houseClose],
			gHouses[i][houseX],gHouses[i][houseY],gHouses[i][houseZ],gHouses[i][houseR], gHouses[i][houseParkX],gHouses[i][houseParkY],gHouses[i][houseParkZ],gHouses[i][houseParkR],gHouses[i][houseOwnerID],gHouses[i][houseOwner],gHouses[i][houseHabitID],gHouseHabits[i][0],gHouseHabits[i][1],gHouseHabits[i][2]);
		//	printf("%d: %s[%d] %s[%d] %s[%d] %s[%d]",gHouses[i][houseID],gHouses[i][houseOwner],gHouses[i][houseOwnerID],gHouseHabits[i][0],gHouses[i][houseHabitID][0],gHouseHabits[i][1],gHouses[i][houseHabitID][1],gHouseHabits[i][2],gHouses[i][houseHabitID][2]);
			//printf("%.2f %.2f %.2f",gHouses[i][houseX],gHouses[i][houseY],gHouses[i][houseZ]);
			gHouseArea[i] = CreateDynamicSphere(gHouses[i][houseX],gHouses[i][houseY],gHouses[i][houseZ],2.0,0,0,-1);
			if(gHouses[i][houseOwnerID] != 0)
			{
				gHousePickup[i] = CreateDynamicPickup(1272,1,gHouses[i][houseX],gHouses[i][houseY],gHouses[i][houseZ]);
				gHouseIcon[i] = CreateDynamicMapIcon(gHouses[i][houseX],gHouses[i][houseY],gHouses[i][houseZ],32,CWHITE);
			}
			else
			{
				gHousePickup[i] = CreateDynamicPickup(1273,1,gHouses[i][houseX],gHouses[i][houseY],gHouses[i][houseZ]);
				gHouseIcon[i] = CreateDynamicMapIcon(gHouses[i][houseX],gHouses[i][houseY],gHouses[i][houseZ],31,CWHITE);
			}
			new hintid = gHouses[i][houseHint];
			for(new k;k<5;k++) //Улучшения
			{
				if(!gHouses[i][houseImprove][k]) continue;
				switch(k)
				{
					case 1:	CreateDynamicObject(2332,gHintSafe[hintid][0],gHintSafe[hintid][1],gHintSafe[hintid][2],gHintSafe[hintid][3],gHintSafe[hintid][4],gHintSafe[hintid][5],i+1); //Сейф
					case 2: CreateDynamicObject(2141,gHintFreez[hintid][0],gHintFreez[hintid][1],gHintFreez[hintid][2],gHintFreez[hintid][3],gHintFreez[hintid][4],gHintFreez[hintid][5],i+1);
					case 3:
					{
						CreateDynamicObject(2708,gHintStore[hintid][0],gHintStore[hintid][1],gHintStore[hintid][2],gHintStore[hintid][3],gHintStore[hintid][4],gHintStore[hintid][5],i+1);
						new cnt;
						for(new l;l<4;l++)
						{
							if(gHouses[i][houseSkin][l]) cnt++;
						}
						cnt--;
						if(cnt < 0 && gHouses[i][houseOwnerID]) printf("Возможны лаги с одеждой в доме %d",i+1);
						else if(cnt > 0)
						{
							CreateDynamicObject(2689,gHintDress[hintid][0][0],gHintDress[hintid][0][1],gHintDress[hintid][0][2],gHintDress[hintid][0][3],gHintDress[hintid][0][4],gHintDress[hintid][0][5],i+1);
							if(cnt > 1) CreateDynamicObject(2704,gHintDress[hintid][1][0],gHintDress[hintid][1][1],gHintDress[hintid][1][2],gHintDress[hintid][1][3],gHintDress[hintid][1][4],gHintDress[hintid][1][5],i+1);
							if(cnt > 2) CreateDynamicObject(2705,gHintDress[hintid][2][0],gHintDress[hintid][2][1],gHintDress[hintid][2][2],gHintDress[hintid][2][3],gHintDress[hintid][2][4],gHintDress[hintid][2][5],i+1);
						}
						for(new l;l<9;l++)
						{
							if(!gHouses[i][houseGun][l]) continue;
							gHouseGunObject[i][l] = CreateDynamicObject(gHintGunID[l],gHintGun[hintid][l][0],gHintGun[hintid][l][1],gHintGun[hintid][l][2],gHintGun[hintid][l][3],gHintGun[hintid][l][4],gHintGun[hintid][l][5],i+1);
						}
					}
				}
			}
		}
		printf("%d houses loaded", gHouseCount);
	}
	mysql_free_result();
	for(new houseid; houseid < MAX_HOUSE_COUNT; houseid ++) {
		if(!gHouses[houseid][houseOwnerID]) continue;
		new str[512];
		format(str, 512, "SELECT * FROM `accounts` WHERE `id` = %i AND `house` = %i", gHouses[houseid][houseOwnerID], houseid+1);
		mysql_query(str);
		mysql_store_result();
		new rows = mysql_num_rows();
		if(!rows) {
			format(str,sizeof(str),"UPDATE `houses` SET `ownerid` = '0', `owner` = '', improve = '0|0|0|0|0', gun = '0|0|0|0|0|0|0|0|0', skin = '0|0|0|0',safecode='0', safemoney='0', drugs='0', products='0',inhabit2id = '0',inhabit3id = '0',inhabit4id = '0',inhabit2='',inhabit3='',inhabit4='' WHERE `id` = '%d'",houseid+1);
			mysql_query(str);
			gHouses[houseid][houseOwnerID] = 0;
			strdel(gHouses[houseid][houseOwner],0,24);
			strdel(gHouseHabits[houseid][0],0,24);
			strdel(gHouseHabits[houseid][1],0,24);
			strdel(gHouseHabits[houseid][2],0,24);
			gHouses[houseid][houseHabitID][0] = 0;
			gHouses[houseid][houseHabitID][1] = 0;
			gHouses[houseid][houseHabitID][2] = 0;
			for(new i;i<9;i++)
			{
				if(i < 5)
				{
					gHouses[houseid][houseImprove][i] = 0;
					if(i < 4) gHouses[houseid][houseSkin][i] = 0;
				}
				gHouses[houseid][houseGun][i] = 0;
			}
			gHouses[houseid][houseSafeCode] = 0;
			gHouses[houseid][houseSafeMoney] = 0;
			gHouses[houseid][houseDrugs] = 0;
			gHouses[houseid][houseProducts] = 0;
			DestroyDynamicPickup(gHousePickup[houseid]);
			gHousePickup[houseid] = CreateDynamicPickup(1273,1,gHouses[houseid][houseX],gHouses[houseid][houseY],gHouses[houseid][houseZ]);
			DestroyDynamicMapIcon(gHouseIcon[houseid]);
			gHouseIcon[houseid] = CreateDynamicMapIcon(gHouses[houseid][houseX],gHouses[houseid][houseY],gHouses[houseid][houseZ],31,CWHITE);
		}
		mysql_free_result();
	}
	mysql_query("SELECT * FROM `transport` ORDER BY `model`");
	mysql_store_result();
	for(new i;i<mysql_num_rows();i++)
	{
		mysql_fetch_row(result);
		sscanf(result,"p<|>e<iis[35]iiiiiii>",gTransport[i]);
		//printf("ID:%d Model:%d Name:%s Cons:%d Tank:%d",i,gTransport[i][trModel],gTransport[i][trName],gTransport[i][trConsumption],gTransport[i][trTank]);
	}
	mysql_free_result();
	mysql_query("SELECT * FROM `cars` ORDER BY `id`");
	mysql_store_result();
	if(mysql_num_rows() > 0)
	{
		for(new i;i<mysql_num_rows();i++)
		{
			mysql_fetch_row(result);
			new data[256];
			sscanf(result,"p<|>e<iiis[12]fffiii>s[256]",gCars[i],data);
			sscanf(data,"a<i>[4]a<i>[14]",gCars[i][carDemages],gCars[i][carTuning]);
			//printf("plate: %s, data:%s",gCars[i][carPlate],data);
		}
	}
	mysql_free_result();
	mysql_query("SELECT `id`,`car`,`house` FROM `accounts` WHERE (NOT `house` = '0') AND NOT `car` = '0'");
	mysql_store_result();
	if(mysql_num_rows() > 0)
	{
		for(new i2;i2<mysql_num_rows();i2++)
		{
			mysql_fetch_row(result);
			new car,house,houseid,plid;
			sscanf(result,"p<|>iii",plid,car,house);
			houseid = house - 1;
			new i=-1;
			for(new i3;i3<MAX_VEHICLES;i3++)
			{
				if(car == gCars[i3][carMysqlID])
				{
					i = i3;
					break;
				}
			}
			if(i != -1)
			{
				new modelid = gCars[i][carModelid];
				if(house)
				{
					new vehicleid = CreateVehicle(gTransport[modelid][trModel],gHouses[houseid][houseParkX],gHouses[houseid][houseParkY],gHouses[houseid][houseParkZ],gHouses[houseid][houseParkR],gCars[i][carColor1],gCars[i][carColor2],-1);
					gCars[i][carVid] = vehicleid;
					UpdateVehicleDamageStatus(vehicleid,gCars[i][carDemages][0],gCars[i][carDemages][1],gCars[i][carDemages][2],gCars[i][carDemages][3]);
					if(gCars[i][carHealth] < 300.0) gCars[i][carHealth] = 300.0;
					SetVehicleHealthEx(vehicleid,gCars[i][carHealth]);
					ToggleLock(vehicleid);
					gVehicles[vehicleid-1][vFuel] = gCars[i][carFuel];
					gVehicles[vehicleid-1][vDrived] = gCars[i][carDrived];
					gVehicles[vehicleid-1][vHealth] = gCars[i][carHealth];
					gVehicles[vehicleid-1][vOwnerid] = gCars[i][carOwnerid];
					gVehicles[vehicleid-1][vProbability] = gCars[i][carProbability];
				}
			}
			else printf("Неверная связка машины у игрока %d (машина %d не найдена)",plid,car);
		}
	}
	mysql_free_result();
	mysql_query("SELECT * FROM `fillings` ORDER BY `id`");
	mysql_store_result();
	if(mysql_num_rows() != FILLING_COUNT) print("Кол-во заправок в базе не совпадает с предопределным количеством");
	if(mysql_num_rows() > 0)
	{
		for(new i;i<mysql_num_rows();i++)
		{
			mysql_fetch_row(result);
			sscanf(result,"p<|>iis[24]iiiia<i>[5]a<i>[5]a<i>[5]",gFillings[i][fillMysqlID],gFillings[i][fillOwnerID],gFillings[i][fillOwner],gFillings[i][fillPrice],gFillings[i][fillBank],gFillings[i][fillWorking],gFillings[i][fillPumps],gFillings[i][fillTanks],gFillings[i][fillFuel],gFillings[i][fillFuelPrice]);
			printf("Filling: %d, Mark[0]: %d",gFillings[i][fillMysqlID],gFillings[i][fillFuel][0]);
			CreateDynamicPickup(19132,1,gFillingBuy[i][0],gFillingBuy[i][1],gFillingBuy[i][2]);
			gFillingBuyArea[i] = CreateDynamicSphere(gFillingBuy[i][0],gFillingBuy[i][1],gFillingBuy[i][2],1.0);
			//printf("Area: %d",gFillingBuyArea[i]);
			for(new i2;i2<4;i2++)
			{
				if(gFuelPumps[i][i2][0] == 0.0) break;
				if(!gFillings[i][fillPumps]) gFuelPumpObjects[i][i2] = CreateDynamicObject(1686,gFuelPumps[i][i2][0],gFuelPumps[i][i2][1],gFuelPumps[i][i2][2],gFuelPumps[i][i2][3],gFuelPumps[i][i2][4],gFuelPumps[i][i2][5]);
				else gFuelPumpObjects[i][i2] = CreateDynamicObject(1676,gFuelPumps[i][i2][0],gFuelPumps[i][i2][1],gFuelPumps[i][i2][2]+1.5,gFuelPumps[i][i2][3],gFuelPumps[i][i2][4],gFuelPumps[i][i2][5]+90.0);
			}
		}
		for(new i,m=mysql_num_rows();i<m;i++) gAreas[arFill][i] = CreateDynamicSphere(gFuelPumps[i][0][0],gFuelPumps[i][0][1],gFuelPumps[i][0][2],10.0);
	}
	mysql_free_result();
	mysql_query("SELECT * FROM `gangs` ORDER BY `id`");
	mysql_store_result();
	if(mysql_num_rows() != 5) print("Кол-во банд в базе не совпадает с предопределным количеством");
	else
	{
		if(mysql_num_rows() > 0)
		{
			for(new i;i<mysql_num_rows();i++)
			{
				new ranks[256];
				mysql_fetch_row(result);
				sscanf(result,"p<|>{i}s[255]a<i>[5]ia<i>[4]ia<i>[4]",ranks,gGangCars[i],gGangDormLimit[i],gGangDorm[i],gGangCode[i],gGangAccess[i]);
				//print(ranks);
				explode(gFractionRankName[i+2],ranks,",");
				//printf("%d %d %d",gGangCars[i][0],gGangCars[i][4],gGangAccess[i][1]);
				//new last;
				for(new j;j<5;j++)
				{
					if(!gGangCars[i][j]) gGangCars[i][j] = 481;
					new vid;
					vid = CreateVehicle(gGangCars[i][j],gGangCarSlot[i][j][0],gGangCarSlot[i][j][1],gGangCarSlot[i][j][2],gGangCarSlot[i][j][3],gGangCarColors[i],gGangCarColors[i],900);
					aGang[i][j] = vid;
					//if(!j) aGang[i][j] = vid;
					//last = vid;
					gVehicles[vid-1][vFuel] = gTransport[GetVehicleModel(vid)-400][trTank];
					gVehicles[vid-1][vHealth] = 1000.0;
					gVehicles[vid-1][vOwnerid] = INVALID_PLAYER_ID;
					gVehicles[vid-1][vLock] = 0;
					gVehicles[vid-1][vID] = vid;
				}
				//aGang[i][1] = last;
			}
		}
	}
	mysql_free_result();
	mysql_query("SELECT * FROM `bints` ORDER BY `id`");
	mysql_store_result();
	if(mysql_num_rows() != BINT_COUNT) print("Кол-во БИНТ'ов в базе не совпадает с предопределным количеством");
	else
	{
		for(new i;i<BINT_COUNT;i++)
		{
			mysql_fetch_row(result);
			sscanf(result,"p<|>e<iifffffffs[32]>",gBints[i]);
			gBintEnterArea[i] = CreateDynamicSphere(gBints[i][bintX],gBints[i][bintY],gBints[i][bintZ],1.0);
			CreateDynamicPickup(1318,1,gBints[i][bintX],gBints[i][bintY],gBints[i][bintZ]);
			CreateDynamicPickup(1239,1,gBints[i][bintXB],gBints[i][bintYB],gBints[i][bintZB]);
		}
		for(new i;i<BINT_COUNT;i++) gBintBuyArea[i] = CreateDynamicSphere(gBints[i][bintXB],gBints[i][bintYB],gBints[i][bintZB],1.0);
	}
	mysql_free_result();
	mysql_query("SELECT * FROM `business` ORDER BY `id`");
	mysql_store_result();
	gBusinessCount = mysql_num_rows();
	if(gBusinessCount >= MAX_BUSINESS_COUNT) print("Кол-во бизнесов в базе превышает предопределнное количество");
	else if(gBusinessCount > 0)
	{
		for(new i;i<gBusinessCount;i++)
		{
			mysql_fetch_row(result);
			sscanf(result,"p<|>e<is[64]iiiiiiiiffffii>",gBusiness[i]);
			gBusinessArea[i] = CreateDynamicSphere(gBusiness[i][busiX],gBusiness[i][busiY],gBusiness[i][busiZ],1.0);
			CreateDynamicPickup(19132,1,gBusiness[i][busiX],gBusiness[i][busiY],gBusiness[i][busiZ]);
			gBusinessText[i] = CreateDynamic3DTextLabel("_",CWHITE,gBusiness[i][busiX],gBusiness[i][busiY],gBusiness[i][busiZ]+1.0,20.0);
			new icon = 0, bint = gBusiness[i][busiBint];
			if(bint >= 1 && bint <= 4) icon = 49;
			else if((bint >= 5 && bint <= 9) || bint == 23) icon = 45;
			else if(bint >= 17 && bint <= 21) icon = 50;
			else if(bint == 22) icon = 27;
			else if(bint == 14 || bint == 15) icon = 48;
			if(icon) gBusinessIcon[i] = CreateDynamicMapIcon(gBusiness[i][busiX], gBusiness[i][busiY], gBusiness[i][busiZ], icon, -1);
		}
	}
	else print("Не обнаружено бизнесов в базе");
	mysql_free_result();
	for(new i;i<gBusinessCount;i++)
	{
		UpdateBusinessText(i);
		gBusiness[i][busiDelivingArea] = CreateDynamicSphere(gBusiness[i][busiX],gBusiness[i][busiY],gBusiness[i][busiZ],10.0);
	}
	for(new i; i<= aNews[1];i++)
	{
		if(GetVehicleModel(i) >= 400 && i > 0)
		{
			gVehicles[i-1][vFuel] = gTransport[GetVehicleModel(i)-400][trTank];
			gVehicles[i-1][vHealth] = 1000.0;
			gVehicles[i-1][vOwnerid] = INVALID_PLAYER_ID;
			gVehicles[i-1][vLock] = 0;
			gVehicles[i-1][vID] = i;
		}
	}
	for(new i;i<DELIVERY_DFT_COUNT;i++)
	{
		gDFTObject[i][0] = INVALID_OBJECT_ID;
		gDFTObject[i][1] = INVALID_OBJECT_ID;
	}
	//mysql_debug();
	new fid = ini_openFile("warehouses.ini");
	if(fid < 0) printf("Error while opening file warehouses.ini (%d)",fid);
	ini_getInteger(fid,"coal",gCoalWH);
	ini_getInteger(fid,"wood",gWoodWH);
	ini_getInteger(fid,"guncoal",gGunWorkWH[0]);
	ini_getInteger(fid,"gunwood",gGunWorkWH[1]);
	ini_getInteger(fid,"gun",gGunWorkWH[2]);
	ini_getInteger(fid,"army1gun",gArmyWarehouse[0][0]);
	ini_getInteger(fid,"army1ammo",gArmyWarehouse[0][1]);
	ini_getInteger(fid,"army2gun",gArmyWarehouse[1][0]);
	ini_getInteger(fid,"army2ammo",gArmyWarehouse[1][1]);
	ini_getInteger(fid,"lspdgun",gPDWarehouse[0][0]);
	ini_getInteger(fid,"lspdammo",gPDWarehouse[0][1]);
	ini_getInteger(fid,"sfpdgun",gPDWarehouse[1][0]);
	ini_getInteger(fid,"sfpdammo",gPDWarehouse[1][1]);
	ini_getInteger(fid,"lvpdgun",gPDWarehouse[2][0]);
	ini_getInteger(fid,"lvpdammo",gPDWarehouse[2][1]);
	ini_closeFile(fid);
	LoadNewsMoney();
	UpdateEconomic();
	LoadDeliveryData();
