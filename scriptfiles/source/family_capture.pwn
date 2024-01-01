ShowFamilyCapture(playerid) {
	for new i; i < 7; i++ do {
		if i < 6 *then
			TextDrawShowForPlayer(playerid, InfoFamilyWar[i]);

		TextDrawShowForPlayer(playerid, FamilyCapture_Back[i]);
	}
}
HideFamilyCapture(playerid) {
	for new i; i < 7; i++ do {
		if i < 6 *then
			TextDrawHideForPlayer(playerid, InfoFamilyWar[i]);

		TextDrawHideForPlayer(playerid, FamilyCapture_Back[i]);
	}
}

ShowFamilyMap(playerid) {

	Int_SetPlayerData(playerid, "familymap", true);

    #include ../library/td/family_capture_map

	for new i = 0; i < 173; i++ do
    {
        if i < FAMILYZONES *then
			PlayerTextDrawBoxColor(playerid, family_capture[playerid][i], FamilyZone[i][zoneOwnerId] == -1 ? 0xFFFFFF80 : FamilyZoneColor[FamilyZone[i][zoneColor]]);

		ShowPlayerTD(playerid, family_capture[playerid][i]);
    }
    return SelectTextDraw(playerid, 0xCD5C5CFF);
}
HideFamilyMap(playerid) {

    for new i; i < 173; i++ do 
		DestroyPlayerTD(playerid, family_capture[playerid][i]);

    CancelSelectTextDraw(playerid);

	DPlayerData(playerid, "familymap");

	return SPD(playerid, 15208, DIALOG_STYLE_LIST, !"����� �� ����������", !"{FFFFFF}����� ����������\n{E65075}����������� �������\n{FFFFFF}������ ���� ������\n���� ����������\n{cccccc}�������� ����������\n��������� ������ �� ������� � 1-�� �����", !"�������", !"�����");

}

ShowMapMenu(playerid, response, listitem) {

	if response *then {

		new zone = Int_GetPlayerData(playerid, "select_famid");

		switch listitem do {
			case 0: 
				SCMF(playerid,COLOR_VALIK,"[����������] {FFFFFF}���������� �%i �������� � ��� �� �����.",zone),
				EnableGPSForPlayer(playerid,FamilyZone[zone][zone_Min_X],FamilyZone[zone][zone_Min_Y],FamilyZone[zone][zone_Max_X]);


			case 1: {

				
				if FamilyZone[zone][zoneOwnerId] == -1 *then
					UpdateFamilyZone(zone, FP_Data[playerid][F_FAMILY_ID]);

				else if FP_Data[playerid][F_FAMILY_ID] == FamilyZone[zone][zoneOwnerId] *then
					SCM(playerid,COLOR_RED,"[������] {ffffff}�� �� ������ �������� ���� �� ����������!");

				else
					return SPD(playerid, 8072, DIALOG_STYLE_INPUT, "{BFBBBA}������� ����� �������", "{ffffff}������� ����� � ������� {ffff00}���:������ {ffffff}(����� ���������)\n\n{cccccc}- ��������� ������� ��� ��������� ��������� ����� � 14:00 �� 21:00);\n- ����� ����� ���������� 3 ���� � ����;\n- �������� 3 ���� � ����;\n- ����� ����� ��������� �������� � ���������� 1 ��� �� ������� � ����� �������;", "�����", "������");	
			}	
		}

	}

	return DPlayerData(playerid,"select_famid");
}

UpdateFamilyZone(zone, famid) {

	FamilyZone[zone][zoneOwnerId] = famid;

	f(mysql_string, 100, "SELECT color FROM family WHERE ID = %d", famid);
	new Cache:result = mysql_query(mysql, mysql_string);

	if cache_get_row_count(mysql) *then
		FamilyZone[zone][zoneColor] = cache_get_row_int(0, 0, mysql);

	cache_delete(result,mysql);

	GangZoneHideForAll(FamilyZone_gang[zone]);
	GangZoneShowForAll(FamilyZone_gang[zone],FamilyZoneColor[FamilyZone[zone][zoneColor]]);

	f(global_str,75,"{CD5C5C}[Family War] ���� ����� ��������� ����� ���������� �%i.",zone);
	SendFamilyMessage(famid, global_str);
}

UpdateFamilyCapture() {
	
	fw_Time--;

	GangZoneFlashForAll(FamilyZone_gang[fw_Zone],FamilyZoneColor[fw_Color]);

	foreach(new i: Player) {
		if FP_Data[i][F_FAMILY_ID] == FamilyZone[fw_Zone][zoneOwnerId] or FP_Data[i][F_FAMILY_ID] == fw_Family *then {
			if !IsTextDrawVisibleForPlayer(i, InfoFamilyWar[0]) *then
				ShowFamilyCapture(i);

			if !fw_Time *then {

				if(TeamDuty{i}) SetPlayerColor(i,TeamColors[GetTeamID(i)]);
				else SetPlayerColor(i,0xFFFFFF80);

				if fw_Kill[0] > fw_Kill[1] && FP_Data[i][F_FAMILY_ID] == fw_Family *then
					AddItem(i,2548,1000+random(1500)), AddItem(i,2207+random(10),2);
					
				else AddItem(i,2548,random(1000)), AddItem(i,2207+random(10),1);
			}

			else if FP_Data[i][F_FAMILY_ID] == FamilyZone[fw_Zone][zoneOwnerId] *then
				SetPlayerColor(i,0x00FF0080);
			
			else if FP_Data[i][F_FAMILY_ID] == fw_Family *then
				SetPlayerColor(i,0xFF000080);

			TextDrawSetString(InfoFamilyWar[2],Convert(fw_Time));	
		}
		else if IsTextDrawVisibleForPlayer(i, InfoFamilyWar[0]) *then
			HideFamilyCapture(i);
	}

	if !fw_Time *then {

		GangZoneStopFlashForAll(FamilyZone_gang[fw_Zone]);

		if fw_Kill[0] > fw_Kill[1] *then	
			UpdateFamilyZone(fw_Zone, fw_Family);

		else {
			GangZoneHideForAll(FamilyZone_gang[fw_Zone]);
			GangZoneShowForAll(FamilyZone_gang[fw_Zone],FamilyZoneColor[FamilyZone[fw_Zone][zoneColor]]);
		}

		for new i; i < 7; i++ do {

			if i < 6 *then
				TextDrawHideForAll(InfoFamilyWar[i]);

			TextDrawHideForAll(FamilyCapture_Back[i]);
		}

	}
}

SaveFamilyZone(zone) {
	f(global_str, 100, "UPDATE `family_zone` SET `ownerid` = '%d', `color` = '%d' WHERE `ID` = '%i'",
	FamilyZone[zone][zoneOwnerId], FamilyZone[zone][zoneColor], zone + 1);
	mysql_query(mysql, global_str, false);
}

CheckZones(playerid) {

	new 
		count = 0,
		page = gpdList(playerid,0);

	global_str = "{FFFF00}� ����������\t{FFFF00}�������� ������\t{FFFF00}������{FFFFFF}";

	for new i; i < FAMILYZONES; i++ do {

		if !(FamilyZone[i][zoneOwnerId] == FP_Data[playerid][F_FAMILY_ID]) *then
			continue;

		count ++;

		if 20 * page < count <= 20 * (page + 1) *then
			f(global_str,sizeof global_str,"%s\n[%i] ���������� �%i\t0 �����\t$0",global_str,count,i);
	}

	if !count *then
		return SPD(playerid,0,DIALOG_STYLE_MSGBOX,"���� ����������","{FFFFFF}����� ���������� �� ����������!",!"����",!"");

	if page+1 < floatround(float(count) / 20, floatround_ceil) *then
		strcat(global_str, "\n"AC_DIALOG_NEXT_PAGE_TEXT"");

	if page *then
		strcat(global_str, "\n"AC_DIALOG_PREVIOUS_PAGE_TEXT"");

	f(mysql_string,25,"{FFFFFF}�������� [%d/%d]", page + 1, floatround(float(count) / 20, floatround_ceil));
	return SPD(playerid, 8071, DIALOG_STYLE_TABLIST_HEADERS, mysql_string, global_str, !"�������", !"�����");
}