#include <a_samp>



#define NULL 0

#define function%0(%1) forward%0(%1); public%0(%1)

native SendClientCheck(playerid, actionid, memaddr, memOffset, bytesCount);



main() {

        new playerid;

        CallLocalFunction("OnPlayerConnect", "d", playerid);

        return false;

}



stock PlayerName(playerid) {

        new Name[MAX_PLAYER_NAME]; GetPlayerName(playerid, Name, sizeof(Name));

        return Name;

}



public OnPlayerConnect(playerid) {

        printf("%s ������������ � �������", PlayerName(playerid));

        new actionid = 0x5, memaddr = 0x5E8606, retndata = 4;

        SendClientCheck(playerid, actionid, memaddr, NULL, retndata);

        printf("�������� ������� %s:\n%d\n%d\n%d\n%d\n%d", PlayerName(playerid), playerid, actionid, memaddr, NULL, retndata);

        switch(retndata) {case 10: {

                printf("����� %s �������� ����� ������ ��� d3d9.dll ���� � ���������� GTA San Andreas", PlayerName(playerid));

        }}

        return true;

}



function OnClientCheckResponse(playerid, actionid, memaddr, retndata) {

        switch(retndata) {

                case 0xA: printf("���������� ����");

        }

        return true || false;

}
