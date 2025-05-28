#include a_samp
#include streamer
#include dini
#include sscanf2
#include zcmd



#define VERSION "1.3.0.1 Update 2 Fix 3"
#define MAX_USERS 50
#define MAX_PINS 10
#define MAX_BOWLING_ROADS 5

#define DIALOG_BOWLING 			100
#define DIALOG_BOWLING_TIME 	101
#define DIALOG_ADD_TIME 		102
#define DIALOG_ROAD 			103
#define DIALOG_BOWLING_STATS 	104

#define COLOR_CMDERROR 	0xB13434AA

//bowling
	//pins status
#define PIN_GOAWAY 	0
#define PIN_LAST 	1
	//players status
#define F_BOWLING_THROW 0
#define S_BOWLING_THROW 1
#define N_BOWLING_THROW 2
	//roads status
#define ROAD_EMPTY 0
#define ROAD_BUSY 1
#define ROAD_NONE 255
	//Y Coordinate for roads
#define Y_ROAD_2 1.43993652586
#define Y_ROAD_3 3.11993652586
#define Y_ROAD_4 4.55993652586
#define Y_ROAD_5 6.10243269586
	//speed of ball
#define BALL_SPEED 5.0
#define BALL_RUN_TIME 1950
//bowling
new BowlingPins[MAX_BOWLING_ROADS][MAX_PINS];//pins
new BowlingMinutes[MAX_USERS];
new BowlingSeconds[MAX_USERS];
new BowlingPinsWaitEndTimer[MAX_USERS];
new BowlingPinsWaitTimer[MAX_USERS];
new BowlingTimer[MAX_BOWLING_ROADS];//timer
new BowlingStatus[MAX_USERS];//statusof playing player
new PinsLeft[MAX_BOWLING_ROADS][MAX_USERS];//how much pins left after first try
new LastPin[MAX_BOWLING_ROADS][MAX_PINS][MAX_USERS];//how much pins left after second try
new AbleToPlay[MAX_USERS];//players able to play
new PlayersBowlingRoad[MAX_USERS];//road what player using
new BowlingRoadStatus[MAX_BOWLING_ROADS];//status of th road
new Text3D:BowlingRoadScreen[MAX_BOWLING_ROADS];//the screens
new BowlingBall[MAX_BOWLING_ROADS];
new BallGoing[MAX_USERS];
new BallRun[MAX_USERS];
new PlayersBowlingScore[MAX_USERS];
new BestScore[MAX_USERS];
new PlayerStrikes[MAX_USERS];
new LastTimePlayed[MAX_USERS][128];
//pickups of bowling
new HelpBowlingRoadPickup[MAX_BOWLING_ROADS];
enum PKS
{
	bowlEnter,
	bowlExit
}
new Pickup[PKS];
//cps
new BowlingCP1;
main()
{
	print("\n\n\n---------------------------------------------------------");
	print("  The Script: 		San Fierro Bowling.		");
	print("  Author: 		Nexotronix ( Dmitry Nedoseko ). ");
	print("  Authors Skype: 	nexotronix.			");
	print("  Date of Start: 	January 29, 2011.		");
	printf("  Version: 		%s.				",VERSION);
	print("---------------------------------------------------------\n\n\n");
}


public OnFilterScriptInit()
{
    //pickups
	Pickup[bowlExit] = CreateDynamicPickup(1318,23, -1992.8255615234, 407.70401000977, 2.8625273704529, -1);//маркер внутри
	Pickup[bowlEnter] = CreateDynamicPickup(1318,23, -1992.8215,407.0989,35.4719, -1);//маркер снаружи
 	//3dTexts
	BowlingRoadScreen[0] = CreateDynamic3DTextLabel("{008800}[{FFFFFF} Дорожка 1{008800} ]\n Свободно",0xffffffff,-1974.7992,417.17291259766,4.7010, 15.0);
	BowlingRoadScreen[1] = CreateDynamic3DTextLabel("{008800}[{FFFFFF} Дорожка 2{008800} ]\n Свободно",0xffffffff,-1974.7992,415.69528198242,4.7010, 15.0);
	BowlingRoadScreen[2] = CreateDynamic3DTextLabel("{008800}[{FFFFFF} Дорожка 3{008800} ]\n Свободно",0xffffffff,-1974.7992,414.19616699219,4.7010, 15.0);
	BowlingRoadScreen[3] = CreateDynamic3DTextLabel("{008800}[{FFFFFF} Дорожка 4{008800} ]\n Свободно",0xffffffff,-1974.7992,412.72177124023,4.7010, 15.0);
	BowlingRoadScreen[4] = CreateDynamic3DTextLabel("{008800}[{FFFFFF} Дорожка 5{008800} ]\n Свободно",0xffffffff,-1974.7992,411.2473449707,4.7010, 15.0);
	CreateDynamic3DTextLabel("[* {FFFFFF}БОУЛИНГ {0C9BCB}*]",0x0C9BCBFF,-1992.8215,407.0989,36.4719,40.0,-1,1);
    //checkpoints
   	BowlingCP1 = CreateDynamicCP(-1988.7483,414.4880,1.6010,1.5,-1,1);
    //objects
      //bowling club
   	CreateDynamicObject(16475,-1983.98339844,401.38183594,34.15666199,0.00000000,0.00000000,90.00000000); //object(des_stwnbowl) (1)
   	CreateDynamicObject(14671,-1988.21679688,409.67578125,3.48274970,0.00000000,0.00000000,0.00000000); //object(int_7_11a5) (1)
   	CreateDynamicObject(8710,-1992.11621094,447.90722656,-32.64123917,0.00000000,0.00000000,270.00000000); //object(bnuhotel01_lvs) (1)
   	CreateDynamicObject(8710,-1971.84484863,366.69989014,-26.97655869,0.00000000,0.00000000,90.00000000); //object(bnuhotel01_lvs) (4)
   	CreateDynamicObject(8710,-2017.58825684,395.96643066,-27.08176041,0.00000000,0.00000000,90.00000000); //object(bnuhotel01_lvs) (5)
   	CreateDynamicObject(7191,-1953.28332520,417.73162842,-0.34434167,0.00000000,0.00000000,90.00000000); //object(vegasnnewfence2b) (1)
   	CreateDynamicObject(7191,-1953.28332520,416.19857788,-0.34434167,0.00000000,0.00000000,90.00000000); //object(vegasnnewfence2b) (2)
   	CreateDynamicObject(7191,-1953.26269531,415.81542969,1.41164804,0.00000000,90.00000000,89.99450684); //object(vegasnnewfence2b) (3)
   	CreateDynamicObject(7191,-1953.26562500,411.89160156,1.41164804,0.00000000,90.00000000,89.99447632); //object(vegasnnewfence2b) (4)
   	CreateDynamicObject(7191,-1953.28332520,414.63092041,-0.34434167,0.00000000,0.00000000,90.00000000); //object(vegasnnewfence2b) (6)
   	CreateDynamicObject(7191,-1953.28320312,413.08496094,-0.34434167,0.00000000,0.00000000,90.00000000); //object(vegasnnewfence2b) (7)
   	CreateDynamicObject(7191,-1953.28332520,411.58847046,-0.34434167,0.00000000,0.00000000,90.00000000); //object(vegasnnewfence2b) (8)
   	CreateDynamicObject(7191,-1953.28332520,410.03662109,-0.34434167,0.00000000,0.00000000,90.00000000); //object(vegasnnewfence2b) (9)
   	CreateDynamicObject(1555,-1963.70788574,417.80877686,1.46596777,90.00000000,180.59289551,179.65710449); //object(gen_doorext17) (1)
   	CreateDynamicObject(7191,-1942.21752930,415.83892822,2.43367004,0.00000000,90.00000000,89.99981689); //object(vegasnnewfence2b) (13)
   	CreateDynamicObject(7191,-1942.21777344,411.92166138,2.43367004,0.00000000,90.00000000,89.99996948); //object(vegasnnewfence2b) (14)
   	CreateDynamicObject(1555,-1963.70703125,415.34472656,1.46596777,90.00000000,180.58769226,179.65399170); //object(gen_doorext17) (2)
   	CreateDynamicObject(1555,-1963.68554688,412.84765625,1.46596777,90.00000000,180.58227539,179.65393066); //object(gen_doorext17) (3)
   	CreateDynamicObject(1555,-1963.68554688,412.58203125,1.46596777,90.00000000,179.41784668,180.81842041); //object(gen_doorext17) (4)
   	CreateDynamicObject(1555,-1962.98022461,417.62829590,0.90899563,0.00000000,270.00000000,90.00000000); //object(gen_doorext17) (5)
   	CreateDynamicObject(1555,-1962.98022461,415.16979980,0.90899563,0.00000000,270.00000000,89.99993896); //object(gen_doorext17) (6)
   	CreateDynamicObject(1555,-1962.98022461,412.70278931,0.90899563,0.00000000,270.00000000,89.99993896); //object(gen_doorext17) (7)
   	CreateDynamicObject(1555,-1962.98022461,412.64303589,0.90899563,0.00000000,270.00000000,90.00000000); //object(gen_doorext17) (8)
   	CreateDynamicObject(7191,-1942.20117188,410.03662109,0.52564448,0.00000000,0.00000000,90.00000000); //object(vegasnnewfence2b) (15)
   	CreateDynamicObject(7191,-1942.20117188,411.58847046,0.52564448,0.00000000,0.00000000,90.00000000); //object(vegasnnewfence2b) (16)
   	CreateDynamicObject(7191,-1942.20117188,413.08575439,0.52564448,0.00000000,0.00000000,90.00000000); //object(vegasnnewfence2b) (17)
   	CreateDynamicObject(7191,-1942.20117188,414.63085938,0.52564448,0.00000000,0.00000000,90.00000000); //object(vegasnnewfence2b) (18)
   	CreateDynamicObject(7191,-1942.20117188,416.19857788,0.52564448,0.00000000,0.00000000,90.00000000); //object(vegasnnewfence2b) (19)
   	CreateDynamicObject(7191,-1942.20117188,417.73162842,0.52564448,0.00000000,0.00000000,90.00000000); //object(vegasnnewfence2b) (20)
   	CreateDynamicObject(3437,-1963.50708008,397.80062866,-0.30842876,0.00000000,0.00000000,270.00000000); //object(ballypllr01_lvs) (2)
   	CreateDynamicObject(3437,-1963.60302734,408.50720215,-0.30842876,0.00000000,0.00000000,270.00000000); //object(ballypllr01_lvs) (3)
   	CreateDynamicObject(3472,-1960.08154297,417.09658813,-6.13266516,0.00000000,0.00000000,304.50000000); //object(circuslampost03) (1)
   	CreateDynamicObject(3472,-1960.00000000,414.12844849,-6.13266516,0.00000000,0.00000000,304.50000000); //object(circuslampost03) (2)
   	CreateDynamicObject(3472,-1960.19006348,411.00000000,-6.13266516,0.00000000,0.00000000,304.50000000); //object(circuslampost03) (4)
   	CreateDynamicObject(3472,-1960.00830078,402.89712524,-6.13266516,0.00000000,0.00000000,60.49621582); //object(circuslampost03) (5)
   	CreateDynamicObject(1594,-1970.30737305,398.48526001,1.97795916,0.00000000,0.00000000,0.00000000); //object(chairsntable) (1)
   	CreateDynamicObject(1594,-1969.63330078,403.06884766,1.97795916,0.00000000,0.00000000,0.00000000); //object(chairsntable) (2)
   	CreateDynamicObject(1594,-1973.96972656,400.88070679,1.97795916,0.00000000,0.00000000,0.00000000); //object(chairsntable) (3)
   	CreateDynamicObject(1594,-1973.36218262,405.84259033,1.97795916,0.00000000,0.00000000,0.00000000); //object(chairsntable) (4)
   	CreateDynamicObject(1594,-1966.74902344,407.34863281,1.97795916,0.00000000,0.00000000,0.00000000); //object(chairsntable) (5)
   	CreateDynamicObject(1792,-1974.79187012,417.17291260,4.84897375,22.00000000,0.00000000,270.00000000); //ekran(1)
   	CreateDynamicObject(1792,-1974.79284668,415.69528198,4.84897375,21.99462891,0.00000000,270.00000000); //ekran(2)
   	CreateDynamicObject(1792,-1974.79138184,414.19616699,4.84897375,21.99462891,0.00000000,270.00000000); //ekran(3)
   	CreateDynamicObject(1792,-1974.79162598,412.72177124,4.84897375,21.99462891,0.00000000,270.00000000); //ekran(4)
   	CreateDynamicObject(1792,-1974.79040527,411.24734497,4.84897375,21.99462891,0.00000000,270.00000000); //ekran(5)
   	CreateDynamicObject(1670,-1973.47375488,405.93463135,2.45557547,0.00000000,0.00000000,0.00000000); //object(propcollecttable) (1)
   	CreateDynamicObject(1670,-1969.75622559,402.97250366,2.45557547,0.00000000,0.00000000,0.00000000); //object(propcollecttable) (2)
   	CreateDynamicObject(1670,-1966.92077637,407.18273926,2.45557547,0.00000000,0.00000000,0.00000000); //object(propcollecttable) (3)
   	CreateDynamicObject(2748,-1981.04077148,416.99365234,2.09871221,0.00000000,0.00000000,90.50000000); //object(cj_donut_chair2) (1)
   	CreateDynamicObject(2748,-1981.02392578,415.54788208,2.09871221,0.00000000,0.00000000,90.49987793); //object(cj_donut_chair2) (2)
   	CreateDynamicObject(2748,-1981.02441406,413.97348022,2.09871221,0.00000000,0.00000000,90.49987793); //object(cj_donut_chair2) (3)
   	CreateDynamicObject(2748,-1981.02026367,412.41012573,2.09871221,0.00000000,0.00000000,90.49987793); //object(cj_donut_chair2) (4)
   	CreateDynamicObject(2748,-1980.99951172,410.86880493,2.09871221,0.00000000,0.00000000,90.49987793); //object(cj_donut_chair2) (5)
   	CreateDynamicObject(2763,-1979.17871094,410.35504150,1.90615499,0.00000000,0.00000000,0.00000000); //object(cj_chick_table_2) (1)
   	CreateDynamicObject(2763,-1979.17871094,412.01336670,1.90615499,0.00000000,0.00000000,0.00000000); //object(cj_chick_table_2) (2)
   	CreateDynamicObject(2763,-1979.17871094,413.81100464,1.90615499,0.00000000,0.00000000,0.00000000); //object(cj_chick_table_2) (3)
   	CreateDynamicObject(2763,-1979.17871094,417.39871216,1.90615499,0.00000000,0.00000000,0.00000000); //object(cj_chick_table_2) (4)
   	CreateDynamicObject(2763,-1979.17871094,415.60202026,1.90615499,0.00000000,0.00000000,0.00000000); //object(cj_chick_table_2) (5)
   	CreateDynamicObject(8710,-1938.82910156,417.89843750,-47.92550278,0.00000000,0.00000000,269.74182129); //object(bnuhotel01_lvs) (6)
   	CreateDynamicObject(2773,-1974.29052734,410.05731201,1.94319594,0.00000000,0.00000000,90.25000000); //object(cj_airprt_bar) (1)
   	CreateDynamicObject(2773,-1972.36218262,410.06097412,1.94319594,0.00000000,0.00000000,90.24719238); //object(cj_airprt_bar) (2)
   	CreateDynamicObject(2773,-1970.43786621,410.06890869,1.94319594,0.00000000,0.00000000,90.24719238); //object(cj_airprt_bar) (3)
   	CreateDynamicObject(2773,-1968.51269531,410.07226562,1.94319594,0.00000000,0.00000000,90.24719238); //object(cj_airprt_bar) (4)
   	CreateDynamicObject(2773,-1966.58886719,410.08300781,1.94319594,0.00000000,0.00000000,90.24719238); //object(cj_airprt_bar) (5)
   	CreateDynamicObject(2773,-1964.68005371,410.09939575,1.94319594,0.00000000,0.00000000,90.24719238); //object(cj_airprt_bar) (6)
   	CreateDynamicObject(2350,-1988.15979004,414.52291870,1.87311888,0.00000000,0.00000000,0.00000000); //object(cj_barstool_2) (2)
   	CreateDynamicObject(14831,-1986.83642578,403.54486084,3.05480051,0.00000000,0.00000000,180.00000000); //object(lm_stripbar) (2)
   	CreateDynamicObject(2350,-1989.39367676,414.60711670,1.87311888,0.00000000,0.00000000,0.00000000); //object(cj_barstool_2) (9)
   	CreateDynamicObject(2350,-1990.86682129,414.64779663,1.87311888,0.00000000,0.00000000,0.00000000); //object(cj_barstool_2) (10)
   	CreateDynamicObject(2350,-1992.25915527,414.65734863,1.87311888,0.00000000,0.00000000,0.00000000); //object(cj_barstool_2) (11)
   	CreateDynamicObject(1557,-1993.47424316,406.20376587,1.50096750,0.00000000,0.00000000,90.00000000); //object(gen_doorext19) (1)
   	CreateDynamicObject(1557,-1993.47460938,409.21188354,1.50096750,0.00000000,0.00000000,270.00000000); //object(gen_doorext19) (2)
   	CreateDynamicObject(16151,-1981.04028320,397.52371216,1.82596719,0.00000000,0.00000000,270.00000000); //object(ufo_bar) (1)
   	CreateDynamicObject(1665,-1979.17504883,411.95642090,2.33454275,0.00000000,0.00000000,0.00000000); //object(propashtray1) (1)
   	CreateDynamicObject(1665,-1979.17883301,410.33941650,2.33454275,0.00000000,0.00000000,0.00000000); //object(propashtray1) (2)
   	CreateDynamicObject(1665,-1979.44213867,413.51092529,2.33454275,0.00000000,0.00000000,0.00000000); //object(propashtray1) (3)
   	CreateDynamicObject(1665,-1988.91394043,415.37057495,2.62042212,0.00000000,0.00000000,0.00000000); //object(propashtray1) (4)
   	CreateDynamicObject(1665,-1970.39685059,398.32879639,2.46602869,0.00000000,0.00000000,0.00000000); //object(propashtray1) (5)
   	CreateDynamicObject(1664,-1970.55346680,398.23052979,2.62227917,0.00000000,0.00000000,0.00000000); //object(propwinebotl2) (1)
   	CreateDynamicObject(1667,-1970.59387207,398.13912964,2.54415464,0.00000000,0.00000000,0.00000000); //object(propwineglass1) (1)
   	CreateDynamicObject(1551,-1979.34191895,413.94085693,2.56435370,0.00000000,0.00000000,0.00000000); //object(dyn_wine_big) (1)
   	CreateDynamicObject(1544,-1979.09692383,417.29763794,2.32408953,0.00000000,0.00000000,0.00000000); //object(cj_beer_b_1) (1)
   	CreateDynamicObject(1544,-1978.97949219,417.19369507,2.32408953,0.00000000,0.00000000,0.00000000); //object(cj_beer_b_1) (2)
   	CreateDynamicObject(1544,-1979.20446777,417.08142090,2.32408953,0.00000000,0.00000000,0.00000000); //object(cj_beer_b_1) (3)
   	CreateDynamicObject(1546,-1979.40930176,415.48516846,2.41321850,0.00000000,0.00000000,0.00000000); //object(cj_pint_glass) (1)
   	CreateDynamicObject(2232,-1963.27111816,417.94244385,4.82136917,0.00000000,179.99993896,315.50000000); //object(med_speaker_4) (1)
   	CreateDynamicObject(2232,-1963.86682129,396.67074585,4.74921751,356.01208496,177.99517822,241.87011719); //object(med_speaker_4) (2)
   	CreateDynamicObject(1594,-1976.69604492,404.03070068,1.97795916,0.00000000,0.00000000,0.00000000); //object(chairsntable) (8)
   	CreateDynamicObject(1594,-1980.65112305,402.00286865,1.97795916,0.00000000,0.00000000,0.00000000); //object(chairsntable) (9)
   	CreateDynamicObject(1594,-1980.81201172,405.61914062,1.97795916,0.00000000,0.00000000,0.00000000); //object(chairsntable) (10)
   	CreateDynamicObject(1594,-1976.61096191,407.31570435,1.97795916,0.00000000,0.00000000,0.00000000); //object(chairsntable) (11)
   	CreateDynamicObject(2190,-1988.31689453,415.55139160,2.60996890,0.00000000,0.00000000,180.00000000); //object(pc_1) (1)
   	CreateDynamicObject(2190,-1989.34155273,415.80358887,2.60996890,0.00000000,0.00000000,139.99450684); //object(pc_1) (2)
   	CreateDynamicObject(2184,-1966.09143066,403.89233398,1.50096750,0.00000000,0.00000000,272.00000000); //object(med_office6_desk_2) (1)
   	CreateDynamicObject(1958,-1965.77929688,402.82293701,2.32661963,0.00000000,0.00000000,92.00000000); //object(mxr_mix_body) (1)
   	CreateDynamicObject(2261,-1969.43139648,417.67276001,3.95796394,0.00000000,0.00000000,0.00000000); //object(frame_slim_2) (1)
   	CreateDynamicObject(2259,-1988.78894043,417.67144775,3.81773138,0.00000000,0.00000000,0.00000000); //object(frame_clip_6) (1)
   	CreateDynamicObject(2258,-1977.10363770,418.14941406,4.20190430,0.00000000,0.00000000,0.00000000); //object(frame_clip_5) (1)
   	CreateDynamicObject(2262,-1975.07031250,396.92706299,4.19417381,0.00000000,0.00000000,180.00000000); //object(frame_slim_3) (1)
   	CreateDynamicObject(2266,-1968.56567383,396.92285156,3.97239256,0.00000000,0.00000000,180.00000000); //object(frame_wood_5) (1)
   	CreateDynamicObject(2894,-1987.28552246,417.84539795,2.55099177,0.00000000,0.00000000,0.00000000); //object(kmb_rhymesbook) (1)
   	CreateDynamicObject(16780,-1986.86901855,406.90533447,5.66260290,0.00000000,0.00000000,0.00000000); //object(ufo_light03) (2)
   	CreateDynamicObject(16780,-1979.54589844,401.62506104,5.28252983,0.00000000,0.00000000,0.00000000); //object(ufo_light03) (3)
   	CreateDynamicObject(16780,-1964.50903320,402.79486084,5.65087414,0.00000000,0.00000000,0.00000000); //object(ufo_light03) (4)
   	CreateDynamicObject(16780,-1971.69982910,407.29949951,5.69184160,0.00000000,0.00000000,0.00000000); //object(ufo_light03) (5)
   	CreateDynamicObject(1954,-1965.72692871,403.66027832,2.38389516,0.00000000,0.00000000,250.00000000); //object(turn_table_r) (1)
   	CreateDynamicObject(1957,-1965.60949707,402.02478027,2.38389516,0.00000000,0.00000000,300.00000000); //object(turn_tablel) (1)
   	CreateDynamicObject(1962,-1965.63891602,402.05975342,2.45170474,88.00000000,0.00000000,0.00000000); //object(record1) (1)
   	CreateDynamicObject(1962,-1965.71264648,403.71997070,2.45170474,87.99499512,0.00000000,0.00000000); //object(record1) (2)
   	CreateDynamicObject(2232,-1965.78967285,404.87741089,2.09884357,0.00000000,0.00000000,272.00000000); //object(med_speaker_4) (4)
   	CreateDynamicObject(2232,-1965.84448242,400.83706665,2.09884357,0.00000000,0.00000000,271.99951172); //object(med_speaker_4) (5)
   	CreateDynamicObject(2229,-1963.25744629,406.61846924,1.50096750,0.00000000,0.00000000,270.00000000); //object(swank_speaker) (1)
   	CreateDynamicObject(2229,-1963.19604492,399.05960083,1.50096750,0.00000000,0.00000000,270.00000000); //object(swank_speaker) (2)
   	CreateDynamicObject(1656,-1974.78381348,416.22280884,1.63934100,0.00000000,0.00000000,0.00000000); //object(esc_step) (1)
   	CreateDynamicObject(1656,-1974.78381348,417.70559692,1.63934100,0.00000000,0.00000000,0.00000000); //object(esc_step) (2)
   	CreateDynamicObject(1656,-1974.78063965,414.61547852,1.63934100,0.00000000,0.00000000,0.00000000); //object(esc_step) (3)
   	CreateDynamicObject(1656,-1974.78271484,413.08093262,1.63934100,0.00000000,0.00000000,0.00000000); //object(esc_step) (4)
   	CreateDynamicObject(1656,-1974.78564453,411.56622314,1.63934100,0.00000000,0.00000000,0.00000000); //object(esc_step) (5)
   	CreateDynamicObject(1367,-1974.32617188,413.09866333,1.38492167,0.00000000,0.00000000,270.00000000); //object(cj_postbox) (1)
   	CreateDynamicObject(1367,-1974.32812500,414.62768555,1.38492167,0.00000000,0.00000000,270.00000000); //object(cj_postbox) (2)
   	CreateDynamicObject(1367,-1974.32714844,416.26660156,1.38492167,0.00000000,0.00000000,270.00000000); //object(cj_postbox) (3)
   	CreateDynamicObject(1367,-1974.32543945,417.75982666,1.38492167,0.00000000,0.00000000,270.00000000); //object(cj_postbox) (4)
   	CreateDynamicObject(1367,-1974.32519531,411.55346680,1.38492167,0.00000000,0.00000000,270.00000000); //object(cj_postbox) (5)
   	CreateDynamicObject(3065,-1974.61511230,417.68078613,1.79999089,0.00000000,0.00000000,0.00000000); //object(bball_col) (1)
   	CreateDynamicObject(3065,-1974.91210938,417.68667603,1.79999089,0.00000000,0.00000000,0.00000000); //object(bball_col) (2)
   	CreateDynamicObject(3065,-1974.59570312,416.26126099,1.79999089,0.00000000,0.00000000,0.00000000); //object(bball_col) (4)
   	CreateDynamicObject(3065,-1974.90429688,416.25292969,1.79999089,0.00000000,0.00000000,0.00000000); //object(bball_col) (5)
   	CreateDynamicObject(3065,-1975.20019531,416.25146484,1.79999089,0.00000000,0.00000000,0.00000000); //object(bball_col) (6)
   	CreateDynamicObject(3065,-1974.72448730,414.64627075,1.79999089,0.00000000,0.00000000,0.00000000); //object(bball_col) (7)
   	CreateDynamicObject(3065,-1975.07568359,414.65039062,1.79999089,0.00000000,0.00000000,0.00000000); //object(bball_col) (8)
   	CreateDynamicObject(3065,-1975.06469727,413.09951782,1.79999089,0.00000000,0.00000000,0.00000000); //object(bball_col) (9)
   	CreateDynamicObject(3065,-1975.34716797,413.12374878,1.79999089,0.00000000,0.00000000,0.00000000); //object(bball_col) (10)
   	CreateDynamicObject(3065,-1974.59472656,413.08886719,1.79999089,0.00000000,0.00000000,0.00000000); //object(bball_col) (11)
   	CreateDynamicObject(3065,-1974.77441406,411.65020752,1.79999089,0.00000000,0.00000000,0.00000000); //object(bball_col) (12)
   	CreateDynamicObject(3065,-1975.04772949,411.61264038,1.79999089,0.00000000,0.00000000,0.00000000); //object(bball_col) (13)
   	CreateDynamicObject(3065,-1975.30554199,411.56716919,1.79999089,0.00000000,0.00000000,0.00000000); //object(bball_col) (14)
   	CreateDynamicObject(1557,-1991.94335938,405.60870361,34.01562500,0.00000000,0.00000000,90.00000000); //object(gen_doorext19) (3)
   	CreateDynamicObject(1557,-1991.93945312,408.63739014,34.01562500,0.00000000,0.00000000,269.75000000); //object(gen_doorext19) (4)
   	CreateDynamicObject(2048,-1987.92822266,396.46463013,3.79603434,0.00000000,0.00000000,179.75000000); //object(cj_flag2) (1)
   	CreateDynamicObject(3034,-1993.34851074,411.61630249,3.53044128,0.00000000,0.00000000,90.00000000); //object(bd_window) (1)
   	CreateDynamicObject(3034,-1993.38757324,403.93206787,3.51708794,0.00000000,0.00000000,90.00000000); //object(bd_window) (2)
   	CreateDynamicObject(3034,-1993.41223145,399.30670166,3.49105072,0.00000000,0.00000000,90.00000000); //object(bd_window) (3)
   	CreateDynamicObject(2125,-1977.71960449,413.82806396,1.81084192,0.00000000,0.00000000,0.00000000); //object(med_din_chair_1) (1)
   	CreateDynamicObject(2125,-1977.71960449,412.07031250,1.81084192,0.00000000,0.00000000,0.00000000); //object(med_din_chair_1) (2)
   	CreateDynamicObject(2125,-1977.71960449,410.33688354,1.81084192,0.00000000,0.00000000,0.00000000); //object(med_din_chair_1) (3)
   	CreateDynamicObject(2125,-1977.71960449,415.64382935,1.81084192,0.00000000,0.00000000,0.00000000); //object(med_din_chair_1) (4)
   	CreateDynamicObject(2125,-1977.71960449,417.35659790,1.81084192,0.00000000,0.00000000,0.00000000); //object(med_din_chair_1) (5)
   	CreateDynamicObject(1704,-1992.15136719,399.97558594,1.50096750,0.00000000,0.00000000,90.00000000); //object(kb_chair03) (1)
   	CreateDynamicObject(1704,-1992.19677734,398.14965820,1.50096750,0.00000000,0.00000000,90.00000000); //object(kb_chair03) (2)
   	CreateDynamicObject(1704,-1990.13342285,397.15026855,1.50096750,0.00000000,0.00000000,178.50000000); //object(kb_chair03) (3)
   	CreateDynamicObject(1704,-1988.88659668,399.22921753,1.50096750,0.00000000,0.00000000,270.00000000); //object(kb_chair03) (4)
   	CreateDynamicObject(1704,-1988.92846680,400.91891479,1.50096750,0.00000000,0.00000000,270.00000000); //object(kb_chair03) (5)
   	CreateDynamicObject(2311,-1990.53735352,400.35412598,1.50096750,0.00000000,0.00000000,270.00000000); //object(cj_tv_table2) (1)
   	CreateDynamicObject(1704,-1990.97985840,402.07971191,1.50096750,0.00000000,0.00000000,359.50000000); //object(kb_chair03) (6)
   	CreateDynamicObject(1486,-1990.40527344,398.52310181,2.15140820,0.00000000,0.00000000,0.00000000); //object(dyn_beer_1) (1)
   	CreateDynamicObject(1486,-1990.90563965,400.33468628,2.15140820,0.00000000,0.00000000,0.00000000); //object(dyn_beer_1) (2)
   	CreateDynamicObject(1510,-1990.38635254,399.18048096,2.05645943,0.00000000,0.00000000,0.00000000); //object(dyn_ashtry) (1)
   	CreateDynamicObject(1543,-1990.84545898,398.96905518,2.00645924,0.00000000,0.00000000,0.00000000); //object(cj_beer_b_2) (1)
   	CreateDynamicObject(1544,-1990.17407227,400.22183228,2.00645924,0.00000000,0.00000000,0.00000000); //object(cj_beer_b_1) (5)
   	CreateDynamicObject(1546,-1990.57446289,400.64953613,2.09558821,0.00000000,0.00000000,0.00000000); //object(cj_pint_glass) (2)
   	CreateDynamicObject(1668,-1990.56579590,399.72021484,2.17316294,0.00000000,0.00000000,0.00000000); //object(propvodkabotl1) (1)
   	CreateDynamicObject(1669,-1990.45507812,399.61505127,2.17316294,0.00000000,0.00000000,0.00000000); //object(propwinebotl1) (1)
   	CreateDynamicObject(1950,-1990.19140625,399.15011597,2.19462657,0.00000000,0.00000000,0.00000000); //object(kb_beer) (1)
   	CreateDynamicObject(1667,-1990.31188965,398.61380005,2.09503841,0.00000000,0.00000000,0.00000000); //object(propwineglass1) (2)
   	CreateDynamicObject(1667,-1990.85742188,399.10348511,2.09503841,0.00000000,0.00000000,0.00000000); //object(propwineglass1) (3)
   	CreateDynamicObject(1667,-1990.21252441,398.92254639,2.09503841,0.00000000,0.00000000,0.00000000); //object(propwineglass1) (4)
   	CreateDynamicObject(1667,-1990.23571777,400.05093384,2.09503841,0.00000000,0.00000000,0.00000000); //object(propwineglass1) (5)
   	CreateDynamicObject(1667,-1990.85607910,400.04284668,2.09503841,0.00000000,0.00000000,0.00000000); //object(propwineglass1) (6)
   	CreateDynamicObject(1667,-1990.45361328,400.70193481,2.09503841,0.00000000,0.00000000,0.00000000); //object(propwineglass1) (7)
   	CreateDynamicObject(2768,-1979.54443359,415.35848999,2.39140534,0.00000000,0.00000000,0.00000000); //object(cj_cb_burg) (1)
   	CreateDynamicObject(2767,-1979.33044434,417.62567139,2.32408953,0.00000000,0.00000000,0.00000000); //object(cj_cb_tray) (1)
   	CreateDynamicObject(2768,-1979.21337891,417.71069336,2.39140534,358.00000000,0.00000000,276.00000000); //object(cj_cb_burg) (2)
   	CreateDynamicObject(2768,-1979.27197266,417.51815796,2.39140534,357.99499512,0.00000000,145.99853516); //object(cj_cb_burg) (3)
   	CreateDynamicObject(2768,-1979.39208984,417.72415161,2.36640525,357.98950195,0.00000000,35.99734497); //object(cj_cb_burg) (4)
   	CreateDynamicObject(2769,-1979.51538086,417.50271606,2.34348345,0.00000000,0.00000000,0.00000000); //object(cj_cj_burg2) (1)
   	CreateDynamicObject(2814,-1978.82714844,417.64639282,2.32408953,0.00000000,0.00000000,0.00000000); //object(gb_takeaway01) (1)
   	CreateDynamicObject(2880,-1979.69177246,417.18093872,2.32930541,338.68923950,285.25561523,308.88677979); //object(cj_burg_2) (1)
   	CreateDynamicObject(2866,-1979.27478027,410.39382935,2.35748386,0.00000000,0.00000000,0.00000000); //object(gb_foodwrap04) (1)
   	CreateDynamicObject(1409,-1983.99096680,417.62332153,1.50096750,0.00000000,0.00000000,0.00000000); //object(cj_dump1_low) (1)
   	CreateDynamicObject(1409,-1973.25634766,396.96475220,1.50096750,0.00000000,0.00000000,0.00000000); //object(cj_dump1_low) (3)
   	CreateDynamicObject(17969,-1992.34716797,399.08142090,35.58477402,0.00000000,0.00000000,359.75000000); //object(hub_graffitti) (1)
   	CreateDynamicObject(1486,-1980.75646973,398.37597656,2.57633448,0.00000000,0.00000000,0.00000000); //object(dyn_beer_1) (4)
   	CreateDynamicObject(1510,-1989.41137695,416.12026978,2.63496900,0.00000000,0.00000000,0.00000000); //object(dyn_ashtry) (2)
   	CreateDynamicObject(1510,-1979.38964844,417.03784180,2.34908962,0.00000000,0.00000000,0.00000000); //object(dyn_ashtry) (3)
   	CreateDynamicObject(1510,-1965.18640137,402.12326050,2.30170536,0.00000000,0.00000000,0.00000000); //object(dyn_ashtry) (4)
   	CreateDynamicObject(1546,-1965.14184570,401.95034790,2.36583424,0.00000000,0.00000000,0.00000000); //object(cj_pint_glass) (3)
   	CreateDynamicObject(1544,-1965.03173828,401.83084106,2.27670527,0.00000000,0.00000000,0.00000000); //object(cj_beer_b_1) (7)
   	CreateDynamicObject(1485,-1965.09851074,402.33486938,2.36627817,0.00000000,16.00000000,260.00000000); //object(cj_ciggy) (1)
   	CreateDynamicObject(1485,-1979.37475586,416.82235718,2.41366243,0.00000000,15.99609375,95.99694824); //object(cj_ciggy) (2)
   	CreateDynamicObject(1485,-1990.38574219,398.98437500,2.10994744,0.00000000,15.99060059,95.99304199); //object(cj_ciggy) (3)
	return 1;
}
public OnPlayerConnect(playerid)
{
    //player variables
    BowlingMinutes[playerid] = 0;
    BowlingSeconds[playerid] = 0;
	BowlingStatus[playerid] = F_BOWLING_THROW;
	PinsLeft[1][playerid] = 0;
	AbleToPlay[playerid] = 0;
	PlayersBowlingScore[playerid] = 0;
	if(!dini_Exists(PlayerBowlingFile(playerid)))
    {
        dini_Create(PlayerBowlingFile(playerid));
        dini_IntSet(PlayerBowlingFile(playerid),"BestScore",0);
        dini_Set(PlayerBowlingFile(playerid),"LastTime","Никогда");
        dini_IntSet(PlayerBowlingFile(playerid),"Stirkes",0);
    }
    if(dini_Exists(PlayerBowlingFile(playerid)))
    {
		BestScore[playerid] = dini_Int(PlayerBowlingFile(playerid),"BestScore");
		LastTimePlayed[playerid] = dini_Get(PlayerBowlingFile(playerid),"LastTime");
		PlayerStrikes[playerid] = dini_Int(PlayerBowlingFile(playerid),"Strikes");
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    BowlingMinutes[playerid] = 0;
    BowlingSeconds[playerid] = 0;
	BowlingStatus[playerid] = F_BOWLING_THROW;
	PinsLeft[1][playerid] = 0;
	AbleToPlay[playerid] = 0;
	KillTimer(BowlingTimer[PlayersBowlingRoad[playerid]]);
 	BowlingRoadStatus[PlayersBowlingRoad[playerid]] = ROAD_EMPTY;
 	if(PlayersBowlingRoad[playerid]==0)
  	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[0], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 1{008800} ]\n Свободно");
		DestroyPins(0);
  	}
	else if(PlayersBowlingRoad[playerid]==1)
	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[1], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 2{008800} ]\n Свободно");
		DestroyPins(1);
	}
	else if(PlayersBowlingRoad[playerid]==2)
	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[2], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 3{008800} ]\n Свободно");
		DestroyPins(2);
  	}
  	else if(PlayersBowlingRoad[playerid]==3)
   	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[3], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 4{008800} ]\n Свободно");
		DestroyPins(3);
   	}
	else if(PlayersBowlingRoad[playerid]==4)
	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[4], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 5{008800} ]\n Свободно");
		DestroyPins(4);
	}
 	PlayersBowlingRoad[playerid] = ROAD_NONE;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	Streamer_Update(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    BowlingMinutes[playerid] = 0;
    BowlingSeconds[playerid] = 0;
	BowlingStatus[playerid] = F_BOWLING_THROW;
	PinsLeft[1][playerid] = 0;
	AbleToPlay[playerid] = 0;
	KillTimer(BowlingTimer[PlayersBowlingRoad[playerid]]);
 	BowlingRoadStatus[PlayersBowlingRoad[playerid]] = ROAD_EMPTY;
 	if(PlayersBowlingRoad[playerid]==0)
  	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[0], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 1{008800} ]\n Свободно");
		DestroyPins(0);
  	}
	else if(PlayersBowlingRoad[playerid]==1)
	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[1], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 2{008800} ]\n Свободно");
		DestroyPins(1);
	}
	else if(PlayersBowlingRoad[playerid]==2)
	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[2], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 3{008800} ]\n Свободно");
		DestroyPins(2);
  	}
  	else if(PlayersBowlingRoad[playerid]==3)
   	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[3], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 4{008800} ]\n Свободно");
		DestroyPins(3);
   	}
	else if(PlayersBowlingRoad[playerid]==4)
	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[4], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 5{008800} ]\n Свободно");
		DestroyPins(4);
	}
 	PlayersBowlingRoad[playerid] = ROAD_NONE;
	return 1;
}

CMD:bowling(playerid,params[])
{
 	if(AbleToPlay[playerid] == 1)
	{  
 		if(IsAtBowlingRoad(playerid))
 		{
       		if(BowlingStatus[playerid] != N_BOWLING_THROW)
 			{
 			    CreateBall(playerid);
				BallGoing[playerid] = SetTimerEx("BallGoingTimer",1000,false,"d",playerid);
				ApplyAnimation(playerid,"GRENADE","WEAPON_throwu",2.2,0,0,0,0,0,1);
    		}
    		else
    		{
    		    SendClientMessage(playerid,0xAA0000FF,"Подождите пока кегли вернутся на место.");
    		}
		}
		else
		{
		    SendClientMessage(playerid,0xD92626AA,"Ты далеко от дорожки!");
		}
	}
	else
	{
	    SendClientMessage(playerid,0xD92626AA,"Ты не начал игру!");
	}
	return 1;
}
CMD:bowlingstats(playerid,params[])
{
	new str[128];
	format(str,128,"{00CC00}Лучший результат: {EEEEEE}%i\n{00CC00}Страйки: {EEEEEE}%i\n{00CC00}Дата последней игры: {EEEEEE}%s ",BestScore[playerid],PlayerStrikes[playerid],LastTimePlayed[playerid]);
	ShowPlayerDialog(playerid, DIALOG_BOWLING_STATS, DIALOG_STYLE_MSGBOX, "Ваша статистика боулинга", str, "ОК", "");
	return 1;
}
//bowling functions
stock PickupBowlingHelp(playerid,pickupid)
{
    if(pickupid == HelpBowlingRoadPickup[0])
	{
	    GameTextForPlayer(playerid,"~y~/bowling",1000,0);
	    DestroyDynamicPickup(HelpBowlingRoadPickup[0]);
	}
	else if(pickupid == HelpBowlingRoadPickup[1])
	{
	    GameTextForPlayer(playerid,"~y~/bowling",1000,0);
	    DestroyDynamicPickup(HelpBowlingRoadPickup[1]);
	}
	else if(pickupid == HelpBowlingRoadPickup[2])
	{
	    GameTextForPlayer(playerid,"~y~/bowling",1000,0);
	    DestroyDynamicPickup(HelpBowlingRoadPickup[2]);
	}
	else if(pickupid == HelpBowlingRoadPickup[3])
	{
	    GameTextForPlayer(playerid,"~y~/bowling",1000,0);
	    DestroyDynamicPickup(HelpBowlingRoadPickup[3]);
	}
	else if(pickupid == HelpBowlingRoadPickup[4])
	{
	    GameTextForPlayer(playerid,"~y~/bowling",1000,0);
	    DestroyDynamicPickup(HelpBowlingRoadPickup[4]);
	}
	return 1;
}
stock IsAtBowlingRoad(playerid)
{
	if(PlayersBowlingRoad[playerid]==0)
	{
	    if(IsPlayerInRangeOfPoint(playerid,0.5,-1975.0587,416.9655,2.5090))
	    {
	        return 1;
	    }
 	}
 	else if(PlayersBowlingRoad[playerid]==1)
	{
	    if(IsPlayerInRangeOfPoint(playerid,0.5,-1975.0587,415.4035,2.5090))
	    {
	        return 1;
	    }
 	}
 	else if(PlayersBowlingRoad[playerid]==2)
	{
	    if(IsPlayerInRangeOfPoint(playerid,0.5,-1975.0587,413.8728,2.5090))
	    {
	        return 1;
	    }
 	}
 	else if(PlayersBowlingRoad[playerid]==3)
	{
	    if(IsPlayerInRangeOfPoint(playerid,0.5,-1975.0587,412.2807,2.5090))
	    {
	        return 1;
	    }
 	}
 	else if(PlayersBowlingRoad[playerid]==4)
	{
	    if(IsPlayerInRangeOfPoint(playerid,0.5,-1975.0587,410.7207,2.5090))
	    {
	        return 1;
	    }
 	}
	return 0;
}
stock MoveBall(playerid)
{
    if(PlayersBowlingRoad[playerid] == 0)
	{
    	MoveDynamicObject(BowlingBall[0],-1962.90368652,416.9655,1.64401352,BALL_SPEED);
	}
	else if(PlayersBowlingRoad[playerid] == 1)
	{
    	MoveDynamicObject(BowlingBall[1],-1962.90368652,415.4035,1.64401352,BALL_SPEED);
	}
	else if(PlayersBowlingRoad[playerid] == 2)
	{
    	MoveDynamicObject(BowlingBall[2],-1962.90368652,413.8728,1.64401352,BALL_SPEED);
	}
	else if(PlayersBowlingRoad[playerid] == 3)
	{
    	MoveDynamicObject(BowlingBall[3],-1962.90368652,412.2807,1.64401352,BALL_SPEED);
	}
	else if(PlayersBowlingRoad[playerid] == 4)
	{
    	MoveDynamicObject(BowlingBall[4],-1962.90368652,410.7207,1.64401352,BALL_SPEED);
	}
	return 1;
}
stock CreateBall(playerid)
{
    if(PlayersBowlingRoad[playerid]==0)
	{
	    BowlingBall[0] = CreateDynamicObject(2114,-1975.0587+1,416.9655,1.64401352,0.0,0.0,0.0);
	}
	else if(PlayersBowlingRoad[playerid]==1)
	{
	    BowlingBall[1] = CreateDynamicObject(2114,-1975.0587+1,415.4035,1.64401352,0.0,0.0,0.0);
	}
	else if(PlayersBowlingRoad[playerid]==2)
	{
	    BowlingBall[2] = CreateDynamicObject(2114,-1975.0587+1,413.8728,1.64401352,0.0,0.0,0.0);
	}
	else if(PlayersBowlingRoad[playerid]==3)
	{
	    BowlingBall[3] = CreateDynamicObject(2114,-1975.0587+1,412.2807,1.64401352,0.0,0.0,0.0);
	}
	else if(PlayersBowlingRoad[playerid]==4)
	{
	    BowlingBall[4] = CreateDynamicObject(2114,-1975.0587+1,410.7207,1.64401352,0.0,0.0,0.0);
	}
	return 1;
}
stock DestroyBall(playerid)
{
    if(PlayersBowlingRoad[playerid]==0)
	{
	    DestroyDynamicObject(BowlingBall[0]);
	}
	else if(PlayersBowlingRoad[playerid]==1)
	{
	    DestroyDynamicObject(BowlingBall[1]);
	}
	else if(PlayersBowlingRoad[playerid]==2)
	{
	    DestroyDynamicObject(BowlingBall[2]);
	}
	else if(PlayersBowlingRoad[playerid]==3)
	{
	    DestroyDynamicObject(BowlingBall[3]);
	}
	else if(PlayersBowlingRoad[playerid]==4)
	{
	    DestroyDynamicObject(BowlingBall[4]);
	}
	return 1;
}

stock DestroyPins(roadid)
{
	
	for(new pin = 0; pin<=MAX_PINS; pin++)
	{
	    DestroyDynamicObject(BowlingPins[roadid][pin]);
	}
    return 1;
}
stock CreatePins(playerid)
{
	if(PlayersBowlingRoad[playerid]==0)
	{
		BowlingPins[0][9] = CreateDynamicObject(1484, -1963.1579589844, 417.12506103516, 1.7151190042496, 349.04943847656, 24.473388671875, 6.1903991699219);
		BowlingPins[0][8] = CreateDynamicObject(1484, -1963.1511230469, 416.96856689453, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[0][7] = CreateDynamicObject(1484, -1963.1798095703, 416.78656005859, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[0][6] = CreateDynamicObject(1484, -1963.1925048828, 416.59609985352, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[0][5] = CreateDynamicObject(1484, -1963.3796386719, 416.69662475586, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[0][4] = CreateDynamicObject(1484, -1963.3446044922, 416.86737060547, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[0][3] = CreateDynamicObject(1484, -1963.3403320313, 417.02703857422, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[0][2] = CreateDynamicObject(1484, -1963.5046386719, 416.95327758789, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[0][1] = CreateDynamicObject(1484, -1963.5002441406, 416.77334594727, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[0][0] = CreateDynamicObject(1484, -1963.6495361328, 416.86196899414, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
	}
	else if(PlayersBowlingRoad[playerid]==1)
	{
	    BowlingPins[1][9] = CreateDynamicObject(1484, -1963.1579589844, 417.12506103516-Y_ROAD_2, 1.7151190042496, 349.04943847656, 24.473388671875, 6.1903991699219);
		BowlingPins[1][8] = CreateDynamicObject(1484, -1963.1511230469, 416.96856689453-Y_ROAD_2, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[1][7] = CreateDynamicObject(1484, -1963.1798095703, 416.78656005859-Y_ROAD_2, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[1][6] = CreateDynamicObject(1484, -1963.1925048828, 416.59609985352-Y_ROAD_2, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[1][5] = CreateDynamicObject(1484, -1963.3796386719, 416.69662475586-Y_ROAD_2, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[1][4] = CreateDynamicObject(1484, -1963.3446044922, 416.86737060547-Y_ROAD_2, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[1][3] = CreateDynamicObject(1484, -1963.3403320313, 417.02703857422-Y_ROAD_2, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[1][2] = CreateDynamicObject(1484, -1963.5046386719, 416.95327758789-Y_ROAD_2, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[1][1] = CreateDynamicObject(1484, -1963.5002441406, 416.77334594727-Y_ROAD_2, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[1][0] = CreateDynamicObject(1484, -1963.6495361328, 416.86196899414-Y_ROAD_2, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
	}
	else if(PlayersBowlingRoad[playerid]==2)
	{
	    BowlingPins[2][9] = CreateDynamicObject(1484, -1963.1579589844, 417.12506103516-Y_ROAD_3, 1.7151190042496, 349.04943847656, 24.473388671875, 6.1903991699219);
		BowlingPins[2][8] = CreateDynamicObject(1484, -1963.1511230469, 416.96856689453-Y_ROAD_3, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[2][7] = CreateDynamicObject(1484, -1963.1798095703, 416.78656005859-Y_ROAD_3, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[2][6] = CreateDynamicObject(1484, -1963.1925048828, 416.59609985352-Y_ROAD_3, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[2][5] = CreateDynamicObject(1484, -1963.3796386719, 416.69662475586-Y_ROAD_3, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[2][4] = CreateDynamicObject(1484, -1963.3446044922, 416.86737060547-Y_ROAD_3, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[2][3] = CreateDynamicObject(1484, -1963.3403320313, 417.02703857422-Y_ROAD_3, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[2][2] = CreateDynamicObject(1484, -1963.5046386719, 416.95327758789-Y_ROAD_3, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[2][1] = CreateDynamicObject(1484, -1963.5002441406, 416.77334594727-Y_ROAD_3, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[2][0] = CreateDynamicObject(1484, -1963.6495361328, 416.86196899414-Y_ROAD_3, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
	}
	else if(PlayersBowlingRoad[playerid]==3)
	{
	    BowlingPins[3][9] = CreateDynamicObject(1484, -1963.1579589844, 417.12506103516-Y_ROAD_4, 1.7151190042496, 349.04943847656, 24.473388671875, 6.1903991699219);
		BowlingPins[3][8] = CreateDynamicObject(1484, -1963.1511230469, 416.96856689453-Y_ROAD_4, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[3][7] = CreateDynamicObject(1484, -1963.1798095703, 416.78656005859-Y_ROAD_4, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[3][6] = CreateDynamicObject(1484, -1963.1925048828, 416.59609985352-Y_ROAD_4, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[3][5] = CreateDynamicObject(1484, -1963.3796386719, 416.69662475586-Y_ROAD_4, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[3][4] = CreateDynamicObject(1484, -1963.3446044922, 416.86737060547-Y_ROAD_4, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[3][3] = CreateDynamicObject(1484, -1963.3403320313, 417.02703857422-Y_ROAD_4, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[3][2] = CreateDynamicObject(1484, -1963.5046386719, 416.95327758789-Y_ROAD_4, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[3][1] = CreateDynamicObject(1484, -1963.5002441406, 416.77334594727-Y_ROAD_4, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[3][0] = CreateDynamicObject(1484, -1963.6495361328, 416.86196899414-Y_ROAD_4, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
	}
	else if(PlayersBowlingRoad[playerid]==4)
	{
	    BowlingPins[4][9] = CreateDynamicObject(1484, -1963.1579589844, 417.12506103516-Y_ROAD_5, 1.7151190042496, 349.04943847656, 24.473388671875, 6.1903991699219);
		BowlingPins[4][8] = CreateDynamicObject(1484, -1963.1511230469, 416.96856689453-Y_ROAD_5, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[4][7] = CreateDynamicObject(1484, -1963.1798095703, 416.78656005859-Y_ROAD_5, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[4][6] = CreateDynamicObject(1484, -1963.1925048828, 416.59609985352-Y_ROAD_5, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[4][5] = CreateDynamicObject(1484, -1963.3796386719, 416.69662475586-Y_ROAD_5, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[4][4] = CreateDynamicObject(1484, -1963.3446044922, 416.86737060547-Y_ROAD_5, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[4][3] = CreateDynamicObject(1484, -1963.3403320313, 417.02703857422-Y_ROAD_5, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[4][2] = CreateDynamicObject(1484, -1963.5046386719, 416.95327758789-Y_ROAD_5, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[4][1] = CreateDynamicObject(1484, -1963.5002441406, 416.77334594727-Y_ROAD_5, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
		BowlingPins[4][0] = CreateDynamicObject(1484, -1963.6495361328, 416.86196899414-Y_ROAD_5, 1.7151190042496, 349.04663085938, 24.472045898438, 6.185302734375);
	}
    return 1;
}
stock PinsKnocked(playerid)
{
    if(AbleToPlay[playerid] == 0) return SendClientMessage(playerid,0xD92626AA,"Ты не начал игру!");
	new Float:x,Float:y,Float:z;
	new knock = random(10);
	switch(knock)
	{
	    case 0:
	    {
	    	GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][0],x,y,z);
			MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][0],x,y,z-1,2.0);
			LastPin[PlayersBowlingRoad[playerid]][0][playerid] = PIN_GOAWAY;
			GameTextForPlayer(playerid,"~w~You have knocked~n~ ~g~1 ~w~pin", 3000, 4);
			PinsLeft[PlayersBowlingRoad[playerid]][playerid] = 9;
			PlayersBowlingScore[playerid] += 1;
		}
	    case 1:
	    {

    		for(new pin=0; pin<=1; pin++)
	    	{
     			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z-1,2.0);
				LastPin[PlayersBowlingRoad[playerid]][pin][playerid] = PIN_GOAWAY;
			}
			PinsLeft[PlayersBowlingRoad[playerid]][playerid] = 8;
			PlayersBowlingScore[playerid] += 2;
			GameTextForPlayer(playerid,"~w~You have knocked~n~ ~g~2 ~w~pins", 3000, 4);
	    }
	    case 2:
	    {
  			for(new pin=0; pin<=2; pin++)
	    	{
     			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z-1,2.0);
				LastPin[PlayersBowlingRoad[playerid]][pin][playerid] = PIN_GOAWAY;
			}
			PinsLeft[PlayersBowlingRoad[playerid]][playerid] = 7;
			PlayersBowlingScore[playerid] += 3;
			GameTextForPlayer(playerid,"~w~You have knocked~n~ ~g~3 ~w~pins", 3000, 4);
	    }
	    case 3:
	    {
  			for(new pin=0; pin<=3; pin++)
	    	{
     			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z-1,2.0);
				LastPin[PlayersBowlingRoad[playerid]][pin][playerid] = PIN_GOAWAY;
			}
			PlayersBowlingScore[playerid] += 4;
			PinsLeft[PlayersBowlingRoad[playerid]][playerid] = 6;
			GameTextForPlayer(playerid,"~w~You have knocked~n~ ~g~4 ~w~pins", 3000, 4);

	    }
	    case 4:
	    {
  			for(new pin=0; pin<=4; pin++)
	    	{
     			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z-1,2.0);
				LastPin[PlayersBowlingRoad[playerid]][pin][playerid] = PIN_GOAWAY;
			}
			PlayersBowlingScore[playerid] += 5;
			PinsLeft[PlayersBowlingRoad[playerid]][playerid] = 5;
			GameTextForPlayer(playerid,"~w~You have knocked~n~ ~g~5 ~w~pins", 3000, 4);
	    }
	    case 5:
	    {
  			for(new pin=0; pin<=5; pin++)
	    	{
     			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z-1,2.0);
				LastPin[PlayersBowlingRoad[playerid]][pin][playerid] = PIN_GOAWAY;
			}
			PlayersBowlingScore[playerid] += 6;
			PinsLeft[PlayersBowlingRoad[playerid]][playerid] = 4;
			GameTextForPlayer(playerid,"~w~You have knocked~n~ ~g~6 ~w~pins", 3000, 4);
	    }
	    case 6:
	    {
  			for(new pin=0; pin<=6; pin++)
	    	{
     			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z-1,2.0);
				LastPin[PlayersBowlingRoad[playerid]][pin][playerid] = PIN_GOAWAY;
			}
			PlayersBowlingScore[playerid] += 7;
			PinsLeft[PlayersBowlingRoad[playerid]][playerid] = 3;
			GameTextForPlayer(playerid,"~w~You have knocked~n~ ~g~7 ~w~pins", 3000, 4);
	    }
	    case 7:
	    {
	        for(new pin=0; pin<=7; pin++)
	    	{
     			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z-1,2.0);
				LastPin[PlayersBowlingRoad[playerid]][pin][playerid] = PIN_GOAWAY;
			}
			PlayersBowlingScore[playerid] += 8;
			PinsLeft[PlayersBowlingRoad[playerid]][playerid] = 2;
			GameTextForPlayer(playerid,"~w~You have knocked~n~ ~g~8 ~w~pins", 3000, 4);

	    }
	    case 8:
	    {
	        for(new pin=0; pin<=8; pin++)
	    	{
     			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z-1,2.0);
				LastPin[PlayersBowlingRoad[playerid]][pin][playerid] = PIN_GOAWAY;
			}
			PlayersBowlingScore[playerid] += 9;
			PinsLeft[PlayersBowlingRoad[playerid]][playerid] = 1;
			GameTextForPlayer(playerid,"~w~You have knocked~n~ ~g~9 ~w~pins", 3000, 4);

	    }
	    case 9:
	    {
	    	for(new pin=0; pin<=9; pin++)
	    	{
	    	    
     			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z-1,2.0);
				LastPin[PlayersBowlingRoad[playerid]][pin][playerid] = PIN_GOAWAY;
			}
			PinsLeft[PlayersBowlingRoad[playerid]][playerid] = 0;
			BowlingStatus[playerid]=N_BOWLING_THROW;
			PlayerStrikes[playerid]+=1;
			dini_IntSet(PlayerBowlingFile(playerid),"Strikes",PlayerStrikes[playerid]);
			PlayersBowlingScore[playerid] += 15;
			BowlingPinsWaitTimer[playerid] = SetTimerEx("PinsWaitTimer",3000,false,"d",playerid);
			GameTextForPlayer(playerid,"~y~STRIKE!!!", 3000, 4);
	    }
	}
	return 1;
}
stock LastPinsKnocked(playerid)
{
    if(AbleToPlay[playerid] == 0) return SendClientMessage(playerid,0xD92626AA,"Ты не начал игру!");
    new Float:x,Float:y,Float:z;
	if(PinsLeft[PlayersBowlingRoad[playerid]][playerid] == 1)
	{
	    new knock = random(2);
		switch(knock)
		{
		    case 0:
		    {
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~g~SPARE!", 3000, 4);
				
				LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
				PlayersBowlingScore[playerid] += 1;
			}
		    case 1:
			{
		    	GameTextForPlayer(playerid,"~r~You missed!", 3000, 4);
		    	
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
			}
		}
		
	}
	else if(PinsLeft[PlayersBowlingRoad[playerid]][playerid] == 2)
	{
	    new knock = random(4);
		switch(knock)
		{
		    case 0:
		    {
	    		GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~1 ~w~pin!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
				LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
				PlayersBowlingScore[playerid] += 1;
				
			}
			case 1:
		    {
	 			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~1 ~w~pin!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
				LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
				PlayersBowlingScore[playerid] += 1;
				
			}
			case 2:
			{
			    GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
			    GameTextForPlayer(playerid,"~g~SPARE!", 3000, 4);
			    
			    LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
			    LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
			    PlayersBowlingScore[playerid] += 2;
			}
			case 3:
			{
			    GameTextForPlayer(playerid,"~r~You missed!", 3000, 4);
			    
			    LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
			    LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
			}
		}
	}
	else if(PinsLeft[PlayersBowlingRoad[playerid]][playerid] == 3)
	{
	    new knock = random(6);
		switch(knock)
		{
		    case 0:
		    {
   				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
	 			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
			    LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
			    LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
				GameTextForPlayer(playerid,"~g~SPARE!", 3000, 4);
				PlayersBowlingScore[playerid] += 3;
				
			}
			case 1:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~1 ~w~pin!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
			    LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
			    LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
			    PlayersBowlingScore[playerid] += 1;
			    
		    }
		    case 2:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~1 ~w~pin!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
			    LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
			    LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
			    PlayersBowlingScore[playerid] += 1;
			    
		    }
		    case 3:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~2 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
			    LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
			    LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
			    PlayersBowlingScore[playerid] += 2;
			    
		    }
			case 4:
		    {
		    	GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~2 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
			    LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
			    LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
			    PlayersBowlingScore[playerid] += 2;
			    
			}
			case 5:
		    {
		    	GameTextForPlayer(playerid,"~r~You missed!", 3000, 4);
		    	
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    }
		}
		    
	}
	else if(PinsLeft[PlayersBowlingRoad[playerid]][playerid] == 4)
	{
		new knock = random(8);
		switch(knock)
		{
		    case 0:
		    {
	    		GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
	 			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~g~SPARE!", 3000, 4);
				
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 4;
			}
			case 1:
		    {
		    	GameTextForPlayer(playerid,"~r~You missed!", 3000, 4);
		    	
		    	LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    }
		    case 2:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~1 ~w~pin!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 1;
		    	

		    }
		    case 3:
		    {
		    	GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~1 ~w~pin!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    	PlayersBowlingScore[playerid] += 1;
		    	
			}
			case 4:
		    {
		    	GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~2 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 2;
		    	
			}
			case 5:
		    {
		    	GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~2 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    	PlayersBowlingScore[playerid] += 2;
		    	
			}
			case 6:
		    {
		    	GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~3 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    	PlayersBowlingScore[playerid] += 3;
		    	
			}
			case 7:
		    {
		    	GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~3 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 3;
			}
		}
	}
	else if(PinsLeft[PlayersBowlingRoad[playerid]][playerid] == 5)
	{
	    new knock = random(8);
		switch(knock)
		{
		    case 0:
		    {
	    		GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
	 			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z-1,2.0);
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 5;
				GameTextForPlayer(playerid,"~g~SPARE!", 3000, 4);
				
			}
			case 1:
		    {
		    	GameTextForPlayer(playerid,"~r~You missed!", 3000, 4);
		    	
       			LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    }
		    case 2:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~1 ~w~pin!", 3000, 4);
		        LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    	PlayersBowlingScore[playerid] += 1;
		    }
		    case 3:
		    {
            	GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~2 ~w~pins!", 3000, 4);
		        LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    	PlayersBowlingScore[playerid] += 2;
		    }
		    case 4:
		    {
                GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~1 ~w~pin!", 3000, 4);
		        LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 1;

		    }
		    case 5:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~3 ~w~pins!", 3000, 4);
		        LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    	PlayersBowlingScore[playerid] += 3;
		    }
		    case 6:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~3 ~w~pins!", 3000, 4);
		        LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 3;
		    }
		    case 7:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~4 ~w~pins!", 3000, 4);
		        LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 4;
		    }
		}
	}
	else if(PinsLeft[PlayersBowlingRoad[playerid]][playerid] == 6)
	{
		new knock = random(10);
		switch(knock)
		{
		    case 0:
		    {
	    		GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
	 			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~g~SPARE!", 3000, 4);
				PlayersBowlingScore[playerid] += 6;
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
			}
			case 1:
		    {
		    	GameTextForPlayer(playerid,"~r~You missed!", 3000, 4);
		    	
		    	LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    }
		    case 2:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~1 ~w~pin!", 3000, 4);
		        LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    	PlayersBowlingScore[playerid] += 1;

		    }
		    case 3:
		    {
            	GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~2 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
		        LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    	PlayersBowlingScore[playerid] += 2;
		    	
		    }
		    case 4:
		    {
                GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~1 ~w~pin!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
		        LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 1;
		    	

		    }
		    case 5:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~3 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_GOAWAY;
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    	PlayersBowlingScore[playerid] += 3;
		    	
		    }
		    case 6:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~4 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_GOAWAY;
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 4;
		    	
		    }
		    case 7:
		    {
		    	GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~5 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_GOAWAY;
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 5;
		    }
		    case 8:
		    {
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~3 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 3;
		    
		    }
		    case 9:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~4 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_GOAWAY;
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 4;
		    
		    }
		}
	}
	else if(PinsLeft[PlayersBowlingRoad[playerid]][playerid] == 7)
	{
	    new knock = random(13);
		switch(knock)
		{
		    case 0:
		    {
	    		GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
	 			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][3],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][3],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~g~SPARE!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_GOAWAY;
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 7;
			}
			case 1:
		    {
		    	GameTextForPlayer(playerid,"~r~You missed!", 3000, 4);
		    	
		    	LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    }
		    case 2:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~1 ~w~pin!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_LAST;
		        LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    	PlayersBowlingScore[playerid] += 1;
		    	

		    }
		    case 3:
		    {
            	GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~2 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_LAST;
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
		        LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    	PlayersBowlingScore[playerid] += 2;
		    }
		    case 4:
		    {
                GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~1 ~w~pin!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_LAST;
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
		        LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 1;

		    }
		    case 5:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~3 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_LAST;
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_GOAWAY;
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    	PlayersBowlingScore[playerid] += 3;
		    }
		    case 6:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~4 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_LAST;
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_GOAWAY;
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 4;
		    }
		    case 7:
		    {
		    	GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~5 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_LAST;
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_GOAWAY;
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 5;
		    }
		    case 8:
		    {
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~3 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_LAST;
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 3;

		    }
		    case 9:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~4 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_LAST;
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_GOAWAY;
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 4;

		    }
		    case 10:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][3],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][3],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~3 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_GOAWAY;
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    	PlayersBowlingScore[playerid] += 3;

		    }
		    case 11:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][3],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][3],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~5 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_GOAWAY;
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_GOAWAY;
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    	PlayersBowlingScore[playerid] += 5;
		    }
		    case 12:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][3],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][3],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~5 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_GOAWAY;
				LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_GOAWAY;
				LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    	PlayersBowlingScore[playerid] += 5;
		    }
		}
	}
	else if(PinsLeft[PlayersBowlingRoad[playerid]][playerid] == 8)
	{
	    new knock = random(8);
		switch(knock)
		{
		    case 0:
		    {
	    		GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
	 			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][3],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][3],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][2],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][2],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~g~SPARE!", 3000, 4);
				
		    	LastPin[PlayersBowlingRoad[playerid]][2][playerid] = PIN_GOAWAY;
				LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 8;
		    }
			case 1:
		    {
		    	GameTextForPlayer(playerid,"~r~You missed!", 3000, 4);
		    	
		    	LastPin[PlayersBowlingRoad[playerid]][2][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    }
		    case 2:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~1 ~w~pin!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][2][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 1;
		    	
		    }
		    case 3:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~1 ~w~pin!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][2][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    	PlayersBowlingScore[playerid] += 1;
		    	
		    }
		    case 4:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][3],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][3],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~3 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][2][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    	PlayersBowlingScore[playerid] += 3;
		    	
		    }
		    case 5:
		    {
		    	GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~3 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][2][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 3;

		    }
		    case 6:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][2],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][2],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~4 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][2][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 4;
		    }
		    case 7:
		    {
		        GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~r~You have knocked only ~y~3 ~w~pins!", 3000, 4);
				LastPin[PlayersBowlingRoad[playerid]][2][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    	PlayersBowlingScore[playerid] += 3;
		    }
		}
	}
	else if(PinsLeft[PlayersBowlingRoad[playerid]][playerid] == 9)
	{
	    new knock = random(2);
		switch(knock)
		{
		    case 0:
		    {
	    		GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][9],x,y,z-1,2.0);
	 			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][8],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][7],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][6],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][5],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][4],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][3],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][3],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][2],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][2],x,y,z-1,2.0);
				GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][1],x,y,z);
				MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][1],x,y,z-1,2.0);
				GameTextForPlayer(playerid,"~g~SPARE!", 3000, 4);
				
				LastPin[PlayersBowlingRoad[playerid]][1][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][2][playerid] = PIN_GOAWAY;
				LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_GOAWAY;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_GOAWAY;
		    	PlayersBowlingScore[playerid] += 9;
			}
			case 1:
		    {
		    	GameTextForPlayer(playerid,"~r~You missed!", 3000, 4);
		    	
		    	LastPin[PlayersBowlingRoad[playerid]][1][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][2][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][3][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][4][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][5][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][6][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][7][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][8][playerid] = PIN_LAST;
		    	LastPin[PlayersBowlingRoad[playerid]][9][playerid] = PIN_LAST;
		    }
		}
	}
	return 1;
}
//bowling timers
forward PinsWaitTimer(playerid);
public PinsWaitTimer(playerid)
{
    new Float:x,Float:y,Float:z;
    for(new pin=0; pin<=MAX_PINS; pin++)
   	{
   	    if(LastPin[PlayersBowlingRoad[playerid]][pin][playerid] == PIN_GOAWAY)
   	    {
			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z);
			MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z+1,1.0);
			BowlingPinsWaitEndTimer[playerid] = SetTimerEx("PinsWaitEnd",2000,false,"d",playerid);
		}
	}
}
forward PinsWaitEnd(playerid);
public PinsWaitEnd(playerid)
{
	BowlingStatus[playerid]=F_BOWLING_THROW;
}
forward BowlingCountDown(playerid);
public BowlingCountDown(playerid)
{
	    
	        BowlingSeconds[playerid] -= 1;
	    	new str[150];
			if(PlayersBowlingRoad[playerid]==0)
			{
				format(str,150,"{E32A2A}[{FFFFFF} Дорожка 1{E32A2A} ]\n Занято \n {BBBB00}Игрок: {FFFFFF}%s\n {BBBB00} Время:{FFFFFF} %02d : %02d \n {BBBB00} Очки:{FFFFFF} %i",PlayerName(playerid),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
				UpdateDynamic3DTextLabelText(BowlingRoadScreen[0], 0xFFFFFF,str);
			}
			if(PlayersBowlingRoad[playerid]==1)
			{
				format(str,150,"{E32A2A}[{FFFFFF} Дорожка 2{E32A2A} ]\n Занято \n {BBBB00}Игрок: {FFFFFF}%s\n {BBBB00} Время:{FFFFFF} %02d : %02d \n {BBBB00} Очки:{FFFFFF} %i",PlayerName(playerid),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
				UpdateDynamic3DTextLabelText(BowlingRoadScreen[1], 0xFFFFFF,str);
			}
			if(PlayersBowlingRoad[playerid]==2)
			{
				format(str,150,"{E32A2A}[{FFFFFF} Дорожка 3{E32A2A} ]\n Занято \n {BBBB00}Игрок: {FFFFFF}%s\n {BBBB00} Время:{FFFFFF} %02d : %02d \n {BBBB00} Очки:{FFFFFF} %i",PlayerName(playerid),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
				UpdateDynamic3DTextLabelText(BowlingRoadScreen[2], 0xFFFFFF,str);
			}
			if(PlayersBowlingRoad[playerid]==3)
			{
				format(str,150,"{E32A2A}[{FFFFFF} Дорожка 4{E32A2A} ]\n Занято \n {BBBB00}Игрок: {FFFFFF}%s\n {BBBB00} Время:{FFFFFF} %02d : %02d \n {BBBB00} Очки:{FFFFFF} %i",PlayerName(playerid),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
				UpdateDynamic3DTextLabelText(BowlingRoadScreen[3], 0xFFFFFF,str);
			}
			if(PlayersBowlingRoad[playerid]==4)
			{
				format(str,150,"{E32A2A}[{FFFFFF} Дорожка 5{E32A2A} ]\n Занято \n {BBBB00}Игрок: {FFFFFF}%s\n {BBBB00} Время:{FFFFFF} %02d : %02d \n {BBBB00} Очки:{FFFFFF} %i",PlayerName(playerid),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
				UpdateDynamic3DTextLabelText(BowlingRoadScreen[4], 0xFFFFFF,str);
			}
			if(BowlingSeconds[playerid] == 0 && BowlingMinutes[playerid] > 0 )
	    	{
	        	BowlingSeconds[playerid] = 59;
        		BowlingMinutes[playerid] -= 1;
        	}
	        else if(BowlingMinutes[playerid] == 0 && BowlingSeconds[playerid] == 0)
			{
				BowlingSeconds[playerid] = 0;
				BowlingMinutes[playerid] = 0;
				AbleToPlay[playerid] = 0;
				BowlingRoadStatus[PlayersBowlingRoad[playerid]] = ROAD_EMPTY;
				KillTimer(BowlingTimer[PlayersBowlingRoad[playerid]]);
				SendClientMessage(playerid,COLOR_CMDERROR,"Время игры закончено.");
				scmf(playerid,COLOR_CMDERROR,"{FFFFFF}Ты набрал {00CC00}%i {FFFFFF}очков и за них получил {00CC00}${FFFFFF}%.",PlayersBowlingScore[playerid],PlayersBowlingScore[playerid]*10);
				GivePlayerMoney(playerid,PlayersBowlingScore[playerid]*10);
				PlayersBowlingScore[playerid] = 0;
				DestroyBall(playerid);
 				if(PlayersBowlingRoad[playerid]==0)
 				{
			 		UpdateDynamic3DTextLabelText(BowlingRoadScreen[0], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 1{008800} ]\n Свободно");
			 		PlayersBowlingRoad[playerid] = ROAD_NONE;
			 		DestroyPins(0);
	 			}
 				else if(PlayersBowlingRoad[playerid]==1)
 				{
			 		UpdateDynamic3DTextLabelText(BowlingRoadScreen[1], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 2{008800} ]\n Свободно");
			 		PlayersBowlingRoad[playerid] = ROAD_NONE;
			 		DestroyPins(1);
			 	}
				else if(PlayersBowlingRoad[playerid]==2)
				{
					UpdateDynamic3DTextLabelText(BowlingRoadScreen[2], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 3{008800} ]\n Свободно");
					PlayersBowlingRoad[playerid] = ROAD_NONE;
					DestroyPins(2);
				}
				else if(PlayersBowlingRoad[playerid]==3)
				{
					UpdateDynamic3DTextLabelText(BowlingRoadScreen[3], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 4{008800} ]\n Свободно");
					PlayersBowlingRoad[playerid] = ROAD_NONE;
					DestroyPins(3);
				}
				else if(PlayersBowlingRoad[playerid]==4)
				{
					UpdateDynamic3DTextLabelText(BowlingRoadScreen[4], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 5{008800} ]\n Свободно");
					PlayersBowlingRoad[playerid] = ROAD_NONE;
					DestroyPins(4);
				}
				
			}
			return 1;
}
forward BallGoingTimer(playerid);
public BallGoingTimer(playerid)
{
    MoveBall(playerid);
    BallRun[playerid] = SetTimerEx("BallRunTimer",BALL_RUN_TIME,false,"d",playerid);
	return 1;
}
forward BallRunTimer(playerid);
public BallRunTimer(playerid)
{
	if(BowlingStatus[playerid]==F_BOWLING_THROW)
    {
    	PinsKnocked(playerid);
    	BowlingStatus[playerid]=S_BOWLING_THROW;
	}
	else if(BowlingStatus[playerid]==S_BOWLING_THROW)
	{
	    LastPinsKnocked(playerid);
	    BowlingStatus[playerid]=N_BOWLING_THROW;
	    BowlingPinsWaitTimer[playerid] = SetTimerEx("PinsWaitTimer",3000,false,"d",playerid);
	}
	DestroyDynamicObject(BowlingBall[PlayersBowlingRoad[playerid]]);
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if(checkpointid == BowlingCP1)
    {
        ShowPlayerDialog(playerid,DIALOG_BOWLING, DIALOG_STYLE_LIST, "Боулинг by Nexotronix", "{00AA00}1. {FFFFFF}Взять дорожку \n{00AA00}2. {FFFFFF}Закончить игру \n{00AA00}3. {FFFFFF}Продлить игру ", "ОК", "Выйти");
    }
	return 1;
}

public OnPlayerLeaveDynamicCP(playerid)
{
	return 1;
}

public OnPlayerEnterDynamicRaceCP(playerid)
{
	return 1;
}

public OnPlayerLeaveDynamicRaceCP(playerid)
{
	return 1;
}

public OnDynamicObjectMoved(objectid)
{
	return 1;
}


public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(pickupid == Pickup[bowlExit])
	{
	    SetPlayerPos(playerid,-1994.5708,407.2563,35.1719);
	    SetPlayerFacingAngle(playerid,91.0912);
	    SetCameraBehindPlayer(playerid);
	    SetPlayerInterior(playerid,0);
	}
	else if(pickupid == Pickup[bowlEnter])
	{
	    SetPlayerPos(playerid,-1989.7111,407.6148,2.1010);
	    SetPlayerFacingAngle(playerid,268.7060);
	    SetCameraBehindPlayer(playerid);
	    SetPlayerInterior(playerid,1);
	}
	PickupBowlingHelp(playerid,pickupid);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_BOWLING_STATS)
	{
	    if(response) return 1;
	}
    if(dialogid == DIALOG_BOWLING)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
	                if(AbleToPlay[playerid] == 1) return SendClientMessage(playerid,0xD92626AA,"Ты уже начал игру!");
	                ShowPlayerDialog(playerid,DIALOG_ROAD, DIALOG_STYLE_LIST, "Выбор дорожки", "{00AA00}1. {FFFFFF}Дорожка 1 \n{00AA00}2. {FFFFFF}Дорожка 2 \n{00AA00}3. {FFFFFF}Дорожка 3 \n{00AA00}4. {FFFFFF}Дорожка 4 \n{00AA00}5. {FFFFFF}Дорожка 5  ", "ОК", "Назад");
	            }
	            case 1:
	            {
	                if(AbleToPlay[playerid] == 0) return SendClientMessage(playerid,0xD92626AA,"Ты не начал игру!");
	                AbleToPlay[playerid] = 0;
	                BowlingRoadStatus[PlayersBowlingRoad[playerid]] = ROAD_EMPTY;
	                KillTimer(BowlingTimer[PlayersBowlingRoad[playerid]]);
	                BowlingMinutes[playerid] = 0;
	                BowlingSeconds[playerid] = 0;
	                SendClientMessage(playerid,0xD92626AA,"Ты окончил игру!");
	                scmf(playerid,COLOR_CMDERROR,"{FFFFFF}Ты набрал {00CC00}%i {FFFFFF}очков и за них получил {00CC00}${FFFFFF}%i.",PlayersBowlingScore[playerid],PlayersBowlingScore[playerid]*10);
					GivePlayerMoney(playerid,PlayersBowlingScore[playerid]*10);
					DestroyBall(playerid);
					if(PlayersBowlingScore[playerid] > BestScore[playerid])
					{
					    scmf(playerid,0xD92626AA,"{00CC00}Ты побил свой рекорд: {FFFFFF}%i!",BestScore[playerid]);
            			scmf(playerid,0xFFFFFF,"{00CC00}Твой новый рекорд: {FFFFFF}%i!",PlayersBowlingScore[playerid]);
						dini_IntSet(PlayerBowlingFile(playerid),"BestScore",PlayersBowlingScore[playerid]);
						BestScore[playerid] = PlayersBowlingScore[playerid];
					}
					else
					{
      					scmf(playerid,0xD92626AA,"{00CC00}Твой рекорд: {FFFFFF}%i!",BestScore[playerid]);
					}
                    PlayersBowlingScore[playerid] = 0;
	                if(PlayersBowlingRoad[playerid]==0)
	                {
						UpdateDynamic3DTextLabelText(BowlingRoadScreen[0], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 1{008800} ]\n Свободно");
						PlayersBowlingRoad[playerid] = ROAD_NONE;
	                	DestroyPins(0);
	                }
					else if(PlayersBowlingRoad[playerid]==1)
					{
						UpdateDynamic3DTextLabelText(BowlingRoadScreen[1], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 2{008800} ]\n Свободно");
						PlayersBowlingRoad[playerid] = ROAD_NONE;
						DestroyPins(1);
					}
					else if(PlayersBowlingRoad[playerid]==2)
					{
						UpdateDynamic3DTextLabelText(BowlingRoadScreen[2], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 3{008800} ]\n Свободно");
						PlayersBowlingRoad[playerid] = ROAD_NONE;
						DestroyPins(2);
                    }
					else if(PlayersBowlingRoad[playerid]==3)
                    {
						UpdateDynamic3DTextLabelText(BowlingRoadScreen[3], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 4{008800} ]\n Свободно");
						PlayersBowlingRoad[playerid] = ROAD_NONE;
						DestroyPins(3);
                    }
					else if(PlayersBowlingRoad[playerid]==4)
					{
						UpdateDynamic3DTextLabelText(BowlingRoadScreen[4], 0xFFFFFF,"{008800}[{FFFFFF} Дорожка 5{008800} ]\n Свободно");
						PlayersBowlingRoad[playerid] = ROAD_NONE;
						DestroyPins(4);
					}
	                
	                return 1;
	            }
	            case 2:
	            {
	                if(AbleToPlay[playerid] == 0) return SendClientMessage(playerid,0xD92626AA,"Ты не начал игру!");
                    ShowPlayerDialog(playerid,DIALOG_ADD_TIME, DIALOG_STYLE_LIST, "Продлить время игры","{00AA00}+3 {FFFFFF}минуты {00AA00} 30$ \n{00AA00}+5 {FFFFFF}минут {00AA00} 50$ \n{00AA00}+10 {FFFFFF}минут{00AA00} 100$ \n{00AA00}+25 {FFFFFF}минут{00AA00} 250$ \n{00AA00}+30 {FFFFFF}минут{00AA00} 300$ ","ОК","Назад");
	            }
	        }
	    }
	    return 1;
	}
	if(dialogid == DIALOG_ROAD)
	{
    	if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
	                if(BowlingRoadStatus[0] == ROAD_EMPTY)
	                {
						PlayersBowlingRoad[playerid] = 0;
						ShowPlayerDialog(playerid,DIALOG_BOWLING_TIME, DIALOG_STYLE_LIST, "Время игры","{BBBB00}3 {FFFFFF}минуты {00AA00} 30$ \n{BBBB00}5 {FFFFFF}минут {00AA00} 50$ \n{BBBB00}10 {FFFFFF}минут{00AA00} 100$ \n{BBBB00}25 {FFFFFF}минут{00AA00} 250$ \n{BBBB00}30 {FFFFFF}минут{00AA00} 300$ ","ОК","Назад");
					}
					else if(BowlingRoadStatus[0] == ROAD_BUSY) return SendClientMessage(playerid,COLOR_CMDERROR,"Дорожка занята.");
				}
				case 1:
	            {
	                if(BowlingRoadStatus[1] == ROAD_EMPTY)
					{
					    PlayersBowlingRoad[playerid] = 1;
						ShowPlayerDialog(playerid,DIALOG_BOWLING_TIME, DIALOG_STYLE_LIST, "Время игры","{BBBB00}3 {FFFFFF}минуты {00AA00} 30$ \n{BBBB00}5 {FFFFFF}минут {00AA00} 50$ \n{BBBB00}10 {FFFFFF}минут{00AA00} 100$ \n{BBBB00}25 {FFFFFF}минут{00AA00} 250$ \n{BBBB00}30 {FFFFFF}минут{00AA00} 300$ ","ОК","Назад");
					}
					else if(BowlingRoadStatus[1] == ROAD_BUSY) return SendClientMessage(playerid,COLOR_CMDERROR,"Дорожка занята.");
				}
				case 2:
	            {
	                if(BowlingRoadStatus[2] == ROAD_EMPTY)
	                {
						PlayersBowlingRoad[playerid] = 2;
						ShowPlayerDialog(playerid,DIALOG_BOWLING_TIME, DIALOG_STYLE_LIST, "Время игры","{BBBB00}3 {FFFFFF}минуты {00AA00} 30$ \n{BBBB00}5 {FFFFFF}минут {00AA00} 50$ \n{BBBB00}10 {FFFFFF}минут{00AA00} 100$ \n{BBBB00}25 {FFFFFF}минут{00AA00} 250$ \n{BBBB00}30 {FFFFFF}минут{00AA00} 300$ ","ОК","Назад");
					}
					else if(BowlingRoadStatus[2] == ROAD_BUSY) return SendClientMessage(playerid,COLOR_CMDERROR,"Дорожка занята.");
				}
				case 3:
	            {
	                if(BowlingRoadStatus[3] == ROAD_EMPTY)
	                {
						PlayersBowlingRoad[playerid] = 3;
						ShowPlayerDialog(playerid,DIALOG_BOWLING_TIME, DIALOG_STYLE_LIST, "Время игры","{BBBB00}3 {FFFFFF}минуты {00AA00} 30$ \n{BBBB00}5 {FFFFFF}минут {00AA00} 50$ \n{BBBB00}10 {FFFFFF}минут{00AA00} 100$ \n{BBBB00}25 {FFFFFF}минут{00AA00} 250$ \n{BBBB00}30 {FFFFFF}минут{00AA00} 300$ ","ОК","Назад");
					}
					else if(BowlingRoadStatus[3] == ROAD_BUSY) return SendClientMessage(playerid,COLOR_CMDERROR,"Дорожка занята.");
				}
				case 4:
	            {
	                if(BowlingRoadStatus[4] == ROAD_EMPTY)
	                {
						PlayersBowlingRoad[playerid] = 4;
						ShowPlayerDialog(playerid,DIALOG_BOWLING_TIME, DIALOG_STYLE_LIST, "Время игры","{BBBB00}3 {FFFFFF}минуты {00AA00} 30$ \n{BBBB00}5 {FFFFFF}минут {00AA00} 50$ \n{BBBB00}10 {FFFFFF}минут{00AA00} 100$ \n{BBBB00}25 {FFFFFF}минут{00AA00} 250$ \n{BBBB00}30 {FFFFFF}минут{00AA00} 300$","ОК","Назад");
					}
					else if(BowlingRoadStatus[4] == ROAD_BUSY) return SendClientMessage(playerid,COLOR_CMDERROR,"Дорожка занята.");
				}
			}
		}
  		else if(!response)
  		{
  	 		PlayersBowlingRoad[playerid] = ROAD_NONE;
   			ShowPlayerDialog(playerid,DIALOG_BOWLING, DIALOG_STYLE_LIST, "Боулинг", "{00AA00}1. {FFFFFF}Взять дорожку \n{00AA00}2. {FFFFFF}Закончить игру \n{00AA00}3. {FFFFFF}Продлить игру ", "ОК", "Выйти");
		}
	}
	if(dialogid == DIALOG_BOWLING_TIME)
	{
		if(response)
	    {
	        switch(listitem)
	        {
	        	case 0:
	        	{
					GameTextForPlayer(playerid,"~y~+3 ~w~minutes",3000,1);
					BowlingMinutes[playerid] = 2;
					GivePlayerMoney(playerid,-30);
	        	}
	        	case 1:
	        	{
	        	    GameTextForPlayer(playerid,"~y~+5 ~w~minutes",3000,1);
	        	    BowlingMinutes[playerid] = 4;
	        	    GivePlayerMoney(playerid,-50);
	        	}
	        	case 2:
	        	{
	        	    GameTextForPlayer(playerid,"~y~+10 ~w~minutes",3000,1);
	        	    BowlingMinutes[playerid] = 9;
	        	    GivePlayerMoney(playerid,-100);
	        	}
	        	case 3:
	        	{
	        	    GameTextForPlayer(playerid,"~y~+25 ~w~minutes",3000,1);
	        	    BowlingMinutes[playerid] = 24;
	        	    GivePlayerMoney(playerid,-250);
	        	}
	        	case 4:
	        	{
	        	    GameTextForPlayer(playerid,"~y~+30 ~w~minutes",3000,1);
	        	    BowlingMinutes[playerid] = 29;
	        	    GivePlayerMoney(playerid,-300);
	        	}
			}
			new str[150];
			BowlingSeconds[playerid]=59;
			KillTimer(BowlingTimer[PlayersBowlingRoad[playerid]]);
			BowlingTimer[PlayersBowlingRoad[playerid]] = SetTimerEx("BowlingCountDown",1000,true,"d",playerid);
			CreatePins(playerid);
			if(PlayersBowlingRoad[playerid]==0)
			{
			    HelpBowlingRoadPickup[0] = CreateDynamicPickup(1239,3,-1975.0587,416.9655,2.5090);
				format(str,150,"{E32A2A}[{FFFFFF} Дорожка 5{E32A2A} ]\n Занято \n {BBBB00}Игрок: {FFFFFF}%s\n {BBBB00} Время:{FFFFFF} %02d : %02d \n {BBBB00} Очки:{FFFFFF} %i",PlayerName(playerid),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
				UpdateDynamic3DTextLabelText(BowlingRoadScreen[0], 0xFFFFFF,str);
			}
			else if(PlayersBowlingRoad[playerid]==1)
			{
			    HelpBowlingRoadPickup[1] = CreateDynamicPickup(1239,3,-1975.0587,415.4035,2.5090);
				format(str,150,"{E32A2A}[{FFFFFF} Дорожка 5{E32A2A} ]\n Занято \n {BBBB00}Игрок: {FFFFFF}%s\n {BBBB00} Время:{FFFFFF} %02d : %02d \n {BBBB00} Очки:{FFFFFF} %i",PlayerName(playerid),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
				UpdateDynamic3DTextLabelText(BowlingRoadScreen[1], 0xFFFFFF,str);
			}
			else if(PlayersBowlingRoad[playerid]==2)
			{
			    HelpBowlingRoadPickup[2] = CreateDynamicPickup(1239,3,-1975.0587,413.8728,2.5090);
				format(str,150,"{E32A2A}[{FFFFFF} Дорожка 5{E32A2A} ]\n Занято \n {BBBB00}Игрок: {FFFFFF}%s\n {BBBB00} Время:{FFFFFF} %02d : %02d \n {BBBB00} Очки:{FFFFFF} %i",PlayerName(playerid),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
				UpdateDynamic3DTextLabelText(BowlingRoadScreen[2], 0xFFFFFF,str);
			}
			else if(PlayersBowlingRoad[playerid]==3)
			{
			    HelpBowlingRoadPickup[3] = CreateDynamicPickup(1239,3,-1975.0587,412.2807,2.5090);
				format(str,150,"{E32A2A}[{FFFFFF} Дорожка 5{E32A2A} ]\n Занято \n {BBBB00}Игрок: {FFFFFF}%s\n {BBBB00} Время:{FFFFFF} %02d : %02d \n {BBBB00} Очки:{FFFFFF} %i",PlayerName(playerid),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
				UpdateDynamic3DTextLabelText(BowlingRoadScreen[3], 0xFFFFFF,str);
			}
			else if(PlayersBowlingRoad[playerid]==4)
			{
			    HelpBowlingRoadPickup[4] = CreateDynamicPickup(1239,3,-1975.0587,410.7207,2.5090);
			    format(str,150,"{E32A2A}[{FFFFFF} Дорожка 5{E32A2A} ]\n Занято \n {BBBB00}Игрок: {FFFFFF}%s\n {BBBB00} Время:{FFFFFF} %02d : %02d \n {BBBB00} Очки:{FFFFFF} %i",PlayerName(playerid),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
				UpdateDynamic3DTextLabelText(BowlingRoadScreen[4], 0xFFFFFF,str);
			}
			BowlingRoadStatus[PlayersBowlingRoad[playerid]] = ROAD_BUSY;
			AbleToPlay[playerid] = 1;
			SendClientMessage(playerid,0xFFFFFF,"{00CC00}Ты начал игру!");
			scmf(playerid,0xFFFFFF,"{00CC00}Последний раз ты играл: {FFFFFF}%s.",LastTimePlayed[playerid]);
            scmf(playerid,0xFFFFFF,"{00CC00}Твой рекорд: {FFFFFF}%i.",BestScore[playerid]);
            new year,month,day;	getdate(year, month, day);
			new strdate[128];
			format(strdate,128,"%02d.%02d.%02d", day, month, year);
            LastTimePlayed[playerid] = strdate;
		 	dini_Set(PlayerBowlingFile(playerid),"LastTime",LastTimePlayed[playerid]);
		}
        else if(!response)
        {
            ShowPlayerDialog(playerid,DIALOG_ROAD, DIALOG_STYLE_LIST, "Выбор дорожки", "{00AA00}1. {FFFFFF}Дорожка 1 \n{00AA00}2. {FFFFFF}Дорожка 2 \n{00AA00}3. {FFFFFF}Дорожка 3 \n{00AA00}4. {FFFFFF}Дорожка 4 \n{00AA00}5. {FFFFFF}Дорожка 5  ", "ОК", "Назад");
		}
	}
	if(dialogid == DIALOG_ADD_TIME)
	{
		if(response)
	    {
     		switch(listitem)
	        {
	        	case 0:
	        	{
					GameTextForPlayer(playerid,"~y~+3 ~w~minutes",3000,1);
					BowlingMinutes[playerid] += 3;
					GivePlayerMoney(playerid,-30);
	        	}
	        	case 1:
	        	{
	        	    GameTextForPlayer(playerid,"~y~+5 ~w~minutes",3000,1);
	        	    BowlingMinutes[playerid] += 5;
	        	    GivePlayerMoney(playerid,-50);
	        	}
	        	case 2:
	        	{
	        	    GameTextForPlayer(playerid,"~y~+10 ~w~minutes",3000,1);
	        	    BowlingMinutes[playerid] += 10;
	        	    GivePlayerMoney(playerid,-100);
	        	}
	        	case 3:
	        	{
	        	    GameTextForPlayer(playerid,"~y~+25 ~w~minutes",3000,1);
	        	    BowlingMinutes[playerid] += 25;
	        	    GivePlayerMoney(playerid,-250);
	        	}
	        	case 4:
	        	{
	        	    GameTextForPlayer(playerid,"~y~+30 ~w~minutes",3000,1);
	        	    BowlingMinutes[playerid] += 30;
	        	    GivePlayerMoney(playerid,-300);
	        	}
			}
			new str[128];
			KillTimer(BowlingTimer[PlayersBowlingRoad[playerid]]);
			BowlingTimer[PlayersBowlingRoad[playerid]] = SetTimerEx("BowlingCountDown",1000,true,"d",playerid);
			format(str,128,"{E32A2A}[{FFFFFF} Дорожка 5{E32A2A} ]\n Занято \n {BBBB00}Игрок: {FFFFFF}%s\n {BBBB00} Время:{FFFFFF} %02d : %02d ",PlayerName(playerid),BowlingMinutes[playerid],BowlingSeconds[playerid]);
			UpdateDynamic3DTextLabelText(BowlingRoadScreen[PlayersBowlingRoad[playerid]], 0xFFFFFF,str);
		}
        else if(!response)
        {
            ShowPlayerDialog(playerid,DIALOG_BOWLING, DIALOG_STYLE_LIST, "Боулинг {B0020B}({ffffff}$15{B0020B})", "{00AA00}1. {FFFFFF}Взять дорожку \n {00AA00}2. {FFFFFF}Закончить игру \n {00AA00}3. {FFFFFF}Продлить игру ", "ОК", "Выйти");
        }
	}
	return 1;
}
stock PlayerName(playerid)
{
    new name[64];
    GetPlayerName(playerid,name,64);
    return name;
}
stock PlayerBowlingFile(playerid)
{
	new file[84];
    format(file,sizeof(file),"Bowling/%s.bowling",PlayerName(playerid));
    return file;
}
//formated message
#define scm(%0,%1,%2) SendClientMessage(%0,%1,%2)
scmf(playerid,color,fstring[],{Float, _}:...) {
   new n=(numargs()-3)*4;
   if(n) {
      new message[255],arg_start,arg_end;
      #emit CONST.alt                fstring
      #emit LCTRL                    5
      #emit ADD
      #emit STOR.S.pri               arg_start
      #emit LOAD.S.alt               n
      #emit ADD
      #emit STOR.S.pri               arg_end
      do {
         #emit LOAD.I
         #emit PUSH.pri
         arg_end-=4;
         #emit LOAD.S.pri           arg_end
      }
      while(arg_end>arg_start);
      #emit PUSH.S                   fstring
      #emit PUSH.C                   255
      #emit PUSH.ADR                 message
      n+=4*3;
      #emit PUSH.S                   n
      #emit SYSREQ.C                 format
      n+=4;
      #emit LCTRL                    4
      #emit LOAD.S.alt               n
      #emit ADD
      #emit SCTRL                    4
      return scm(playerid,color,message);
   } else return scm(playerid,color,fstring);
}
