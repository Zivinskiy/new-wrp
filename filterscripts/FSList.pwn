#include <a_samp>
#include <gl_common>

#define COLOR_INTERFACE 0xCCCCCC
new
	massivanim[54][26] =
	{
		  "�������",//0
		  "���� �� ����� 1",//1
		  "���� �� ����� 2",//2
		  "���� �� ����� 3",//3
		  "���� �� ����� 4",//4
		  "������ ���",//5
		  "�������� �����",//6
		  "������ ������",//7
		  "������� ���� ������",//8
		  "�������� � ����� �1",//9
		  "�������� � ����� �2",//10
		  "���� ��� ��������",//11
		  "������������� �1",//12
		  "������������� �2",//13
		  "������������� �3",//14
		  "������������� �4",//15
		  "����� �1",//16
		  "����� �2",//17
		  "����� �3",//18
		  "����� �4",//19
		  "����� �5",//20
		  "������� ���-��",//21
		  "���� ���-�� �� ��",//22
		  "��������� ���������� ����",//23
		  "�������� �����",//24
		  "��������� �� ��������",//25
		  "��������� ��������",//26
		  "������� ���-��",//27
		  "������������ � ���-��",//28
		  "���",//29
		  "������������ ���� �1",//30
		  "������������ ���� �2",//31
		  "������������ ���� �3",//32
		  "�������� ������������",//33
		  "�������� �������",//34
		  "�����",//35
		  "���������",//36
		  "�������� �� �����",//37
		  "������ ���-��",//38
		  "������ ������ �1",//39
		  "������ ������ �2",//40
		  "������ ������ �3",//41
		  "������ ������ �4",//42
		  "������ ������ �5",//43
		  "������ ������ �6",//44
		  "������ ������ �7",//45
		  "������ ������ �8",//46
		  "������ ������ �9",//47
		  "������ ������ �10",//48
		  "������ ������ �11",//49
		  "���� ���������",//50
		  "����� �����",//51
		  "������ � �����",//52
		  "�������"//53
	};
	  
	  
	
	
public OnPlayerCommandText(playerid, cmdtext[])
{
    new cmd[128], idx, tmp[128];
	cmd = strtok(cmdtext, idx);
    if(!strcmp(cmd,"/anim",true))
	{
	    tmp = strtok(cmdtext, idx);
	    if(!strlen(tmp))
		{
		    new string[1024],bufer[64];
			for( new i; i<53; i++ ) {format(bufer,sizeof(bufer),"[%i]%s\n",i,massivanim[i]); strcat(string,bufer);}			
			return ShowPlayerDialog(playerid,1000,2,"��������",string,"�������","�����");
		}
		switch(strval(tmp))
		{
		    case 0: ApplyAnimation(playerid,"BD_FIRE","M_smklean_loop",4.1,0,1,1,1,1);
			case 1: ApplyAnimation(playerid,"BEACH","bather",4.1,0,1,1,1,1);
			case 2: ApplyAnimation(playerid,"BEACH","Lay_Bac_Loop",4.1,0,1,1,1,1);
			case 3: ApplyAnimation(playerid,"BEACH","ParkSit_W_loop",4.1,0,1,1,1,1);
			case 4: ApplyAnimation(playerid,"BEACH","SitnWait_loop_W",4.1,0,1,1,1,1);
		    case 5: ApplyAnimation(playerid,"benchpress","gym_bp_celebrate",4.1,0,1,1,1,1);
		    case 6: ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.1,0,1,1,1,1);
		    case 7: ApplyAnimation(playerid,"CAR","Fixn_Car_Loop",4.1,0,1,1,1,1);
		    case 8: ApplyAnimation(playerid,"COP_AMBIENT","Coplook_in",4.1,0,1,1,1,1);
		    case 9: ApplyAnimation(playerid,"CRACK","Bbalbat_Idle_01",4.1,0,1,1,1,1);
		    case 10: ApplyAnimation(playerid,"CRACK","Bbalbat_Idle_02",4.1,0,1,1,1,1);
		    case 11: ApplyAnimation(playerid,"CRACK","crckdeth2",4.1,0,1,1,1,1);
		    case 12: ApplyAnimation(playerid,"CRACK","crckdeth3",4.1,0,1,1,1,1);
		    case 13: ApplyAnimation(playerid,"CRACK","crckidle1",4.1,0,1,1,1,1);
		    case 14: ApplyAnimation(playerid,"CRACK","crckidle3",4.1,0,1,1,1,1);
		    case 15: ApplyAnimation(playerid,"CRACK","crckdeth1",4.1,0,1,1,1,1);
		    case 16: ApplyAnimation(playerid,"DANCING","dance_loop",4.1,0,1,1,1,1);
		    case 17: ApplyAnimation(playerid,"DANCING","DAN_Left_A",4.1,0,1,1,1,1);
		    case 18: ApplyAnimation(playerid,"DANCING","dnce_M_a",4.1,0,1,1,1,1);
		    case 19: ApplyAnimation(playerid,"DANCING","dnce_M_b",4.1,0,1,1,1,1);
		    case 20: ApplyAnimation(playerid,"DANCING","dnce_M_d",4.1,0,1,1,1,1);
		    case 21: ApplyAnimation(playerid,"DEALER","DEALER_DEAL",4.1,0,1,1,1,1);
		    case 22: ApplyAnimation(playerid,"FOOD","EAT_Vomit_P",4.1,0,1,1,1,1);
		    case 23: ApplyAnimation(playerid,"GANGS","prtial_gngtlkD",4.1,0,1,1,1,1);
		    case 24: ApplyAnimation(playerid,"GANGS","smkcig_prtl",4.1,0,1,1,1,1);
		    case 25: ApplyAnimation(playerid,"GANGS","DEALER_IDLE",4.1,0,1,1,1,1);
		    case 26: ApplyAnimation(playerid,"GANGS","drnkbr_prtl_F",4.1,0,1,1,1,1);
		    case 27: ApplyAnimation(playerid,"GANGS","DEALER_DEAL",4.1,0,1,1,1,1);
		    case 28: ApplyAnimation(playerid,"GANGS","hndshkfa",4.1,0,1,1,1,1);
		    case 29: ApplyAnimation(playerid,"GANGS","Invite_No",4.1,0,1,1,1,1);
		    case 30: ApplyAnimation(playerid,"GHANDS","gsign1",4.1,0,1,1,1,1);
		    case 31: ApplyAnimation(playerid,"GHANDS","gsign1LH",4.1,0,1,1,1,1);
		    case 32: ApplyAnimation(playerid,"GHANDS","gsign3",4.1,0,1,1,1,1);
		    case 33: ApplyAnimation(playerid,"GHANDS","gsign4",4.1,0,1,1,1,1);
		    case 34: ApplyAnimation(playerid,"GRAFFITI","spraycan_fire",4.1,0,1,1,1,1);
		    case 35: ApplyAnimation(playerid,"GRAVEYARD","mrnF_loop",4.1,0,1,1,1,1);
		    case 36: ApplyAnimation(playerid,"MISC","plyr_shkhead",4.1,0,1,1,1,1);
		    case 37: SendClientMessage(playerid,0xCCCCCCFF,"�������� ����������");
		    case 38: ApplyAnimation(playerid,"VENDING","VEND_Drink_P",4.1,0,1,1,1,1);
		    case 39: ApplyAnimation(playerid,"OTB","betslp_in",4.1,0,1,1,1,1);
			case 40: ApplyAnimation(playerid,"OTB","betslp_lkabt",4.1,0,1,1,1,1);
			case 41: ApplyAnimation(playerid,"OTB","betslp_loop",4.1,0,1,1,1,1);
			case 42: ApplyAnimation(playerid,"OTB","betslp_out",4.1,0,1,1,1,1);
			case 43: ApplyAnimation(playerid,"OTB","betslp_tnk",4.1,0,1,1,1,1);
			case 44: ApplyAnimation(playerid,"OTB","wtchrace_cmon",4.1,0,1,1,1,1);
			case 45: ApplyAnimation(playerid,"OTB","wtchrace_in",4.1,0,1,1,1,1);
			case 46: ApplyAnimation(playerid,"OTB","wtchrace_loop",4.1,0,1,1,1,1);
			case 47: ApplyAnimation(playerid,"OTB","wtchrace_lose",4.1,0,1,1,1,1);
			case 48: ApplyAnimation(playerid,"OTB","wtchrace_out",4.1,0,1,1,1,1);
			case 49: ApplyAnimation(playerid,"OTB","wtchrace_win",4.1,0,1,1,1,1);
			case 50: ApplyAnimation(playerid,"SMOKING","M_smk_in",4.1,0,1,1,1,1);
			case 51: ApplyAnimation(playerid,"SHOP","ROB_Shifty",4.1,0,1,1,1,1);
			case 52: ApplyAnimation(playerid,"SMOKING","M_smklean_loop",4.1,0,1,1,1,1);
			case 53: ApplyAnimation(playerid,"RIOT","RIOT_shout",4.1,0,1,1,1,1);
			default: return SendClientMessage(playerid,COLOR_INTERFACE,"�������� ID ������ ��������. ���������: 1-53");
		}
		return 1;
	}
	return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if( dialogid == 1000 )
	{
	    new string[64];
	    format(string,sizeof(string),"/anim %d",listitem);
		SendClientMessage(playerid,0xFFFFFFFF,string);
	    OnPlayerCommandText(playerid, string);
	    return 1;
	}
	return 1;
}
