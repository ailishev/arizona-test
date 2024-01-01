new PlayerText:battle_td[MAX_PLAYERS][26];

LoadNewGangZone(time) {
    
    for new i = 0; i < 9; i++ do {

        if i < 6 *then
            BattleKills[i] = 0;

        NewGangZone[i] = GangZoneCreate(InfoGang[i][0], InfoGang[i][1], InfoGang[i][2], InfoGang[i][3]);
        GangZoneShowForAll(NewGangZone[i], i == 4 ? 0xB22222FF : 0x000000FF);
    }

    NewCaptureTimer = time*60; // 7200 = 2 часа

    return SCMALL(COLOR_OLDRED,"[Битва за притон] Внимание! Началась битва за притон! Отправляйтесь на территорию притона.");
}

TickNewGangZone() {

    NewCaptureTimer--;

    foreach(new i: Player) {

        if !IsPlayerLogged{i} *then
            continue;

        if GetPlayerTeamInBattle(GetTeamID(i)) *then {

            if !ItsOpenBattleDraw(i) *then
                ShowBattleDraw(i);

            f(global_str,31,"BATTLE_FOR_DRUGDEN~n~%s",Convert(NewCaptureTimer));
            PlayerTextDrawSetString(i,battle_td[i][12],global_str);

            for new x; x < 6; x++ do 
                f(global_str,11,"%i",BattleKills[x]),
                PlayerTextDrawSetString(i,battle_td[i][x],global_str);

        }
        else if ItsOpenBattleDraw(i) *then
            HideBattleDraw(i);
    }

    GangZoneFlashForAll(NewGangZone[4], 0xFFFFFF80);

    if !NewCaptureTimer *then {

        GangZoneStopFlashForAll(NewGangZone[4]);

		for new i = 0; i < 9; i++ do 
       		GangZoneDestroy(NewGangZone[i]);	

        new 
            winner = WinnerTeam(), 
            itemid, amount;

        f(global_str,150,"[Битва за притон] Банда %s победила в сражении и её члены получают:",OrgInfo[winner][oName]);
        SCMALL(COLOR_OLDRED,global_str);

        foreach(new i: Player) {

            HideBattleDraw(i);

            if GetTeamID(i) == winner *then {

                switch random(2) do {
                    case 0: itemid = random(2554), amount = 1;
                    case 1: itemid = 1461, amount = random(15000);
                }

                AddItem(i,itemid,amount);

                f(global_str,150,"[Битва за притон] {FFFFFF}%s получает приз: {BE2D2D}%s (%i шт)",PN(i), ItemsInfo[itemid][ItemName2], amount);
                SCMALL(COLOR_VALIK,global_str);
            }
        
        }
    }
 
}

ShowBattleDraw(playerid) {

    if InventoryOpen{playerid} *then
        return false;

    #include <textdraws/battle>

	for new i; i < 26; i++ do
		ShowPlayerTD(playerid, battle_td[playerid][i]);

    return 1;  
}

HideBattleDraw(playerid) {
    for new i; i < 26; i++ do 
        DestroyPlayerTD(playerid, battle_td[playerid][i]);
}

ItsOpenBattleDraw(playerid) {

    if IsPlayerTextDrawVisible(playerid, battle_td[playerid][0]) *then
        return 1;

    return 0;    
}

GetPlayerTeamInBattle(team) {
    switch team do {
        case 11..15: return team-10;
        case 25: return 6;
    }
    return 0;
}

WinnerTeam() {
    new win = 0;

    for new i; i < 6; i++ do
        if BattleKills[i] > win *then win = i;

    switch win do {
        case 0..4: win = win+11;
        case 5: win = 25;
    }
    return win;
}

cmd:startgangwar(playerid, data[]) {

	extract data -> new time; else
	    return SCM(playerid, COLOR_OLDRED, !"Используйте: /startgangwar [время в минутах]");

    if time < 1 *then
        return false;

    return LoadNewGangZone(time);
}