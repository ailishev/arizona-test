stock ShowFamilyMembers(playerid, list = 0)
{
	format(mysql_string, 256, "SELECT `NickName`, `FamilyRang`, `Online_status`, `LastLogin` FROM `accounts` WHERE `Family` = %i ORDER BY `Online_status` DESC LIMIT %d, %d", FP_Data[playerid][F_FAMILY_ID], 15*list, 15*(list + 1));
	mysql_tquery(mysql, mysql_string, "@ShowFamilyMembers", "dd", playerid, list);

	return true;
}

public: @ShowFamilyMembers(playerid, list)
{
	FirstBL[playerid] = list;

	new countS = cache_get_row_count(mysql);

	global_str = "{FFFFFF}Игрок\t{FFFFFF}Ранг\t{FFFFFF}Последний вход\n";

	for new i; i < countS; i++ do
		cache_get_row(i, 0, SQL_GET_ROW_STR[0], mysql, 24),
		cache_get_row(i, 3, SQL_GET_ROW_STR[1], mysql, 10),
		format(global_str, 2048, "%s%s\t%i ранг\t%s\n", global_str, SQL_GET_ROW_STR[0], cache_get_row_int(i, 1, mysql), cache_get_row_int(i, 2, mysql) == 1001 ? "{7ADC66}online":SQL_GET_ROW_STR[1]);

	if countS == 15 && list *then strcat(global_str, ">>> Следующая страница\n<<< Предыдущая страница");
	else if countS == 15 *then strcat(global_str, ">>> Следующая страница");

	return SPD(playerid, 8073, DIALOG_STYLE_TABLIST_HEADERS, !"Список членов семьи", global_str, !"Выбрать", !"Назад");
}