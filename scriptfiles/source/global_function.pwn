public: @DeleteFamily(playerid, famid) {
    
    if !cache_get_row_count(mysql) *then
        return SCM(playerid, COLOR_RED, "[Ошибка] {FFFFFF}Семья не найдена в базе данных!");

    foreach(Player, i) {
        if !(FP_Data[i][F_FAMILY_ID] == -1) && famid == FP_Data[i][F_FAMILY_ID] *then
        {
            SCM(playerid, COLOR_OLDRED, !"[Информация]{FFFFFF} Семья в которой вы состояли, была расформирована!");
            UpdatePlayerDataInt(i, "Family", FP_Data[i][F_FAMILY_ID] = -1);
            if FamilyText[i] *then
                DestroyDynamic3DTextLabel(FamilyText[i]),
                FamilyText[i] = Text3D:false;
        }
    }

    cache_get_row(0, 0, SQL_GET_ROW_STR[0], mysql, 32);

    SQL("DELETE FROM family WHERE ID = %i", famid);

    SAMF(COLOR_OLDRED, "Администратор %s[%i] удалил семью %s[FamID: %i].", PN(playerid), playerid, SQL_GET_ROW_STR[0], famid);

    return amlf("Администратор <a href=../data/account.php?id=%i>%s</a> удалил семью %s[FamID: %i].", PI[playerid][pID], PN(playerid), SQL_GET_ROW_STR[0], famid);
}
stock GetPlayerLauncherName(playerid) {
	static version[18];
	switch GetPlayerLauncher(playerid) do {
		case 1: version = "Лаунчер";
		case 2: version = "Мобильный лаунчер";
		default: version = "Без лаунчера";
	}
	return version;
}
public void:OnPlayerKeyUp(player, key) {}
public void:OnPlayerKeyDown(player, key) {
    switch key do {
        case 73: OnPlayerKeyStateChange(player,KEY_YES,0);
        case 75: callcmd::key(player);
        case 76: callcmd::lock(player);
        case 80: callcmd::phone(player);
        case 85: callcmd::anims(player,"");
    }
}

LoadCountItems() {
    new Cache:result = mysql_query(mysql, "SELECT Item, ItemKolvo, Aks FROM accounts");

	for new i = 0, inv[2][108], aks[8]; i < cache_get_row_count(mysql); i++ do {

        cache_get_row(i, 0, global_str, mysql), Int_UnPackMassive(global_str, inv[0]),
        cache_get_row(i, 1, global_str, mysql), Int_UnPackMassive(global_str, inv[1]);
        cache_get_row(i, 2, global_str, mysql), Int_UnPackMassive(global_str, aks);

        for new x = 0; x < 108; x++ do {

            if x < 8 *then
                CountItems[aks[x]] ++;

            CountItems[inv[0][x]] += inv[1][x];
        }
    }

    return cache_delete(result, mysql);
}