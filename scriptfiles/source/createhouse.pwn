cmd:addhousemenu(playerid) {
	if !IsOsnovatel(playerid, 2) *then
		return false;

	return ShowCreateHouse(playerid);	
}

stock ShowCreateHouse(playerid, listitem = -1, bool:show = true, value[] = "", dialogid = 0) {

	new 
		info_house[3],
		Float:float_player[3],
		Float:float_garage[3];

	Int_UnPackMassive(String_GetPlayerData(playerid,"data_int",0), info_house);
	Float_UnPackMassive(String_GetPlayerData(playerid,"data_float",0), float_player);
	Float_UnPackMassive(String_GetPlayerData(playerid,"data_float",1), float_garage);

	if dialogid && strval(value) > 0 *then {
		info_house[dialogid-8065] = strval(value);

		String_SetPlayerData(playerid,"data_int",0,Int_PackMassive(0, info_house));
	}

	switch listitem do 
	{
		case 0, 4: {
			new 
				Float:X, Float:Y, Float:Z;

			GetPlayerPos(playerid, X,Y,Z);

			f(global_str,32,"%f,%f,%f",X,Y,Z);

			switch listitem do {
				case 0: float_player[0] = X, float_player[1] = Y, float_player[2] = Z;
				case 4: float_garage[0] = X, float_garage[1] = Y, float_garage[2] = Z;
			}

			String_SetPlayerData(playerid,"data_float",listitem == 4 ? 1 : 0,global_str);
		}
		case 1: return SPD(playerid,8065,DIALOG_STYLE_INPUT,"Стоимость дома","{ffffff}Введите стоимость для нового дома:","Принять","Назад");
		case 2: return SPD(playerid,8066,DIALOG_STYLE_INPUT,"Класс дома","{ffffff}Введите класс для нового дома:","Принять","Назад");
		case 3: {
			info_house[2] = !info_house[2];
			
			String_SetPlayerData(playerid,"data_int",0,Int_PackMassive(0, info_house));
		}
		case 5: return CrearData_House(playerid), ShowCreateHouse(playerid);
		case 6: {
			for new i; i < 2; i++ do {
				if !info_house[i] || !float_player[i] *then
					return SCM(playerid,COLOR_VALIK,"Заполните все поля!");
			}
			if !(1 <= info_house[1] <= 6) *then 
				return SCM(playerid, COLOR_VALIK, !"Класс дома от 1 до 6");

			else if info_house[2] && !float_garage[0] *then
				return SCM(playerid,COLOR_VALIK,"Вы не указали позицию гаража");

			new ID = OWNABLEHOUSES;

			if ID+1 > MAX_HOUSES *then 
				return SCM(playerid, COLOR_VALIK, !"Нет свободных мест для создания дома");
			
			HouseInfo[ID][hID] = ID;
			HouseInfo[ID][hKlass] = info_house[1];
			HouseInfo[ID][hCost] = info_house[0];
			SetString(HouseInfo[ID][hOwner], "The State");
			HouseInfo[ID][hExit_X] = 267.1;
			HouseInfo[ID][hExit_Y] = 305;
			HouseInfo[ID][hExit_Z] = 999.148;
			HouseInfo[ID][hInt] = 2;
			HouseInfo[ID][hLevel] = 1;
			HouseInfo[ID][hGarage] = info_house[2];
			HouseInfo[ID][hGarage_X] = float_garage[0];
			HouseInfo[ID][hGarage_Y] = float_garage[1];
			HouseInfo[ID][hGarage_Z] = float_garage[2];
			HouseInfo[ID][hEnter_X] = float_player[0];
			HouseInfo[ID][hEnter_Y] = float_player[1];
			HouseInfo[ID][hEnter_Z] = float_player[2];

			for(new i; i < 5; i++) 
				HRoomOwner[ID][i] = "The State";

			//=-=-=-=-=-==-=-=--=-==
			f(global_str, 420, "\
			INSERT INTO `houses`(`ID`, `Enter_X`, `Enter_Y`, `Enter_Z`, `Exit_X`, `Exit_Y`, `Exit_Z`, `Owner`, `Cost` , `Klass`, `Interior`, `Level`, `Garage`, `Garage_X`, `Garage_Y`, `Garage_Z`) \
			VALUES (%d, '%.2f', '%.2f', '%.2f', '%.2f', '%.2f', '%.2f', 'The State', '%d', '%d', '%d', '%d', '%d', '%.2f', '%.2f', '%.2f')", ID \
			, float_player[0], float_player[1], float_player[2], HouseInfo[ID][hExit_X], HouseInfo[ID][hExit_Y], HouseInfo[ID][hExit_Z], HouseInfo[ID][hCost], HouseInfo[ID][hKlass], HouseInfo[ID][hInt], HouseInfo[ID][hLevel] \
			, info_house[2], float_garage[0], float_garage[1], float_garage[2]);
			mysql_tquery(mysql, global_str);
			//=-=-=-=-=-=-==-=-=-=-=
			HouseIcon[ID] = CreateDynamicMapIcon(HouseInfo[ID][hEnter_X], HouseInfo[ID][hEnter_Y], HouseInfo[ID][hEnter_Z], 31, 0);
			House3DText[ID] = CreateDynamic3DTextLabel(" Дом ", 0xE1AE3CFF, HouseInfo[ID][hEnter_X], HouseInfo[ID][hEnter_Y], HouseInfo[ID][hEnter_Z], 10.0);
			UpdateHouse(ID);
			UpdateHouseGarage(ID);
			OWNABLEHOUSES++;

			return CrearData_House(playerid), SCM(playerid,COLOR_VALIK,"Дом успешно создан!");
		}
	}

	if show *then {

		f(global_str,564," \t \n\
		{BE2D2D}[1] {FFFFFF}Установить точку двери\t{CCCCCC}[%f, %f, %f]\n\
		{BE2D2D}[2] {FFFFFF}Стоимость дома\t{42B02C}[$%i]\n\
		{BE2D2D}[3] {FFFFFF}Выбрать класс дома\t{CCCCCC}[%i]\n\
		{BE2D2D}[4] {FFFFFF}Выбрать тип гаража\t{CCCCCC}[%s]\n\
		{BE2D2D}[5] {FFFFFF}Установить точку выезда из гаража\t\t\t{CCCCCC}[%f, %f, %f]\n\
		{CCCCCC}>> Сбросить заполненные данные\n{73B461}>> Создать дом", \
		float_player[0],float_player[1],float_player[2], \
		info_house[0],info_house[1], info_house[2] ? "с гаражом" : "без гаража", \
		float_garage[0],float_garage[1],float_garage[2]);

		return SPD(playerid,8064,DIALOG_STYLE_TABLIST_HEADERS,"Создания дома",global_str,"Выбрать","Отмена");
	}
	return true;
}

stock CrearData_House(playerid) {
	DPlayerData(playerid,"data_int0");

	for new i; i < 2; i++ do
		f(global_str,16,"data_float%i",i), DPlayerData(playerid,global_str);

	return true;	
}