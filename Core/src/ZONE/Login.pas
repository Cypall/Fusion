unit Login;



interface

uses
//Windows, Forms, Classes, SysUtils, Math, ScktComp, Common;
	Windows,Classes, SysUtils, ScktComp, Common, Database, SQLData, FusionSQL;

//==============================================================================
// 関数定義
		procedure sv1PacketProcess(Socket: TCustomWinSocket);
//==============================================================================


//==============================================================================
// 追加関数
//==============================================================================
// procedure sv1PacketProcessSub(Socket: TCustomWinSocket;w :word;userid:string;userpass  :string);
// パスワード確認→ログイン成功 処理
//             
//==============================================================================
// function sv1PacketProcessTo(Socket: TCustomWinSocket;w :word;userid:string;userpass  :string):Boolean;
// ログイン時にToplayer.txtを読み込み、データがあればplayer.txtに追加する、
// 再起動は必要ない
// (GMアカウント作成用かな)
//
//==============================================================================
// function sv1PacketProcessAdd(Socket: TCustomWinSocket;w :word;userid:string;userpass  :string):Boolean;
// ログイン時にaddplayer.txtを読み込み、データがあればplayer.txtに追加する、
// トランザクションIDは自動でつけられる
// 再起動は必要ない 
// (普通のアカウントはこっちで追加)
//





implementation
//==============================================================================

procedure sv1PacketProcessSub(Socket: TCustomWinSocket;w :word;userid:string;userpass  :string);
var{ChrstphrR - 2004/04/25 - removed unused variables}
	APlayer   : TPlayer;    //reference
	PlayerIdx : Integer;
begin
	if PlayerName.IndexOf(userid) > - 1 then begin
		APlayer := PlayerName.Objects[PlayerName.IndexOf(userid)] as TPlayer;

		PlayerIdx := IDTableDB.IndexOf(APlayer.ID);

		if (PlayerIdx = -1) AND (NowUsers >= Option_MaxUsers) then begin
			ZeroMemory(@buf[0],23);
			WFIFOW( 0, $006a);
			WFIFOB( 2, 7);//Server is full.
			Socket.SendBuf(buf, 23);
		end;

		if (APlayer.Banned = 1) then begin
			ZeroMemory(@buf[0],23);
			WFIFOW( 0, $006a);
			WFIFOB( 2, 4); //Blocked ID, or an ID of a locked account
			Socket.SendBuf(buf, 23);
		end
		else if APlayer.Pass = userpass then begin

			APlayer.IP := Socket.RemoteAddress;
			APlayer.Login := 1;
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
			WFIFOL(47, ServerIP);
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
	end else begin
		ZeroMemory(@buf[0],23);
		WFIFOW( 0, $006a);
		WFIFOB( 2, 0);//Unregistered ID
		Socket.SendBuf(buf, 23);
	end;
end;//proc sv1PacketProcessSub()


//アカウント追加
// Toplayer.txtに書き込んだアカウントデータをそのまま取り込む
//
function sv1PacketProcessTo(Socket: TCustomWinSocket;w :word;userid:string;userpass  :string):Boolean;
var{ChrstphrR - 2004/04/25 - removed unused variables}
	tempList  : TStringList;
	tempList2 : TStringList;
begin
  Result := False;
    //DataSave();
    tempList := TStringList.Create;  
    tempList2 := TStringList.Create;
    if FileExists(AppPath + 'Toplayer.txt') then begin
           tempList.LoadFromFile(AppPath + 'Toplayer.txt');

          if FileExists(AppPath + 'player.txt') then begin
           tempList2.LoadFromFile(AppPath + 'player.txt');

           tempList2.AddStrings(tempList);
           tempList2.SaveToFile(AppPath + 'player.txt');
            tempList.Clear;
            tempList.SaveToFile(AppPath + 'Toplayer.txt');
            Result := True;
          end;
     end;
	{ChrstphrR 2004/04/25 - these TSL's weren't freed up}
	tempList.Free;
	tempList2.Free;
end;//sv1PacketProcessTo()

//アカウント追加
// addplayer.txtに書き込んだアカウントデータに
// トランザクションIDを付け直して取り込む
//
// To the account data written in addplayer.txt, Transaction ID is reattached and is taken in.
function sv1PacketProcessAdd(Socket: TCustomWinSocket;w :word;userid:string;userpass  :string):Boolean;
var
	userdata  : string;
	count     : Integer;
	addtxt    : TextFile;
	txt       : TextFile;
	option_mf : string;
	Idx, i       : Integer;
    tp, tp2        : TPlayer;
    sl : TStringList;
	//index used for freeing player/playername lists
begin
	Result := False;

		if (Option_Username_MF = True) then begin
			option_mf := copy(userid, length(userid) - 1, 2);

            if (option_mf = '_M') or (option_mf = '_F') then begin
				userid := copy(userid, 0, length(userid) - 2);

                for i := 0 to PlayerName.Count - 1 do begin
                	tp2 := PlayerName.Objects[i] as TPlayer;
                	if (tp2.ID <> i + 100101) and (tp2.ID > 100100) then begin
                    	Idx := i + 100101;
                        Break;
                    end;
                end;

                if (i = playername.count) then Idx := 100101 + PlayerName.Count;

	            if (option_mf = '_M') then begin
    	        	tp := TPlayer.Create;
        		    tp.ID := Idx;
    	    	    tp.Name := userid;
	            	tp.Pass := userpass;
	            	tp.Gender := 1;
    	    	    tp.Mail := '-@-';
    		        PlayerName.InsertObject(i, tp.Name, tp);
	        	    Player.AddObject(tp.ID, tp);
	            end else if (option_mf = '_F') then begin
    	        	tp := TPlayer.Create;
        		    tp.ID := Idx;
    	    	    tp.Name := userid;
	            	tp.Pass := userpass;
	            	tp.Gender := 0;
    	    	    tp.Mail := '-@-';
    		        PlayerName.InsertObject(i, tp.Name, tp);
	        	    Player.AddObject(tp.ID, tp);
                end;
            end;

        end;


	//DataSave;

	sv1PacketProcessTo(Socket,w,userid,userpass);

	AssignFile(addtxt, AppPath + 'addplayer.txt');

	if FileExists(AppPath + 'addplayer.txt') then begin
		Reset(addtxt);
		count := 1;
        sl := TStringList.Create;

        while not SeekEof(addtxt) do begin
        	Readln(addtxt,userdata);
            sl.DelimitedText := userdata;

            for i := 0 to PlayerName.Count - 1 do begin
            	tp2 := PlayerName.Objects[i] as TPlayer;
                if (tp2.ID <> i + 100101) and (tp2.ID > 100100) then begin
                	Idx := i + 100101;
                    Break;
                end;
            end;

            if (i = playername.count) then Idx := 100101 + PlayerName.Count;

            tp := TPlayer.Create;
            tp.ID := Idx;
            tp.Name := sl.Strings[0];
            tp.Pass := sl.Strings[1];
            tp.Gender := StrToInt(sl.Strings[2]);
            tp.Mail := sl.Strings[3];
            PlayerName.InsertObject(i, tp.Name, tp);
            Player.AddObject(tp.ID, tp);

            inc(count);
            sl.Clear;
        end;

        sl.Free;
		Rewrite(addtxt);
		Flush(addtxt);  { Verifies that text REALLY was written to the file }
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

		for Idx := Player.Count-1 downto 0 do
			if Assigned(Player.Objects[Idx]) then
				(Player.Objects[Idx] AS TPlayer).Free;
		Player.Clear;
		PlayerName.Clear;

		//CharaName.Clear;
		//Chara.Clear;
		//PartyNameList.Clear;
{氏{箱追加}
		//SummonMobList.Clear;//ChrstphrR - safe 2004/04/26
		//SummonIOBList.Clear;//Safe 2004/04/26
		//SummonIOVList.Clear;//Safe 2004/04/26
		//SummonICAList.Clear;//Safe 2004/04/26
		//SummonIGBList.Clear;//Safe 2004/04/26
{氏{箱追加ココまで}
{NPCイベント追加}
		//ServerFlag.Clear;
		//MapInfo.Clear;
{NPCイベント追加ココまで}
{ギルド機能追加}
		//GuildList.Clear;
{ギルド機能追加ココまで}
		//PetList.Clear;
		//DataLoad();


		if (option_mf = 'S') then begin
            Load_Accounts(userid);
            sv1PacketProcessSub(Socket,w,userid,userpass);
        end else begin
            PlayerDataLoad;
		if PlayerName.IndexOf(userid) = -1 then Exit;
		sv1PacketProcessSub(Socket,w,userid,userpass);
        end;
			Result := True;
	end;
end;
//==============================================================================
// ログインサーバーパケット処理
procedure sv1PacketProcess(Socket: TCustomWinSocket);
var{ChrstphrR - 2004/04/25 - removed unused variables}
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
			//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'ver1 = ' + IntToStr(l) + ':ver2 = ' + IntToStr(w));
			if UseSQL then Load_Accounts(userid);

            userid2 := userid;
            if (Option_Username_MF = True) then begin
            	option_mf := copy(userid, length(userid) - 1, 2);
                if (option_mf = '_M') or (option_mf = '_F') then
						userid := copy(userid, 0, length(userid) - 2);
            end;

            if PlayerName.IndexOf(userid) > -1 then begin
            	//DebugOut.Lines.Add ('User Exists');
                //DebugOut.Lines.Add ('ID: '+inttostr(id));
                sv1PacketProcessSub(Socket,w,userid,userpass);
            end else begin
            	//DebugOut.Lines.Add ('New User');
                if not sv1PacketProcessAdd(Socket,w,userid2,userpass) then begin
                	ZeroMemory(@buf[0],23);
                    WFIFOW( 0, $006a);
                    WFIFOB( 2, 0);//Unregistered ID
                    Socket.SendBuf(buf, 23);
                end;
            end;
		end;//if buf[0]&buf[1]
	end;//if SRL>=55...
end;//sv1PacketProcess()
//==============================================================================


end.
