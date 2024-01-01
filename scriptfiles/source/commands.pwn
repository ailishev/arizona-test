cmd:fakesms(playerid, data[]) {

    if sscanf(data, "ds[124]", data[0], data[1]) *then
		return SCM(playerid, COLOR_OLDRED, !"���������: /fakesms [id] [text]");

	if !IsPlayerConnected(data[0]) *then
		return 0;

	SCM(data[0],COLOR_RED,data[1]);

    f(global_str, 200, "������������� %s[%d] ������� ������ %s[%d]: %s", PN(playerid), playerid, PN(data[0]), data[0], data[1]);
    SendAdminsMessage(COLOR_GREY, global_str);

	return amlf("������������� <a href=../data/account.php?id=%d>%s</a> ������� SMS ������ <a href=../data/account.php?id=%d>%s</a>: %s.", PI[playerid][pID], PN(playerid), PI[data[0]][pID], PN(data[0]), data[1]);
}
cmd:sethouseowner(playerid, data[]) {

    if sscanf(data, "ds[24]", data[0], data[1]) *then
		return SCM(playerid, COLOR_OLDRED, !"���������: /sethouseowner [houseid] [nickname]");

	if data[0] > OWNABLEHOUSES *then
		return false;

	SetString(HouseInfo[data[0]][hOwner], data[1]);
	UpdateHouse(data[0]);

    f(global_str, 100, "������������� %s[%d] ������ ������ %s ���������� ���� �%i.", PN(playerid), playerid, data[1], data[0]);
    SendAdminsMessage(COLOR_GREY, global_str);

	return amlf("������������� <a href=../data/account.php?id=%d>%s</a> ������ ������ <a href=../data/account.php?name=%s>%s</a> ���������� ���� �%i", PI[playerid][pID], PN(playerid), data[1], data[1], data[0]);
}
cmd:setbizowner(playerid, data[]) {

    if sscanf(data, "ds[24]", data[0], data[1]) *then
		return SCM(playerid, COLOR_OLDRED, !"���������: /setbizowner [bizid] [nickname]");

	if data[0] > OWNABLEBIZES *then
		return false;

	SetString(BizData[data[0]][bOwner], data[1]);
	UpdateBusinessText(data[0]);

    f(global_str, 100, "������������� %s[%d] ������ ������ %s ���������� ������� �%i.", PN(playerid), playerid, data[1], data[0]);
    SendAdminsMessage(COLOR_GREY, global_str);

	return amlf("������������� <a href=../data/account.php?id=%d>%s</a> ������ ������ <a href=../data/account.php?name=%s>%s</a> ���������� ������� �%i", PI[playerid][pID], PN(playerid), data[1], data[1], data[0]);
}
cmd:findfamzone(playerid, data[]) {
	extract data -> new zone; else
	    return SCM(playerid, COLOR_OLDRED, !"�����������: /findfamzone [���������� 0 - 155]");

	if zone < 0 or zone > 155 *then
		return SCM(playerid, COLOR_OLDRED, !"�����������: /findfamzone [���������� 0 - 155]");

	EnableGPSForPlayer(playerid,FamilyZone[zone][zone_Min_X],FamilyZone[zone][zone_Min_Y],FamilyZone[zone][zone_Max_X]);
	return SCMF(playerid,COLOR_VALIK,"[����������] {FFFFFF}���������� �%i �������� � ��� �� �����.",zone);
}
cmd:recon_update(playerid, data[])
	return false;

cmd:cl(playerid, data[]) {
	extract data -> new id; else
	    return SCM(playerid, COLOR_OLDRED, !"�����������: /cl [id]");

	if !IsPlayerConnected(id) *then
		return false;

	return SCMF(playerid, -1, "����� %s[%i] ��������� � %s!", PN(id), id, GetPlayerLauncher(id) ? "{4EFF2B}PC Launcher'a � � ���� ���� voice": "{FF2B2B}�������������� ������� - ��� voice");
}