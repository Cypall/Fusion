unit Login;



interface

uses
    {Windows VCL}
    {$IFDEF MSWINDOWS}
	Windows, ScktComp,
    {$ENDIF}
    {Kylix/Delphi CLX}
    {$IFDEF LINUX}
    Qt, Types,
    {$ENDIF}
    {Shared}
    Classes, SysUtils,
    {Fusion}
    Common, Database, SQLData, FusionSQL, PlayerData, Globals;

//==============================================================================
procedure sv1PacketProcess(Socket: TCustomWinSocket); //Gets the packet (at bottom)
//==============================================================================

implementation

//==============================================================================
//Takes the interpreted data and processes it
procedure sv1PacketProcessSub(Socket: TCustomWinSocket;w :word;userid:string;userpass  :string);
var{ChrstphrR - 2004/04/25 - removed unused variables}
    i         : integer;
    tc        : TChara;   //Used for duplicate login
    loggedIn  : boolean;
	APlayer   : TPlayer;    //reference
	PlayerIdx : Integer;
begin
    APlayer := PlayerName.Objects[PlayerName.IndexOf(userid)] as TPlayer;

    APlayer.IP := Socket.RemoteAddress;

    PlayerIdx := IDTableDB.IndexOf(APlayer.ID);

    if (PlayerIdx = -1) AND (NowUsers >= Option_MaxUsers) then begin
        ZeroMemory(@buf[0],23);
        WFIFOW( 0, $006a);
        WFIFOB( 2, 7);//Server is full.
        Socket.SendBuf(buf, 23);
    end;

    for i := 0 to BanList.Count -1 do begin
        if APlayer.IP = BanList.Strings[i] then begin
            ZeroMemory(@buf[0],23);
            WFIFOW( 0, $006a);
            WFIFOB( 2, 4); //Blocked ID, or an ID of a locked account
            Socket.SendBuf(buf, 23);
            Exit; //stop the other stuff
        end;
    end;

    if (APlayer.Banned = True) then begin
        ZeroMemory(@buf[0],23);
        WFIFOW( 0, $006a);
        WFIFOB( 2, 4); //Blocked ID, or an ID of a locked account
        Socket.SendBuf(buf, 23);
    end

    else if (APlayer.Login) then begin  //Check if player is logged in already
        loggedIn := false;
        {This way we check that a character of the player is also logged in}
        for i := 0 to 8 do begin
            if CharaName.IndexOf(APlayer.CName[i]) = -1 then Continue;
            tc := CharaName.Objects[CharaName.IndexOf(APlayer.CName[i])] as TChara;
            if tc.Login = 2 then loggedIn := true;
            //keep this tc active and not change it.  Used later to KICK off
            if tc.Login = 2 then break;
        end;

        if loggedIn then begin
            ZeroMemory(@buf[0],23);
            WFIFOW( 0, $0081);
            WFIFOB( 2, 2);//Someone is logged on the same ID
            Socket.SendBuf(buf, 23);
            if assigned(tc) then begin //Kicking online user
                if assigned(tc.Socket) and (tc.Login <> 0) then begin
                    WFIFOW( 0, $0081);
                    WFIFOB( 2, 2);//Someone is logged on the same ID
                    tc.Socket.SendBuf(buf, 23);
                    tc.Socket.Close;
                    tc.Socket := nil;
                end;
            end;
        end else APlayer.Login := false;
    end

    else if APlayer.Pass = userpass then begin
        APlayer.LoginID1 := Random($7FFFFFFF) + 1;
        if UseSQL then APlayer.LoginID2 := Assign_AccountID()
        else begin
            APlayer.LoginID2 := NowLoginID;
            Inc(NowLoginID);
        end;
        if NowLoginID >= 2000000000 then NowLoginID := 0;
        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'tp.ver2 = '+inttostr(w));
        //tp.ver2 := w;
        APlayer.ver2 := 9;
        WFIFOW( 0, $0069);
        WFIFOW( 2, 79);
        WFIFOL( 4, APlayer.LoginID1);
        WFIFOL( 8, APlayer.ID);
        WFIFOL(12, APlayer.LoginID2);
        WFIFOL(16, 0);
        WFIFOS(20, PChar(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now)), 24);
        WFIFOW(44, 0);
        WFIFOB(46, APlayer.Gender); //sex 0=F 1=M
        if uselan(APlayer.IP) then WFIFOL(47, LAN_ADDR)
        else WFIFOL(47, WAN_ADDR);
        WFIFOW(51, sv2port);
        WFIFOS(53, ServerName, 20);
        WFIFOW(73, NowUsers);
        WFIFOW(75, 0);
        WFIFOW(77, 0);
        Socket.SendBuf(buf, 79);
    end else begin
        ZeroMemory(@buf[0],23);
        WFIFOW( 0, $006a);
        WFIFOB( 2, 1);//Password Incorrect
        Socket.SendBuf(buf, 23);
    end;

end;

//==============================================================================
//Addplayer.txt - adds accounts from addplayer.txt
function sv1PacketProcessAdd(Socket: TCustomWinSocket;w :word;userid:string;userpass  :string):Boolean;
var
	userdata  : string;
	count     : Integer;
	addtxt    : TextFile;
	option_mf : string;
    sl : TStringList;
begin
	Result := False;

		if (Option_Username_MF = True) then begin
			option_mf := copy(userid, length(userid) - 1, 2);

            if (option_mf = '_M') or (option_mf = '_F') then begin
				userid := copy(userid, 0, length(userid) - 2);
                create_account(userid, userpass, '-@-', option_mf);
            end;

        end;


	AssignFile(addtxt, AppPath + 'addplayer.txt');
	if FileExists(AppPath + 'addplayer.txt') then begin
		Reset(addtxt);
		count := 1;
        sl := TStringList.Create;

        while not SeekEof(addtxt) do begin
        	Readln(addtxt,userdata);
            sl.CommaText := userdata;

            create_account(sl.Strings[0], sl.Strings[1], sl.Strings[3], sl.Strings[2]);

            inc(count);
            sl.Clear;
        end;

        sl.Free;
		Rewrite(addtxt);
		Flush(addtxt);  //Verifies that text REALLY was written to the file
		CloseFile(addtxt);

        if UseSQL then
        	SQLDataSave
        else
        	DataSave;

		{ChrstphrR 2004/04/25 - Clear's are unsafe
		for the TPlayer objects, unless you pre-free the Objects[]
		... and even so, I'm worried about the safety of rebuilding this
		list on the fly. -- A safer solution would be to...
		- Add the player's account into the runtime Lists,
		Player, PlayerName
		- Make a safe routine to write the new accounts, or, if not,
		the whole list to txtfile or SQL, as the case may be.}

        {
		for Idx := Player.Count-1 downto 0 do
			if Assigned(Player.Objects[Idx]) then
				(Player.Objects[Idx] AS TPlayer).Free;
		Player.Clear;
		PlayerName.Clear;

		if (option_mf = 'S') then begin
            Load_Accounts(userid);
            sv1PacketProcessSub(Socket,w,userid,userpass);
        end else begin
            PlayerDataLoad;
        }

		if PlayerName.IndexOf(userid) = -1 then Exit;
		sv1PacketProcessSub(Socket,w,userid,userpass);

			Result := True;
	end;
end;

//==============================================================================
//Retrieves the packet and interprets
procedure sv1PacketProcess(Socket: TCustomWinSocket);
var
	w         :word;
	l         :longword;
	len       :integer;
	userid    :string;
    userid2   :string;
    option_mf :string;
	userpass  :string;
begin
	{ChrstphrR - 2004/04/28 - brought back the Len variable, out of concern
	it may be causing the Unable-to-connect to the Login Server Eliotsan's users
	had observed -- notes from the helpfile seem to back this :P

	Call ReceiveLength to determine the amount of information to read over
	the socket connection in response to an asynchronous read notification.

	Note: ReceiveLength is not guaranteed to be accurate
	for streaming socket connections.

	From ReceiveBuf notes...
	Note:	While the ReceiveLength method can return an estimate of the size of
	buffer required to retrieve information from the socket, the number of bytes
	it returns is not necessarily accurate.
	}
	len := Socket.ReceiveLength;
	if len >= 55 then begin
		Socket.ReceiveBuf(buf, len);
		if (buf[0] = $64) and (buf[1] = $0) then begin
			RFIFOL(2, l);
			//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'ver1 ' + IntToStr(l));
			RFIFOW(54, w);
			userid := RFIFOS(6, 24);
			userpass := RFIFOS(30, 24);

			debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'User: ' + userid + ' - Pass: ' + userpass);

			if UseSQL then Load_Accounts(userid)
            else PD_PlayerData_Load(userid);

            userid2 := userid;
            if (Option_Username_MF = True) then begin
            	option_mf := copy(userid, length(userid) - 1, 2);
                if (option_mf = '_M') or (option_mf = '_F') then
						userid := copy(userid, 0, length(userid) - 2);
            end;

            if PlayerName.IndexOf(userid) > -1 then
                sv1PacketProcessSub(Socket,w,userid,userpass) //Start the user validation
            else begin
                if not sv1PacketProcessAdd(Socket,w,userid2,userpass) then begin
                    //If the user wasn't added from the above function
                	ZeroMemory(@buf[0],23);
                    WFIFOW( 0, $006a);
                    WFIFOB( 2, 0); //Unregistered ID
                    Socket.SendBuf(buf, 23);
                end;
            end;
		end;
	end;
end;
//==============================================================================
end.
