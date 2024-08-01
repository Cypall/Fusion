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

        //DebugOut.Lines.Add('tp.ver2 = '+inttostr(w));
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
function sv1PacketProcessAdd(Socket: TCustomWinSocket;w :word;userid:string;userpass  :string):Boolean;
var
	userdata  : string;
	count     : Integer;
	addtxt    : TextFile;
	txt       : TextFile;
	option_mf : string;
	Idx       : Integer;
	//index used for freeing player/playername lists
begin
	Result := False;
	DataSave;

	sv1PacketProcessTo(Socket,w,userid,userpass);
	AssignFile(addtxt, AppPath + 'addplayer.txt');
	AssignFile(txt, AppPath + 'player.txt');
	if not FileExists(AppPath + 'player.txt') then begin
		Rewrite(txt);
		Writeln(txt, '##Weiss.PlayerData.0x0002');
	end else begin
		Append(txt);
	end;
	if FileExists(AppPath + 'addplayer.txt') then begin
		Reset(addtxt);
		count := 1;

		if (Option_Username_MF = True) then begin
			option_mf := copy(userid, length(userid) - 1, 2);
			userid := copy(userid, 0, length(userid) - 2);

			if (option_mf = '_M') then begin
				Writeln(txt, inttostr(100100+PlayerName.Count+count)+','+userid+','+userpass+',1,-@-,0,,,,,,,,,');
			end else if (option_mf = '_F') then begin
				Writeln(txt, inttostr(100100+PlayerName.Count+count)+','+userid+','+userpass+',0,-@-,0,,,,,,,,,');
			end;

			Writeln(txt, '0');
			inc(count);
		end

		else begin
			while not SeekEof(addtxt) do begin
				Readln(addtxt,userdata);
				Writeln(txt, inttostr(100100+PlayerName.Count+count)+','+userdata);
				Writeln(txt, '0');
				inc(count);
			end;
		end;

		Flush(txt);  { テキストが実際にファイルに書き込まれたことを確かめる }
		CloseFile(txt);

		Rewrite(addtxt);
		Flush(addtxt);  { テキストが実際にファイルに書き込まれたことを確かめる }
		CloseFile(addtxt);


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

		PlayerDataLoad;

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

		if PlayerName.IndexOf(userid) = -1 then Exit;
		sv1PacketProcessSub(Socket,w,userid,userpass);
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
			//DebugOut.Lines.Add('ver1 ' + IntToStr(l));
			RFIFOW(54, w);
			userid := RFIFOS(6, 24);
			userpass := RFIFOS(30, 24);

			DebugOut.Lines.Add('User: ' + userid + ' - Pass: ' + userpass);
			//DebugOut.Lines.Add('ver1 = ' + IntToStr(l) + ':ver2 = ' + IntToStr(w));
			if UseSQL then begin
				if Load_Accounts(userid) then begin
					sv1PacketProcessSub(Socket,w,userid,userpass);
				end else begin
					ZeroMemory(@buf[0],23);
					WFIFOW( 0, $006a);
					WFIFOB( 2, 0);//Unregistered ID
					Socket.SendBuf(buf, 23);
				end;
			end else begin
				if PlayerName.IndexOf(userid) > -1 then begin
					//DebugOut.Lines.Add ('User Exists');
					//DebugOut.Lines.Add ('ID: '+inttostr(id));
					sv1PacketProcessSub(Socket,w,userid,userpass);
				end else begin
					//DebugOut.Lines.Add ('New User');
					if not sv1PacketProcessAdd(Socket,w,userid,userpass) then begin
						ZeroMemory(@buf[0],23);
						WFIFOW( 0, $006a);
						WFIFOB( 2, 0);//Unregistered ID
						Socket.SendBuf(buf, 23);
					end;
				end;
			end;
		end;//if buf[0]&buf[1]
	end;//if SRL>=55...
end;//sv1PacketProcess()
//==============================================================================


end.
