enum PR_JoinData
{
	PR_iVersion,
	PR_byteMod,
	PR_byteNicknameLen,
	PR_NickName[24],
	PR_uiClientChallengeResponse,
	PR_byteAuthKeyLen,
	PR_auth_key[50],
	PR_iClientVerLen,
	PR_ClientVersion[30]
};

stock BS_ReadJoinServer(BitStream:bs, data[PR_JoinData])
{
    BS_ReadValue(
        bs,
        PR_INT32, data[PR_iVersion],
		PR_UINT8, data[PR_byteMod],
		PR_UINT8, data[PR_byteNicknameLen],
		PR_STRING, data[PR_NickName], data[PR_byteNicknameLen],
		PR_UINT32, data[PR_uiClientChallengeResponse],
		PR_UINT8, data[PR_byteAuthKeyLen],
		PR_STRING, data[PR_auth_key], data[PR_byteAuthKeyLen],
		PR_UINT8, data[PR_iClientVerLen]
	);

	BS_ReadValue(
		bs,
		PR_STRING, data[PR_ClientVersion], (data[PR_iClientVerLen] >= 30 ? 30:data[PR_iClientVerLen]) 
	);
}

stock CheckPlayerLogged(playerid, Name[])
{
	foreach(Player, i)
	{
		if playerid == i *then 
			continue; 

		if !strcmp(PlayerName[i], Name, true) *then
		{
			if IsPlayerLogged{i} *then
			{	
				return false;
			}

			return true;
		}
	}

	return 2;
}

const PLAYER_SERVER_JOIN = 25;

IRPC:PLAYER_SERVER_JOIN(playerid, BitStream:bs)
{
	new JoinData[PR_JoinData];
	BS_ReadJoinServer(bs, JoinData);
	
	SetString(PlayerName[playerid], JoinData[PR_NickName]);

	if GetString(JoinData[PR_ClientVersion], "Arizona PC") *then
		LauncherState[playerid] = 1;

	else if GetString(JoinData[PR_ClientVersion], "arizona-mobile") *then
		LauncherState[playerid] = 2;

	else LauncherState[playerid] = 0;

	SetLauncherStatus(playerid, ( GetString(JoinData[PR_ClientVersion], "Arizona PC") or GetString(JoinData[PR_ClientVersion], "arizona-mobile") ) ? true:false);

	return true;
}


stock ExecuteEvent(playerid, const event[])
{
	
	new BitStream:bs = BS_New();
	BS_WriteValue(bs, PR_UINT8, 220);
	BS_WriteValue(bs, PR_UINT8, 17);
	BS_WriteValue(bs, PR_UINT32, 1);
	BS_WriteValue(bs, PR_UINT32, strlen(event));
	BS_WriteValue(bs, PR_STRING, event, strlen(event));
	BS_WriteValue(bs, PR_UINT8, 255);
	BS_WriteValue(bs, PR_UINT8, 255);
	BS_WriteValue(bs, PR_UINT8, 255);
	BS_WriteValue(bs, PR_UINT8, 255);
	return PR_SendPacket(bs, playerid);
}
stock CreateBrowser(playerid, browserid, const url[])
{
	new BitStream:cefInitiliaze = BS_New();

	BS_WriteValue(cefInitiliaze, PR_UINT8, 220);
	BS_WriteValue(cefInitiliaze, PR_UINT8, 10);

	BS_WriteValue(cefInitiliaze, PR_UINT8, playerCefResultion_Window[playerid][0]);
	BS_WriteValue(cefInitiliaze, PR_UINT8, playerCefResultion_Window[playerid][1]);

	BS_WriteValue(cefInitiliaze, PR_UINT8, 0);
	BS_WriteValue(cefInitiliaze, PR_UINT8, 0);

	BS_WriteValue(cefInitiliaze, PR_UINT8, playerCefResultion_Window[playerid][2]);
	BS_WriteValue(cefInitiliaze, PR_UINT8, playerCefResultion_Window[playerid][3]);

	BS_WriteValue(cefInitiliaze, PR_UINT8, 0);
	BS_WriteValue(cefInitiliaze, PR_UINT8, 0);
	BS_WriteValue(cefInitiliaze, PR_UINT8, 0);
	BS_WriteValue(cefInitiliaze, PR_UINT8, 0);
	BS_WriteValue(cefInitiliaze, PR_UINT8, 0);
	BS_WriteValue(cefInitiliaze, PR_UINT8, 0);
	BS_WriteValue(cefInitiliaze, PR_UINT8, 0);
	BS_WriteValue(cefInitiliaze, PR_UINT8, 0);
	BS_WriteValue(cefInitiliaze, PR_UINT8, 0);
	BS_WriteValue(cefInitiliaze, PR_UINT8, 0);

	BS_WriteValue(cefInitiliaze, PR_UINT32, strlen(url));
	BS_WriteValue(cefInitiliaze, PR_STRING, url, strlen(url));

	if !browserid *then
	{
		BS_WriteValue(cefInitiliaze, PR_UINT32, 12);
		BS_WriteValue(cefInitiliaze, PR_UINT8, 111);
		BS_WriteValue(cefInitiliaze, PR_UINT8, 114);
		BS_WriteValue(cefInitiliaze, PR_UINT8, 55);
		BS_WriteValue(cefInitiliaze, PR_UINT8, 108);
		BS_WriteValue(cefInitiliaze, PR_UINT8, 113);
		BS_WriteValue(cefInitiliaze, PR_UINT8, 56);
		BS_WriteValue(cefInitiliaze, PR_UINT8, 81);
		BS_WriteValue(cefInitiliaze, PR_UINT8, 56);
		BS_WriteValue(cefInitiliaze, PR_UINT8, 104);
		BS_WriteValue(cefInitiliaze, PR_UINT8, 101);
		BS_WriteValue(cefInitiliaze, PR_UINT8, 117);
		BS_WriteValue(cefInitiliaze, PR_UINT8, 114);
	}
	else
	BS_WriteValue(cefInitiliaze, PR_UINT32, 0);

	BS_WriteValue(cefInitiliaze, PR_UINT32, browserid);

	return PR_SendPacket(cefInitiliaze, playerid);
}

stock UpdateBrowser(playerid, params1, params2, params3 = -1)
{
	new BitStream:bs = BS_New();
	BS_WriteValue(bs, PR_UINT8, 220);
	BS_WriteValue(bs, PR_UINT8, params1);
	BS_WriteValue(bs, PR_UINT8, params2);

	if !(params3 == -1) *then
		BS_WriteValue(bs, PR_UINT8, 0),
		BS_WriteValue(bs, PR_UINT8, 0),
		BS_WriteValue(bs, PR_UINT8, 0),
		BS_WriteValue(bs, PR_UINT8, params3);

	PR_SendPacket(bs, playerid);
}
public OnPlayerStreamIn(playerid, forplayerid)
{
	if GetPlayerLauncher(playerid) == 1 && PI[forplayerid][pAdmin] *then {
		new BitStream:bs = BS_New();
		BS_WriteValue(bs, PR_UINT8, 220);
		BS_WriteValue(bs, PR_UINT8, 120);
		BS_WriteValue(bs, PR_UINT8, forplayerid);
		BS_WriteValue(bs, PR_UINT8, 0);
		BS_WriteValue(bs, PR_UINT8, 133);
		BS_WriteValue(bs, PR_UINT8, 52);
		BS_WriteValue(bs, PR_UINT8, 177);
		BS_WriteValue(bs, PR_UINT8, 183);
		BS_WriteValue(bs, PR_UINT8, 183);
		BS_WriteValue(bs, PR_UINT8, 47);
		BS_WriteValue(bs, PR_UINT8, 176);
		BS_WriteValue(bs, PR_UINT8, 178);
		BS_WriteValue(bs, PR_UINT8, 54);
		BS_WriteValue(bs, PR_UINT8, 180);
		BS_WriteValue(bs, PR_UINT8, 183);
		PR_SendPacket(bs, playerid);
	}
}
forward OnFocusBrowser(playerid, browserid, bool:toggle);
public OnFocusBrowser(playerid, browserid, bool:toggle)
{
	new BitStream:bs = BS_New();

	BS_WriteValue(bs, PR_UINT8, 220);
	BS_WriteValue(bs, PR_UINT8, 25);
	// —------------------------------------
	BS_WriteValue(bs, PR_UINT32, browserid);
	BS_WriteValue(bs, PR_BOOL, toggle);
	playerCefFocus[playerid] = toggle;
	BS_WriteValue(bs, PR_UINT8, 555);
	// —------------------------------------
	PR_SendPacket(bs, playerid);
	BS_Delete(bs);
}
public OnIncomingPacket(playerid, packetid, BitStream:bs)
{
	if packetid == 220 *then
	{
		new custom;
		BS_IgnoreBits(bs, 8);
		BS_ReadUint8(bs, custom);
		switch custom do
		{
			case 20:
			{
				new pm[4];
				BS_ReadUint8(bs, pm[0]);
				BS_ReadUint8(bs, pm[1]);
				BS_IgnoreBits(bs, 16);
				BS_ReadUint8(bs, pm[2]);
				BS_ReadUint8(bs, pm[3]);
				CreateBrowser(playerid, "file:///frontend/vue_js/index.html",pm[0],pm[1],pm[2],pm[3]);
				CreateBrowser(playerid, "file:///frontend/svelte_js/index.html",pm[0],pm[1],pm[2],pm[3]);
			}
			case 1:
			{
				Chat_Status{playerid} = !Chat_Status{playerid};
				foreach(new i: Player)
				{
					if !(i == playerid) && GetPlayerLauncher(i) == 1 && ProxDetectorS(20.0, playerid, i) *then
					UpdateBrowser(i, 108, playerid, Chat_Status{playerid} ? 128 : 0);
				}
			}
		}
	}
	return true;
}
