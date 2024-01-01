stock Open_PaintingAcs(playerid) {
	
	if Int_GetPlayerData(playerid,"painting_acs") *then 
		return false;

	if InventoryOpen{playerid} *then 
		HideInvent(playerid);

	Int_SetPlayerData(playerid,"painting_acs", true);

	#include <textdraws/cataloges/painting_acs>
	for new i; i < 29; i++ do ShowPlayerTD(playerid, ChangeColor_PTD[playerid][i]);
	
	ShowInventoryPage(playerid, 485.299988 - 5.799865 * InventorySize[playerid][0], 138.642853, E_INVENTORY_TYPE_COLOR);

	return SelectTextDraw(playerid, PI[playerid][pSelectTD]);
}

stock ChangeColor_PaintingAcs(playerid, slot) {

	if Int_GetPlayerData(playerid,"painting_acs") == 2 *then
		return false;

	new color = Int_GetPlayerData(playerid,"ChangeColor_PaintingAcs");

	if color > 0 && color == slot+1 *then
		return DPlayerData(playerid,"ChangeColor_PaintingAcs"), DestroyPlayerTD(playerid, ChangeColor_PTD[playerid][29]);

	if IsPlayerTextDrawVisible(playerid, ChangeColor_PTD[playerid][29]) *then
		DestroyPlayerTD(playerid, ChangeColor_PTD[playerid][29]);
	

	Int_SetPlayerData(playerid,"ChangeColor_PaintingAcs",slot+1);

    new AksColor[20] = { -1, -870045953, -864541441,-423878913,-707314433,1020739839,1020778495,1010751487,-683879169};

	ChangeColor_PTD[playerid][29] = CreatePlayerTextDraw(playerid, 217.9998, 180.7183, "LD_SPAC:white"); // ИКОНКА ЦВЕТА
	PlayerTextDrawLetterSize(playerid, ChangeColor_PTD[playerid][29], 0.4799, 1.1200);
	PlayerTextDrawTextSize(playerid, ChangeColor_PTD[playerid][29], 6.0000, 7.0000);
	PlayerTextDrawAlignment(playerid, ChangeColor_PTD[playerid][29], 1);
	PlayerTextDrawColor(playerid, ChangeColor_PTD[playerid][29], AksColor[slot]);
	PlayerTextDrawBackgroundColor(playerid, ChangeColor_PTD[playerid][29], 255);
	PlayerTextDrawFont(playerid, ChangeColor_PTD[playerid][29], 4);
	PlayerTextDrawSetProportional(playerid, ChangeColor_PTD[playerid][29], 0);
	PlayerTextDrawSetShadow(playerid, ChangeColor_PTD[playerid][29], 0);
	PlayerTextDrawShow(playerid, ChangeColor_PTD[playerid][29]);

	return true;

}

stock ChangeItem_PaintingAcs(playerid,slot) {

	if Int_GetPlayerData(playerid,"painting_acs") == 2 *then
		return false;

	new item = Inventory[playerid][0][slot];

	switch item do {

		case 331: {
			if ItemChangeColor[playerid][2][1] *then 
				SetDontClickSlot(playerid,ItemChangeColor[playerid][2][0],false), InvSlotUpdate(playerid, GetInvID(playerid, ItemChangeColor[playerid][2][0], 1), ItemChangeColor[playerid][2][0]);
			
			ItemChangeColor[playerid][2][0] = slot;
			ItemChangeColor[playerid][2][1] = Inventory[playerid][1][slot];

			SetDontClickSlot(playerid,ItemChangeColor[playerid][2][0]), InvSlotUpdate(playerid, GetInvID(playerid, ItemChangeColor[playerid][2][0], 1), ItemChangeColor[playerid][2][0]);

			f(global_str,11,"%d/7", ItemChangeColor[playerid][2][1]);
			PlayerTextDrawSetString(playerid, ChangeColor_PTD[playerid][25], global_str);
			PlayerTextDrawColor(playerid, ChangeColor_PTD[playerid][24], ItemChangeColor[playerid][2][1] >= 7 ? -1 : -1717986817);
			PlayerTextDrawSetSelectable(playerid, ChangeColor_PTD[playerid][24], ItemChangeColor[playerid][2][1] >= 7 ? 1 : 0);
			PlayerTextDrawShow(playerid, ChangeColor_PTD[playerid][24]);
		}

		case 1130: {
			if ItemChangeColor[playerid][1][1] *then 
				SetDontClickSlot(playerid,ItemChangeColor[playerid][1][0],false), InvSlotUpdate(playerid, GetInvID(playerid, ItemChangeColor[playerid][1][0], 1), ItemChangeColor[playerid][1][0]);
			
			ItemChangeColor[playerid][1][0] = slot;
			ItemChangeColor[playerid][1][1] = Inventory[playerid][1][slot];

			SetDontClickSlot(playerid,ItemChangeColor[playerid][1][0]), InvSlotUpdate(playerid, GetInvID(playerid, ItemChangeColor[playerid][1][0], 1), ItemChangeColor[playerid][1][0]);

			f(global_str,11,"%d/1", ItemChangeColor[playerid][1][1]);
			PlayerTextDrawSetString(playerid, ChangeColor_PTD[playerid][28], global_str);
			PlayerTextDrawColor(playerid, ChangeColor_PTD[playerid][27], ItemChangeColor[playerid][1][1] ? -1 : -1717986817);
			PlayerTextDrawSetSelectable(playerid, ChangeColor_PTD[playerid][27], ItemChangeColor[playerid][1][1] ? 1 : 0);
			PlayerTextDrawShow(playerid, ChangeColor_PTD[playerid][27]);
		}

		default: {
			if ItemChangeColor[playerid][0][1] *then 
				SetDontClickSlot(playerid,ItemChangeColor[playerid][0][0],false), InvSlotUpdate(playerid, GetInvID(playerid, ItemChangeColor[playerid][0][0], 1), ItemChangeColor[playerid][0][0]);
			
			ItemChangeColor[playerid][0][0] = slot;
			ItemChangeColor[playerid][0][1] = 1;

			SetDontClickSlot(playerid,slot), InvSlotUpdate(playerid, GetInvID(playerid, slot, 1), slot);


			PlayerTextDrawSetSelectable(playerid, ChangeColor_PTD[playerid][26], ItemChangeColor[playerid][0][1] ? 1 : 0);
			PlayerTextDrawSetPreviewModel(playerid, ChangeColor_PTD[playerid][26], ItemsInfo[item][ItemModel]);
			PlayerTextDrawSetPreviewRot(playerid, ChangeColor_PTD[playerid][26], ItemsInfo[item][POSTDx], ItemsInfo[item][POSTDy], ItemsInfo[item][POSTDz], ItemsInfo[item][POSTDc]);
			PlayerTextDrawShow(playerid, ChangeColor_PTD[playerid][26]);

		}
	}
	return CheckInfo_PaintingAcs(playerid);
}


stock ResetItem_PaintingAcs(playerid, type) {

	if Int_GetPlayerData(playerid,"painting_acs") == 2 *then
		return false;

	switch type do {
		case 3: {
			SetDontClickSlot(playerid,ItemChangeColor[playerid][2][0],false), InvSlotUpdate(playerid, GetInvID(playerid, ItemChangeColor[playerid][2][0], 1), ItemChangeColor[playerid][2][0]);
		
			ItemChangeColor[playerid][2][0] =
			ItemChangeColor[playerid][2][1] = 0;

			PlayerTextDrawSetString(playerid, ChangeColor_PTD[playerid][25], "0/7");
			PlayerTextDrawColor(playerid, ChangeColor_PTD[playerid][24], -1717986817);
			PlayerTextDrawSetSelectable(playerid, ChangeColor_PTD[playerid][24], 0);
			PlayerTextDrawShow(playerid, ChangeColor_PTD[playerid][24]);
		}
		case 2: {
			SetDontClickSlot(playerid,ItemChangeColor[playerid][1][0],false), InvSlotUpdate(playerid, GetInvID(playerid, ItemChangeColor[playerid][1][0], 1), ItemChangeColor[playerid][1][0]);
		
			ItemChangeColor[playerid][1][0] =
			ItemChangeColor[playerid][1][1] = 0;

			PlayerTextDrawSetString(playerid, ChangeColor_PTD[playerid][28], "0/1");
			PlayerTextDrawColor(playerid, ChangeColor_PTD[playerid][27], -1717986817);
			PlayerTextDrawSetSelectable(playerid, ChangeColor_PTD[playerid][27], 0);
			PlayerTextDrawShow(playerid, ChangeColor_PTD[playerid][27]);
		}
		case 1: {
			SetDontClickSlot(playerid,ItemChangeColor[playerid][0][0],false), InvSlotUpdate(playerid, GetInvID(playerid, ItemChangeColor[playerid][0][0], 1), ItemChangeColor[playerid][0][0]);
		
			ItemChangeColor[playerid][0][0] =
			ItemChangeColor[playerid][0][1] = 0;

			PlayerTextDrawSetSelectable(playerid, ChangeColor_PTD[playerid][26], 0);
			PlayerTextDrawSetPreviewModel(playerid, ChangeColor_PTD[playerid][26], 1649);
			PlayerTextDrawSetPreviewRot(playerid, ChangeColor_PTD[playerid][26], 0.0000, 0.0000, 90.0000, 0.6036);
			PlayerTextDrawShow(playerid, ChangeColor_PTD[playerid][26]);
		}
	}
	return CheckInfo_PaintingAcs(playerid);
}

stock CheckInfo_PaintingAcs(playerid) {

    if ItemChangeColor[playerid][0][1] && ItemChangeColor[playerid][1][1] && ItemChangeColor[playerid][2][1] >= 7 *then {
		if !IsPlayerTextDrawVisible(playerid, ChangeColor_PTD[playerid][30]) *then {
			#include <textdraws/cataloges/info_acs>

			f(global_str,16,"$%i",BizData[BizEntered[playerid]][bItem][2]);
			PlayerTextDrawSetString(playerid, ChangeColor_PTD[playerid][32], global_str);


			f(global_str,24,"%s:%i.0",!PI[playerid][pLanguage] ? "CHANCE" : FixText("ШАНС"), PI[playerid][pVIP] >= 7 ? 10 : 5);
			PlayerTextDrawSetString(playerid, ChangeColor_PTD[playerid][35], global_str);


			for new i = 30; i < 36; i++ do PlayerTextDrawShow(playerid, ChangeColor_PTD[playerid][i]);
			PlayerTextDrawSetSelectable(playerid, ChangeColor_PTD[playerid][13], 1);
		}
    }
	else {
		if IsPlayerTextDrawVisible(playerid, ChangeColor_PTD[playerid][30]) *then {
			for new i = 30; i < 36; i++ do DestroyPlayerTD(playerid, ChangeColor_PTD[playerid][i]);
			PlayerTextDrawSetSelectable(playerid, ChangeColor_PTD[playerid][13], 0);
		}
	}

	return PlayerTextDrawShow(playerid, ChangeColor_PTD[playerid][13]);
}

stock Buy_PaintingAcs(playerid) {

	if PI[playerid][pMoney] < BizData[BizEntered[playerid]][bItem][2] *then	
		return SendDonateLink(playerid);

	Int_SetPlayerData(playerid,"painting_acs", 2);

	PlayerTextDrawSetSelectable(playerid, ChangeColor_PTD[playerid][13], 0);
	PlayerTextDrawShow(playerid, ChangeColor_PTD[playerid][13]);
	
	switch random(3) do
	{
		case 0: ApplyAnimationEx(playerid, !"SCRATCHING", !"SCMID_L", 4.1, 1, 1, 1, 1, 0, 1);
		case 1: ApplyAnimationEx(playerid, !"BSKTBALL", !"BBALL_REACT_MISS", 4.1, 1, 1, 1, 1, 0, 1);
		case 2: ApplyAnimationEx(playerid, !"CASINO", !"DEALONE", 4.1, 1, 1, 1, 1, 0, 1);
	}
	return CallTimeOutFunction("@Craft_PaintingAcs",5000+random(5000),false,"d",playerid);
}


public: @Craft_PaintingAcs(playerid) {

	new chance = 5;

	if PI[playerid][pVIP] >= 7 *then
		chance = chance*2;

	if random(100) <= chance *then {
		
		Inventory[playerid][4][ItemChangeColor[playerid][0][0]] = Int_GetPlayerData(playerid,"ChangeColor_PaintingAcs");

		GameTextForPlayer(playerid, "~g~Successfully", 1000, 1);

		SCMF(playerid,COLOR_VALIK,"[Информация] {ffffff}Вы успешно перекрасили аксессуар '%s'.",ItemsInfo[Inventory[playerid][0][ItemChangeColor[playerid][0][0]]][ItemName2]);
	}
	else 
		GameTextForPlayer(playerid, "~r~Failing", 1000, 1), SCM(playerid,COLOR_VALIK,"[Информация] {ffffff}К сожалению вам не удалось перекрасить аксессуар.");

	ClearAnimationsEx(playerid);

	Int_SetPlayerData(playerid,"painting_acs", false);

	Inventory[playerid][1][ItemChangeColor[playerid][1][0]] -= 1;
	Inventory[playerid][1][ItemChangeColor[playerid][2][0]] -= 7;

	GiveMoney(playerid, -BizData[BizEntered[playerid]][bItem][2]);

	GiveBizMoney(BizEntered[playerid], BizData[BizEntered[playerid]][bItem][2]);

	return Close_PaintingAcs(playerid);

}

stock Close_PaintingAcs(playerid) {

	if Int_GetPlayerData(playerid,"painting_acs") == 2 *then
		return SelectTextDraw(playerid, PI[playerid][pSelectTD]);

	for new i; i < 36; i++ do {

		if i < 3 *then {
			if ItemChangeColor[playerid][i][1] *then	
				SetDontClickSlot(playerid,ItemChangeColor[playerid][i][0],false);

			ItemChangeColor[playerid][i][0] =
			ItemChangeColor[playerid][i][1] = 0;
		}

		if i >= 30 && !IsPlayerTextDrawVisible(playerid, ChangeColor_PTD[playerid][i]) *then
			continue;

		DestroyPlayerTD(playerid, ChangeColor_PTD[playerid][i]);
	}

	DPlayerData(playerid,"painting_acs"),
	DPlayerData(playerid,"ChangeColor_PaintingAcs");
	
	CancelSelectTextDraw(playerid);

	return HideInvent(playerid);

}