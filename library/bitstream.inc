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
        return 1;
}
