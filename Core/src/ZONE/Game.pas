unit Game;



interface

uses
	Windows, MMSystem, Forms, Classes, Math, SysUtils, ScktComp,
	Path, Script, Common, Zip, SQLData, FusionSQL;

//==============================================================================
// 関数定義
		procedure sv3PacketProcess(Socket: TCustomWinSocket);
//==============================================================================


implementation
//==============================================================================


(*-----------------------------------------------------------------------------*
// ゲームサーバーパケット処理

???
Appears to have a large portion of the game logic intermixed with a
case statement that processes incoming messages from the server.

CRW - 2004/04/07
- Applied consistant formatting to PART of this 7300 line long routine so it's
  now sane to look at.
- Separated variables, one per line, no exceptions.
- Started Translation of the SJIS code from the original coder(s) in the form:
  <original> ' Lit. "'<Edited_Babelfish_Translation_Here>'"'

  I hope this helps a wee bit. :P

*-----------------------------------------------------------------------------*)
Procedure sv3PacketProcess(Socket: TCustomWinSocket);
Var
	i     : Integer;
  h     : Integer;
	j     : Integer;
	k     : Integer;
	ii    : Integer;
	cmd   : Word;
	w     : Word;
	w1    : Word;
	w2    : Word;
  w3    : Word;
{追加}
	wjob  : Int64;
{追加ココまで}
{アイテム製造追加}
	m1      : Word;//主に製造されるアイテムのIDとして利用
	m       : Array[0..2] of Word;//主に製造アイテムに不可される属性石、星のかけらのIDとして利用
	e,e2    : Word;//主に製造時消費アイテムのInventory内検索時に利用
	anvil   : Word;//金敷によって上がる成功率
{アイテム製造追加ココまで}
	id1       : Cardinal;
  id2       : Cardinal;

	L         : Cardinal; //was lowercase "l"
	L2        : Cardinal; //was lowercase "l2" (close to 1 or I in the wrong font)
	weight    : Cardinal;
  c         : Cardinal;
	b         : Byte;
  b1        : Byte;
	Len       : Integer;

	Str       : String;
  Str2      : String;
	AccountID : String;
	CharaID   : String;
	NpcID     : String;

	tp  : TPlayer;
	tc  : TChara;
	tc1 : TChara;
	tm  : TMap;
	tn  : TNPC;
	ts  : TMob;
  ts1 : TMob;
  tss : TSlaveDB;
  ma  : TMArrowDB;
  tid : TIDTbl;
	ti  : TItem;
	tk  : TSkill;
	tl  : TSkillDB;
	td  : TItemDB;

{アイテム製造追加}
	tma : TMaterialDB;
{アイテム製造追加ココまで}
{パーティー機能追加}
	tpa : TParty;
{パーティー機能追加ココまで}
{チャットルーム機能追加}
	tcr : TChatRoom;
{チャットルーム機能追加ココまで}
{露店スキル追加}
	tv  : TVender;
{露店スキル追加ココまで}
{取引機能追加}
	tdl : TDealings;
  twp : TWarpDatabase;
{取引機能追加ココまで}
{キューペット}
  tpd : TPetDB;
  tmd : TMobDB;
{氏{箱追加}
	tsmn  : TSummon;
{氏{箱追加ココまで}
  tpe             :TPet;

  i1  : Integer;
  j1  : Integer;
  k1  : Integer;
{キューペットここまで}
{NPCイベント追加}
	mi  : MapTbl;
{NPCイベント追加ココまで}
{ギルド機能追加}
	tg    : TGuild;
	tg1   : TGuild;
	tgb   : TGBan;
	tgl   : TGRel;
	tp1   : TPlayer;
{ギルド機能追加ココまで}
	ta  : TMapList;
	xy  : TPoint;
  s   : String;
	SL  : TStringList;
	ww      : array of array of Word; //CRW This is dynamic 2-dim array??
	tmpbuf  : array of Byte;

  afm_compressed  : TZip;
  afm             : Textfile;
  letter          : Char;
  MapName         : String;
  dat             : TMemoryStream;
  h2              :array[0..3] of Single; //CRW What is this for??
  maptype         : Integer;

Begin(* Proc sv3PacketProcess() *)

  j := 0;
  tcr := nil;
	while Socket.ReceiveLength >= 2 do
  begin
		//len := Socket.ReceiveLength;
		Socket.ReceiveBuf(buf[0], 2);
		RFIFOW(0, cmd);
		//if cmd = $00c8 then
		//	//DebugOut.Lines.Add('!');
		tc := Socket.Data;
		if (cmd > $200) then begin
			//DebugOut.Lines.Add('不明なパケット' + IntToStr(Socket.ReceiveLength) + 'バイトを破棄しました');
			SetLength(tmpbuf, Socket.ReceiveLength);
			Socket.ReceiveBuf(tmpbuf[0], Socket.ReceiveLength);
			Continue;
		end;
		Assert((cmd > 0) AND (cmd <= $200), 'Packet Type: index error ' + IntToStr(cmd));
		if PacketLength[cmd] = -1 then begin
			Socket.ReceiveBuf(buf[2], 2);
			RFIFOW(2, w);
			Socket.ReceiveBuf(buf[4], w - 4);
			//DebugOut.Lines.Add(Format('3:%.8d CMD %.4x len:%d plen:%d', [tc.ID, cmd, w, len]));
		end else begin
			Socket.ReceiveBuf(buf[2], PacketLength[cmd] - 2);
			//if cmd <> $0072 then begin
			//DebugOut.Lines.Add(Format('3:%.8d CMD %.4x', [tc.ID, cmd]));
			//end;
		end;
    //DebugOut.Lines.Add('Command:' + IntToStr(cmd));

		case cmd of
		//--------------------------------------------------------------------------
		$0072: //ゲーム鯖接続要求    Lit. "Game socket connection requested"
			begin
				RFIFOL( 2, L);
				accountid := IntToStr(L);
				//DebugOut.Lines.Add(Format('3:%.8d CMD %.4x', [l, cmd]));
				//DebugOut.Lines.Add('		AccountID = ' + IntToHex(l, 4));
				RFIFOL( 6, l2);
				charaid := IntToStr(l2);
				//DebugOut.Lines.Add('		CharaID = ' + IntToHex(l, 4));
				RFIFOL(10, id1);
				//DebugOut.Lines.Add('		LoginID1 = ' + IntToHex(id1, 4));
				//RFIFOL(14, id2);
				if (Player.IndexOf(L) <> -1) and (Chara.IndexOf(L2) <> -1) then begin
					tp := Player.IndexOfObject(L) as TPlayer;
					tc := Chara.IndexOfObject(L2) as TChara;

					//if tc.IP = Socket.RemoteAddress then begin
					if (tp.LoginID1 = id1) and (tp.LoginID1 <> 0) then begin
						tc.ver2 := tp.ver2;
						//tp.LoginID1 := 0;
						tc.Login := 1;
						//tc.ID := tp.ID;
						//tc.Gender := tp.Gender;
						tc.PData := tp;
						if CharaPID.IndexOf(tc.ID) = -1 then CharaPID.AddObject(tc.ID, tc);
						tc.Socket := Socket;
						Socket.Data := tc;
						WFIFOL(0, $00000000);
						Socket.SendBuf(buf, 4);

						WFIFOW(0, $0073);
						WFIFOL(2, timeGetTime());
						WFIFOM1(6, tc.Point);
						WFIFOW(9, $0505);
						Socket.SendBuf(buf, 11);

						//前回ワープに失敗して落ちたときの復旧処理
						if tc.tmpMap <> '' then begin
							tc.Map := tc.tmpMap;
							tc.tmpMap := '';
						end;

						//マップロード
						if Map.IndexOf(tc.Map) = -1 then begin
							MapLoad(tc.Map);
						end;
{ギルド機能追加}
						j := GuildList.IndexOf(tc.GuildID);
						if (j <> -1) then begin
							tg := GuildList.Objects[j] as TGuild;
							//メンバーに通知
							WFIFOW( 0, $016d);
							WFIFOL( 2, tc.ID);
							WFIFOL( 6, tc.CID);
							WFIFOL(10, 1);
							SendGuildMCmd(tc, 14, true);
							//ギルド情報
							SendGLoginInfo(tg, tc);
						end;

            //CRW -- Broadcasts Welcome Message to all Users.
            if (Option_WelcomeMsg) then begin
              str2 := 'blueWelcome, '+tc.Name+', to the '+ServerName+' Ragnarok Online Server - Powered by Fusion Server Technology';
              //CRW -- why is "w" 200 -- should it not be SizeOf(str2) ??
              w := 200;
              WFIFOW(0, $009a);
              WFIFOW(2, w);
              WFIFOS(4, str2, w-4);
              for i := 0 to CharaName.Count - 1 do begin
				        tc1 := CharaName.Objects[i] as TChara;
				        if tc1.Login = 2 then begin
                  tc1.Socket.SendBuf(buf, w);
                end;
              end;
              tc.Socket.SendBuf(buf, w);
            end;//if (Option.WelcomeMsg)

{ギルド機能追加ココまで}
					end else begin
						WFIFOW(0, $0074); //あってるかな？
						WFIFOB(2, 0);
						Socket.SendBuf(buf, 3);
					end;
				end;
			end;//$0072
		//--------------------------------------------------------------------------
		$007d: // Map loading completed (display the map to user)
			begin
				if tc.tmpMap <> '' then begin
					tc.Map := tc.tmpMap;
					tc.tmpMap := '';
				end;
        if Map.IndexOf(tc.Map) <> - 1 then begin
				tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
				while tm.Mode < 2 do
					Application.ProcessMessages;

				tc.MData := tm;
				if CharaPID.IndexOf(tc.ID) = -1 then CharaPID.AddObject(tc.ID, tc);
        if MapInfo.IndexOf(tm.Name) <> -1 then begin
        mi := MapInfo.Objects[MapInfo.IndexOf(tm.Name)] as MapTbl;

				// Add this character to the charlist for this map
				tm.CList.AddObject(tc.ID, tc);
				tm.Block[tc.Point.X div 8][tc.Point.Y div 8].CList.AddObject(tc.ID, tc);

        //Grace Time
        if mi.PvPG = true then begin
          tc.GraceTick := timeGetTime() + 15000;
        end else begin
          tc.GraceTick := timeGetTime() + 5000;
        end;

				// If dead, recover status/HP as necessary
				if tc.Sit = 1 then tc.Sit := 3;
				if tc.HP = 0 then begin
          if tc.JID = 0 then begin
            tc.HP := tc.MAXHP div 2;
            if tc.FullRecover then begin
              tc.HP := tc.MAXHP;
              tc.SP := tc.MAXSP;
            end;
          end else begin
            if tc.FullRecover then begin
              tc.HP := tc.MAXHP;
              tc.SP := tc.MAXSP;
            end else begin
              tc.HP := 1;
            end;
          end;
        end;

        // Reset vending/chat/trade/deal status
				tc.VenderID := 0;
				tc.ChatRoomID := 0;
				tc.DealingID := 0;
				tc.PreDealID := 0;

				//ブロック処理
				for j := tc.Point.Y div 8 - 2 to tc.Point.Y div 8 + 2 do begin
					for i := tc.Point.X div 8 - 2 to tc.Point.X div 8 + 2 do begin
						// Notify about nearby NPCs
						for k := 0 to tm.Block[i][j].NPC.Count - 1 do begin
							tn := tm.Block[i][j].NPC.Objects[k] as TNPC;
							if (abs(tc.Point.X - tn.Point.X) < 16) and (abs(tc.Point.Y - tn.Point.Y) < 16) then begin

                //SendNData(Socket, tn, tc.ver2);
								if (tn.Enable = true) then begin
									SendNData(Socket, tn,tc.ver2);
									if (tn.ScriptInitS <> -1) and (tn.ScriptInitD = false) then begin
										//OnInit processing
										//DebugOut.Lines.Add(Format('OnInit Event(%d)', [tn.ID]));
										tc1 := TChara.Create;
										tc1.TalkNPCID := tn.ID;
										tc1.ScriptStep := tn.ScriptInitS;
										tc1.AMode := 3;
										tc1.AData := tn;
										tc1.Login := 0;
										NPCScript(tc1,0,1);
										tn.ScriptInitD := true;
										tc1.Free;
									end;
									if (tn.ChatRoomID <> 0) then begin
										// Show NPC chatrooms
										ii := ChatRoomList.IndexOf(tn.ChatRoomID);
										if (ii <> -1) then begin
											tcr := ChatRoomList.Objects[ii] as TChatRoom;
											if (tn.ID = tcr.MemberID[0]) then begin
												w := Length(tcr.Title);
												WFIFOW(0, $00d7);
												WFIFOW(2, w + 17);
												WFIFOL(4, tcr.MemberID[0]);
												WFIFOL(8, tcr.ID);
												WFIFOW(12, tcr.Limit);
												WFIFOW(14, tcr.Users);
												WFIFOB(16, tcr.Pub);
												WFIFOS(17, tcr.Title, w);
												if tc.Socket <> nil then begin
													tc.Socket.SendBuf(buf, w + 17);
												end;
											end;
										end;
									end;
								end;
							end;
						end;
						// Notify nearby players about you (and you about them)
						for k := 0 to tm.Block[i][j].CList.Count - 1 do begin
							tc1 := tm.Block[i][j].CList.Objects[k] as TChara;
							if (tc <> tc1) and (abs(tc.Point.X - tc1.Point.X) < 16) and (abs(tc.Point.Y - tc1.Point.Y) < 16) then begin
								SendCData(tc, tc1);
								SendCData(tc1, tc);
								// Remove any chats or vends you may have had displayed (after death, perhaps...)
								ChatRoomDisp(tc.Socket, tc1);
								VenderDisp(tc.Socket, tc1);
							end;
						end;
						// Update about mobs in your range of vision
						for k := 0 to tm.Block[i][j].Mob.Count - 1 do begin
							ts := tm.Block[i][j].Mob.Objects[k] as TMob;
							if (abs(tc.Point.X - ts.Point.X) < 16) and (abs(tc.Point.Y - ts.Point.Y) < 16) then begin
								SendMData(Socket, ts);
							end;
						end;
					end;
				end;

				// Update skill list
				SendCSkillList(tc);

				// Update character stats
				CalcStat(tc);
				SendCStat(tc, true);

				// Update inventory data
				WFIFOW(0, $00a3);
				j := 0;
				for i := 1 to 100 do begin
					if (tc.Item[i].ID <> 0) and (not tc.Item[i].Data.IEquip) then begin
						WFIFOW( 4 +j*10, i);
						WFIFOW( 6 +j*10, tc.Item[i].Data.ID);
						WFIFOB( 8 +j*10, tc.Item[i].Data.IType);
						WFIFOB( 9 +j*10, tc.Item[i].Identify);
						WFIFOW(10 +j*10, tc.Item[i].Amount);
						if tc.Item[i].Data.IType = 10 then
							WFIFOW(12 +j*10, 32768)
						else
							WFIFOW(12 +j*10, 0);
						Inc(j);
					end;
				end;
				WFIFOW(2, 4+j*10);
				Socket.SendBuf(buf, 4+j*10);
				// Update equipment data
				WFIFOW(0, $00a4);
				j := 0;
				for i := 1 to 100 do begin
					if (tc.Item[i].ID <> 0) and tc.Item[i].Data.IEquip then begin
						WFIFOW( 4 +j*20, i);
						WFIFOW( 6 +j*20, tc.Item[i].Data.ID);
						WFIFOB( 8 +j*20, tc.Item[i].Data.IType);
						WFIFOB( 9 +j*20, tc.Item[i].Identify);
						with tc.Item[i].Data do begin
							if (tc.JID = 12) and (IType = 4) and (Loc = 2) and
								 ((View = 1) or (View = 2) or (View = 6)) then
								WFIFOW(10 +j*20, 34)
							else
								WFIFOW(10 +j*20, Loc);
						end;
						WFIFOW(12 +j*20, tc.Item[i].Equip);
						WFIFOB(14 +j*20, tc.Item[i].Attr);
						WFIFOB(15 +j*20, tc.Item[i].Refine);
						WFIFOW(16 +j*20, tc.Item[i].Card[0]);
						WFIFOW(18 +j*20, tc.Item[i].Card[1]);
						WFIFOW(20 +j*20, tc.Item[i].Card[2]);
						WFIFOW(22 +j*20, tc.Item[i].Card[3]);
						Inc(j);
					end;
				end;
				WFIFOW(2, 4+j*20);
				Socket.SendBuf(buf, 4+j*20);
				// Update arrow equipment status
				j := 0;
				for i := 1 to 100 do begin
					if (tc.Item[i].ID <> 0) and (tc.Item[i].Equip = 32768) then begin
						j := i;
						break;
					end;
				end;
				WFIFOW(0, $013c);
				WFIFOW(2, j);
				Socket.SendBuf(buf, 4);

        // Transmit cart data
				// Colus, 20040123: Other carts weren't getting checked.
				w3 := tc.Option and $0788;
				if (w3 <> 0) then begin
					SendCart(tc);
				end;

        // Reset regen/recovery ticks and combat status
				tc.HPTick := timeGetTime();
				tc.SPTick := timeGetTime();
				tc.HPRTick := timeGetTime() - 500;
				tc.SPRTick := timeGetTime();
				tc.Sit := 3;
				tc.AMode := 0;
				tc.DmgTick := 0;

        // Set login data and send party info
				tc.Login := 2;
				SendPartyList(tc);

        // Find and show your active pet
        j := 0;
        for i := 1 to 100 do begin
          if ( tc.Item[i].ID <> 0 ) and ( tc.Item[i].Amount > 0 ) and
          ( tc.Item[i].Card[0] = $FF00 ) and ( tc.Item[i].Attr <> 0 ) then begin
            j := i;
            break;
          end;
        end;

        if j > 0 then begin
          i := PetList.IndexOf( tc.Item[j].Card[2] + tc.Item[j].Card[3] * $10000 );
          if i <> -1 then begin
            SendPetRelocation(tm, tc, i);
          end;
        end;


        // Get and display the guild news
				j := GuildList.IndexOf(tc.GuildID);
				if (j <> -1) then begin
					tg := GuildList.Objects[j] as TGuild;
					WFIFOW( 0, $016f);
					WFIFOS( 2, tg.Notice[0], 60);
					WFIFOS(62, tg.Notice[1], 120);
					Socket.SendBuf(buf, 182);
				end;

        // Is this map PvP?  Then set that mode and ladder status.
        if (mi.Pvp = true) then begin
          for j := 0 to tm.CList.Count - 1 do begin
            tc1 := tm.CList.Objects[j] as TChara;
            WFIFOW( 0, $0199);
            WFIFOW( 2, 1);
            tc1.Socket.SendBuf(buf, 4);
            k := j + 1;
            i := tm.CList.Count;
            WFIFOW( 0, $019a);
            WFIFOL( 2, tc1.ID);
            WFIFOL( 6, k);
            WFIFOL( 10, i);
            tc1.Socket.SendBuf(buf, 14);
          end;
        end;

        // Is this map GvG?  Then set that mode.
        if (mi.PvPG = true) then begin
          for j := 0 to tm.CList.Count - 1 do begin
            tc1 := tm.CList.Objects[j] as TChara;
            WFIFOW( 0, $0199);
            WFIFOW( 2, 3);
            tc1.Socket.SendBuf(buf, 4);
          end;
        end;

        // Colus, 20040118: Update Spirit Spheres for monks
        if (tc.spiritSpheres > 0) then UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);

        {if (mi.noDay = true) {or (tc.noDay = true) then begin
          WFIFOW(0, $0119);
          WFIFOL(2, tc1.ID);
          WFIFOW(6, 00);
          WFIFOW(8, 16);
          WFIFOW(10, 00);
          WFIFOB(12, 0); // attack animation
          Socket.SendBuf(buf, 13)
        end;}

        // Colus, 20040409: Gave the option to enable lower class dyes.
        // This should be removed when Gravity reenables them.
        UpdateLook(tm, tc, 7, tc.ClothesColor, 0, true);
        end;
        end;

			end;//$007d
		//--------------------------------------------------------------------------
		$007e: //tick
			begin
				WFIFOW(0, $007f);
				WFIFOL(2, timeGetTime());
				Socket.SendBuf(buf, 6);
			end;
		//--------------------------------------------------------------------------
		$0085: //移動要求 (座ってるときやチャットなどでは移動できないようにすること)
			begin
{チャットルーム機能追加} {Lit. "Chat room functional addition"}
        if tc.Sit = 1 then continue;

				if tc.ChatRoomID <> 0 then continue; //チャット中の移動禁止
{チャットルーム機能追加ココまで} {Lit. "To Chat room functional additional coconut}
{露店スキル追加} {Lit. "Street stall skill addition"}
				if tc.VenderID <> 0 then continue; //露店中の移動禁止  Lit. "Movement prohibition in street stall"
{露店スキル追加ココまで} {Lit. "To street stall skill additional coconut"}
				RFIFOM1(2, xy);
				tc.NextFlag := true;
				tc.NextPoint := xy;
{パーティー機能追加} {Lit. "Party functional addition"}
				//同一マップ内PTMに所在を知らせる  Lit. "It informs about location inside PTM the identical map"
				if tc.PartyName <> '' then begin
					WFIFOW( 0, $0107);
					WFIFOL( 2, tc.ID);
					WFIFOW( 6, tc.NextPoint.X);
					WFIFOW( 8, tc.NextPoint.Y);
					SendPCmd(tc,10,true,true);
				end;
{パーティー機能追加ココまで} {Lit. "To party functional additional coconut"}
			end;
		//--------------------------------------------------------------------------
		$0089: //攻撃、座り
			begin
        //DebugOut.Lines.Add(IntToStr(tc.ID));
        //DebugOut.Lines.Add(IntToStr(tc.AMode));
				if tc.AMode > 2 then continue;
				if tc.MMode <> 0 then continue;

                tc.Delay := 0;
                tc.Skill[272].Tick := 0;

				RFIFOB(6, b);
				//DebugOut.Lines.Add('Inside Attack Command');
				if (b = 0) or (b = 7) then begin
        //DebugOut.Lines.Add(IntToStr(b));
					//攻撃
					RFIFOL(2, l);
					tm := tc.MData;
          //DebugOut.Lines.Add(IntToStr(l));
          ////////////////////////////////////
					//モンスター型NPC（攻撃しようとすると開始）
          if tm.NPC.IndexOf(l) <> -1 then begin
            tn := tm.NPC.IndexOfObject(l) as TNPC;
						//距離チェック
            if (tc.Map <> tn.Map) OR (abs(tc.Point.X - tn.Point.X) > 15) OR
               (abs(tc.Point.Y - tn.Point.Y) > 15) then begin
              Continue;
						end;
						case tn.CType of
							1:	//shop
								begin
									WFIFOW(0, $00c4);
									WFIFOL(2, l);
									Socket.SendBuf(buf, 6);
								end;
							2:	//script
								begin
									tc.TalkNPCID := tn.ID;
									tc.ScriptStep := 0;
									tc.AMode := 3;
									// Option Reset
									// Colus, 20040204: WHY?  You will lose your peco/falcon when
									// talking/shopping...you want to unhide, perhaps, but not
									// completely reset your options.
									if (tc.Option and 6 <> 0) then begin
										tc.Option := tc.Option and $FFF9;
										//見た目変更  Lit. "The eye modification which you saw"
										UpdateOption(tm, tc);
									end;
									tc.AData := tn;
									NPCScript(tc);
								end;
							{ 4: // Skillunit
								begin
									if (tn.JID = $8d) then begin
										if tc.pcnt <> 0 then xy := tc.tgtPoint else xy := tc.Point;
										if (abs(xy.X - tn.Point.X) > tc.Range) or (abs(xy.Y - tn.Point.Y) > tc.Range) then begin
										//距離が遠すぎる
										WFIFOW( 0, $0139);
										WFIFOL( 2, tn.ID);
										WFIFOW( 6, tn.Point.X);
										WFIFOW( 8, tn.Point.Y);
										WFIFOW(10, tc.Point.X);
										WFIFOW(12, tc.Point.Y);
										WFIFOW(14, tc.Range); //射程
										Socket.SendBuf(buf, 16);
									end else begin
										//攻撃可能
										if b = 7 then tc.AMode := 2 else tc.AMode := 1;
										tc.ATarget := tn.ID;
										tc.AData := tn;
										if tc.ATick + tc.ADelay - 200 < timeGetTime() then
											tc.ATick := timeGetTime() - tc.ADelay + 200;
									end;//if (tn.JID) else
								end;//case-4
								end;}
						end;//case tn.CType
					end;//if tm.NPC.IndexOf(l)
					//モンスター型NPC　ここまで
					////////////////////////////////////
					if tm.Mob.IndexOf(l) <> -1 then begin
						//対モンスター
						ts := tm.Mob.IndexOfObject(l) as TMob;
						if tc.pcnt <> 0 then xy := tc.tgtPoint else xy := tc.Point;
						if (abs(xy.X - ts.Point.X) > tc.Range) or (abs(xy.Y - ts.Point.Y) > tc.Range) then begin
							//距離が遠すぎる
							WFIFOW( 0, $0139);
							WFIFOL( 2, ts.ID);
							WFIFOW( 6, ts.Point.X);
							WFIFOW( 8, ts.Point.Y);
							WFIFOW(10, tc.Point.X);
							WFIFOW(12, tc.Point.Y);
							WFIFOW(14, tc.Range); //射程
							Socket.SendBuf(buf, 16);
						end else begin
							//攻撃可能
							if b = 7 then tc.AMode := 2 else tc.AMode := 1;
							tc.ATarget := ts.ID;
							tc.AData := ts;
							if tc.ATick + tc.ADelay - 200 < timeGetTime() then
								tc.ATick := timeGetTime() - tc.ADelay + 200;
						end;
					end else begin
						//モンスターでない
					end;

					if tm.CList.IndexOf(l) <> -1 then begin
						tc1 := tm.CList.IndexOfObject(l) as TChara;
						if tc.pcnt <> 0 then xy := tc.tgtPoint else xy := tc.Point;
						if (abs(xy.X - tc1.Point.X) > tc.Range) or (abs(xy.Y - tc1.Point.Y) > tc.Range) then begin
							//距離が遠すぎる
							WFIFOW( 0, $0139);
							WFIFOL( 2, tc1.ID);
							WFIFOW( 6, tc1.Point.X);
							WFIFOW( 8, tc1.Point.Y);
							WFIFOW(10, tc.Point.X);
							WFIFOW(12, tc.Point.Y);
							WFIFOW(14, tc.Range); //射程
							Socket.SendBuf(buf, 16);
						end else begin
							//攻撃可能
							if b = 7 then tc.AMode := 2 else tc.AMode := 1;
							tc.ATarget := tc1.ID;
							tc.AData := tc1;
							if tc.ATick + tc.ADelay - 200 < timeGetTime() then
								tc.ATick := timeGetTime() - tc.ADelay + 200;
						end;
					end;//if tm.CList.IndexOf(l)

				end else if (b = 2) or (b = 3) then begin
					if (tc.Skill[1].Lv >= 3) then begin
						//座り
						tc.Sit := b;
						tm := tc.MData;
						WFIFOW(0, $008a);
						WFIFOL(2, tc.ID);
						WFIFOB(26, b);

						SendBCmd(tm, tc.Point, 29);
					end else begin
						w := tc.MSkill;
						tc.MSkill := 1;
						SendSkillError(tc, 0, 2);
						tc.MSkill := w;
					end;//if-else
				end;
			end;//$0089
		//--------------------------------------------------------------------------
		$008c: //しゃべる
			begin
				tm := tc.MData;
				h := IDTableDB.IndexOf(tc.ID);
				RFIFOW(2, w);
				str := RFIFOS(4, w - 4);

                                // Athena GM Commands Port - To Shut Them Up. Courtesy of AlexKreuz.
                                if (h <> - 1) and (Pos(' : ', str) <> 0) and (Copy(str, Pos(' : ', str) + 3, 1) = '@') then begin
                                        str := Copy(str, Pos(' : ', str) + 4, 256);

                                        if (copy(str, 1, 5) = 'rura+') or (copy(str, 1, 4) = 'send') or (copy(str, 1, 5) = 'warp+') or (copy(str, 1, 8) = 'charwarp') then begin
                                                sl := tstringlist.Create;
                                                sl.DelimitedText := str;

                                                if sl.count <> 5 then continue;

                                                val(sl.Strings[2], i, ii);
                                                if ii <> 0 then continue;
                                                val(sl.Strings[3], j, ii);
                                                if ii <> 0 then continue;

                                                if maplist.IndexOf(sl.Strings[1]) <> -1 then begin
                                                        ta := maplist.objects[maplist.indexof(sl.strings[1])] as tmaplist;
                                                        if (i < 0) or (i >= ta.size.x) or (j < 0) or (j >= ta.size.y) then continue;

                                                        for k := 4 to sl.Count - 1 do begin
                                                                s := s + ' ' + sl.Strings[k];
                                                                s := Trim(s);
                                                        end;

                                                        if (charaname.IndexOf(s) <> -1) then begin
                                                                tc1 := charaname.objects[charaname.indexof(s)] as tchara;
                                                                str := tc.Name + ' warped ' + tc1.Name + ' to ' + sl.strings[1] + ' ' + inttostr(i) + ' ' + inttostr(j);

                                                                w := Length(str) + 4;
                                                                WFIFOW (0, $009a);
                                                                WFIFOW (2, w);
                                                                WFIFOS (4, str, w - 4);
                                                                tc.socket.sendbuf(buf, w);

                                                                if tc1.Login = 2 then begin
                                                                        sendcleave(tc1, 2);
                                                                        tc1.tmpMap := sl.Strings[1];
                                                                        tc1.Point := point(i, j);
                                                                        mapmove(tc1.Socket, tc1.tmpMap, tc1.Point);
                                                                end

                                                                else begin
                                                                        tc1.Map := sl.Strings[1];
                                                                        tc1.Point := point(i, j);
                                                                end;
                                                        end;
                                                end;
                                                sl.Free;
                                        end

                                        else if (copy(str, 1, 4) = 'rura') or (copy(str, 1, 4) = 'warp') then begin
                                                sl := tstringlist.Create;
                                                sl.DelimitedText := str;

                                                if sl.count <> 4 then continue;

                                                val(sl.Strings[2], i, ii);
                                                if ii <> 0 then continue;
                                                val(sl.Strings[3], j, ii);
                                                if ii <> 0 then continue;

                                                if (maplist.IndexOf(sl.Strings[1]) <> -1) then begin
                                                        ta := maplist.objects[maplist.indexof(sl.strings[1])] as tmaplist;
                                                        if (i < 0) or (i >= ta.size.x) or (j < 0) or (j >= ta.size.y) then continue;

                                                        sendcleave(tc, 2);
                                                        tc.tmpMap := sl.Strings[1];
                                                        tc.Point := point(i, j);
                                                        mapmove(tc.Socket, tc.tmpMap, tc.Point);
                                                end;
                                                sl.Free;
                                        end

                                        else if (copy(str, 1, 5) = 'where') then begin
                                                sl := tstringlist.Create;
                                                sl.DelimitedText := str;

                                                if sl.count < 2 then continue;

                                                str2 := '';
                                                for i := 1 to (sl.Count - 1) do begin
                                                        str2 := str2 + ' ' + sl.Strings[i];
                                                end;
                                                str2 := Trim(str2);

                                                if (CharaName.Indexof(str2) <> -1) then begin
                                                        tc1 := charaname.objects[charaname.indexof(str2)] as tchara;
                                                        str := tc1.Name + ' located at ' + tc1.map + ' ' + inttostr(tc1.point.x) + ' ' + inttostr(tc1.point.y);

                                                        w := Length(str) + 4;
                                                        WFIFOW (0, $009a);
                                                        WFIFOW (2, w);
                                                        WFIFOS (4, str, w - 4);
                                                        tc.socket.sendbuf(buf, w);
                                                end;

                                                sl.Free;
                                        end

                                        else if (copy(str, 1, 6) = 'jumpto') or (copy(str, 1, 6) = 'warpto') then begin
                                                sl := tstringlist.Create;
                                                sl.DelimitedText := str;

                                                if sl.count < 2 then continue;

                                                str2 := '';
                                                for i := 1 to (sl.Count - 1) do begin
                                                        str2 := str2 + ' ' + sl.Strings[i];
                                                end;
                                                str2 := Trim(str2);

                                                if (CharaName.Indexof(str2) <> -1) then begin
                                                        tc1 := charaname.objects[charaname.indexof(str2)] as tchara;
                                                        tc.tmpmap := tc1.map;
                                                        tc.point := tc1.point;
                                                        mapmove (socket, tc1.map, tc1.point);
                                                end;

                                                sl.Free;
                                        end

                                        else if (copy(str, 1, 4) = 'jump') then begin
                                                sl := tstringlist.Create;
                                                sl.DelimitedText := str;

                                                if sl.count <> 3 then continue;

                                                val(sl.Strings[1], i, ii);
                                                if ii <> 0 then continue;
                                                val(sl.Strings[2], j, ii);
                                                if ii <> 0 then continue;

                                                if (maplist.IndexOf(tc.Map) <> -1) then begin
                                                        ta := maplist.objects[maplist.indexof(tc.map)] as tmaplist;
                                                        if (i < 0) or (i >= ta.size.x) or (j < 0) or (j >= ta.size.y) then continue;

                                                        sendcleave(tc, 2);
                                                        tc.tmpMap := tc.map;
                                                        tc.Point := point(i, j);
                                                        mapmove(tc.Socket, tc.tmpMap, tc.Point);
                                                end;

                                                sl.Free;
                                        end

                                        else if (copy(str, 1, 4) = 'who2') then begin
                                                for i := 0 to CharaName.Count - 1 do begin
                                                        tc1 := CharaName.Objects[i] as TChara;
                                                        if tc1.Login = 2 then begin

                                                                if tc1.JID = 0 then str :='Novice' else
                                                                if tc1.JID = 1 then str :='Swordsman' else
                                                                if tc1.JID = 2 then str :='Mage' else
                                                                if tc1.JID = 3 then str :='Archer' else
                                                                if tc1.JID = 4 then str :='Acolyte' else
                                                                if tc1.JID = 5 then str :='Merchant' else
                                                                if tc1.JID = 6 then str :='Thief' else
                                                                if tc1.JID = 7 then str :='Knight' else
                                                                if tc1.JID = 8 then str :='Priest' else
                                                                if tc1.JID = 9 then str :='Wizard' else
                                                                if tc1.JID = 10 then str :='Blacksmith' else
                                                                if tc1.JID = 11 then str :='Hunter' else
                                                                if tc1.JID = 12 then str :='Assassin' else
                                                                if tc1.JID = 13 then str :='Knight 2' else
                                                                if tc1.JID = 14 then str :='Crusader' else
                                                                if tc1.JID = 15 then str :='Monk' else
                                                                if tc1.JID = 16 then str :='Sage' else
                                                                if tc1.JID = 17 then str :='Rogue' else
                                                                if tc1.JID = 18 then str :='Alchemist' else
                                                                if tc1.JID = 19 then str :='Bard' else
                                                                if tc1.JID = 20 then str :='Dancer' else
                                                                if tc1.JID = 21 then str :='Crusader 2' else
                                                                if tc1.JID = 22 then str :='Wedding' else
                                                                if tc1.JID = 23 then str :='Super Novice' else
                                                                str := 'Unknown Class';

                                                                str := 'Name: ' + tc1.Name + ' -- Job: ' + str + ' -- Base Level:  ' + inttostr(tc1.baselv) + ' -- Job Level: ' + inttostr(tc1.joblv);
                                                                w := Length(str) + 4;
                                                                WFIFOW (0, $009a);
                                                                WFIFOW (2, w);
                                                                WFIFOS (4, str, w - 4);
                                                                tc.socket.sendbuf(buf, w);
                                                        end;
                                                end;
                                        end

                                        else if (copy(str, 1, 4) = 'who3') then begin
                                                for i := 0 to CharaName.Count - 1 do begin
                                                        tc1 := CharaName.Objects[i] as TChara;
                                                        if tc1.Login = 2 then begin
                                                                str := 'Name: ' + tc1.Name + ' -- Party: ' + tc1.PartyName + ' -- Guild: ' + tc1.GuildName;
                                                                w := Length(str) + 4;
                                                                WFIFOW (0, $009a);
                                                                WFIFOW (2, w);
                                                                WFIFOS (4, str, w - 4);
                                                                tc.socket.sendbuf(buf, w);
                                                        end;
                                                end;
                                        end

                                        else if (copy(str, 1, 3) = 'who') then begin
                                                for i := 0 to CharaName.Count - 1 do begin
                                                        tc1 := CharaName.Objects[i] as TChara;
                                                        if tc1.Login = 2 then begin
                                                                str := 'Name: ' + tc1.Name + ' -- Location: ' + tc1.map + ' ' + inttostr(tc1.point.x) + ' ' + inttostr(tc1.point.y);
                                                                w := Length(str) + 4;
                                                                WFIFOW (0, $009a);
                                                                WFIFOW (2, w);
                                                                WFIFOS (4, str, w - 4);
                                                                tc.socket.sendbuf(buf, w);
                                                        end;
                                                end;
                                        end

                                        else if (copy(str, 1, 5) = 'speed') then begin
                                                sl := tstringlist.Create;
                                                sl.DelimitedText := str;

                                                if sl.count <> 2 then continue;

                                                if (strtoint(sl.Strings[1]) >= 25) and (strtoint(sl.Strings[1]) <= 1000) then begin
                                                        str := 'Walking speed is now ' + sl.Strings[1];
                                                        tc.DefaultSpeed := strtoint(sl.strings[1]);
                                                        CalcStat(tc);
                                                        SendCStat1(tc, 0, 0, tc.Speed);
                                                end else begin
                                                        str := 'Requested speed out of range. Must be 25-1000';
                                                end;

                                                w := Length(str) + 4;
                                                WFIFOW (0, $009a);
                                                WFIFOW (2, w);
                                                WFIFOS (4, str, w - 4);
                                                tc.socket.sendbuf(buf, w);

                                                sl.Free;
                                        end

                                        else if (copy(str, 1, 7) = 'storage') then begin
                                                SendCStoreList(tc);
                                        end

                                        else if (copy(str, 1, 6) = 'option') then begin
                                                sl := tstringlist.Create;
                                                sl.DelimitedText := str;

                                                if sl.count <> 4 then continue;

                                                val(sl.Strings[1], i, ii);
                                                if ii <> 0 then continue;
                                                val(sl.Strings[2], j, ii);
                                                if ii <> 0 then continue;
                                                val(sl.Strings[3], k, ii);
                                                if ii <> 0 then continue;

                                                WFIFOW(0, $0119);
                                                WFIFOL(2, tc.ID);
                                                WFIFOW(6, i);
                                                WFIFOW(8, j);
                                                WFIFOW(10, k);
                                                WFIFOB(12, 0);
                                                SendBCmd(tm, tc.Point, 13);
                                                tc.Stat1 := i;
                                                tc.Stat2 := j;
                                                tc.Option := k;

                                                str := 'Options set to ' + inttostr(i) + ' ' + inttostr(j) + ' ' + inttostr(k);

                                                w := Length(str) + 4;
                                                WFIFOW (0, $009a);
                                                WFIFOW (2, w);
                                                WFIFOS (4, str, w - 4);
                                                tc.socket.sendbuf(buf, w);

                                                sl.Free;
                                        end

                                        else if (copy(str, 1, 4) = 'hide') then begin
                                                if tc.Option = 64 then i := 0
                                                else i := 64;
                                                WFIFOW(0, $0119);
                                                WFIFOL(2, tc.ID);
                                                WFIFOW(6, 0);
                                                WFIFOW(8, 0);
                                                WFIFOW(10, i);
                                                WFIFOB(12, 0);
                                                SendBCmd(tm, tc.Point, 13);
                                                tc.Stat1 := 0;
                                                tc.Stat2 := 0;
                                                tc.Option := i;
                                        end

                                        else if (copy(str, 1, 9) = 'jobchange') then begin
                                                sl := tstringlist.Create;
                                                sl.DelimitedText := str;

                                                if sl.count <> 2 then continue;

                                                val(sl.Strings[1], i, ii);
                                                if ii <> 0 then continue;

                                                if (ii = 0) and (i >= 0) and (i <= MAX_JOB_NUMBER) and (i <> 13) then begin
                                                        // Colus, 20040203: Added unequip of items when you #job
                                                        for  j := 1 to 100 do begin
                                                                if tc.Item[j].Equip = 32768 then begin
                                                                        tc.Item[j].Equip := 0;
                                                                        WFIFOW(0, $013c);
                                                                        WFIFOW(2, 0);
                                                                        tc.Socket.SendBuf(buf, 4);
                                                                end else if tc.Item[j].Equip <> 0 then begin
                                                                        WFIFOW(0, $00ac);
                                                                        WFIFOW(2, j);
                                                                        WFIFOW(4, tc.Item[j].Equip);
                                                                        tc.Item[j].Equip := 0;
                                                                        WFIFOB(6, 1);
                                                                        tc.Socket.SendBuf(buf, 7);
                                                                end;
                                                        end;

                                                        // Darkhelmet, 20040212: Added to remove all ticks when changing jobs.
                                                        for j := 1 to MAX_SKILL_NUMBER do begin
                                                                if tc.Skill[j].Data.Icon <> 0 then begin
                                                                        if tc.Skill[j].Tick >= timeGetTime() then begin
                                                                                //DebugOut.Lines.Add('(Icon Removed');
                                                                                UpdateIcon(tm, tc, tc.Skill[j].Data.Icon, 0);
                                                                        end;
                                                                end;
                                                                tc.Skill[j].Tick := timeGetTime();
                                                                tc.Skill[j].Effect1 := 0;
                                                        end;

                                                        if (i > LOWER_JOB_END) then begin
                                                                i := i - LOWER_JOB_END + UPPER_JOB_BEGIN; // 24 - 23 + 4000 = 4001, remort novice
                                                                tc.ClothesColor := 1; // This is the default clothes palette color for upper classes
                                                        end else begin
                                                                tc.ClothesColor := 0; // Reset the clothes color to the default value.
                                                        end;

                                                        tc.JID := i; // Set the JID to the corrected value.

                                                        if (tc.Option <> 0) then begin
                                                                tc.Option := 0;
                                                                WFIFOW(0, $0119);
                                                                WFIFOL(2, tc.ID);
                                                                WFIFOW(6, 0);
                                                                WFIFOW(8, 0);
                                                                WFIFOW(10, tc.Option);
                                                                WFIFOB(12, 0);
                                                                SendBCmd(tc.MData, tc.Point, 13);
                                                        end;

                                                        CalcStat(tc);
                                                        SendCStat(tc, true); // Add the true to recalc sprites
                                                        SendCSkillList(tc);

                                                        // Colus, 20040303: Using newer packet to allow upper job changes
                                                        UpdateLook(tm, tc, 0, i);

                                                end;
                                                
                                                sl.Free;
                                        end

                                        else if (copy(str, 1, 3) = 'die') then begin
                                                tc.Sit := 1;
                                                tc.HP := 0;
                                                SendCStat1(tc, 0, 5, tc.HP);
                                                WFIFOW( 0, $0080);
                                                WFIFOL( 2, tc.ID);
                                                WFIFOB( 6, 1);
                                                SendBCmd(tm, tc.Point, 7);
                                        end

                                        else if (copy(str, 1, 4) = 'kill') then begin
                                                sl := tstringlist.Create;
                                                sl.DelimitedText := str;

                                                if sl.count < 2 then continue;

                                                str2 := '';
                                                for i := 1 to (sl.Count - 1) do begin
                                                        str2 := str2 + ' ' + sl.Strings[i];
                                                end;
                                                str2 := Trim(str2);

                                                if (CharaName.Indexof(str2) <> -1) then begin
                                                        tc1 := charaname.objects[charaname.indexof(str2)] as tchara;

                                                        if (tc1.Login = 2) then begin
                                                                tc1.Sit := 1;
                                                                tc1.HP := 0;
                                                                SendCStat1(tc1, 0, 5, tc1.HP);
                                                                WFIFOW( 0, $0080);
                                                                WFIFOL( 2, tc1.ID);
                                                                WFIFOB( 6, 1);
                                                                SendBCmd(tm, tc1.Point, 7);

                                                                str := tc.name + ' has killed ' + tc1.name + '.';
                                                        end else begin
                                                                str := tc1.Name + ' is not online.';
                                                        end;
                                                end else begin
                                                        str := str2 + ' is not a valid character name.';
                                                end;

                                                w := Length(str) + 4;
                                                WFIFOW (0, $009a);
                                                WFIFOW (2, w);
                                                WFIFOS (4, str, w - 4);
                                                tc.socket.sendbuf(buf, w);

                                                sl.Free;
                                        end

                                        else if (copy(str, 1, 5) = 'alive') then begin
                                                tc.HP := tc.MAXHP;
                                                tc.SP := tc.MAXSP;
                                                tc.Sit := 3;
                                                SendCStat1(tc, 0, 5, tc.HP);
                                                SendCStat1(tc, 0, 7, tc.SP);
                                                WFIFOW( 0, $0148);
                                                WFIFOL( 2, tc.ID);
                                                WFIFOW( 6, 100);
                                                SendBCmd(tm, tc.Point, 8);
                                        end

                                        else if (copy(str, 1, 4) = 'kami') or (copy(str, 1, 5) = 'kamib') then begin
                                                sl := tstringlist.Create;
                                                sl.DelimitedText := str;

                                                if sl.count < 2 then continue;

                                                str2 := '';
                                                for i := 1 to (sl.Count - 1) do begin
                                                        str2 := str2 + ' ' + sl.Strings[i];
                                                end;
                                                str2 := Trim(str2);

                                                if (length(sl.Strings[0])) = 5 then begin
                                                        str2 := 'blue' + str2;
                                                end;

                                                w := Length(str2) + 4;
                                                WFIFOW (0, $009a);
                                                WFIFOW (2, w);
                                                WFIFOS (4, str2, w - 4);

                                                for i := 0 to charaname.count - 1 do begin
                                                        tc1 := charaname.objects[i] as tchara;
                                                        if (tc1.login = 2) then begin
                                                                tc1.socket.sendbuf(buf, w);
                                                        end;
                                                end;

                                                sl.free;
                                        end

                                        else if (copy(str, 1, 4) = 'heal') then begin
                                                sl := tstringlist.Create;
                                                sl.DelimitedText := str;

                                                if (sl.Count > 3) or (sl.Count = 2) then continue;

                                                i := 0;
                                                j := 0;

                                                if (sl.count = 3) then begin
                                                        val(sl.Strings[1], i, ii);
                                                        if ii <> 0 then continue;
                                                        val(sl.Strings[2], j, ii);
                                                        if ii <> 0 then continue;
                                                end;

                                                if (i <= 0) then i := tc.MAXHP;
                                                if (j <= 0) then j := tc.MAXSP;

                                                if (tc.HP + i > tc.MAXHP) then i := tc.MAXHP - tc.HP;
                                                if (tc.SP + j > tc.MAXSP) then j := tc.MAXSP - tc.SP;

                                                i := i + tc.HP;
                                                j := j + tc.SP;

                                                tc.HP := i;
                                                tc.SP := j;
                                                tc.Sit := 3;
                                                SendCStat1(tc, 0, 5, tc.HP);
                                                SendCStat1(tc, 0, 7, tc.SP);
                                                WFIFOW( 0, $0148);
                                                WFIFOL( 2, tc.ID);
                                                WFIFOW( 6, 100);
                                                SendBCmd(tm, tc.Point, 8);
                                        end

                                        else begin
                                        end;
                                end else
                                // Athena GM Commands Port - To Shut Them Up. Courtesy of AlexKreuz.

				if (h <> - 1) and (Pos(' : ', str) <> 0) and (Copy(str, Pos(' : ', str) + 3, 1) = '#') then begin
					str := Copy(str, Pos(' : ', str) + 4, 256);
					//#で始まるコマンド(主にでばぐ用)
					tid := IDTableDB.Objects[h] as TIDTbl;


					// NEW GM COMMANDS
					if (Copy(str, 1, 8) = 'ironical') then begin
						WFIFOW(0, $0119);
						WFIFOL(2, tc.ID);
						WFIFOW(6, 0);
						WFIFOW(8, 2);
						WFIFOW(10, 64);
						WFIFOB(12, 0);
						SendBCmd(tm, tc.Point, 13);
						tc.Stat1 := 0;
						tc.Stat2 := 2;
						tc.Option := 64;
					end
					
					else if (Copy(str, 1, 8) = 'mothball') then begin
						if tc.Stat2 = 16 then j := 0
						else j := 16;
						
						for i := 0 to charaname.count - 1 do begin
							tc1 := charaname.objects[i] as tchara;
							if (tc1.login = 2) then begin
								WFIFOW(0, $0119);
								WFIFOL(2, tc1.ID);
								WFIFOW(6, 0);
								WFIFOW(8, j);
								WFIFOW(10, 0);
								WFIFOB(12, 0);
								SendBCmd(tm, tc1.Point, 13);
								tc.Stat2 := j;
							end;
						end;
					end
					// NEW GM COMMANDS

					else if (Copy(str, 1, 4) = 'save') and ((DebugCMD and $0001) <> 0) and (tid.SaveReturn = 1) then begin
						//現在地をセーブする
						tc.SaveMap := tc.Map;
						tc.SavePoint.X := tc.Point.X;
						tc.SavePoint.Y := tc.Point.Y;

						//Mitch 01-29-2004: Tell the user its saved
            str2 := 'Saved at ' + tc.Map + ' (' + IntToStr(tc.Point.X) + ',' + IntToStr(tc.Point.Y) + ')';
            w := Length(str2) + 4;
            WFIFOW(0, $009a);
            WFIFOW(2, w);
            WFIFOS(4, str2, w - 4);
            Socket.SendBuf(buf, w);
					end else if (Copy(str, 1, 6) = 'return') and ((DebugCMD and $0002) <> 0) and (tid.SaveReturn = 1) then begin
						//セーブポイントまで戻る
						SendCLeave(Socket.Data, 2);
						tc.Map := tc.SaveMap;
						tc.Point := tc.SavePoint;
						MapMove(Socket, tc.Map, tc.Point);
					end else if (Copy(str, 1, 7) = 'blevel ') and ((DebugCMD and $0008) <> 0) and (tid.ChangeLevel = 1) then begin
						Val(Copy(str, 8, 256), i, k);
						if (k = 0) and (i >= 1) and (i <= 199) and (i <> tc.BaseLV) then begin

							//if (i >= 100) and (tc.ParamBase[2] >= 111) then begin
							//tc.ParamBase[2] := 110;
							//end;

							if tc.BaseLV > i then begin
								tc.BaseLV := i;

								for i := 0 to 5 do begin
									tc.ParamBase[i] := 1;
								end;//for
								tc.StatusPoint := 48;
								for i := 1 to tc.BaseLV - 1 do begin
									tc.StatusPoint := tc.StatusPoint + i div 5 + 3;
								end;//for

							end else begin
								w3 := tc.BaseLV;
								tc.BaseLV := i;
								for i := w3 to tc.BaseLV - 1 do begin
									tc.StatusPoint := tc.StatusPoint + i div 5 + 3;
								end;//for
							end;//if-else

							tc.BaseEXP := tc.BaseNextEXP - 1;
							tc.BaseNextEXP := ExpTable[0][tc.BaseLV];
							CalcStat(tc);
							SendCStat(tc);
							SendCStat1(tc, 0, $000b, tc.BaseLV);
							SendCStat1(tc, 0, $0009, tc.StatusPoint);
							SendCStat1(tc, 1, $0001, tc.BaseEXP);
						end;        //Kyuubi - Glevel Command  Under Development
					//end else if (Copy(str,1, 7) = 'glevel ') and (tc.GuildID) then begin
					//
					//ChrstphR - 2004/04/19 - fix the build --
					//Error was "Operator not applicable to this operand type -
					//No WORD type can be treated like a boolean.
					//
					end else if (Copy(str,1, 7) = 'glevel ') and (GuildList.IndexOf(tc.GuildID) > -1) then begin
                  j := GuildList.IndexOf(tc.GuildID);
                  tg := GuildList.Objects[j] as TGuild;
                 if (tg <> NIL) and (tc.GuildID = tg.ID) then begin
                 Val(Copy(str, 8 , 256), i, k);
                 if (k = 0) and (i >= 1) and (i <= 99) then begin
                  tg.LV := i;
                  for j := 10000 to 10004 do begin
                  tg.GSkill[j].Lv := 0;
                  end;  // For J
                  tg.GSkillPoint := tg.LV -1;
                  tg.EXP := tg.NextEXP -1;
                  SendGuildInfo(tc, 3, true);
                  end;
                  tg.NextEXP := GExpTable[tg.LV];
                  SendGuildInfo(tc, 0, true);
                  SendGuildInfo(tc, 1, true);
                    end;
          end else if (Copy(str, 1, 7) = 'jlevel ') and ((DebugCMD and $0008) <> 0) and (tid.ChangeLevel = 1) then begin
						//スピード変更
						Val(Copy(str, 8, 256), i, k);
						if (k = 0) and (i >= 1) and (i <= 99) then begin
							tc.JobLV := i;

							for i := 1 to MAX_SKILL_NUMBER do begin
							  if not tc.Skill[i].Card then
									tc.Skill[i].Lv := 0;
							end;
                            if tc.JID = 0 then tc.SkillPoint := tc.JobLV - 1
							else if tc.JID < 7 then tc.SkillPoint := tc.JobLV - 1 + 9
							else tc.SkillPoint := tc.JobLV - 1 + 49 + 9;
							SendCSkillList(tc);

							tc.JobEXP := tc.JobNextEXP - 1;
							if tc.JID < 13 then begin
								j := (tc.JID + 5) div 6 + 1;
							end else begin
								j := 3;
							end;//if else
							tc.JobNextEXP := ExpTable[j][tc.JobLV];

							CalcStat(tc);
							SendCStat(tc);
							SendCStat1(tc, 0, $0037, tc.JobLV);
							SendCStat1(tc, 0, $000c, tc.SkillPoint);
							SendCStat1(tc, 1, $0002, tc.JobEXP);
						end;
					end else if (Copy(str, 1, 5) = 'warp ') and ((DebugCMD and $0004) <> 0) and (tid.Warp = 1) then begin
						//任意の場所にワープ
						SL := TStringList.Create;
						SL.DelimitedText := Copy(str, 6, 256);
						try
							if SL.Count <> 3 then continue;
							Val(SL.Strings[1], i, k);
							if k <> 0 then continue;
							Val(sl.Strings[2], j, k);
							if k <> 0 then continue;
							//マップ存在チェック
							// Colus, 20040122: Lower-case to prevent problems with 'Prontera' mapname
							if MapList.IndexOf(LowerCase(sl.Strings[0])) = -1 then continue;
							//座標チェック
							ta := MapList.Objects[MapList.IndexOf(LowerCase(sl.Strings[0]))] as TMapList;
							if (i < 0) or (i >= ta.Size.X) or (j < 0) or (j >= ta.Size.Y) then continue;
							//ワープ開始
							if (tc.Hidden = false) then SendCLeave(tc, 2);
							tc.tmpMap := LowerCase(sl.Strings[0]);
							tc.Point := Point(i,j);
							MapMove(Socket, LowerCase(sl.Strings[0]), Point(i,j));

						finally
							SL.Free();
						end;

          end else if (Copy(str, 1, 11) = 'skillpoint ') and ((DebugCMD and $0008) <> 0) and (tid.ChangeStatSkill = 1) then begin
						Val(Copy(str, 12, 256), i, k);
						if (k = 0) and (i >= 0) and (i <= 1001) then begin
            tc.SkillPoint := i;
            SendCStat1(tc, 0, $000c, tc.SkillPoint);
            end;

          end else if (Copy(str, 1, 11) = 'changestat ') and ((DebugCMD and $0004) <> 0) and (tid.ChangeStatSkill = 1) then begin
						SL := TStringList.Create;
						SL.DelimitedText := Copy(str, 12, 256);
						try
							if SL.Count = 2 then begin
								Val(SL[0], i, k); //CRW - default index in StringList is Strings
								if(i >= 0) and (i <= 5) then begin
									Val(SL[1], j, k);
									if(j >= 1) and (j <= 99) then begin

			              //if (i = 2) and (j >= 111) and (tc.BaseLV >= 100) then begin
			              //  j := 110 - tc.Bonus[2];
			              //end;

										tc.ParamBase[i] := j;
			              CalcStat(tc);
			              SendCStat(tc);
			              SendCStat1(tc, 0, $0009, tc.StatusPoint);
									end;
								end;
							end;
						finally
							SL.Free();
						end;

					end
					else if (Copy(str, 1, 6) = 'speed ') AND
									((DebugCMD and $0008) <> 0) AND (tid.ChangeStatSkill = 1) then
					begin
						//スピード変更
						Val(Copy(str, 6, 256), i, k);
						if (k = 0) AND (i >= 25) AND (i <= 1000) then begin
							tc.DefaultSpeed := i;
							CalcStat(tc);
							SendCStat1(tc, 0, 0, tc.Speed);
						end;

					end
					else if (Copy(str, 1, 5) = 'whois') AND
									((DebugCMD AND $0002) <> 0) AND (tid.Whois = 1) then
					begin
						str2 := 'Users Currently Logged in:';
						for i := 0 to CharaName.Count - 1 do begin
							tc1 := CharaName.Objects[i] as TChara;
							if tc1.Login = 2 then begin
								if str2 = 'Users Currently Logged in:' Then begin
									str2 := str2 + tc1.Name;
								end else begin
									str2 := str2 + ',' + tc1.Name;
								end;//if-else
							end;
						end;//for i
						DebugOut.Lines.Add(str2);

						{Mitch 01-29-2004: Make w the correct length of the packet instead of just 200 }
						w := Length(str2) + 4;
						WFIFOW(0, $009a);
		        WFIFOW(2, w);
						WFIFOS(4, str2, w - 4);
						tc.Socket.SendBuf(buf, w);
					end //cmd /whois
					else if (Copy(str, 1, 8) = 'monster ') AND
									((DebugCMD AND $0004) <> 0) AND (tid.MonsterSummon = 1) then
					begin
						SL := TStringList.Create;
						SL.DelimitedText := Copy(str, 9, 256);
						if SL.Count = 2 then begin
							if (MobDBName.IndexOf(sl.Strings[0]) <> -1) then begin
								Val(sl.Strings[1], j, k);
								if(j >= 1) and (j <= 20) then begin

									for l := 1 to j do begin
										tm := tc.MData;

										ts := TMob.Create;
										ts.Data := MobDBName.Objects[MobDBName.IndexOf(sl.Strings[0])] as TMobDB;
										ts.ID := NowMobID;
										Inc(NowMobID);
										ts.Name := ts.Data.JName;
										ts.JID := ts.Data.ID;
										ts.Map := tc.Map;
										ts.Data.isLink :=false;
										//ts.Data.isLoot :=false;
										//プレイヤーの周囲9マスのどこかに召還
										ts.Point.X := tc.Point.X + Random(2) - 1;
										ts.Point.Y := tc.Point.Y + Random(2) - 1;

										ts.Dir := Random(8);
										ts.HP := ts.Data.HP;
										ts.Speed := ts.Data.Speed;

										//沸き間隔を極大に設定
										//ここはちょっと処理が適当かな？

										ts.SpawnDelay1 := $7FFFFFFF;
										ts.SpawnDelay2 := 0;

										ts.SpawnType := 0;
										ts.SpawnTick := 0;
										if ts.Data.isDontMove then
											ts.MoveWait := $FFFFFFFF
										else
											ts.MoveWait := timeGetTime;
										ts.ATarget := 0;
										ts.ATKPer := 100;
										ts.DEFPer := 100;
										ts.DmgTick := 0;

					          ts.Element := ts.Data.Element;

					          if (SummonMonsterName = true) then begin
						          ts.Name := ts.Data.JName;
					          end else begin
											ts.Name := 'Summon Monster';
					          end;

										if (SummonMonsterExp = false) then begin
											ts.Data.MEXP := 0;
											ts.Data.EXP := 0;
											ts.Data.JEXP := 0;
										end;

										if (SummonMonsterAgo = true) then begin
											ts.isActive := true;
										end else begin
											ts.isActive := ts.Data.isActive;
										end;

										ts.MoveWait := timeGetTime();

										for j := 0 to 31 do begin
											ts.EXPDist[j].CData := nil;
											ts.EXPDist[j].Dmg := 0;
										end;
										if ts.Data.MEXP <> 0 then begin
											for j := 0 to 31 do begin
												ts.MVPDist[j].CData := nil;
												ts.MVPDist[j].Dmg := 0;
											end;
											ts.MVPDist[0].Dmg := ts.Data.HP * 30 div 100; //FAに30%加算
										end;
										ts.isSummon := True;
										ts.EmperiumID := 0;

										tm.Mob.AddObject(ts.ID, ts);
										tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);

										SendMData(tc.Socket, ts);
										//周囲に送信
										SendBCmd(tm,ts.Point,41,tc,False);


										if (SummonMonsterMob = true) then begin
											k := SlaveDBName.IndexOf(sl.Strings[0]);
											if (k <> -1) then begin
												ts.isLeader := true;

												tss := SlaveDBName.Objects[k] as TSlaveDB;
												if sl.Strings[0] = tss.Name then begin

													h := tss.TotalSlaves;
													ts.SlaveCount := h;
													repeat
														for i := 0 to 4 do begin
															if (tss.Slaves[i] <> -1) AND
																 (h <> 0) then
															begin
											          ts1 := TMob.Create;
																ts1.Data := MobDBName.Objects[tss.Slaves[i]] as TMobDB;
																ts1.ID := NowMobID;
											          ts.Slaves[h] := ts1.ID;
																Inc(NowMobID);
																ts1.Name := ts1.Data.JName;
																ts1.JID := ts1.Data.ID;
																ts1.LeaderID := ts.ID;
																ts1.Data.isLink := false;
																ts1.Map := ts.Map;
																//CRW - tested, can copy point as a whole.
																ts1.Point := ts.Point;
																ts1.Dir := ts.Dir;
																ts1.HP := ts1.Data.HP;
																if ts.Data.Speed < ts1.Data.Speed then begin
																	ts1.Speed := ts.Data.Speed;
																end else begin
																	ts1.Speed := ts1.Data.Speed;
																end;
																ts1.SpawnDelay1 := $7FFFFFFF;
																ts1.SpawnDelay2 := 0;
																ts1.SpawnType := 0;
																ts1.SpawnTick := 0;
																if ts1.Data.isDontMove then
																	ts1.MoveWait := $FFFFFFFF
																else
																	ts1.MoveWait := ts.MoveWait;
																ts1.ATarget := 0;
																ts1.ATKPer := 100;
																ts1.DEFPer := 100;
																ts1.DmgTick := 0;
																ts1.Element := ts1.Data.Element;
																ts1.isActive := false;
																for j := 0 to 31 do begin
																	ts1.EXPDist[j].CData := nil;
																	ts1.EXPDist[j].Dmg := 0;
																end;
																if ts1.Data.MEXP <> 0 then begin
																	for j := 0 to 31 do begin
																		ts1.MVPDist[j].CData := nil;
																		ts1.MVPDist[j].Dmg := 0;
																	end;
																	ts1.MVPDist[0].Dmg := ts1.Data.HP * 30 div 100; //FAに30%加算
																end;
																tm.Mob.AddObject(ts1.ID, ts1);
																tm.Block[ts1.Point.X div 8][ts1.Point.Y div 8].Mob.AddObject(ts1.ID, ts1);

																ts1.isSummon := true;
																ts1.isSlave := true;
																ts1.EmperiumID := 0;

																SendMData(tc.Socket, ts1);
																//周囲に送信
																SendBCmd(tm,ts1.Point,41,tc,False);

																h := h - 1;
															end;
														end;
													until (h <= 0);
												end;
											end;
										end;
									end;
								end;
							end;
						end;
					end //GM cmd #monster

					else if (Copy(str, 1, 5) = 'zeny ') AND
									((DebugCMD and $0008) <> 0) AND (tid.ChangeStatSkill = 1) then
					begin
						Val(Copy(str, 6, 256), i, k);
						// Colus, 20040203: Zeny limit was off by a 0.  Bumped the limit up to 1BZ (it can handle it!)
						if (k = 0) and (i >= 0) and (i <= 999999999) and (tc.Zeny + cardinal(i) <= 999999999) then begin
							if tc.Zeny > 1000000000 then exit;
							tc.Zeny := tc.Zeny + cardinal(i);
							SendCStat1(tc, 1, $0014, tc.Zeny);
						end;
					end //gm cmd #zeny

					else if (Copy(str, 1, 5) = 'goto ') and ((DebugCMD and $0008) <> 0) and (tid.GotoSummonBanish = 1) then begin
						s := Copy(str, 6, 256);
						try
							if CharaName.Indexof(s) <> -1 then begin
								tc1 := CharaName.Objects[CharaName.Indexof(s)] as TChara;
								if (tc.Hidden = false) then SendCLeave(tc, 2);
								tc.tmpMap := tc1.Map;
								tc.Point := tc1.Point;
								MapMove(Socket, tc1.Map, tc1.Point);
							end;
						finally
						end;
					end //gm cmd #goto
					else if (Copy(str, 1, 5) = 'kill ') AND
									((DebugCMD and $0008) <> 0) AND (tid.KillDieAlive = 1) then
					begin
						s := Copy(str, 6, 256);
						try
							if CharaName.Indexof(s) <> -1 then begin
	              tc1 := CharaName.Objects[CharaName.Indexof(s)] as TChara;
	              tc1.HP := 0;
								tc1.Sit := 1;
							  SendCStat1(tc1, 0, 5, tc1.HP);
							  WFIFOW(0, $0080);
							  WFIFOL(2, tc1.ID);
							  WFIFOB(6, 1);
	              Socket.SendBuf(buf, 7);
	              WFIFOW( 0, $0080);
						    WFIFOL( 2, tc1.ID);
						    WFIFOB( 6, 1);
						    SendBCmd(tm, tc1.Point, 7);
							end;
						finally
						end;
					end //GM cmd #kill
					else if (Copy(str, 1, 5) = 'where') and (tid.BroadCast = 1) then begin
						s := Copy(str, 7, 256);
						if s = '' then begin
              //Location of self
              str := tc.Name + ' located at: ' + tc.Map + ' (' + IntToStr(tc.Point.X) + ',' + IntToStr(tc.Point.Y) + ')';
              w := Length(str) + 4;
              WFIFOW (0, $009a);
              WFIFOW (2, w);
              WFIFOS (4, str, w - 4);
              tc.socket.sendbuf(buf, w);
            end else if CharaName.IndexOf(s) <> -1 then begin
              tc1 := CharaName.Objects[CharaName.IndexOf(s)] as TChara;
              if tc1.Login <> 2 then begin
                str := tc1.Name + ' is not logged in!';
                w := Length(str) + 4;
                WFIFOW (0, $009a);
                WFIFOW (2, w);
                WFIFOS (4, str, w - 4);
                tc.socket.sendbuf(buf, w);
              end else begin
                str := tc1.Name + ' located at: ' + tc1.Map + ' (' + IntToStr(tc1.Point.X) + ',' + IntToStr(tc1.Point.Y) + ')';
                w := Length(str) + 4;
                WFIFOW (0, $009a);
                WFIFOW (2, w);
                WFIFOS (4, str, w - 4);
                tc.socket.sendbuf(buf, w);
              end;
            end else begin
              str := 'Couldnt find player: ' + s;
              w := Length(str) + 4;
              WFIFOW (0, $009a);
              WFIFOW (2, w);
              WFIFOS (4, str, w - 4);
              tc.socket.sendbuf(buf, w);
            end;
				end // cmd /where

				{ Mitch 01-29-2004: Revive goes under "killdiealive" }
				else if (Copy(str, 1, 7) = 'revive ') AND
								((DebugCMD AND $0008) <> 0) AND (tid.KillDieAlive = 1) then
				begin
          s := Copy(str, 8, 256);
          try
            if CharaName.IndexOf(s) <> -1 then begin
              tc1 := CharaName.Objects[CharaName.IndexOf(s)] as TChara;
              tc1.HP := tc1.MAXHP;
              tc1.SP := tc1.MAXSP;
              tc1.Sit := 3;
              SendCStat1(tc1,0,5,tc1.HP);
              SendCStat1(tc1,0,7,tc1.SP);
              WFIFOW( 0, $0148);
              WFIFOL( 2, tc1.ID);
              WFIFOW( 6, 100);
              SendBCmd(tm, tc1.Point, 8);
            end;

            str := tc.Name + ' revived ' + tc1.Name + '!';
            w := Length(str) + 4;
            WFIFOW (0, $009a);
            WFIFOW (2, w);
            WFIFOS (4, str, w - 4);
            tc.socket.sendbuf(buf, w);
            if tc1.Login = 2 then begin
              tc1.Socket.SendBuf(buf, w);
            end;
          finally
          end;
        end //GM cmd #revive
        else if (Copy(str, 1, 7) = 'summon ') AND
        				((DebugCMD AND $0008) <> 0) and (tid.GotoSummonBanish = 1) then
				begin
          s := Copy(str, 8, 256);
          try
            if CharaName.Indexof(s) <> -1 then begin
		          tc1 := CharaName.Objects[CharaName.Indexof(s)] as TChara;
			        if tc1.Login = 2 then begin
			          SendCLeave(tc1, 2);
			          tc1.tmpMap := tc.Map;
			          tc1.Point := tc.Point;
					      MapMove(tc1.Socket, tc.Map, tc.Point);
		          end;
            end;
          finally
          end;
				end //GM cmd #summon

				else if (Copy(str, 1, 7) = 'banish ') AND
								((DebugCMD AND $0008) <> 0) AND (tid.GotoSummonBanish = 1) then
				begin
					SL := TStringList.Create;
					SL.DelimitedText := Copy(str, 8, 256);
					try
						Val(SL[SL.Count - 2], i, k);
						if k <> 0 then continue;

						Val(SL[SL.Count - 1], j, k);
						if k <> 0 then continue;

						if MapList.IndexOf(sl.Strings[sl.Count - 3]) <> -1 then begin
							ta := MapList.Objects[MapList.IndexOf(sl.Strings[sl.Count - 3])] as TMapList;
							if (i < 0) or (i >= ta.Size.X) or (j < 0) or (j >= ta.Size.Y) then continue;

							for k := 0 to sl.Count - 4 do begin
								s := s + ' ' + sl.Strings[k];
								s := Trim(s);
							end;

							if CharaName.Indexof(s) <> -1 then begin
								tc1 := CharaName.Objects[CharaName.Indexof(s)] as TChara;
								if tc1.Login = 2 then begin
				          SendCLeave(tc1, 2);
				          tc1.tmpMap := sl.Strings[sl.Count - 3];
				          //CRW  Point() does same as temp var here...
				          tc1.Point := Point(i,j);
				          MapMove(tc1.Socket, tc1.tmpMap, tc1.Point);
				        end else begin
					        tc1.Map := sl.Strings[sl.Count - 3];
					        tc1.Point := Point(i,j);
					      end;//if-else
					    end;//if CharaName else
						end;//if Maplist.IndexOf
					finally
						SL.Free();
					end;//try-finally
				end //GM cmd #banish

				else if (Copy(str, 1, 4) = 'ban ') then begin
					s := Copy(str, 5, 256);
					s := Trim(s);

					try
				    if CharaName.Indexof(s) <> -1 then begin
				      tc1 := CharaName.Objects[CharaName.Indexof(s)] as TChara;
				      tp1 := Player.IndexOfObject(tc1.ID) as TPlayer;
				      if tp1.Banned = 0 then begin
				        str := tc.Name +' has banned ' + s;
				        tp1.Banned := 1;
				      end else begin
				        str := tc.Name +' has un-banned ' + s;
				        tp1.Banned := 0;
				      end;

				      { Mitch 01-29-2004: Fix: Correct w size now made instead of just 256 }
				      w := Length(str) + 4;
				      WFIFOW (0, $009a);
				      WFIFOW (2, w);
				      WFIFOS (4, str, w - 4);

				      tc.socket.sendbuf(buf, w);
				      if tc1.Login = 2 then begin
					      tc1.socket.sendbuf(buf, w);
					    end;
				    end;//if CharaName
				  finally
				  end;//try-finally
				end //GM cmd #ban

			else if (Copy(str, 1, 5) = 'kick ') then begin
				s := Copy(str, 6, 256);
				s := Trim(s);

				try
			    if CharaName.Indexof(s) <> -1 then begin
				    tc1 := CharaName.Objects[CharaName.Indexof(s)] as TChara;
				    if tc1.Login = 2 then begin
			        tc1.Socket.Close;

			        { Mitch 01-29-2004: Fix: Correct w size now made instead of just 256 }
			        str := tc.Name +' has kicked ' + s;
			        w := Length(str) + 4;
			        WFIFOW (0, $009a);
			        WFIFOW (2, w);
			        WFIFOS (4, str, w - 4);
			        tc.socket.sendbuf(buf, w);
				    end;
			    end;
			  finally
				end;
			end //GM cmd #kick

			else if (Copy(str, 1, 4) = 'job ') AND ((DebugCMD and $0010) <> 0) AND
							(tid.ChangeJob = 1) then
			begin
			{修正} {Lit. "Correction"}
        if (tc.JID <> 0) or ((DebugCMD and $0020) <> 0) then //ノービスからは出来ない
        begin
          //職業変更  Lit. "Occupation modification"
          Val(Copy(str, 5, 256), i, k);
          if (k = 0) and (i >= 0) and (i <= MAX_JOB_NUMBER) and (i <> 13) then begin
            // Colus, 20040203: Added unequip of items when you #job
            for  j := 1 to 100 do begin
              if tc.Item[j].Equip = 32768 then begin
                tc.Item[j].Equip := 0;
                WFIFOW(0, $013c);
                WFIFOW(2, 0);
                tc.Socket.SendBuf(buf, 4);
              end else if tc.Item[j].Equip <> 0 then begin
                WFIFOW(0, $00ac);
                WFIFOW(2, j);
                WFIFOW(4, tc.Item[j].Equip);
                tc.Item[j].Equip := 0;
                WFIFOB(6, 1);
                tc.Socket.SendBuf(buf, 7);
              end;
            end;

            // Darkhelmet, 20040212: Added to remove all ticks when changing jobs.
            for j := 1 to MAX_SKILL_NUMBER do begin
              if tc.Skill[j].Data.Icon <> 0 then begin
                if tc.Skill[j].Tick >= timeGetTime() then begin
                  //DebugOut.Lines.Add('(Icon Removed');
                  UpdateIcon(tm, tc, tc.Skill[j].Data.Icon, 0);
                end;
              end;
              tc.Skill[j].Tick := timeGetTime();
              tc.Skill[j].Effect1 := 0;
            end;

            //tc.SkillPoint := 0;
            if (i > LOWER_JOB_END) then begin
              i := i - LOWER_JOB_END + UPPER_JOB_BEGIN; // 24 - 23 + 4000 = 4001, remort novice
              tc.ClothesColor := 1; // This is the default clothes palette color for upper classes
            end else begin
              tc.ClothesColor := 0; // Reset the clothes color to the default value.
            end;

            tc.JID := i; // Set the JID to the corrected value.
            //ステータス再計算

            //オプション初期化
            if (tc.Option <> 0) then begin
              tc.Option := 0;
              //見た目変更
              WFIFOW(0, $0119);
              WFIFOL(2, tc.ID);
              WFIFOW(6, 0);
              WFIFOW(8, 0);
              WFIFOW(10, tc.Option);
              WFIFOB(12, 0);
              SendBCmd(tc.MData, tc.Point, 13);
            end;
            // Colus, 20040203: Don't need two of these, do we?
            //SendCStat(tc);
            CalcStat(tc);
            SendCStat(tc, true); // Add the true to recalc sprites
            SendCSkillList(tc);
            // Colus, 20040303: Using newer packet to allow upper job changes
            UpdateLook(tm, tc, 0, i);
          end;
        end;
      end //GM cmd #job

      else if (Copy(str, 1, 5) = 'icon ') and ((DebugCMD and $0040) <> 0) then begin
        // Set the specified icon
        Val(Copy(str, 6, 256), i, k);

        if (k = 0) then begin
          for j := i to i do begin
            UpdateIcon(tm, tc, j, 1);
          end;
        end;
      end //GM cmd #icon
      else if (Copy(str, 1, 7) = 'unicon ') and ((DebugCMD and $0040) <> 0) then begin
        // Set the specified icon
        Val(Copy(str, 8, 256), i, k);

        if (k = 0) then begin
          for j := i to i do begin
            UpdateIcon(tm, tc, j, 0);
          end;
        end;
{修正ココまで} {Lit. "To correction coconut"}
      end //GM cmd #unicon

      else if (Copy(str, 1, 7) = 'ccolor ') AND ((DebugCMD AND $0040) <> 0) AND
      				(tid.ChangeColorStyle = 1) then
			begin
        //服の色変更
        Val(Copy(str, 8, 256), i, k);
        if (k = 0) and (i >= 0) and (i <= 77) then begin
          tc.ClothesColor := i;
          UpdateLook(tm, tc, 7, i, 0, true);
        end;
      end //GM cmd #ccolor

{髪色変更追加} {Lit. "Color modification of clothes"}
      else if (Copy(str, 1, 7) = 'hcolor ') AND
      				(tid.ChangeColorStyle = 1) then
			begin
        //髪の色変更
        Val(Copy(str, 8, 256), i, k);
        if (k = 0) and (i >= 0) and (i <= 8) then begin
          tc.HairColor := i;
          UpdateLook(tm, tc, 6, i, 0, true);
        end;

      end else if (Copy(str, 1, 7) = 'hstyle ') and (tid.ChangeColorStyle = 1) then begin
        //髪の色変更
        Val(Copy(str, 8, 256), i, k);
        if (k = 0) and (i >= 0) and (i <= 19) then begin
          tc.Hair := i;
          UpdateLook(tm, tc, 1, i, 0, true);
        end;
      end //GM cmd #hstyle

      else if (Copy(str, 1, 3) = 'die') AND ((DebugCMD AND $0080) <> 0) AND
      				(tid.KillDieAlive = 1) then
			begin
        //自殺
        tc.HP := 0;
        tc.Sit := 1;
        SendCStat1(tc, 0, 5, tc.HP);
        WFIFOW(0, $0080);
        WFIFOL(2, tc.ID);
        WFIFOB(6, 1);
        Socket.SendBuf(buf, 7);
        WFIFOW( 0, $0080);
        WFIFOL( 2, tc.ID);
        WFIFOB( 6, 1);
        SendBCmd(tm, tc.Point, 7);
      end //GM cmd #die

      else if (Copy(str, 1, 5) = 'alive') and ((DebugCMD and $0100) <> 0) and (tid.KillDieAlive =1 ) then begin
        //生き返り
        tc.HP := tc.MAXHP;
        tc.SP := tc.MAXSP;
        tc.Sit := 3;
        SendCStat1(tc, 0, 5, tc.HP);
        SendCStat1(tc, 0, 7, tc.SP);
        WFIFOW( 0, $0148);
        WFIFOL( 2, tc.ID);
        WFIFOW( 6, 100);
        SendBCmd(tm, tc.Point, 8);
      {end else if (Copy(str, 1, 5) = 'noday') then begin
        if tc.noday = false then
					tc.noday := true
        else if tc.noday = true then
          tc.noday := false;}
      end //GM cmd #alive

      else if (Copy(str, 1, 5) = 'item ') AND ((DebugCMD AND $0200) <> 0) AND
      				(tid.ItemSummon = 1) then
			begin
        //アイテム作成
				//CRW 2004/04/07th -- added try-finally for safety.
        SL := TStringList.Create;
        SL.DelimitedText := Copy(str, 6, 256);
        try
	        if SL.Count = 2 then begin
  	        Val(SL[0], i, k);
    	      if k <> 0 then continue;
      	    if ItemDB.IndexOf(i) = -1 then continue;
	          Val(SL[1], j, k);
  	        if k <> 0 then continue;
    	      if (j <= 0) or (j > 30000) then continue;
	          td := ItemDB.IndexOfObject(i) as TItemDB;
  	        if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) * cardinal(j) then begin
    	        k := SearchCInventory(tc, i, td.IEquip);
      	      if k <> 0 then begin
	              if tc.Item[k].Amount + j > 30000 then continue;
  	            if td.IEquip then j := 1;
    	          //アイテム追加
      	        tc.Item[k].ID := i;
        	      tc.Item[k].Amount := tc.Item[k].Amount + j;
	              tc.Item[k].Equip := 0;
  	            tc.Item[k].Identify := 1;
    	          tc.Item[k].Refine := 0;
      	        tc.Item[k].Attr := 0;
	              tc.Item[k].Card[0] := 0;
  	            tc.Item[k].Card[1] := 0;
    	          tc.Item[k].Card[2] := 0;
      	        tc.Item[k].Card[3] := 0;
        	      tc.Item[k].Data := td;
	              //重量追加
  	            tc.Weight := tc.Weight + cardinal(td.Weight) * cardinal(j);
    	          SendCStat1(tc, 0, $0018, tc.Weight);

	              //アイテムゲット通知
  	            SendCGetItem(tc, k, j);
    	        end;
	          end else begin
  	          //重量オーバー
    	        WFIFOW( 0, $00a0);
      	      WFIFOB(22, 2);
	            Socket.SendBuf(buf, 23);
  	        end;
    	    end;
        finally
	        SL.Free();
        end;//try-finally
			end //GM cmd #item

      else if (Copy(str, 1, 7) = 'option ') AND ((DebugCMD AND $0400) <> 0) AND
      				(tid.ChangeOption = 1) then
			begin
        if Copy(str, 8, 5) = 'sight' then begin
          tc.Option := tc.Option or 1;
        end else if Copy(str, 8, 6) = 'ruwach' then begin
          tc.Option := tc.Option or 8192;
        end
        //CRW 2004/04/07th - Set math increased code clarity.
        else if ((tc.JID IN [ 5, 10, 18, 23 ]) OR (tc.JID = 4006) OR (tc.JID = 4011) OR (tc.JID = 4019)) AND
                (Copy(str, 8, 4) = 'cart') then
        begin
        //else if ((tc.JID = 5) or (tc.JID = 10) or (tc.JID = 18) or (tc.JID = 23) or (tc.JID = 4006) or (tc.JID = 4011) or (tc.JID = 4019)) and (Copy(str, 8, 4) = 'cart') then begin
          tc.Option := tc.Option or 8;
					//カートデータ送信
{追加}		SendCart(tc);
        end else if (((tc.JID = 11) OR (tc.JID = 4012)) AND (Copy(str, 8, 6) = 'falcon')) then begin
          tc.Option := tc.Option or $10;
        end
        else if ((tc.JID IN [ 7, 14 ]) OR (tc.JID = 4008) OR
        				(tc.JID = 4014) OR (tc.JID = 4015) OR (tc.JID = 4023 )) AND
        				((Copy(str, 8, 4) = 'peko') or (Copy(str, 8, 4) = 'peco')) then
        begin
          tc.Option := tc.Option or $20;
        end else if Copy(str, 8, 3) = 'off' then begin
          tc.Option := 0;
        end else begin
          tc.Option := tc.Option or (StrToInt(Copy(str, 8, 6)));
        end;
        UpdateOption(tm, tc);

      end else if (Copy(str, 1, 7) = 'refine ') and ((DebugCMD and $0800) <> 0) and (tid.Refine = 1)  then begin
        //装備中の武器防具を精錬
        Val(Copy(str, 8, 256), j, k);
        if (k <> 0) or (j < 0) or (j > 10) then continue;
        for i := 1 to 100 do begin
          with tc.Item[i] do begin
	          if (ID <> 0) AND (Amount <> 0) AND Data.IEquip AND (Equip <> 0) then
            begin
          	  tc.Item[i].Refine := Byte(j);
        	    WFIFOW(0, $0188);
      	      WFIFOW(2, 0);
    	        WFIFOW(4, i);
  	          WFIFOW(6, word(j));
	            Socket.SendBuf(buf, 8);
            end;
          end;
        end;//for
        WFIFOW(0, $019b);
        WFIFOL(2, tc.ID);
        WFIFOL(6, 3);
        SendBCmd(tm, tc.Point, 10, tc);
        CalcStat(tc);
        SendCStat(tc);
      end else if (Copy(str, 1, 5) = 'unit ') and ((DebugCMD and $1000) <> 0) and (tid.AutoRawUnit = 1) then begin
        //スキル効能地表示テスト
        Val(Copy(str, 6, 256), j, k);
        if (k <> 0) or (j < 0) or (j > 999) then continue;
        SetSkillUnit(tm, tc.ID, Point(tc.Point.X + 1, tc.Point.Y - 1), timeGetTime(), j, 1, 10000);

      end else if (Copy(str, 1, 5) = 'stat ') and ((DebugCMD and $2000) <> 0) and (tid.ChangeOption = 1) then begin
        //0x0119パケテスト
        SL := TStringList.Create;
        SL.DelimitedText := Copy(str, 6, 256);
        try
          if SL.Count <> 4 then continue;
          Val(SL[0], i, ii);
          if ii <> 0 then continue;
          Val(SL[1], j, ii);
          if ii <> 0 then continue;
          Val(SL[2], k, ii);
          if ii <> 0 then continue;
          Val(SL[3], l, ii);
          if ii <> 0 then continue;
          WFIFOW(0, $0119);
          WFIFOL(2, tc.ID);
          WFIFOW(6, i);
          WFIFOW(8, j);
          WFIFOW(10, k);
          WFIFOB(12, l);
          SendBCmd(tm, tc.Point, 13);
          tc.Stat1 := i;
          tc.Stat2 := j;
          tc.Option := k;
        finally
          SL.Free;
        end;
					end else if (Copy(str, 1, 4) = 'raw ') and ((DebugCMD and $2000) <> 0) and (tid.AutoRawUnit = 1) then begin
						//任意パケテスト
						sl := TStringList.Create;
						sl.DelimitedText := Copy(str, 5, 256);
						try
							if (sl.Count = 0) then continue;
							for i := 0 to sl.Count - 1 do begin
								WFIFOB(i, StrToInt('$' + sl.Strings[i]));
							end;
							Socket.SendBuf(buf, i);
						finally
							sl.Free();
						end;

                                        end else if (Copy(str, 1, 6) = 'server') then begin
                                        	str2 := 'Powered by Fusion Server Technology - http://fusion.cobax.net/';
                                        	DebugOut.Lines.Add(str2);
                                        	w := 200;
                                        	WFIFOW(0, $009a);
                                        	WFIFOW(2, w);
                                        	WFIFOS(4, str2, w - 4);
                                        	tc.Socket.SendBuf(buf, w);

            end else if (Copy(str, 1, 7) = 'statall') and ((DebugCMD and $4000) <> 0) and (tid.ChangeStatSkill = 1) then begin

						  for i := 0 to 5 do begin
						  tc.ParamBase[i] := 99;
					    end;
					    tc.StatusPoint := 1000;

              CalcStat(tc);
              SendCStat(tc);
              SendCStat1(tc, 0, $0009, tc.StatusPoint);
						//DebugOut.Lines.Add('DEBUG* Added all stats to ' + tc.Name);

          end else if (Copy(str, 1, 12) = 'changeskill ') and ((DebugCMD and $4000) <> 0) and (tid.ChangeStatSkill = 1) then begin

            sl := TStringList.Create;
						sl.DelimitedText := Copy(str, 13, 256);
						if sl.Count = 2 then begin
							Val(sl.Strings[0], i, k);
							if k <> 0 then continue;
							Val(sl.Strings[1], j, k);
							if k <> 0 then continue;

            if ((i >= 0) and (i <= 157)) or ((i >= 210) and (i <= MAX_SKILL_NUMBER)) then begin

            if (j > tc.Skill[i].Data.MasterLV) then j := tc.Skill[i].Data.MasterLV;
           tc.Plag := i;
           tc.PLv := j;
           tc.Skill[i].Plag := true;
            SendCSkillList(tc);
            CalcStat(tc);
            SendCStat(tc);
            end;
            sl.Free;
            end;
					end else if (Copy(str, 1, 8) = 'skillall') and ((DebugCMD and $4000) <> 0) and (tid.ChangeStatSkill = 1) then begin
						//全スキル習得
{修正}
            j := tc.JID;
            if (j > UPPER_JOB_BEGIN) then j := j - UPPER_JOB_BEGIN + LOWER_JOB_END; // (RN 4001 - 4000 + 23 = 24
						for i := 1 to 157 do begin
              if (tc.Skill[i].Data.Job1[j]) or (tc.Skill[i].Data.Job2[j]) then begin
							tc.Skill[i].Lv := tc.Skill[i].Data.MasterLV;
              end;
            end;
						for i := 210 to MAX_SKILL_NUMBER do begin //韓国桜井専用
              if (tc.Skill[i].Data.Job1[j]) or (tc.Skill[i].Data.Job2[j]) then begin
							tc.Skill[i].Lv := tc.Skill[i].Data.MasterLV;
              end;
						end;
{修正ココまで}
						tc.SkillPoint := 1000;
						//DebugOut.Lines.Add('DEBUG* Added all skills to ' + tc.Name);
						SendCSkillList(tc);
{追加}      CalcStat(tc);
            SendCStat(tc);
 					end else if (Copy(str, 1, 4) = 'auto') and ((DebugCMD and $8000) <> 0) and (tid.AutoRawUnit = 1) then begin
						//自動行動テスト
						sl := TStringList.Create;
						sl.DelimitedText := Copy(str, 5, 256);
						try
						if sl.Count = 0 then Continue;
						Val(sl.Strings[0], j, k);
						if (k <> 0) or (j < 0) then continue;
						tc.Auto := j;
						if sl.Count = 3 then begin
							Val(sl.Strings[1], tc.A_Skill, k);
							Val(sl.Strings[2], tc.A_Lv, k);
						end;
						finally
							sl.Free();
						end;
          { MITCH 01-31-04: Added PVP and GPVP GM commands! }
          end else if (Copy(str, 1, 5) = 'pvpon') and (tid.PVPControl = 1) then begin
            if MapInfo.IndexOf(tc.Map) = -1 then continue;
            mi := MapInfo.Objects[MapInfo.IndexOf(tc.Map)] as MapTbl;
            mi.PvP := true;
            //mi.dbPvP := true;
            for i := 0 to tm.CList.Count - 1 do begin
              tc1 := tm.CList.Objects[j] as TChara;
              {WFIFOW( 0, $0199);
							WFIFOW( 2, 1);
							tc1.Socket.SendBuf(buf, 4);
              k := i + 1;
              j := tm.CList.Count;
              WFIFOW( 0, $019a);
              WFIFOL( 2, tc1.ID);
              WFIFOL( 6, k);
              WFIFOL( 10, j);
              tc1.Socket.SendBuf(buf, 14);  }

							if (tc1.Hidden = false) then SendCLeave(tc1, 2);
							tc1.tmpMap := LowerCase(tc1.Map);
							tc1.Point := Point(tc1.Point.X, tc1.Point.Y);
							MapMove(tc1.Socket, LowerCase(tc1.Map), Point(tc1.Point.X, tc1.Point.Y));

              str := 'PvP has been enabled!';
              w := Length(str) + 4;
              WFIFOW (0, $009a);
              WFIFOW (2, w);
              WFIFOS (4, str, w - 4);
              tc1.socket.sendbuf(buf, w);
            end;
          end else if (Copy(str, 1, 6) = 'pvpoff') and (tid.PVPControl = 1) then begin
            mi := MapInfo.Objects[MapInfo.IndexOf(tc.Map)] as MapTbl;
            mi.PvP := false;
            //mi.dbPvP := false;
            for i := 0 to tm.CList.Count - 1 do begin
              tc1 := tm.CList.Objects[j] as TChara;
              {WFIFOW( 0, $0199);
							WFIFOW( 2, 0);
							tc1.Socket.SendBuf(buf, 4);   }

							if (tc1.Hidden = false) then SendCLeave(tc1, 2);
							tc1.tmpMap := LowerCase(tc1.Map);
							tc1.Point := Point(tc1.Point.X, tc1.Point.Y);
							MapMove(tc1.Socket, LowerCase(tc1.Map), Point(tc1.Point.X, tc1.Point.Y));

              str := 'PvP has been disabled!';
              w := Length(str) + 4;
              WFIFOW (0, $009a);
              WFIFOW (2, w);
              WFIFOS (4, str, w - 4);
              tc1.socket.sendbuf(buf, w);
            end;
          end else if (Copy(str, 1, 6) = 'gpvpon') and (tid.PVPControl = 1) then begin
            if MapInfo.IndexOf(tc.Map) = -1 then continue;
            mi := MapInfo.Objects[MapInfo.IndexOf(tc.Map)] as MapTbl;
            mi.PvPG := true;
            //mi.dbPvPG := true;
            for i := 0 to tm.CList.Count - 1 do begin
              tc1 := tm.CList.Objects[j] as TChara;
              {WFIFOW( 0, $0199);
							WFIFOW( 2, 1);
							tc1.Socket.SendBuf(buf, 4);
              k := i + 1;
              j := tm.CList.Count;
              WFIFOW( 0, $019a);
              WFIFOL( 2, tc1.ID);
              WFIFOL( 6, k);
              WFIFOL( 10, j);
              tc1.Socket.SendBuf(buf, 14);  }

							if (tc1.Hidden = false) then SendCLeave(tc1, 2);
							tc1.tmpMap := LowerCase(tc1.Map);
							tc1.Point := Point(tc1.Point.X, tc1.Point.Y);
							MapMove(tc1.Socket, LowerCase(tc1.Map), Point(tc1.Point.X, tc1.Point.Y));

              str := 'Guild PVP has been enabled!';
              w := Length(str) + 4;
              WFIFOW (0, $009a);
              WFIFOW (2, w);
              WFIFOS (4, str, w - 4);
              tc1.socket.sendbuf(buf, w);
            end;
          end else if (Copy(str, 1, 7) = 'gpvpoff') and (tid.PVPControl = 1) then begin
            mi := MapInfo.Objects[MapInfo.IndexOf(tc.Map)] as MapTbl;
            mi.PvPG := false;
            //mi.dbPvPG := false;
            for i := 0 to tm.CList.Count - 1 do begin
              tc1 := tm.CList.Objects[j] as TChara;
              {WFIFOW( 0, $0199);
							WFIFOW( 2, 0);
							tc1.Socket.SendBuf(buf, 4);   }

							if (tc1.Hidden = false) then SendCLeave(tc1, 2);
							tc1.tmpMap := LowerCase(tm.Name);
							tc1.Point := Point(tc1.Point.X, tc1.Point.Y);
							MapMove(tc1.Socket, LowerCase(tm.Name), Point(tc1.Point.X, tc1.Point.Y));

              str := 'Guild PvP has been disabled!';
              w := Length(str) + 4;
              WFIFOW (0, $009a);
              WFIFOW (2, w);
              WFIFOS (4, str, w - 4);
              tc1.socket.sendbuf(buf, w);
            end;
          { Mitch 02-03-04 <== NEAT! : User Controls added for GMs (CreateUser) }
          end else if (Copy(str, 1, 10) = 'newplayer ') and (tid.UserControl = 1) then begin
            //Syntax: #newplayer user pass [1|0] email
            //Gender: 1 = male // 0 = female (same as players.txt)
            sl := TStringList.Create;
            sl.DelimitedText := Copy(str, 11, 256);
            try
              if sl.Count <> 4 then continue;
              if PlayerName.IndexOf(sl.Strings[0]) <> -1 then begin
                str := 'Player name already exists!';
                w := Length(str) + 4;
                WFIFOW (0, $009a);
                WFIFOW (2, w);
                WFIFOS (4, str, w - 4);
                tc.socket.sendbuf(buf, w);
                continue;
              end else if (Length(sl.Strings[0]) < 4) or (Length(sl.strings[1]) < 4) then begin
                str := 'Player name and password must be at least 4 characters long.';
                w := Length(str) + 4;
                WFIFOW (0, $009a);
                WFIFOW (2, w);
                WFIFOS (4, str, w - 4);
                tc.socket.sendbuf(buf, w);
                continue;
              end else if (sl.strings[2] <> '1') and (sl.strings[2] <> '0') then begin
                str := 'Gender can only be: 1 - Male, or 2 - Female.';
                w := Length(str) + 4;
                WFIFOW (0, $009a);
                WFIFOW (2, w);
                WFIFOS (4, str, w - 4);
                tc.socket.sendbuf(buf, w);
                continue;
              end;
              tp1 := TPlayer.Create;
              tp1.ID := 110000 + PlayerName.Count;
              tp1.Name := sl.Strings[0];
              tp1.Pass := sl.Strings[1];
              tp1.Mail := sl.Strings[3];
              tp1.Gender := StrToInt(sl.Strings[2]);
              tp1.Banned := 0;
              tp1.ver2 := 9;

              PlayerName.AddObject(tp1.Name, tp1);
              Player.AddObject(tp1.ID, tp1);

              str := tp1.Name + ' has been successfully added!';
              w := Length(str) + 4;
              WFIFOW (0, $009a);
              WFIFOW (2, w);
              WFIFOS (4, str, w - 4);
              tc.socket.sendbuf(buf, w);
            finally
              sl.Free;
            end;
{追加ココまで}
					end;

                                end

                                // AlexKreuz: User Commands
                                else if (tc.ID >=100001) and(Pos(' : ', str) <> 0) and (Copy(str, Pos(' : ', str) + 3, 1) = '-') then begin
                                        str := Copy(str, Pos(' : ', str) + 4, 256);

                                        // AlexKreuz: Change Password
                                        if (Copy(str, 1, 5) = 'pword') then begin
                                                sl := TStringList.Create;
                                                sl.DelimitedText := Copy(str, 7, 256);
                                                if sl.Count <> 2 then continue;

                                                if length(sl.Strings[0]) < 4 then begin
                                                        //DebugOut.Lines.Add('Password Change Failed');
                                                        { Mitch 01-29-2004: Notify user why it failed! }
                                                        str := 'Passwords must be at least 4 characters long!';
                                                        w := Length(str) + 4;
                                                        WFIFOW (0, $009a);
                                                        WFIFOW (2, w);
                                                        WFIFOS (4, str, w - 4);
                                                        tc.socket.sendbuf(buf, w);
                                                end
                                                else if (sl.Strings[0] = ' ') or (sl.Strings[1] = ' ') then begin
                                                        //DebugOut.Lines.Add('Password Change Failed');
                                                        { Mitch 01-29-2004: Notify user why it failed! }
                                                        str := 'You have to enter a new password and your email address!';
                                                        w := Length(str) + 4;
                                                        WFIFOW (0, $009a);
                                                        WFIFOW (2, w);
                                                        WFIFOS (4, str, w - 4);
                                                        tc.socket.sendbuf(buf, w);
                                                end
                                                else begin
                                                        tp1 := Player.IndexOfObject(tc.ID) as TPlayer;
                                                        { Mitch: Removed the following because it isnt used yet:
                                                        if tp1.Gender = 0 then begin
                                                                //DebugOut.Lines.Add(tc.Name + ' is changing her password.');
                                                        end
                                                        else begin
                                                                //DebugOut.Lines.Add(tc.Name + ' is changing his password.');
                                                        end;
                                                        }
                                                        //DebugOut.Lines.Add('Old Password: ' + tp1.Pass);
                                                        if sl.Strings[1] <> tp1.Mail then begin
                                                          { Mitch 01-29-2004: Notify user why it failed! }
                                                          str := 'Your email address didnt match the one you entered!';
                                                          w := Length(str) + 4;
                                                          WFIFOW (0, $009a);
                                                          WFIFOW (2, w);
                                                          WFIFOS (4, str, w - 4);
                                                          tc.socket.sendbuf(buf, w);
                                                        end else begin
                                                          tp1.Pass := sl.Strings[0];
                                                          //DebugOut.Lines.Add('New Password: ' + tp1.Pass);
                                                          { Mitch 01-29-2004: Notify user that the password is changed! }
                                                          str := 'Password changed. New Password: ' + tp1.Pass;
                                                          w := Length(str) + 4;
                                                          WFIFOW (0, $009a);
                                                          WFIFOW (2, w);
                                                          WFIFOS (4, str, w - 4);
                                                          tc.socket.sendbuf(buf, w);
                                                        end;
                                                end;                                        
                                        end else
                                        // AlexKreuz: Change Password

                                        // AlexKreuz: Get list of users
                                        if (Copy(str, 1, 5) = 'users') then begin
                                            str2 := 'Users Currently Logged in:';
                                            for i := 0 to CharaName.Count - 1 do begin
                                            tc1 := CharaName.Objects[i] as TChara;
                                                if tc1.Login = 2 then begin
                                                    if str2 = 'Users Currently Logged in:' Then begin
                                                        str2 := str2 + tc1.Name;
                                                    end else begin
                                                        str2 := str2 + ',' + tc1.Name;
                                    				end;
                                                end;
                                            end;
                                            DebugOut.Lines.Add(str2);

                                            { Mitch 01-29-2004: Get correct str length and packet length }
                                            w := Length(str2) + 4;
                                            WFIFOW(0, $009a);
                                            WFIFOW(2, w);
                                            WFIFOS(4, str2, w - 4);
                                            tc.Socket.SendBuf(buf, w);
                                        end else
                                        // AlexKreuz: Get list of users
                                        // Darkhelmet Player Warp commands
                                        if (Copy(str, 1, 4) = 'warp') then begin
                                          if WarpItem <> 0 then k := SearchCInventory(tc, WarpItem, false);
                                          sl := TStringList.Create;
                                          sl.DelimitedText := Copy(str, 6, 256);
                                          try
                                             if WarpDatabase.IndexOf(sl.Strings[0]) <> -1 then begin
                                              twp := WarpDatabase.Objects[WarpDatabase.IndexOf(sl.Strings[0])] as TWarpDatabase;
                                              if (tc.Zeny >= cardinal(twp.Cost)) and ((k <> 0) and (tc.Item[k].Amount >= 1)) then begin
                                                if (sl.Strings[0] = 'save') or (sl.Strings[0] = 'return') or (sl.Strings[0] = 'home') then begin
                                                  if (tc.Hidden = false) then SendCLeave(tc, 2);
                                                  tc.Map := tc.SaveMap ;
						                                      tc.Point.X := tc.SavePoint.X;
						                                      tc.Point.Y := tc.SavePoint.Y;
                                                  twp.Map := tc.SaveMap ;
						                                      twp.X := tc.SavePoint.X;
						                                      twp.Y := tc.SavePoint.Y;
                                                end else begin
							                                  //if sl.Count <> 3 then continue;
							                                  i := twp.X;

							                                  j := twp.Y;

							                                  //Find the Map
							                                  if MapList.IndexOf(LowerCase(twp.MAP)) = -1 then continue;
							                                  //座標チェック
							                                  ta := MapList.Objects[MapList.IndexOf(LowerCase(twp.MAP))] as TMapList;
							                                  if (i < 0) or (i >= ta.Size.X) or (j < 0) or (j >= ta.Size.Y) then continue;
                                                if (tc.Hidden = false) then SendCLeave(tc, 2);
                                                tc.tmpMap := LowerCase(twp.MAP);
						                                  	tc.Point :=Point(twp.X,twp.Y);
                                                end;
							                                  //Warp the Player
                                                tc.Zeny := tc.Zeny - cardinal(twp.Cost);

							                                  MapMove(Socket, LowerCase(twp.MAP), Point(twp.X,twp.Y));
                                              end else if ((k <> 0) and (tc.Item[k].Amount >= 1)) then SendSkillError(tc, 5)
                                              else SendSkillError(tc, 6)
                                             end;

                                            finally
                                              sl.Free();
                                            end;
                                        end;


                                                if (Copy(str, 1, 6) = 'server') then begin
                                                        str2 := 'Powered by Fusion Server Technology - http://fusion.cobax.net/';
                                                        DebugOut.Lines.Add(str2);
                                                        { Mitch 01-29-2004: Get correct str length and packet length }
                                                        w := Length(str2);
                                                        WFIFOW(0, $009a);
                                                        WFIFOW(2, w);
                                                        WFIFOS(4, str2, w - 4);
                                                        tc.Socket.SendBuf(buf, w);
                                                end;

                                end
                                // AlexKreuz: User Commands

				else begin
					tm := tc.MData;

					WFIFOW(0, $008e);
					WFIFOW(2, w);
					WFIFOS(4, str, w - 4);
					Socket.SendBuf(buf, w);

					WFIFOW(0, $008d);
					WFIFOW(2, w + 4);
					WFIFOL(4, tc.ID);
					WFIFOS(8, str, w - 4);
					//ブロック処理
{チャットルーム機能追加}
					if (tc.ChatRoomID <> 0) then begin
						SendCrCmd(tc, w + 4, true);
					end else begin
						SendNCrCmd(tm, tc.Point, w + 4, tc, true, true);
					end;

          

{チャットルーム機能追加ココまで}
                                end;

			end;
		//--------------------------------------------------------------------------
		$0090: //NPCに話しかける
			begin
				if tc.AMode <> 0 then continue;
				tm := tc.MData;
				RFIFOL(2, l);
				if tm.NPC.IndexOf(l) <> -1 then begin
					tn := tm.NPC.IndexOfObject(l) as TNPC;
					//距離チェック
					if (tc.Map <> tn.Map) or (abs(tc.Point.X - tn.Point.X) > 15) or (abs(tc.Point.Y - tn.Point.Y) > 15) then begin
						continue;
					end;
					case tn.CType of
					1:	//shop
						begin
							WFIFOW(0, $00c4);
							WFIFOL(2, l);
							Socket.SendBuf(buf, 6);
						end;
					2:	//script
						begin
							tc.TalkNPCID := tn.ID;
							tc.ScriptStep := 0;
							tc.AMode := 3;
							tc.AData := tn;
							NPCScript(tc);
						end;
					end;
				end;
			end;
		//--------------------------------------------------------------------------
		$0094: //指定IDのキャラ、NPCの名前を要求
   
			begin
      tm := tc.MData;
				RFIFOL(2, l);
				//accountid := IntToStr(l);
				if CharaPID.IndexOf(l) <> -1 then begin
					tc := CharaPID.IndexOfObject(l) as TChara;
{ギルド機能追加}
					if (tc.GuildID = 0) then begin
						WFIFOW(0, $0095);
						WFIFOL( 2, l);
						WFIFOS( 6, tc.Name, 24);
						Socket.SendBuf(buf, 30);
					end else begin
						WFIFOW(0, $0195);
						WFIFOL( 2, l);
						WFIFOS( 6, tc.Name, 24);
						WFIFOS(30, tc.PartyName, 24);
						WFIFOS(54, tc.GuildName, 24);
						WFIFOS(78, tc.ClassName, 24);
						Socket.SendBuf(buf, 102);
					end;
{ギルド機能追加ココまで}
				end else if tm.Mob.IndexOf(l) <> -1 then begin
					ts := tm.Mob.IndexOfObject(l) as TMob;
					WFIFOW(0, $0095);
					WFIFOL( 2, l);
					WFIFOS( 6, ts.Name, 24);
					Socket.SendBuf(buf, 30);
				end else if tm.NPC.IndexOf(l) <> -1 then begin
					tn := tm.NPC.IndexOfObject(l) as TNPC;
					WFIFOW( 0, $0095);
					WFIFOL( 2, l);
					WFIFOS( 6, tn.Name, 24);
					Socket.SendBuf(buf, 30);
				end;
			end;
		//--------------------------------------------------------------------------
		$0096: //wis送信
			begin
				RFIFOW(2, w);
        //DebugOut.Lines.Add(IntToStr(w));
				str := RFIFOS(4, 24);
				i := CharaName.IndexOf(str);
				if i = -1 then begin
					//指定された名前のキャラが居ない
					WFIFOW( 0, $0098);
					WFIFOB( 2, 1);
					Socket.SendBuf(buf, 3);
					continue;
				end;
				tc1 := CharaName.Objects[i] as TChara;
				if tc1.Login <> 2 then begin
					//相手がログインしていない
					WFIFOW( 0, $0098);
					WFIFOB( 2, 1);
					Socket.SendBuf(buf, 3);
					continue;
				end;
				//wis送信
				WFIFOW( 0, $0097);
				WFIFOS( 4, tc.Name, 24);
				tc1.Socket.SendBuf(buf, w);
				WFIFOW( 0, $0098);
				WFIFOB( 2, 0);
				Socket.SendBuf(buf, 3);
			end;
		//--------------------------------------------------------------------------
		//030316/030317 Cardinal
		$0099: //GM
			begin
      //tp := tc.PData;
      h := IDTableDB.IndexOf(tc.ID);
      if (h <> -1) then begin
      tid := IDTableDB.Objects[h] as TIDTbl;
      if (tid.BroadCast = 1) then begin

				RFIFOW(2, w);
				str := RFIFOS(4, w - 4);
        WFIFOW(0, $009a);

        if (Copy(str, 1, 4) = 'blue') then begin
        for k := 0 to CharaName.Count - 1 do begin
					tc1 := CharaName.Objects[k] as TChara;
        if (tc1.Login = 2) and (tc1.Map = tc.Map) then tc1.Socket.SendBuf(buf, w);
        end;
				end else begin
				for k := 0 to CharaName.Count - 1 do begin
					tc1 := CharaName.Objects[k] as TChara;
        if tc1.Login = 2 then tc1.Socket.SendBuf(buf, w);
        end;
        end;

      //DebugOut.Lines.Add('GM:'+str);
      end;
      end;
      end;
		//--------------------------------------------------------------------------
		$009b: //向き変更
			begin
				tm := tc.MData;

				RFIFOW(2, tc.HeadDir);
				RFIFOB(4, tc.Dir);

				WFIFOW(0, $009c);
				WFIFOL(2, tc.ID);
				WFIFOW(6, tc.HeadDir);
				WFIFOB(8, tc.Dir);

				//ブロック処理
				SendBCmd(tm, tc.Point, 9, tc);
			end;
		//--------------------------------------------------------------------------
		$009f: //アイテムを拾う
			begin
				RFIFOL(2, l);
				PickUpItem(tc,l);
			end;
		//--------------------------------------------------------------------------
		$00a2: //アイテムドロップ
			begin
				tm := tc.MData;
				RFIFOW(2, w1);
				RFIFOW(4, w2);
				if (tc.Item[w1].ID <> 0) and (tc.Item[w1].Amount >= w2) then begin
					tn := TNPC.Create;
					tn.ID := NowItemID;
					Inc(NowItemID);
					tn.Name := 'item';
					tn.JID := tc.Item[w1].ID;
					tn.Map := tc.Map;
					tn.Point.X := tc.Point.X - 1 + Random(3);
					tn.Point.Y := tc.Point.Y - 1 + Random(3);
					tn.CType := 3;
          tn.Enable := true;
					tn.Item := TItem.Create;
					tn.Item.ID := tc.Item[w1].ID;
					tn.Item.Amount := w2;
					tn.Item.Identify := tc.Item[w1].Identify;
					tn.Item.Refine := tc.Item[w1].Refine;
					tn.Item.Attr := tc.Item[w1].Attr;
					tn.Item.Card[0] := tc.Item[w1].Card[0];
					tn.Item.Card[1] := tc.Item[w1].Card[1];
					tn.Item.Card[2] := tc.Item[w1].Card[2];
					tn.Item.Card[3] := tc.Item[w1].Card[3];
					tn.Item.Data := tc.Item[w1].Data;
					tn.SubX := Random(8);
					tn.SubY := Random(8);
					tn.Tick := timeGetTime() + 60000;
					tm.NPC.AddObject(tn.ID, tn);
					tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.AddObject(tn.ID, tn);
					//アイテム数減少
					WFIFOW( 0, $00af);
					WFIFOW( 2, w1);
					WFIFOW( 4, w2);
					Socket.SendBuf(buf, 6);

					tc.Item[w1].Amount := tc.Item[w1].Amount - w2;
					if tc.Item[w1].Amount = 0 then tc.Item[w1].ID := 0;
					tc.Weight := tc.Weight - tc.Item[w1].Data.Weight * w2;
					//Update weight
          SendCStat1(tc, 0, $0018, tc.Weight);

					//周りに通知
					WFIFOW( 0, $009e);
					WFIFOL( 2, tn.ID);
					WFIFOW( 6, tn.JID);
					WFIFOB( 8, tn.Item.Identify);
					WFIFOW( 9, tn.Point.X);
					WFIFOW(11, tn.Point.Y);
					WFIFOB(13, tn.SubX);
					WFIFOB(14, tn.SubY);
					WFIFOW(15, tn.Item.Amount);
					SendBCmd(tm, tn.Point, 17);
				end;
			end;
		//--------------------------------------------------------------------------
		$00a7: //Item Use
			begin

                tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;

{チャットルーム機能追加}
				//入室中のアイテム使用無効
				if (tc.ChatRoomID <> 0) then continue;
{チャットルーム機能追加ココまで}
{露店スキル追加}
				//露店中のアイテム使用無効
{アジト機能追加}
				i := MapInfo.IndexOf(tc.Map);
				if (i <> -1) then begin
					mi := MapInfo.Objects[i] as MapTbl;
				end else begin
					mi := MapTbl.Create;
				end;
				if mi.noItem then continue;
{アジト機能追加ココまで}
				if (tc.VenderID <> 0) then continue;

        //if (tc.Sit <> 1) then continue;
{露店スキル追加ココまで}
				RFIFOW(2, w);
				RFIFOL(4, l);
				if (l = tc.ID) and (w >= 1) and (w <= 100) then begin
        //DebugOut.Lines.Add('UsedItem:' + IntToStr(w));
					td := tc.Item[w].Data;
					b := 0;
                                        if tc.item[w].Amount <= 0 then exit;
          if tc.BaseLV < td.eLV then exit;
                                    case td.IType of
					0: //Recovery item
						begin
                                                        {Concentration Potion, Awakening Potion, Beserk Potion}
                                                        if (td.ID = 645) then SendItemSkill(tc, 291, 1);
                                                        if (td.ID = 656) then SendItemSkill(tc, 291, 2);
                                                        if (td.ID = 657) then SendItemSkill(tc, 291, 3);

							if tc.Item[w].Amount > 0 then begin
                                                                if td.ID = 607 then begin  {Yggasberry}
                                                                        tc.HP := tc.MAXHP;
                                                                        tc.SP := tc.MAXSP;
                                                                        SendCStat1(tc, 0, 5, tc.HP);
                                                                        SendCStat1(tc, 0, 7, tc.SP);
                                                                end else if td.ID = 608 then begin      {Seed of Yggassdril}
                                                                        tc.HP := tc.HP + (tc.MAXHP div 2);
                                                                        tc.SP := tc.SP + (tc.MAXSP div 2);
                                                                        if tc.HP > tc.MAXHP then tc.HP := tc.MAXHP;
                                                                        if tc.SP > tc.MAXSP then tc.SP := tc.MAXSP;
                                                                        SendCStat1(tc, 0, 5, tc.HP);
                                                                        SendCStat1(tc, 0, 7, tc.SP);
                                                                end;

                                                                if td.Effect = 1 then begin
                                                                        tc.isPoisoned := False;
                                                                        tc.PoisonTick := timeGetTime();
                                                                        tc.Stat2 := 0;
                                                                        UpdateStatus(tm, tc, timeGetTime);
                                                                end;

								if td.HP2 <> 0 then begin
                                                                        if tc.Skill[227].Lv <> 0 then begin
                                                                                tc.HP := tc.HP + ((td.HP1 + Random(td.HP2 - td.HP1 + 1)) * (100 + tc.Param[2]) div 100) * tc.Skill[227].Data.Data1[tc.Skill[227].Lv] div 100;  //Learning Potion
                                                                        end else begin
                                                                                // Added HP Recovery skill's power to the recovery calc
                                                                                if (tc.Skill[4].Lv <> 0) then begin
                                                                                  tc.HP := tc.HP + (td.HP1 + Random(td.HP2 - td.HP1 + 1)) * (100 + tc.Param[2]) div 100 * (100 + (tc.Skill[4].Lv * 10)) div 100;
                                                                                end else begin
                                                                                  tc.HP := tc.HP + (td.HP1 + Random(td.HP2 - td.HP1 + 1)) * (100 + tc.Param[2]) div 100;
                                                                                end;
                                                                        end;
									//030316追加 Cardinal
									if tc.HP > tc.MAXHP then tc.HP := tc.MAXHP;
									SendCStat1(tc, 0, 5, tc.HP);
								end;
								if td.SP2 <> 0 then begin
									tc.SP := tc.SP + (td.SP1 + Random(td.SP2 - td.SP1 + 1)) * (100 + tc.Param[3]) div 100;

									//030316追加 Cardinal
									if tc.SP > tc.MAXSP then tc.SP := tc.MAXSP;
									SendCStat1(tc, 0, 7, tc.SP);
                                                                        end;
   // Tumy
   Dec(tc.Item[w].Amount);
   if tc.Item[w].Amount = 0 then tc.Item[w].ID := 0; 
   tc.Weight := tc.Weight - td.Weight; 

   // {Alex: Reduce Number of Items}
   WFIFOW( 0, $00af); 
   WFIFOW( 2, w);
   WFIFOW( 4, 1);
                     Socket.SendBuf(buf, 6);

   // {Alex: Update Weight Display}
   SendCStat1(tc, 0, $0018, tc.Weight);

   // {Alex: Displays Effect}
   WFIFOW( 0, $01c8);
   WFIFOW( 2, w);
   WFIFOW( 4, td.ID);
   WFIFOL( 6, l);
   WFIFOW( 10, tc.Item[w].Amount);
   WFIFOB( 12, 1);
   //Socket.SendBuf(buf, 13);
   SendBCmd(tm, tc.Point, 13);

                     b := 1;
                     // Tumy
							end;
						end;
					2: //使用アイテム
						begin
							case td.Effect of
                                                                0:
                                                                begin
                                                                        UseUsableItem(tc, w);

                                                                        {Yggasdril Leaf}
                                                                        if (td.ID = 610) then begin
                                                                                SendItemSkill(tc, 54, 1);
                                                                        end;

                                                        end;
							1: //拡大鏡
								begin
									WFIFOW(0, $0177);
									j := 4;
									for i := 1 to 100 do begin
										if (tc.Item[i].ID <> 0) and (tc.Item[i].Amount > 0) and
											 (tc.Item[i].Identify = 0) then begin
											WFIFOW(j, i);
											j := j + 2;
										end;
									end;
									if j <> 4 then begin //未鑑定アイテムがある場合
										WFIFOW(2, j);
										Socket.SendBuf(buf, j);
										tc.UseItemID := w;
										b := 1;
									end;
								end;
							2: // Fly Wings - Rewritten by AlexKreuz
								begin
                  if ((tc.item[w].Amount <= 0) or (tc.Sit = 1) or (tc.Option and 6 <> 0)) then exit;
									i := MapInfo.IndexOf(tc.Map);
									j := -1;
									if (i <> -1) then begin
										mi := MapInfo.Objects[i] as MapTbl;
										if (mi.noTele = true) then j := 0;
									end;
									if (j <> 0) then begin

                                        tm := tc.MData;

                                        j := 0;

									        repeat
										        xy.X := Random(tm.Size.X - 2) + 1;
										        xy.Y := Random(tm.Size.Y - 2) + 1;
										        Inc(j);
									        until ( ((tm.gat[xy.X, xy.Y] <> 1) and (tm.gat[xy.X, xy.Y] <> 5)) or (j = 100) );

									        if j <> 100 then begin
										        UseUsableItem(tc, w);
										        b := 1;
                                                SendCLeave(tc, 3);
										        tc.Point := xy;
                                                MapMove(Socket, tc.Map, tc.Point);
									        end;
                                                                        end;
                                                                end;
							3: //蝶の羽
								begin
{NPCイベント追加}                                                       if tc.item[w].Amount <= 0 then exit;
									i := MapInfo.IndexOf(tc.Map);
									j := -1;
									if (i <> -1) then begin
										mi := MapInfo.Objects[i] as MapTbl;
										if (mi.noTele = true) then j := 0;
									end;
									if (j <> 0) then begin
{NPCイベント追加ココまで}
									UseUsableItem(tc, w);

									b := 1;
									SendCLeave(tc, 0);
									tc.Map := tc.SaveMap;
									tc.Point := tc.SavePoint;
									MapMove(Socket, tc.Map, tc.Point);
{NPCイベント追加}
									end;
{NPCイベント追加ココまで}
								end;
{氏{箱追加}
							10, 201: //Dead Branch
								begin
									if not mi.noBranch then begin
										UseUsableItem(tc, w);

										//Use MobList or MobListMVP
										if (SummonMobList.Count > 0) then begin
											tm := tc.MData;
											ts := TMob.Create;
											if td.Effect = 10 then begin
												{ChrstphrR - 2004/04/20 - design change}
												// L = ID of
												L := SummonMobList.RandomChoice;
												str := (MobDB.Objects[MobDB.IndexOf(L)] AS TMobDB).Name;
												//Fill Mob Data.
												ts.Data := MobDBName.Objects[MobDBName.IndexOf(str)] as TMobDB;
												ts.ID := NowMobID;
												Inc(NowMobID);
											end else begin //MVP list
												{ChrstphrR - I'm not sure this code is called - its list is empty
												and the bigger problem is it doesn't CHECK to see if it's empty...
												I'm leaving it as is, and will fix it after SummonMobList is confirmed}

												l := Random(SummonMobListMVP.Count);
												tsmn := SummonMobListMVP.Objects[l] as TSummon;

												str := tsmn.Name;
												ts.Data := MobDBName.Objects[MobDBName.IndexOf(str)] as TMobDB;
												ts.ID := NowMobID;
												Inc(NowMobID);
											end;

											if (SummonMonsterName = true) then begin
												ts.Name := ts.Data.JName;
											end else begin
												ts.Name := 'Summon Monster';
											end;

											if (SummonMonsterAgo = true) then begin
												ts.isActive := true;
											end else begin
												ts.isActive := ts.Data.isActive;
											end;

											ts.JID := ts.Data.ID;
											ts.Map := tc.Map;

										j := 0;
										repeat
											ts.Point.X := tc.Point.X + Random(11) - 5;
											ts.Point.Y := tc.Point.Y + Random(11) - 5;
											Inc(j);
										until ( ((tm.gat[ts.Point.X, ts.Point.Y] <> 1) and (tm.gat[ts.Point.X, ts.Point.Y] <> 5))  or (j = 10) );
										if (j = 10) then begin
											ts.Point.X := tc.Point.X;
											ts.Point.Y := tc.Point.Y;
										end;

										ts.Dir := Random(8);
										ts.HP := ts.Data.HP;
										ts.Speed := ts.Data.Speed;

										ts.SpawnDelay1 := $7FFFFFFF;
										ts.SpawnDelay2 := 0;

										ts.SpawnType := 0;
										ts.SpawnTick := 0;
										ts.MoveWait := timeGetTime();
										ts.ATarget := 0;
										ts.ATKPer := 100;
										ts.DEFPer := 100;
										ts.DmgTick := 0;
										ts.isActive := true;

										ts.Element := ts.Data.Element;

										for j := 0 to 31 do begin
											ts.EXPDist[j].CData := nil;
											ts.EXPDist[j].Dmg := 0;
										end;
										if ts.Data.MEXP <> 0 then begin
											for j := 0 to 31 do begin
												ts.MVPDist[j].CData := nil;
												ts.MVPDist[j].Dmg := 0;
											end;
											ts.MVPDist[0].Dmg := ts.Data.HP * 30 div 100; //FAに30%加算
										end;

										// Link monster to Map it's now on.
										tm.Mob.AddObject(ts.ID, ts); //Owned here.
										tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);

										ts.isSummon := True;
										ts.EmperiumID := 0;

										SendMData(tc.Socket, ts);
										//周囲に送信
										SendBCmd(tm,ts.Point,41,tc,False);
										b := 1;
									end;
{アジト機能追加}
									end;
{アジト機能追加ココまで}
								end;
							11,12,13,14: //青箱、紫箱、カード帖、プレ箱
								begin
									UseUsableItem(tc, w);

									str := '';
									case td.Effect of
									11: //青箱
										begin
											if (SummonIOBList.Count > 0) then begin
												str := SummonIOBList[Random(SummonIOBList.Count)];
											end;
										end;
									12: //紫箱
										begin
											if (SummonIOVList.Count > 0) then begin
												str := SummonIOVList[Random(SummonIOVList.Count)];
											end;
										end;
									13: //カード帖
										begin
											if (SummonICAList.Count > 0) then begin
												str := SummonICAList[Random(SummonICAList.Count)];
											end;
										end;
									14: //プレ箱
										begin
											if (SummonIGBList.Count > 0) then begin
												str := SummonIGBList[Random(SummonIGBList.Count)];
											end;
										end;
									200:  //New --- Old Weapon Box
										begin
											if (SummonIOWBList.Count > 0) then begin
												str := SummonIOWBList[Random(SummonIOWBList.Count)];
											end;
										end;
									end;


									if (str <> '') then begin
										i := 0;
										td := ItemDBName.Objects[ItemDBName.IndexOf(str)] as TItemDB;
										if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) * cardinal(j) then begin
											k := SearchCInventory(tc, td.ID, td.IEquip);
											if (k <> 0) then begin
												if tc.Item[k].Amount < 30000 then begin
													//アイテム追加
													tc.Item[k].ID := td.ID;
													tc.Item[k].Amount := tc.Item[k].Amount + 1;
													tc.Item[k].Equip := 0;
													tc.Item[k].Identify := 1;
													tc.Item[k].Refine := 0;
													tc.Item[k].Attr := 0;
													tc.Item[k].Card[0] := 0;
													tc.Item[k].Card[1] := 0;
													tc.Item[k].Card[2] := 0;
													tc.Item[k].Card[3] := 0;
													tc.Item[k].Data := td;
													//重量追加
													tc.Weight := tc.Weight + cardinal(td.Weight);
													SendCStat1(tc, 0, $0018, tc.Weight);
													//アイテムゲット通知
													SendCGetItem(tc, k, 1);
													b := 1;
												end;
											end else begin
												i := 1;
											end;
										end else begin
											i := 2;
										end;
										if (i <> 0) then begin
											//取得失敗
											WFIFOW( 0, $00a0);
											WFIFOB(22, i);
											Socket.SendBuf(buf, 23);
											b := 1;
										end;
									end;
								end;
                                                        15:
                                                                begin
									UseUsableItem(tc, w);

                                                                        if tc.Item[w].ID = 645 then begin
                                                                        tc.ASpeed := tc.ASpeed + 6;
                                                                        end;
                                                                        if tc.Item[w].ID = 656 then tc.ASpeed := tc.ASpeed + 8;
                                                                        if tc.Item[w].ID = 657 then tc.ASpeed := tc.ASpeed + 10;

                                                                end;

							100: // Forging items (mini-furnace, hammers)
								begin
                  // Colus, 20040214:
                  // Save the ID of the item you're using first.
                  // If it's the last one, UseUsableItem will make its ID 0.
                  w3 := tc.Item[w].ID;

									UseUsableItem(tc, w);
                                                                        
									b := 1;

									//アイテムリスト送信
									j := 4;

									for w1 := 0 to MaterialDB.Count-1 do begin
										e2 := 0;//e2を製造可能かのフラグとして使う
										tma := MaterialDB.Objects[w1] as TMaterialDB;

										case tma.RequireSkill of

										0,94,95,96://星のかけら、各種属性石の場合は使用アイテムが溶鉱炉かチェック
											begin

												for w2 := 0 to 2 do begin
													if (tma.ItemLV > tc.Skill[tma.RequireSkill].Lv) or (w3 <> 612) then begin
														e2 := 1;
														continue;
													end;
													if tma.MaterialID[w2] = 0 then continue;
													e := SearchCInventory(tc, tma.MaterialID[w2], false);
													if (e = 0) or (tc.Item[e].Amount < tma.MaterialAmount[w2]) then begin
														e2 := 1;
													end;
												end;

												if (e2 <> 1) then begin

													WFIFOW(j, tma.ID);
													WFIFOW(j+2, 12);
													WFIFOL(j+4, tc.ID);
													j := j+8;

												end;
											end;
										98,99,100,101,102,103,104://武器の場合は使用アイテムがレベルに応じた金槌かチェック
											begin

												for w2 := 0 to 2 do begin

													if (tma.ItemLV > tc.Skill[tma.RequireSkill].Lv) or (w3 = 612) or ((tma.ItemLV > 1) and (w3 = 613)) or ((tma.ItemLV = 3) and (w3 = 614)) then begin
														e2 := 1;
														continue;
													end;

													if tma.MaterialID[w2] = 0 then continue;

													e := SearchCInventory(tc, tma.MaterialID[w2], false);

													if (e = 0) or (tc.Item[e].Amount < tma.MaterialAmount[w2]) then begin
													e2 := 1;
													end;
												end;

												if (e2 <> 1) then begin

													WFIFOW(j, tma.ID);
													WFIFOW(j+2, 12);
													WFIFOL(j+4, tc.ID);
													j := j+8;

												end;
											end;
										end;

									end;

									WFIFOW(0, $018d);
									WFIFOW(2, j);
									Socket.SendBuf(buf, j);
								end;

                                                                                120: // テイミングアイテム
                                                                                        begin
                                                                                                tc.UseItemID := tc.Item[w].Data.ID;


Dec(tc.Item[w].Amount);
if tc.Item[w].Amount = 0 then tc.Item[w].ID := 0;
tc.Weight := tc.Weight - tc.Item[w].Data.Weight;

//Update weight
SendCStat1(tc, 0, $0018, tc.Weight);

// アイテム使用パケットを送信
WFIFOW( 0, $00a8);
WFIFOW( 2, w);
WFIFOW( 4, tc.Item[w].Amount);
WFIFOB( 6, 1);
{精錬NPC機能追加}
//装備ロックチェック
if tc.EqLock = true then continue;
{精錬NPC機能追加ココまで}
Socket.SendBuf(buf, 7);

//アイテム数減少
WFIFOW( 0, $00af);
WFIFOW( 2, w);
WFIFOW( 4, 1);
//Socket.SendBuf(buf,6);

b := 1;

// モンスター選択パケ送信
WFIFOW( 0, $019e );
Socket.SendBuf( buf, 2 );
end;
                                                        121: // Pet Incubator
                                                                begin
                                                                        if ( tc.PetData = nil ) and ( tc.PetNPC = nil ) then begin

                                                                                WFIFOW(0, $01a6);
									        j := 4;
									        for i := 1 to 100 do begin
										        if ( tc.Item[i].ID <> 0 ) and (tc.Item[i].Amount > 0) and
                                                                                        ( tc.Item[i].Data.IType = 4 ) and ( tc.Item[i].Data.Loc = 0 ) and
                                                                                        ( tc.Item[i].Data.Effect = 122 ) then begin
     											        WFIFOW(j, i);
											        j := j + 2;
										        end;
									        end;
									        if j <> 4 then begin //When there is an egg
										        WFIFOW(2, j);
										        Socket.SendBuf(buf, j);
                                                                                        tc.UseItemID := w;
                                                                                        b := 1;
                                                                                end;
                                                                        end;
                                                                end;

{キューペットここまで}
							end;
						end;
					end;
					if b = 0 then begin
						WFIFOW( 0, $00a8);
						WFIFOW( 2, w);
						WFIFOW( 4, 0);
						WFIFOB( 6, 0);
						Socket.SendBuf(buf, 7);
					end;
				end;
			end;
		//--------------------------------------------------------------------------
{精錬NPC機能追加}
				//装備ロックチェック
{精錬NPC機能追加ココまで}
		$00a9: // Equip an item.
			begin
				if tc.EqLock = true then continue;
				RFIFOW(2, w1);
				RFIFOW(4, w2);
				//DebugOut.Lines.Add(Format('Index:%d EquipType:%d', [w1, w2]));
{修正}
        // Colus, 20040304: Upper classes able to equip things now?
        i := tc.JID;
        if (i > UPPER_JOB_BEGIN) then i := i - UPPER_JOB_BEGIN + LOWER_JOB_END;
        // wjob := 1 shl tc.JID;
        wjob := Int64(1) shl i;
{修正ココまで}
				if (not DisableEquipLimit) and
					 ((tc.Item[w1].Identify = 0) or (tc.BaseLV < tc.Item[w1].Data.eLV) or
						((tc.Item[w1].Data.Gender <> 2) and (tc.Gender <> tc.Item[w1].Data.Gender)) or
						((tc.Item[w1].Data.Job and wjob) = 0)) then begin
					//未鑑定アイテムは装備できない
					WFIFOW(0, $00aa);
					WFIFOW(2, w1);
					WFIFOW(4, 0);
					WFIFOB(6, 0);
					Socket.SendBuf(buf, 7);
					continue;
				end;

				if tc.Item[w1].Data.Loc = $88 then begin
					//アクセサリ用処理
					w := $88;
					j := 0;
					for i := 1 to 100 do begin //装備箇所があいてるかチェック
						if (tc.Item[i].ID <> 0) and tc.Item[i].Data.IEquip then begin
							if (tc.Item[i].Equip = $8)	then begin w := (w and $80);				 end;
							if (tc.Item[i].Equip = $80) then begin w := (w and $8);	j := i; end;
						end;
					end;
					if w = 0 then begin //両方埋まってるときは右側をはずす
						WFIFOW(0, $00ac);
						WFIFOW(2, j);
						WFIFOW(4, tc.Item[j].Equip);
						tc.Item[j].Equip := 0;
						WFIFOB(6, 1);
						Socket.SendBuf(buf, 7);
						w := $80;
					end;
					if w = $88 then w := $8; //両方あいてるときは左に
					tc.Item[w1].Equip := w;

					WFIFOW(0, $00aa);
					WFIFOW(2, w1);
					WFIFOW(4, w);
					WFIFOB(6, 1);
					Socket.SendBuf(buf, 7);
				end else if (tc.Item[w1].Data.Loc = $2) and ((tc.JID = 12) or (tc.JID = 4013)) and (w2 = $22) then begin
					//アサシン二刀流用処理
					w := $22;
					j := 0;
					for i := 1 to 100 do begin //装備箇所があいてるかチェック
						if (tc.Item[i].ID <> 0) and tc.Item[i].Data.IEquip then begin
							if (tc.Item[i].Equip = $2)	then begin w := (w and $20);				 end;
							if (tc.Item[i].Equip = $20) then begin w := (w and $2);	j := i; end;
							if (tc.Item[i].Equip = $22) then begin w := 0;					 j := i; end;
						end;
					end;
					if w = 0 then begin //両方埋まってるときは右側あるいはカタールをはずす
						WFIFOW(0, $00ac);
						WFIFOW(2, j);
						WFIFOW(4, tc.Item[j].Equip);
						tc.Item[j].Equip := 0;
						WFIFOB(6, 1);
						Socket.SendBuf(buf, 7);
						w := $20;
					end;
					if w = $22 then w := $2; //両方あいてるときは左に
					tc.Item[w1].Equip := w;

					WFIFOW(0, $00aa);
					WFIFOW(2, w1);
					WFIFOW(4, w);
					WFIFOB(6, 1);
					Socket.SendBuf(buf, 7);
{キューペット}
                                // ペットアクセサリ
                                end else if tc.Item[w1].Data.Effect = 123 then begin

                                        if ( tc.PetData <> nil ) and ( tc.PetNPC <> nil ) then begin

                                                tpe := tc.PetData;
                                                tn := tc.PetNPC;

                                                if tc.Item[w1].Data.ID = tpe.Data.AcceID then begin

                                                        // アイテム減少
                                                        Dec(tc.Item[w1].Amount);
                                                        if tc.Item[w1].Amount = 0 then tc.Item[w1].ID := 0;
                                                        tc.Weight := tc.Weight - tc.Item[w1].Data.Weight;

                                                        //アイテム数減少
                                                        WFIFOW( 0, $00af);
                                                        WFIFOW( 2, w1);
                                                        WFIFOW( 4, 1);
                                                        Socket.SendBuf( buf, 6 );

                                                        //Update weight
                                                        SendCStat1(tc, 0, $0018, tc.Weight);

                                                        if ( tpe.Accessory <> 0 ) and ( ItemDB.IndexOf( tpe.Accessory ) <> -1 ) then begin
                                                                td := ItemDB.IndexOfObject( tpe.Accessory ) as TItemDB;

                                                                if tc.MaxWeight >= tc.Weight + td.Weight then begin
                                                                        j := SearchCInventory(tc, td.ID, td.IEquip );
                                                                        if j <> 0 then begin
                                                                                //アイテム追加
                                                                                tc.Item[j].ID := td.ID;
                                                                                tc.Item[j].Amount := tc.Item[j].Amount + 1;
                                                                                tc.Item[j].Equip := 0;
                                                                                tc.Item[j].Identify := 1;
                                                                                tc.Item[j].Refine := 0;
                                                                                tc.Item[j].Attr := 0;
                                                                                tc.Item[j].Card[0] := 0;
                                                                                tc.Item[j].Card[1] := 0;
                                                                                tc.Item[j].Card[2] := 0;
                                                                                tc.Item[j].Card[3] := 0;

                                                                                tc.Item[j].Data := td;
                                                                                //アイテムゲット通知
                                                                                SendCGetItem(tc, j, 1);

                                                                                //重量追加
                                                                                tc.Weight := tc.Weight + td.Weight;
                                                                                SendCStat1(tc, 0, $0018, tc.Weight);
                                                                        end else begin
                                                                                //これ以上もてない
                                                                                WFIFOW( 0, $00a0);
                                                                                WFIFOB(22, 1);
                                                                                Socket.SendBuf(buf, 23);
                                                                        end;
                                                                end else begin
                                                                        //重量オーバー
                                                                        WFIFOW( 0, $00a0);
                                                                        WFIFOB(22, 2);
                                                                        Socket.SendBuf(buf, 23);
                                                                end;
                                                        end;

                                                        tm := tc.MData;
                                                        tpe.Accessory := tc.Item[w1].Data.ID;
                                                        WFIFOW( 0, $01a4 );
                                                        WFIFOB( 2, 3 );
                                                        WFIFOL( 3, tn.ID );
                                                        WFIFOL( 7, tpe.Accessory );

                                                        SendBCmd( tm, tn.Point, 11 );
                                                end else begin
                                                        WFIFOW(0, $00aa);
					                WFIFOW(2, w1);
					                WFIFOW(4, 0);
					                WFIFOB(6, 0);
					                Socket.SendBuf(buf, 7);
                                                end;
                                        end else begin
                                                WFIFOW(0, $00aa);
                                                WFIFOW(2, w1);
                                                WFIFOW(4, 0);
                                                WFIFOB(6, 0);
                                                Socket.SendBuf(buf, 7);
                                        end;
{キューペットここまで}
				end else begin
					if tc.Item[w1].Data.IType = 10 then begin
            //arrow equip
						WFIFOW(0, $013c);
						WFIFOW(2, 0);
						Socket.SendBuf(buf, 4);
					end;
					for i := 1 to 100 do begin
						if (tc.Item[i].ID <> 0) and (tc.Item[i].Data.IEquip or (tc.Item[i].Data.IType = 10)) then begin
							if (tc.Item[i].Equip and tc.Item[w1].Data.Loc) <> 0 then begin
								//装備箇所重複により装備解除
								WFIFOW(0, $00ac);
								WFIFOW(2, i);
								WFIFOW(4, tc.Item[i].Equip);
								tc.Item[i].Equip := 0;
								WFIFOB(6, 1);
								Socket.SendBuf(buf, 7);
							end;
						end;
					end;
					tc.Item[w1].Equip := tc.Item[w1].Data.Loc;

					if tc.Item[w1].Data.IType = 10 then begin
						WFIFOW(0, $013b);
						WFIFOW(2, 3);
						Socket.SendBuf(buf, 4);
						WFIFOW(0, $013c);
						WFIFOW(2, w1);
						Socket.SendBuf(buf, 4);
					end else begin
            //equip wep
            //if (tc.Item[w1].Data.IType <> 0) then begin
            //WFIFOW(0, $013b);
						//WFIFOW(2, 3);
						//Socket.SendBuf(buf, 4);
            //end;
						WFIFOW(0, $00aa);
						WFIFOW(2, w1);
						WFIFOW(4, tc.Item[w1].Data.Loc);
						WFIFOB(6, 1);
						Socket.SendBuf(buf, 7);
					end;
				end;

				CalcStat(tc);
        SendCSkillList(tc);

        // Recalculate stats with sprite update
        SendCStat(tc, true);


      end;
		//--------------------------------------------------------------------------
		$00ab: //アイテム装備解除
			begin
{精錬NPC機能追加}
				//装備ロックチェック
				if tc.EqLock = true then continue;
{精錬NPC機能追加ココまで}
				RFIFOW(2, w);
        //DebugOut.Lines.Add(IntToStr(tc.Item[w].Equip));
				if tc.Item[w].Equip = 32768 then begin
					tc.Item[w].Equip := 0;
					WFIFOW(0, $013c);
					WFIFOW(2, 0);
					Socket.SendBuf(buf, 4);

                                // Tumy
				end else begin
                               WFIFOW(0, $00ac);
                               WFIFOW(2, w);
                               WFIFOW(4, tc.Item[w].Equip);
                               tc.Item[w].Equip := 0;
                               WFIFOB(6, 1);
                               Socket.SendBuf(buf, 7);
                            end;

            CalcStat(tc);
            SendCStat(tc, true);
            // Tumy

			end;
		//--------------------------------------------------------------------------
		$00b2: //リスタート、キャラセレ要求
			begin
				RFIFOB(2, b);
				case b of
				0:
					begin
						if tc.Sit <> 1 then continue;
						SendCLeave(tc, 0);
						tc.Map := tc.SaveMap;
						tc.Point := tc.SavePoint;
						MapMove(Socket, tc.Map, tc.Point);
					end;
				1:
					begin
						SendCLeave(Socket.Data, 2);

						WFIFOW(0, $00b3);
						WFIFOB(2, 1);
						Socket.SendBuf(buf, 3);
					end;
				end;
			end;
		//--------------------------------------------------------------------------
		$00b8: //NPC会話で選択肢を選択した
			begin
				RFIFOL(2, l);
				if tc.TalkNPCID <> l then continue;
				RFIFOB(6, b);
				NPCScript(tc, b);
			end;
		//--------------------------------------------------------------------------
		$00b9: //NPC会話でNEXTを選択した
			begin
				RFIFOL(2, l);
				if tc.TalkNPCID <> l then continue;
				NPCScript(tc);
			end;
		//--------------------------------------------------------------------------
		$00bb: //ステータスアップ要求
			begin
				RFIFOW(2, w);
				RFIFOB(4, b);
				//DebugOut.Lines.Add('	amount = ' + IntToStr(b));
				w := w - 13;
				if (tc.ParamBase[w] < 100) and (tc.StatusPoint >= tc.ParamUp[w]) then begin
					Inc(tc.ParamBase[w]);
					b := tc.ParamBase[w];
          b1 := tc.ParamUp[w];  // Save temp value to compare later
					Dec(tc.StatusPoint, tc.ParamUp[w]);
				end else begin
					b := 0;
				end;
				WFIFOW(0, $00bc);
				WFIFOW(2, 13 + w);
				if b <> 0 then begin
					WFIFOB(4, 0);
					WFIFOB(5, b);
					Socket.SendBuf(buf, 6);
                                                  
					SendCStat(tc);
					CalcStat(tc);

          {Colus, 20030113: Update points-to-level up display if needed}
          if (tc.ParamUp[w] > b1) then begin
            WFIFOW(0, $00be);
            WFIFOW(2, 32 + w);
            WFIFOB(4, tc.ParamUp[w]);
            Socket.SendBuf(buf, 5);
          end;
				end else begin
					WFIFOB(4, 1);
					WFIFOB(5, tc.ParamBase[w]);//修正箇所
					Socket.SendBuf(buf, 6);
				end;

			end;
		//--------------------------------------------------------------------------
		$00bf: // Display an emotion.
			begin
				tm := tc.MData;

				RFIFOB(2, b);
				if (tc.Skill[1].Lv < 2) and (not DisableSkillLimit) then begin
          w := tc.MSkill;
          // This is for a basic skill.
          tc.MSkill := 1;
          SendSkillError(tc, 0, 1);
          tc.MSkill := w;
        end else begin
  				WFIFOW(0, $00c0);
  				WFIFOL(2, tc.ID);
  				WFIFOB(6, b);
          SendBCmd(tm, tc.Point, 7);
        end;

			end;
		//--------------------------------------------------------------------------
		$00c1: //login人数問い合わせ
			begin
				WFIFOW(0, $00c2);
				WFIFOL(2, NowUsers);
				Socket.SendBuf(buf, 6);
			end;
		//--------------------------------------------------------------------------
		$00c5: //shop buy/sell選択
			begin
				tm := tc.MData;
				RFIFOL(2, l);
				RFIFOB(6, b);
				if tm.NPC.IndexOf(l) <> -1 then begin
					tn := tm.NPC.IndexOfObject(l) as TNPC;
					if tn.CType = 1 then begin
						tc.TalkNPCID := l;
						case b of
						0: //buy
							begin
								WFIFOW(0, $00c6);
								WFIFOW(2, 4 + Length(tn.ShopItem) * 11);
								for i := 0 to Length(tn.ShopItem) - 1 do begin
									WFIFOL( 4 +i*11, tn.ShopItem[i].Price);
									if tc.Skill[37].Lv <> 0 then begin
										l := tn.ShopItem[i].Price * cardinal(tc.Skill[37].Data.Data1[tc.Skill[37].Lv]) div 100;
										if l = 0 then	l := 1;
                                                                        end else if tc.Skill[224].Lv <> 0 then begin
                                                                                l := tn.ShopItem[i].Price * cardinal(tc.Skill[224].Data.Data1[tc.Skill[224].Lv]) div 100;
										if l = 0 then	l := 1;
									end else begin
										l := tn.ShopItem[i].Price;
									end;
									WFIFOL( 8 +i*11, l);
									WFIFOB(12 +i*11, tn.ShopItem[i].Data.IType);
									WFIFOW(13 +i*11, tn.ShopItem[i].ID);
								end;
								Socket.SendBuf(buf, 4 + Length(tn.ShopItem) * 11);
							end;
						1: //sell
							begin
								WFIFOW(0, $00c7);
								w := 0;
								for i := 1 to 100 do begin
									if (tc.Item[i].ID <> 0) and (tc.Item[i].Amount > 0) and (tc.Item[i].Equip = 0) then begin
										WFIFOW( 4+ w*10, i);
										WFIFOL( 6+ w*10, tc.Item[i].Data.Price div 2);
										if tc.Skill[38].Lv <> 0 then begin
											l := tc.Item[i].Data.Price div 2 * cardinal(tc.Skill[38].Data.Data1[tc.Skill[38].Lv]) div 100;
										end else begin
											l := tc.Item[i].Data.Price div 2;
										end;
										WFIFOL(10+ w*10, l);
										Inc(w);
									end;
								end;
								WFIFOW(2, 4 + w * 10);
								Socket.SendBuf(buf, 4 + w * 10);
							end;
						end;
					end;
				end;
			end;
		//--------------------------------------------------------------------------
		$00c8: // Send Request to Buy Item from NPC Shop
			begin
				tm := tc.MData;
				tn := tm.NPC.IndexOfObject(tc.TalkNPCID) as TNPC;
				if (tn.Map <> tc.Map) or (abs(tn.Point.X - tc.Point.X) > 15)
															or (abs(tn.Point.Y - tc.Point.Y) > 15) then begin
					// Can't buy from NPCs on other maps/too far away
					continue;
				end;
				RFIFOW(2, w);
				l := 0;
				weight := 0;
				k := -1;
				SetLength(ww, ((w - 4) div 4), 2);
        i1 := 0; // This is the count of actual items being bought
				for i := 0 to ((w - 4) div 4) - 1 do begin
					RFIFOW(4 + i*4, w1);
					RFIFOW(6 + i*4, w2);
          if (w1 = 0) or (w2 = 0) then continue;
					ww[i][0] := w1;
					ww[i][1] := w2;
					k := -1;
					for j := 0 to Length(tn.ShopItem) - 1 do begin
						if tn.ShopItem[j].ID = w2 then begin
							k := j;
							if tc.Skill[37].Lv <> 0 then begin
								l := l + (tn.ShopItem[j].Price * cardinal(tc.Skill[37].Data.Data1[tc.Skill[37].Lv]) div 100) * w1;
							end else if tc.Skill[224].Lv <> 0 then begin
								l := l + (tn.ShopItem[j].Price * cardinal(tc.Skill[224].Data.Data1[tc.Skill[224].Lv]) div 100) * w1;
							end else begin
								l := l + tn.ShopItem[j].Price * w1;
							end;
							weight := weight + cardinal(tn.ShopItem[j].Data.Weight) * cardinal(w1);
              Inc(i1);
							break;
						end;
					end;
					if k = -1 then break;
				end;

        // Was anything actually bought?
        if (i1 = 0) then continue;
        
				if tc.Zeny < l then begin
					// Insufficient Zeny message
					WFIFOW(0, $00ca);
					WFIFOB(2, 1);
					Socket.SendBuf(buf, 3);
					{// Overweight message (should not be sent here, and isn't?)
					WFIFOW(0, $00ca);
					WFIFOB(2, 2);	//1=Not enough zeny, 2=Overweight, 3=Maximum item capacity reached?
					Socket.SendBuf(buf, 3);}
				end else if k <> -1 then begin
					for k := 0 to ((w - 4) div 4) - 1 do begin
						td := nil;
						for j := 0 to Length(tn.ShopItem) - 1 do begin
							if tn.ShopItem[j].ID = ww[k][1] then begin
								td := tn.ShopItem[j].Data;
								if tc.Skill[37].Lv <> 0 then begin
									l := (tn.ShopItem[j].Price * cardinal(tc.Skill[37].Data.Data1[tc.Skill[37].Lv]) div 100);
								end else if tc.Skill[224].Lv <> 0 then begin
									l := (tn.ShopItem[j].Price * cardinal(tc.Skill[224].Data.Data1[tc.Skill[224].Lv]) div 100);
								end else begin
									l := tn.ShopItem[j].Price;
								end;
								if l = 0 then l := 1;
								l := l * ww[k][0];
								break;
							end;
						end;

						if td = nil then continue;

            // AlexKreuz - 12/19/2003.
            // Added to prevent overweight NPC purchases.
            if (cardinal(td.Weight * ww[k][0]) > tc.MaxWeight - tc.Weight) then begin
					    WFIFOW(0, $00ca); // "You are over the weight limit"
					    WFIFOB(2, 2);
					    Socket.SendBuf(buf, 3);
            end

            else begin
  						j := SearchCInventory(tc, ww[k][1], td.IEquip);
  						if j <> 0 then begin
  							// Give each bought item to the character
	  						tc.Item[j].ID := ww[k][1];
		  					tc.Item[j].Amount := tc.Item[j].Amount + ww[k][0];
			  				tc.Item[j].Equip := 0;
				  			tc.Item[j].Identify := 1;
					  		tc.Item[j].Refine := 0;
  							tc.Item[j].Attr := 0;
	  						tc.Item[j].Card[0] := 0;
		  					tc.Item[j].Card[1] := 0;
			  				tc.Item[j].Card[2] := 0;
				  			tc.Item[j].Card[3] := 0;
					  		tc.Item[j].Data := td;

  							tc.Weight := tc.Weight + td.Weight * ww[k][0];
	  						tc.Zeny := tc.Zeny - l;
		  					SendCGetItem(tc, j, ww[k][0]);

      					// Update weight
      			 		SendCStat1(tc, 0, $0018, tc.Weight);
      					// Update zeny
      					SendCStat1(tc, 1, $0014, tc.Zeny);
      					// Send buy success message
      					WFIFOW(0, $00ca);
      					WFIFOB(2, 0);
      					Socket.SendBuf(buf, 3);
  						end else begin
                // This says something about no further processing (process time: not yet)?
  							//これ以上もてない(時の処理：未)
	  					end;
            end;
					end;
				end else begin
          // 'A cheating situation: Trying to buy from a nonexistent shop?'
					//不正な処理（店にないものを買おうとした）
					WFIFOW(0, $00ca);
					WFIFOB(2, 3);  // 'You have reached the maximum capacity' message?
					Socket.SendBuf(buf, 3);
				end;
			end;
		//--------------------------------------------------------------------------
		$00c9: //NPCのお店に売る
			begin
				tm := tc.MData;
				tn := tm.NPC.IndexOfObject(tc.TalkNPCID) as TNPC;
				if (tn.Map <> tc.Map) or (abs(tn.Point.X - tc.Point.X) > 15)
															or (abs(tn.Point.Y - tc.Point.Y) > 15) then begin
					//視界の外のNPCには売れない
					continue;
				end;
				RFIFOW(2, w);
				for i := 1 to (w - 4) div 4 do begin
					RFIFOW(0+i*4, w1);
					RFIFOW(2+i*4, w2);
					if (tc.Item[w1].ID <> 0) and (tc.Item[w1].Amount >= w2) and (tc.Item[w1].Equip = 0) then begin
						td := tc.Item[w1].Data;
						if tc.Skill[38].Lv <> 0 then begin
							l := (td.Price div 2 * cardinal(tc.Skill[38].Data.Data1[tc.Skill[38].Lv]) div 100) * w2;
						end else begin
							l := td.Price div 2 * w2;
						end;
						tc.Weight := tc.Weight - td.Weight * w2;
						tc.Zeny := tc.Zeny + l;
						//アイテム数減少
						WFIFOW( 0, $00af);
						WFIFOW( 2, w1);
						WFIFOW( 4, w2);
						Socket.SendBuf(buf, 6);
						Dec(tc.Item[w1].Amount, w2);
						if tc.Item[w1].Amount = 0 then tc.Item[w1].ID := 0;
					end;
				end;
				//Update weight
        SendCStat1(tc, 0, $0018, tc.Weight);
				//Update zeny
        SendCStat1(tc, 1, $0014, tc.Zeny);
				//取引ができました
				WFIFOW(0, $00cb);
				WFIFOB(2, 0);
				Socket.SendBuf(buf, 3);
			end;
		//--------------------------------------------------------------------------
{チャットルーム機能追加}
		$00d5: //チャットルーム作成
			begin
				if (tc.Skill[1].Lv < 4) and (not DisableSkillLimit) then begin
					i := 1;
          w := tc.MSkill;
          tc.MSkill := 1;
          SendSkillError(tc, 0, 3);
          tc.MSkill := w;
          continue;
				end else if (tc.VenderID <> 0) then begin
					i := 1;
				end else begin
					tcr := TChatRoom.Create;
					RFIFOW(2, w);
					tcr.Title := RFIFOS(15, w - 15);
					RFIFOW(4, tcr.Limit);
					RFIFOB(6, tcr.Pub);
					tcr.Pass := RFIFOS(7, 8);

					tcr.MemberID[0] := tc.ID; //オーナー:0
					tcr.MemberCID[0] := tc.CID;
					tcr.MemberName[0] := tc.Name;
					ChatMaxID := ChatMaxID + 1;
					tcr.ID := ChatMaxID;
					tcr.Users := 1;

					tc.ChatRoomID := tcr.ID;
					ChatRoomList.AddObject(tcr.ID, tcr);
					//DebugOut.Lines.Add(Format('ChatRoomTitle = %s : OwnerID = %d : OwnerName = %s', [tcr.Title, tcr.MemberID[0], tcr.MemberName[0]]));
					i := 0;
        end;

        //チャットルーム作成正否応答
				WFIFOW( 0, $00d6);
				WFIFOB( 2, i);         // 0:成功 1:失敗
				Socket.SendBuf(buf, 3);

        if i = 0 then begin
					//周辺にパケ送信
                                        if tcr = nil then exit;
					w := Length(tcr.Title);
					WFIFOW(0, $00d7);
					WFIFOW(2, w + 17);
					WFIFOL(4, tcr.MemberID[0]);
					WFIFOL(8, tcr.ID);
					WFIFOW(12, tcr.Limit);
					WFIFOW(14, tcr.Users);
					WFIFOB(16, tcr.Pub);
					WFIFOS(17, tcr.Title, w);
					SendNCrCmd(tc.MData, tc.Point, w + 17, tc, true);
				end;
			end;
		//--------------------------------------------------------------------------
		$00d9: //チャット参加
			begin
				if (tc.ChatRoomID <> 0) then continue;
				RFIFOL(2, l);
				str := RFIFOS(6, 8);
				i := ChatRoomList.IndexOf(l);
				if (i <> -1) then begin
					tcr := ChatRoomList.Objects[i] as TChatRoom;
					k := -1;
					if (tcr.Pub = 0) and (tcr.Pass <> str) then begin
						//パスワード間違い
						k := 1;
					end else if (tcr.Users >= tcr.Limit) then begin
						//人数超過
						k := 0;
					end else begin
						//Kickチェック
						j := tcr.KickList.IndexOf(tc.CID);
						if (j <> -1) then begin
							k := 2;
						end;
					end;
					if k <> -1 then begin
						WFIFOW( 0, $00da);
						WFIFOB( 2, k);
						Socket.SendBuf(buf, 3);
						continue;
					end;

					//新メンバーのデータ追加
					tcr.MemberID[tcr.Users] := tc.ID;
					tcr.MemberCID[tcr.Users] := tc.CID;
					tcr.MemberName[tcr.Users] := tc.Name;
					tcr.Users := tcr.Users + 1;
					tc.ChatRoomID := tcr.ID;

					//ルーム内メンバーに新規参加者通知
					WFIFOW( 0, $00dc);
					WFIFOW( 2, tcr.Users);
					WFIFOS( 4, tc.Name, 24);
					SendCrCmd(tc, 28);

					//ルーム内の既存メンバーリスト
					WFIFOW( 0, $00db);
					w := 8 + tcr.Users * 28;
					WFIFOW( 2, w);
					WFIFOL( 4, tcr.ID);
					for j := 0 to tcr.Users -1 do begin
						WFIFOL( 8+j*28, j);
						WFIFOS( 12+j*28, tcr.MemberName[j], 24);
					end;
					Socket.SendBuf(buf, w);

					//チャットステータス変更を周囲に通知
					w := Length(tcr.Title);
					WFIFOW(0, $00d7);
					WFIFOW(2, w + 17);
					WFIFOL(4, tcr.MemberID[0]);
					WFIFOL(8, tcr.ID);
					WFIFOW(12, tcr.Limit);
					WFIFOW(14, tcr.Users);
					WFIFOB(16, tcr.Pub);
					WFIFOS(17, tcr.Title, w);
					SendNCrCmd(tc.MData, tc.Point, w + 17, tc, true);
					//DebugOut.Lines.Add(Format('Join = %s / RoomTitle = %s / Users = %d', [tc.Name, tcr.Title, tcr.Users]));
{NPCイベント追加}
					if (tcr.NPCowner <> 0) and (tcr.Limit = tcr.Users) then begin
						tc1 := TChara.Create;
						tm := tc.MData;
						tn := tm.NPC.IndexOfObject(tcr.MemberID[0]) as TNPC;
						tc1.TalkNPCID := tn.ID;
						for j := 0 to tn.ScriptCnt - 1 do begin
							k := -1;
							if (tn.Script[j].ID = 39) then begin
								k := tn.Script[j].Data3[1];
								break;
							end;
						end;
						if (k <> -1) then begin
							tc1.ScriptStep := k;
							tc1.AMode := 3;
							tc1.AData := tn;
							tc1.Login := 0;
							NPCScript(tc1,0,1);
						end;
						tc1.Free;
					end;
{NPCイベント追加ココまで}
				end;
			end;
		//--------------------------------------------------------------------------
		$00de: //チャットルームのステータス変更
			begin
				i := ChatRoomList.IndexOf(tc.ChatRoomID);
				if (i <> -1) then begin
					tcr := ChatRoomList.Objects[i] as TChatRoom;
					if (tc.ID = tcr.MemberID[0]) then begin
						RFIFOW(2, w);
						tcr.Title := RFIFOS(15, w - 15);
						RFIFOW(4, tcr.Limit);
						RFIFOB(6, tcr.Pub);
						tcr.Pass := RFIFOS(7, 8);

						//ステータス変更パケ送信
						w := Length(tcr.Title);
						WFIFOW(0, $00df);
						WFIFOW(2, w + 17);
						WFIFOL(4, tcr.MemberID[0]);
						WFIFOL(8, tcr.ID);
						WFIFOW(12, tcr.Limit);
						WFIFOW(14, tcr.Users);
						WFIFOB(16, tcr.Pub);
						WFIFOS(17, tcr.Title, w);
						SendCrCmd(tc, w + 17);
						WFIFOW(0, $00d7);
						SendNCrCmd(tc.MData, tc.Point, w + 17, tc, true);
					end;
				end;
			end;
		//--------------------------------------------------------------------------
		$00e0: //チャットルームのオーナー変更
			begin
				str := RFIFOS(6, 24);
				i := ChatRoomList.IndexOf(tc.ChatRoomID);
				if (i <> -1) then begin
					//メンバー検索
					tcr := ChatRoomList.Objects[i] as TChatRoom;
					if (tc.ID = tcr.MemberID[0]) then begin
						j := -1;
						for i := 1 to 19 do begin;
							if str = tcr.MemberName[i] then begin
								j := i;
								break;
							end;
						end;

						if (j <> -1) then begin
							//オーナー変更
							tcr.MemberID[0] := tcr.MemberID[j];
							tcr.MemberID[j] := tc.ID;
							tcr.MemberCID[0] := tcr.MemberCID[j];
							tcr.MemberCID[j] := tc.CID;
							tcr.MemberName[j] := tc.Name;
							tcr.MemberName[0] := str;

							//メンバーに変更通知
							WFIFOW( 0, $00e1);
							WFIFOL( 2, j);
							WFIFOS( 6, tcr.MemberName[j], 24);
							SendCrCmd(tc, 30);
							WFIFOW( 0, $00e1);
							WFIFOL( 2, 0);
							WFIFOS( 6, tcr.MemberName[0], 24);
							SendCrCmd(tc, 30);

							//オーナー変更チャット消去
							WFIFOW( 0, $00d8);
							WFIFOL( 2, tcr.ID);
							SendNCrCmd(tc.MData, tc.Point, 6, tc, true);

							//周辺にオーナー変更通知
							w := Length(tcr.Title);
							WFIFOW(0, $00d7);
							WFIFOW(2, w + 17);
							WFIFOL(4, tcr.MemberID[0]);
							WFIFOL(8, tcr.ID);
							WFIFOW(12, tcr.Limit);
							WFIFOW(14, tcr.Users);
							WFIFOB(16, tcr.Pub);
							WFIFOS(17, tcr.Title, w);
							SendNCrCmd(tc.MData, tc.Point, w + 17, tc, true);
						end;
					end;
				end;
			end;
		//--------------------------------------------------------------------------
		$00e2: //メンバーkick
			begin
				str := RFIFOS(2, 24);
				i := ChatRoomList.IndexOf(tc.ChatRoomID);
				if (i <> -1) then begin
					//メンバー検索
					tcr := ChatRoomList.Objects[i] as TChatRoom;
					if (tc.ID = tcr.MemberID[0]) then begin
						j := -1;
						for i := 1 to 19 do begin;
							if str = tcr.MemberName[i] then begin
								j := i;
								break;
							end;
						end;

						if (j <> -1) then begin
							tc1 := Chara.IndexOfObject(tcr.MemberCID[j]) as TChara;
							if (tc1 <> nil) then begin
								//メンバー削除
								ChatRoomExit(tc1);
							end;
							//Kickリストに追加
							tcr.KickList.Add(tc1.CID);
						end;
					end;
				end;
			end;
		//--------------------------------------------------------------------------
		$00e3: //チャットルーム抜け
			begin
				ChatRoomExit(tc);
			end;
{チャットルーム機能追加ココまで}
{取引機能追加}
		//--------------------------------------------------------------------------
		$00e4: //取引要請
			begin
        // Can you even do it?
				if (tc.Skill[1].Lv = 0) and (not DisableSkillLimit) then begin
          w := tc.MSkill;
          tc.MSkill := 1;
          SendSkillError(tc, 0, 0);
          tc.MSkill := w;
          continue;
        end;

				RFIFOL(2, l);
				tc1 := CharaPID.IndexOfObject(l) as TChara;
				b := 0;

				if (tc1 = nil) then begin
					b := 1; // Invalid player.
				end else if (tc1.Map <> tc.Map) or (abs(tc1.Point.X - tc.Point.X) > 5)
					or (abs(tc1.Point.Y - tc.Point.Y) > 5) then begin
					b := 0; // Too far away.
				end else if (tc1.DealingID <> 0) or (tc1.PreDealID <> 0) then begin
					b := 2; // Already in another trade.
        end else if (tc1.Skill[1].Lv = 0) and (not DisableSkillLimit) then begin
          b := 4; // Failed (due to no basic skills!)
				end else begin
					tc.PreDealID := tc1.ID;
					tc1.PreDealID := tc.ID;
					//取引要請通知
					WFIFOW(0, $00e5);
					WFIFOS(2, tc.Name, 24);
					tc1.Socket.SendBuf(buf, 26);
					continue;
				end;
				//取引要請エラー
				WFIFOW(0, $00e7);
				WFIFOB(2, b);
				Socket.SendBuf(buf, 3);
			end;
		//--------------------------------------------------------------------------
		$00e6: //取引要請応答
			begin
				RFIFOB(2, b);
				tc1 := CharaPID.IndexOfObject(tc.PreDealID) as TChara;
				if (tc1 = nil) then begin
					//相手キャラ不存在
					tc.PreDealID := 0;
					WFIFOW(0, $00e7);
					WFIFOB(2, 1);
					Socket.SendBuf(buf, 3);
				end else if (b = 3) or (b = 4) then begin
					//要請返答(3=yes,4=no)
					tc.PreDealID := 0;
					tc1.PreDealID := 0;
					WFIFOW(0, $00e7);
					WFIFOB(2, b);
					Socket.SendBuf(buf, 3);
					tc1.Socket.SendBuf(buf, 3);
					//仮設倉庫作成
					if (b = 3) then begin
						tdl := TDealings.Create;
						DealMaxID := DealMaxID + 1;
						tdl.ID := DealMaxID;
						tc.DealingID := tdl.ID;
						tc1.DealingID := tdl.ID;
						tdl.UserID[0] := tc1.ID;
						tdl.USerID[1] := tc.ID;
						DealingList.AddObject(tdl.ID, tdl);
						//DebugOut.Lines.Add(Format('StartDealing ID = %d : Char1 = %S : Char2 = %s', [tdl.ID, tc1.Name, tc.Name]));
					end;
				end;
			end;
		//--------------------------------------------------------------------------
		$00e8: //アイテム追加
			begin
				if (tc.DealingID = 0) then continue;
				i := DealingList.IndexOf(tc.DealingID);
				if (i = -1) then continue;
				tdl:= DealingList.Objects[i] as TDealings;
				if (tdl.UserID[0] = tc.ID) then begin
					w1 := 0;
					w2 := 1;
				end else begin
					w1 := 1;
					w2 := 0;
				end;
				if (tdl.Mode[w1] <> 0) then continue;//既にOK済
				tc1 := CharaPID.IndexOfObject(tdl.UserID[w2]) as TChara;
				if (tc1 = nil) then continue;

				RFIFOW(2, w);
				RFIFOL(4, l);
				if (w <> 0) then begin
					//アイテムチェック
					if (tc.Item[w].ID <> 0) and (tc.Item[w].Amount >= l) then begin
						td := tc.Item[w].Data;
						if (cardinal(td.Weight * l) > tc1.MaxWeight - tc1.Weight) then begin
							//相手方重量オーバー//100種類以上チェック未済
							WFIFOW( 0, $00ea);
							WFIFOW( 2, w);
							WFIFOB( 4, 1);
							Socket.SendBuf(buf, 5);
						end else begin
							//仮設倉庫にアイテム追加
							tdl.ItemIdx[w1][tdl.Cnt[w1]] := w;
							tdl.Amount[w1][tdl.Cnt[w1]] := l;
							tdl.Cnt[w1] := tdl.Cnt[w1] + 1;
							//アイテム提示成功パケ
							WFIFOW( 0, $00ea);
							WFIFOW( 2, w);
							WFIFOB( 4, 0);
							Socket.SendBuf(buf, 5);
							//相手方にアイテム提示パケ
							WFIFOW( 0, $00e9);
							WFIFOL( 2, l);
							WFIFOW( 6, td.ID);
							WFIFOB( 8, tc.Item[w].Identify);
							WFIFOB( 9, tc.Item[w].Attr);
							WFIFOB(10, tc.Item[w].Refine);
							WFIFOW(11, tc.Item[w].Card[0]);
							WFIFOW(13, tc.Item[w].Card[1]);
							WFIFOW(15, tc.Item[w].Card[2]);
							WFIFOW(17, tc.Item[w].Card[3]);
							tc1.Socket.SendBuf(buf, 19);
						end;
					end;
				end else begin
					//ゼニーチェック
					if (tc.Zeny < l) then l := tc.Zeny;
					//仮設倉庫にゼニー追加
					tdl.Zeny[w1] := l;
					//アイテム提示成功パケ
					WFIFOW( 0, $00ea);
					WFIFOW( 2, 0);
					WFIFOB( 4, 0);
					Socket.SendBuf(buf, 5);
					//ゼニー提示パケ
					ZeroMemory(@buf[0], 19);
					WFIFOW( 0, $00e9);
					WFIFOL( 2, l);
					WFIFOB( 8, 1);
					tc1.Socket.SendBuf(buf, 19);
				end;
			end;
		//--------------------------------------------------------------------------
		$00eb: //アイテム追加完了
			begin
				if (tc.DealingID = 0) then continue;
				i := DealingList.IndexOf(tc.DealingID);
				if (i = -1) then continue;
				tdl:= DealingList.Objects[i] as TDealings;
				if (tdl.UserID[0] = tc.ID) then begin
					w1 := 0;
					w2 := 1;
				end else begin
					w1 := 1;
					w2 := 0;
				end;
				tc1 := CharaPID.IndexOfObject(tdl.UserID[w2]) as TChara;
				if (tc1 = nil) then continue;

				tdl.Mode[w1] := 1;
				//追加完了パケ
				WFIFOW(0, $00ec);
				WFIFOB(2, 0);
				Socket.SendBuf(buf, 3);
				WFIFOW(0, $00ec);
				WFIFOB(2, 1);
				tc1.Socket.SendBuf(buf, 3);
			end;
		//--------------------------------------------------------------------------
		$00ed: //取引キャンセル
			begin
				CancelDealings(tc);
			end;
		//--------------------------------------------------------------------------
		$00ef: //取引承諾
			begin
				if (tc.DealingID = 0) then continue;
				i := DealingList.IndexOf(tc.DealingID);
				if (i = -1) then continue;
				tdl:= DealingList.Objects[i] as TDealings;
				if (tdl.UserID[0] = tc.ID) then begin
					w1 := 0;
					w2 := 1;
				end else begin
					w1 := 1;
					w2 := 0;
				end;
				if (tdl.Mode[w1] = 0) then begin
					continue;//OK未済
				end else if (tdl.Mode[w1] = 1) then begin
					tdl.Mode[w1] := 2;
				end;
				if (tdl.Mode[w1] <> 2) or (tdl.Mode[w2] <> 2) then continue;//両者完了待ち
				tc1 := CharaPID.IndexOfObject(tdl.UserID[w2]) as TChara;
				if (tc1 = nil) then continue;

				//キャラ１アイテム処理
				if (tdl.Cnt[w1] > 0) then begin
					for i := 0 to tdl.Cnt[w1] - 1 do begin
						w := tdl.ItemIdx[w1][i];
						if (tc.Item[w].ID <> 0) and (tc.Item[w].Amount > 0) then begin
							td := tc.Item[w].Data;
							//相手にアイテム追加
							j := SearchCInventory(tc1, td.ID, td.IEquip);
							with tc.Item[w] do begin
								tc1.Item[j].ID := ID;
								tc1.Item[j].Amount := tc1.Item[j].Amount + tdl.Amount[w1][i];
								tc1.Item[j].Equip := Equip;
								tc1.Item[j].Identify := Identify;
								tc1.Item[j].Refine := Refine;
								tc1.Item[j].Attr := Attr;
								tc1.Item[j].Card[0] := Card[0];
								tc1.Item[j].Card[1] := Card[1];
								tc1.Item[j].Card[2] := Card[2];
								tc1.Item[j].Card[3] := Card[3];
								tc1.Item[j].Data := td;
							end;
							SendCGetItem(tc1, j, tdl.Amount[w1][i]);
							//相手の重量変更
							tc1.Weight := tc1.Weight + cardinal(td.Weight * tdl.Amount[w1][i]);
							//自分のアイテム削除
							Dec(tc.Item[w].Amount, tdl.Amount[w1][i]);
							if (tc.Item[w].Amount = 0) then tc.Item[w].ID := 0;
							//自分の重量変更
							tc.Weight := tc.Weight - cardinal(td.Weight * tdl.Amount[w1][i]);
						end;
					end;
				end;

				//キャラ２アイテム処理
				if (tdl.Cnt[w2] > 0) then begin
					for i := 0 to tdl.Cnt[w2] - 1 do begin
						w := tdl.ItemIdx[w2][i];
						if (tc1.Item[w].ID <> 0) and (tc1.Item[w].Amount > 0) then begin
							td := tc1.Item[w].Data;
							//相手にアイテム追加
							j := SearchCInventory(tc, td.ID, td.IEquip);
							with tc1.Item[w] do begin
								tc.Item[j].ID := ID;
								tc.Item[j].Amount := tc.Item[j].Amount + tdl.Amount[w2][i];
								tc.Item[j].Equip := Equip;
								tc.Item[j].Identify := Identify;
								tc.Item[j].Refine := Refine;
								tc.Item[j].Attr := Attr;
								tc.Item[j].Card[0] := Card[0];
								tc.Item[j].Card[1] := Card[1];
								tc.Item[j].Card[2] := Card[2];
								tc.Item[j].Card[3] := Card[3];
								tc.Item[j].Data := td;
							end;
							SendCGetItem(tc, j, tdl.Amount[w2][i]);
							//相手の重量変更
							tc.Weight := tc.Weight + cardinal(td.Weight * tdl.Amount[w2][i]);
							//自分のアイテム削除
							Dec(tc1.Item[w].Amount, tdl.Amount[w2][i]);
							if (tc1.Item[w].Amount = 0) then tc1.Item[w].ID := 0;
							//自分の重量変更
							tc1.Weight := tc1.Weight - cardinal(td.Weight * tdl.Amount[w2][i]);
						end;
					end;
				end;

				if (tdl.Zeny[w1] <> 0) or (tdl.Zeny[w2] <> 0) then begin
          // Update zeny for trade partners
					tc.Zeny := tc.Zeny - tdl.Zeny[w1] + tdl.Zeny[w2];
          SendCStat1(tc, 1, $0014, tc.Zeny);

					tc1.Zeny := tc1.Zeny - tdl.Zeny[w2] + tdl.Zeny[w1];
          SendCStat1(tc1, 1, $0014, tc1.Zeny);
				end;

        // Update players' weights
        SendCStat1(tc, 0, $0018, tc.Weight);
        SendCStat1(tc1, 0, $0018, tc1.Weight);

				//取引完了パケ
				WFIFOW(0, $00f0);
				WFIFOB(2, 0);
				tc.Socket.SendBuf(buf, 3);
				tc1.Socket.SendBuf(buf, 3);

				tc.DealingID := 0;
				tc1.DealingID := 0;
				//DebugOut.Lines.Add(Format('Dealings(%d) was completed / Remaining Dealings(%d)', [tdl.ID,DealingList.Count-1]));
				DealingList.Delete(DealingList.IndexOf(tdl.ID));
				tdl.Free;
			end;
{取引機能追加ココまで}
		//--------------------------------------------------------------------------
		$00f3: //倉庫にアイテム放り込み
			begin
				tp := tc.PData;
				RFIFOW(2, w1);
				RFIFOL(4, l);
				if l > 30000 then l := 30000;
				w2 := l;
				if (tc.Item[w1].ID = 0) or (tc.Item[w1].Amount < w2) then begin
					continue;
				end;
				j := SearchPInventory(tc, tc.Item[w1].ID, tc.Item[w1].Data.IEquip);
				if j = 0 then begin
					continue;
				end;
				if tp.Kafra.Item[j].Amount + w2 > 30000 then begin
					continue;
				end;
				//倉庫にアイテム追加
				tp.Kafra.Item[j].ID := tc.Item[w1].ID;
				Inc(tp.Kafra.Item[j].Amount, w2);
				tp.Kafra.Item[j].Equip := 0;
				tp.Kafra.Item[j].Identify := tc.Item[w1].Identify;
				tp.Kafra.Item[j].Refine := tc.Item[w1].Refine;
				tp.Kafra.Item[j].Attr := tc.Item[w1].Attr;
				tp.Kafra.Item[j].Card[0] := tc.Item[w1].Card[0];
				tp.Kafra.Item[j].Card[1] := tc.Item[w1].Card[1];
				tp.Kafra.Item[j].Card[2] := tc.Item[w1].Card[2];
				tp.Kafra.Item[j].Card[3] := tc.Item[w1].Card[3];
				tp.Kafra.Item[j].Data := tc.Item[w1].Data;
				//パケ送信
				WFIFOW( 0, $00f4);
				WFIFOW( 2, j);
				WFIFOL( 4, w2);//tp.Kafra.Item[j].Amount
				WFIFOW( 8, tp.Kafra.Item[j].ID);
				WFIFOB(10, tp.Kafra.Item[j].Identify);
				WFIFOB(11, tp.Kafra.Item[j].Attr);
				WFIFOB(12, tp.Kafra.Item[j].Refine);
				WFIFOW(13, tp.Kafra.Item[j].Card[0]);
				WFIFOW(15, tp.Kafra.Item[j].Card[1]);
				WFIFOW(17, tp.Kafra.Item[j].Card[2]);
				WFIFOW(19, tp.Kafra.Item[j].Card[3]);
				Socket.SendBuf(buf, 21);
				//倉庫アイテム数変更
				Inc(tp.Kafra.Count);
				WFIFOW(0, $00f2);
				WFIFOW(2, tp.Kafra.Count);
				WFIFOW(4, 100);
				tc.Socket.SendBuf(buf, 6);
				//アイテム数減少
				Dec(tc.Item[w1].Amount, w2);
				if tc.Item[w1].Amount = 0 then tc.Item[w1].ID := 0;
				WFIFOW( 0, $00af);
				WFIFOW( 2, w1);
				WFIFOW( 4, w2);
				Socket.SendBuf(buf, 6);
				//重量変更
				tc.Weight := tc.Weight - tc.Item[w1].Data.Weight * w2;
        Inc(tp.Kafra.Weight,(tc.Item[w1].Data.Weight * w2));
				SendCStat1(tc, 0, $0018, tc.Weight);
			end;
		//--------------------------------------------------------------------------
		$00f5: //倉庫からアイテム取り出し
			begin
				tp := tc.PData;
				RFIFOW(2, w1);
				RFIFOL(4, l);
				if l > 30000 then l := 30000;
				w2 := l;
				if (tp.Kafra.Item[w1].ID = 0) or (tp.Kafra.Item[w1].Amount < w2) then begin
					continue;
				end;
				weight := tp.Kafra.Item[w1].Data.Weight * w2;

				if longint(tc.MaxWeight) - longint(tc.Weight) < weight then begin // AlexKreuz: Integer Overflow Protection
					//重量オーバー
					WFIFOW(0, $00ca);
					WFIFOB(2, 3);  //1=お金が足りない 2=重量オーバー 3=アイテム最大種類数オーバー
					Socket.SendBuf(buf, 3);
				end

                                // AlexKreuz: User Overweight - Kafra Protection
                                else begin
	        			j := SearchCInventory(tc, tp.Kafra.Item[w1].ID, tp.Kafra.Item[w1].Data.IEquip);
        				if j = 0 then begin
				        	continue;
			        	end;
		        		if tc.Item[j].Amount + w2 > 30000 then begin
	        				continue;
        				end;
		        		//倉庫からアイテム追加
	        			tc.Item[j].ID := tp.Kafra.Item[w1].ID;
        				Inc(tc.Item[j].Amount, w2);
				        tc.Item[j].Equip := 0;
			        	tc.Item[j].Identify := tp.Kafra.Item[w1].Identify;
		        		tc.Item[j].Refine := tp.Kafra.Item[w1].Refine;
	        			tc.Item[j].Attr := tp.Kafra.Item[w1].Attr;
        				tc.Item[j].Card[0] := tp.Kafra.Item[w1].Card[0];
				        tc.Item[j].Card[1] := tp.Kafra.Item[w1].Card[1];
			        	tc.Item[j].Card[2] := tp.Kafra.Item[w1].Card[2];
		        		tc.Item[j].Card[3] := tp.Kafra.Item[w1].Card[3];
	        			tc.Item[j].Data := tp.Kafra.Item[w1].Data;
        				SendCGetItem(tc, j, w2);
				        //倉庫のアイテム数減少
			        	Dec(tp.Kafra.Item[w1].Amount, w2);
		        		if tp.Kafra.Item[w1].Amount = 0 then begin
                  tp.Kafra.Item[w1].ID := 0;
                  Dec(tp.Kafra.Count);
                end;
	        			WFIFOW( 0, $00f6);
        				WFIFOW( 2, w1);
				        WFIFOL( 4, l);
			        	Socket.SendBuf(buf, 8);
		        		//倉庫アイテム数変更
        				WFIFOW(0, $00f2);
				        WFIFOW(2, tp.Kafra.Count);
			        	WFIFOW(4, 100);
		        		tc.Socket.SendBuf(buf, 6);
	        			//重量変更
        				tc.Weight := tc.Weight + weight;
                                        Dec(tp.Kafra.Weight,weight);
			        	SendCStat1(tc, 0, $0018, tc.Weight);
                                end;
			end;
		//--------------------------------------------------------------------------
		$00f7: //倉庫閉じ
			begin
				tc.AMode := 0;
				WFIFOW( 0, $00f8);
				Socket.SendBuf(buf, 2);
			end;
		//--------------------------------------------------------------------------
		$00f9: // Request to organize a party - NOTE, 01e8 is updated version
			begin
				str := RFIFOS(2, 24);
				if (tc.Skill[1].Lv < 7) and (not DisableSkillLimit) then begin
          { Mitch: Fix (Bug #394) }
          // Colus, 20040218: Are you kidding me?  Why would you use a GLOBAL
          // BROADCAST to give the party fail message?
          {str := 'You must be at least Basic Skill Level 7 to create a party!';
          w := Length(str) + 4;
          WFIFOW (0, $009a);
          WFIFOW (2, w);
          WFIFOS (4, str, w - 4);
          tc.socket.sendbuf(buf, w); }
          w := tc.MSkill;
          // This is for a basic skill.
          tc.MSkill := 1;
          SendSkillError(tc, 0, 4);
          tc.MSkill := w;
				end else begin
					if tc.PartyName <> '' then begin
						i := 2;
					end else if (str = '') or (PartyNameList.IndexOf(str) <> -1) then begin
						i := 1;
					end else begin
						//パーティー名が重複してはいけない
						tpa := TParty.Create;
						tpa.Name := str;
						tpa.EXPShare := 0;
						tpa.ITEMShare := 1;
						tpa.MemberID[0] := tc.CID; //リーダ:0
						tpa.Member[0] := tc;
                                                if tc.JID = 19 then begin
                                                        tpa.PartyBard[0] := tc;
                                                        //DebugOut.Lines.Add(Format('Bard Added To Party', [tpa.Name, tpa.MinLV, tpa.MaxLV, tpa.MemberID[0], tpa.Member[0].Name]));
                                                end else if tc.JID = 20 then begin
                                                        tpa.PartyDancer[0] := tc;
                                                        //DebugOut.Lines.Add(Format('Dancer Added To Party', [tpa.Name, tpa.MinLV, tpa.MaxLV, tpa.MemberID[0], tpa.Member[0].Name]));
                                                end;
						tc.PartyName := tpa.Name;
						PartyNameList.AddObject(tpa.Name, tpa);
						//DebugOut.Lines.Add(Format('PartyName %s : from %d to %d : ID = %d : Name = %s', [tpa.Name, tpa.MinLV, tpa.MaxLV, tpa.MemberID[0], tpa.Member[0].Name]));
						SendPartyList(tc);
						i := 0;
					end;

					//パーティー作成正否応答
					WFIFOW( 0, $00fa);
					WFIFOB( 2, i);         // 1:同名～ 2:既に～
					Socket.SendBuf(buf, 3);
				end;
				//DebugOut.Lines.Add(Format('PartyNameList.Count = %d', [PartyNameList.Count]));

			end;

		//--------------------------------------------------------------------------
		$00fc: //パーティー勧誘
			begin
				RFIFOL(2, l);
				tc1 := CharaPID.IndexOfObject(l) as TChara;
				if tc1 = nil then Continue;
				if (tc1.PartyName = '') and ((tc1.Skill[1].Lv >= 5) or DisableSkillLimit) then begin
					WFIFOW( 0, $00fe);
					WFIFOL( 2, tc.ID);
					WFIFOS( 6, tc.PartyName, 24);
					tc1.Socket.SendBuf(buf, 30);
					//DebugOut.Lines.Add(Format('Party (%s) Join Request From %s To %s', [tc.PartyName,tc.Name,tc1.Name]));
				end else begin
					WFIFOW( 0, $00fd);
					WFIFOS( 2, tc1.Name, 24);
          if (tc1.Skill[1].Lv < 5) and (not DisableSkillLimit) then
  					WFIFOB(26, 1)
          else
            WFIFOB(26, 0);
					tc.Socket.SendBuf(buf, 27);
				end;
			end;
		//--------------------------------------------------------------------------
		$00ff: //パーティー勧誘返答
			begin
				RFIFOL(2, l);
				RFIFOL(6, l2);
				j := -1;
				//DebugOut.Lines.Add(Format('tc.ID = %d : l = %d', [tc.CID,l]));
				tc1 := CharaPID.IndexOfObject(l) as TChara;
				if tc1 = nil then Continue;
				//DebugOut.Lines.Add(Format('tc.ID = %d / tc1.ID = %d / l = %d', [tc.CID,tc1.CID,l]));
				if (l2 = 0) then begin
					WFIFOW( 0, $00fd);
					WFIFOS( 2, tc.Name, 24);
					WFIFOB( 26, 1);
					tc1.Socket.SendBuf(buf, 27);
				end else begin
					tpa := PartyNameList.Objects[PartyNameList.IndexOf(tc1.PartyName)] as TParty;
					for i := 0 to 11 do begin
						if (tpa.MemberID[i] = 0) and (tpa.Member[i] = nil) then begin
							tpa.MemberID[i] := tc.CID;
							tpa.Member[i] := tc;
                                                        if tc.JID = 19 then begin
                                                                tpa.PartyBard[0] := tc;
                                                                //DebugOut.Lines.Add(Format('Bard Added To Party', [tpa.Name, tpa.MinLV, tpa.MaxLV, tpa.MemberID[0], tpa.Member[0].Name]));
                                                        end else if tc.JID = 20 then begin
                                                                tpa.PartyDancer[0] := tc;
                                                                //DebugOut.Lines.Add(Format('Dancer Added To Party', [tpa.Name, tpa.MinLV, tpa.MaxLV, tpa.MemberID[0], tpa.Member[0].Name]));
                                                        end;
							tc.PartyName := tpa.Name;
							if (tc.BaseLV < tpa.MinLV) then tpa.MinLV := tc.BaseLV;
							if (tc.BaseLV > tpa.MaxLV) then tpa.MaxLV := tc.BaseLV;
							j := i;
							break
						end;
					end;
					if (j <> -1) then begin
						//DebugOut.Lines.Add(Format('PartyName = %s / tc.ID = %d / tc1.ID = %d / slot = %d', [tpa.Name,tc.ID,tc1.ID,j]));
						SendPartyList(tc);
					end;
				end;
			end;
		//--------------------------------------------------------------------------
		$0100: //パーティー脱退
			begin
				i := PartyNameList.IndexOf(tc.PartyName);
				if (i <> -1) then begin
					tpa := PartyNameList.Objects[i] as TParty;
					//DebugOut.Lines.Add(Format('party check tc.PartyName = %d tpa.Name = %d', [PartyNameList.IndexOf(tc.PartyName),PartyNameList.IndexOf(tpa.Name)]));

					WFIFOW( 0, $0105);
					WFIFOL( 2, tc.CID);
					WFIFOS( 6, tc.Name , 24);
					WFIFOB( 30, 1);
					SendPCmd(tc,31);

					tc.PartyName := '';

					j := -1;
					for i := 0 to 11 do begin;
						if tc.CID = tpa.MemberID[i] then begin
							j := i;
							break;
						end;
					end;

					for i := j to 10 do begin
						tpa.MemberID[i] := tpa.MemberID[i+1];
						tpa.Member[i] := tpa.Member[i+1];
					end;
						tpa.MemberID[11] := 0;
						tpa.Member[11] := nil;

					//DebugOut.Lines.Add(Format('%s Leaves %s', [tc.Name,tpa.Name]));

					if (tpa.MemberID[0] = 0) then begin
					  if UseSQL then DeleteParty(tpa.Name);
						PartyNameList.Delete(PartyNameList.IndexOf(tpa.Name));
						//DebugOut.Lines.Add(Format('party(%s) was deleted (%d)', [tpa.Name,PartyNameList.Count]));
						tpa.Free;
					end else begin
						SendPartyList(tpa.Member[0]);
					end;
				end;
			end;
		//--------------------------------------------------------------------------
		$0102: //パーティー設定変更
			begin

				RFIFOW(2, w1);
				RFIFOW(4, w2);
				if (PartyNameList.IndexOf(tc.PartyName) <> -1) then begin
					tpa := PartyNameList.Objects[PartyNameList.IndexOf(tc.PartyName)] as TParty;

					//公平可能レベルの設定はここ。iniで設定できたほうが便利かな？
					if (tpa.MaxLV - tpa.MinLV > 10) then begin
						w1 := 2;
					end else begin
						tpa.EXPShare := w1;
					end;

					tpa.ITEMShare := w2;

					WFIFOW( 0, $0101);
					WFIFOW( 2, w1);
					WFIFOW( 6, w2);
					SendPCmd(tc,6);

					if (w1 = 2) then begin
						WFIFOW(0, $0101);
						WFIFOW(2, tpa.EXPShare);
						WFIFOW(4, tpa.ITEMShare);
						SendPCmd(tc, 6);
					end;
				end;
			end;
		//--------------------------------------------------------------------------
		$0103: //パーティー除名
			begin
				RFIFOL(2, l);
				if CharaPID.IndexOf(l) <> -1 then begin
					tc1 := CharaPID.IndexOfObject(l) as TChara;
					if (PartyNameList.IndexOf(tc1.PartyName) <> -1) then begin
						tpa := PartyNameList.Objects[PartyNameList.IndexOf(tc1.PartyName)] as TParty;

						WFIFOW( 0, $0105);
						WFIFOL( 2, tc1.CID);
						WFIFOS( 6, tc1.Name , 24);
						WFIFOB( 30, 1);
						SendPCmd(tc1,31);

						tc1.PartyName := '';

						j := -1;
						for i := 0 to 11 do begin;
							if tc1.CID = tpa.MemberID[i] then begin
							j := i;
							break;
							end;
						end;

						for i := j to 10 do begin
							tpa.MemberID[i] := tpa.MemberID[i+1];
							tpa.Member[i] := tpa.Member[i+1];
						end;
							tpa.MemberID[11] := 0;
							tpa.Member[11] := nil;

						//DebugOut.Lines.Add(Format('%s Leaves %s', [tc.Name,tpa.Name]));

						if (tpa.MemberID[0] = 0) then begin
						  if UseSQL then DeleteParty(tpa.Name);
							PartyNameList.Delete(PartyNameList.IndexOf(tpa.Name));
							//DebugOut.Lines.Add(Format('party(%s) was deleted (%d)', [tpa.Name,PartyNameList.Count]));
							tpa.Free;
						end else begin
							SendPartyList(tpa.Member[0]);
						end;
					end;
				end;
			end;
		//--------------------------------------------------------------------------
		$0108: //パーティーチャット
			begin
				RFIFOW(2, w);
				str := RFIFOS(4, w - 4);
				if (PartyNameList.IndexOf(tc.PartyName) <> -1) then begin
					WFIFOW( 0, $0109);
					WFIFOW( 2, w + 4);
					WFIFOL( 4, tc.ID);
					WFIFOS( 8, str , w - 4);
					SendPCmd(tc,w + 4);
				end;
			end;
{パーティー機能追加ココまで}
		//--------------------------------------------------------------------------
		$0112: //スキルレベルアップ要求
			begin
				RFIFOW(2, w);
{ギルド機能追加}
				if (w >= 10000) then begin
					//ギルドスキル
					j := GuildList.IndexOf(tc.GuildID);
					if (j <> -1) then begin
						tg := GuildList.Objects[j] as TGuild;
						with tg do begin
							if (GSkill[w].Lv < GSkill[w].Data.MasterLV) and (GSkillPoint > 0)
							and (tc.Name = MasterName) then begin
								GSkill[w].Lv	:= GSkill[w].Lv + 1;
								GSkillPoint	:= GSkillPoint - 1;
								if (w = 10004) then begin
									MaxUsers := 16 + GSkill[w].Data.Data1[GSkill[w].Lv];
									SendGuildInfo(tc, 0, true);
								end;
								SendGuildInfo(tc, 3, true);
							end;
						end;
					end;
				end else begin
{ギルド機能追加ココまで}
					if (tc.Skill[w].Lv < tc.Skill[w].Data.MasterLV) and (tc.SkillPoint > 0) then begin
						tc.Skill[w].Lv	:= tc.Skill[w].Lv + 1;
						tc.SkillPoint	:= tc.SkillPoint - 1;

						WFIFOW(0, $010e);
						WFIFOW(2, w);
						WFIFOW(4, tc.Skill[w].Lv);
						WFIFOW(6, tc.Skill[w].Data.SP[tc.Skill[w].Lv]);
						WFIFOW(8, tc.Skill[w].Data.Range);
						if (tc.Skill[w].Lv < tc.Skill[w].Data.MasterLV) and (tc.SkillPoint > 0) then b := 1 else b := 0;
						WFIFOB(10, b);
						Socket.SendBuf(buf,11);
						SendCSkillList(tc);

						CalcStat(tc);
						SendCStat(tc);
					end else begin
						//失敗
						WFIFOW(0, $010e);
						WFIFOW(2, w);
						WFIFOW(4, tc.Skill[w].Lv);
						WFIFOW(6, tc.Skill[w].Data.SP[tc.Skill[w].Lv]);
						WFIFOW(8, tc.Skill[w].Data.Range);
						if (tc.Skill[w].Lv < tc.Skill[w].Data.MasterLV) and (tc.SkillPoint > 0) then b := 1 else b := 0;
						WFIFOB(10, b);
						Socket.SendBuf(buf,11);
					end;
{ギルド機能追加}
				end;
{ギルド機能追加ココまで}
			end;
		//--------------------------------------------------------------------------
		$0113: //ターゲット指定or瞬時発動スキル
			begin
        // OK, you have to know what you're trying to cast first.  Is it
        // Cast Cancel?

        RFIFOW(4, w);

        //if ((tc.MMode <> 0) and (tc.MSkill <> 275)) then continue;   // <- Leave that in!
        //if ((tc.MMode = 0) and (tc.MTick > timeGetTime())) or (tc.MSkill = 277) then Continue;

				if (((tc.MMode <> 0) and (w <> 275)) or
            ((tc.MMode = 0) and ((tc.MTick > timeGetTime()) or (w = 275))) ) then continue;
{チャットルーム機能追加}
				//入室中のスキル使用無効
				if (tc.ChatRoomID <> 0) then continue;
{チャットルーム機能追加ココまで}
{露店スキル追加}
				//露店中のスキル使用無効
				if (tc.VenderID <> 0) then continue;
{露店スキル追加ココまで}


        // Now we need to save the previous spell off somewhere to pick it up
        // when we actually perform the Cast Cancel effect.
        if (w = 275) then begin
          tc.Skill[275].Effect1 := tc.MSkill;
          tc.Skill[275].EffectLV := tc.MUseLV;
        end;

				RFIFOW(2, tc.MUseLV);
				tc.MSkill := w; // We already read this above... RFIFOW(4, tc.MSkill);
				RFIFOL(6, tc.MTarget);
				tc.MPoint.X := 0;
				tc.MPoint.Y := 0;

        //DebugOut.Lines.Add('Use Skill:' + IntToStr(tc.MSkill));
        //DebugOut.Lines.Add('Use Level:' + IntToStr(tc.MUseLV));
        //DebugOut.Lines.Add('Target:' + IntToStr(tc.MTarget));
        //DebugOut.Lines.Add('Mode:' + IntToStr(tc.MMode));
        //DebugOut.Lines.Add('Use Item:' + IntToStr(tc.UseItemID));

        if (tc.Sit <> 1) or (tc.MSkill = 143) then begin
				if (tc.MSkill = 0) or (tc.MSkill > MAX_SKILL_NUMBER) then continue;
{NPCイベント追加}
				i := MapInfo.IndexOf(tc.Map);
				j := -1;
				if (i <> -1) then begin
					mi := MapInfo.Objects[i] as MapTbl;
					if ((mi.noTele = true) or (mi.noPortal = true) or (tc.Option and 6 <> 0)) then j := 0;
				end;
				if (tc.MSkill = 26) and (j = 0) then continue;
{アジト機能追加ココまで}
{Colus, 20040116: This whole section seems redundant...
				RFIFOW(2, tc.MUseLV);
				RFIFOW(4, tc.MSkill);
				RFIFOL(6, tc.MTarget);
				tc.MPoint.X := 0;
				tc.MPoint.Y := 0;

				if (tc.MSkill = 0) or (tc.MSkill > 336) then continue;
// Japanese comment: 'Begin agit consideration'
				if (tc.MSkill = 26) and mi.noPortal then continue;
// Japanese comment: 'Agit consideration ends here.'  We rolled this into the above checks.
}
{修正}	if (tc.ver2 = 9) and (tc.MUseLV > 30) then tc.MUseLV := tc.MUseLV - 30;
				if ((tc.Skill[tc.MSkill].Lv >= tc.MUseLV) and (tc.MUseLV > 0)) then begin
					tk := tc.Skill[tc.MSkill];
					tl := tc.Skill[tc.MSkill].Data;

					k := UseTargetSkill(tc,timeGetTime());
					if k <> 0 then SendSkillError(tc,k);
        end else if (tc.ItemSkill) then begin
          tk := tc.Skill[tc.MSkill];
					tl := tc.Skill[tc.MSkill].Data;

					k := UseTargetSkill(tc,timeGetTime());
					if k <> 0 then SendSkillError(tc,k);
				end;
        end;
			end;
		//--------------------------------------------------------------------------
		$0116: //場所指定スキル
			begin
				if tc.MMode <> 0 then continue;
        if (tc.MMode = 0) and (tc.MTick > timeGetTime()) then Continue;
{チャットルーム機能追加}
				//入室中のスキル使用無効
				if (tc.ChatRoomID <> 0) then continue;
{チャットルーム機能追加ココまで}
{露店スキル追加}
				//露店中のスキル使用無効
				if (tc.VenderID <> 0) then continue;
{露店スキル追加ココまで}
{アジト機能追加}
				i := MapInfo.IndexOf(tc.Map);
				if (i <> -1) then begin
					mi := MapInfo.Objects[i] as MapTbl;
				end else begin
					mi := MapTbl.Create;
				end;
				if mi.noSkill then continue;
{アジト機能追加ココまで}

				RFIFOW(2, tc.MUseLV);
				RFIFOW(4, tc.MSkill);
				RFIFOW(6, tc.MPoint.X);
				RFIFOW(8, tc.MPoint.Y);
				tc.MTarget := 0;

				if (tc.MSkill = 0) or (tc.MSkill > MAX_SKILL_NUMBER) then continue;
{アジト機能追加}
				if ((tc.MSkill = 27) and (mi.noTele or (tc.Option and 6 <> 0))) then continue;
{アジト機能追加ココまで}
{修正}	if (tc.ver2 = 9) and (tc.MUseLV > 30) then tc.MUseLV := tc.MUseLV - 30;
				if (tc.Skill[tc.MSkill].Lv >= tc.MUseLV) and (tc.MUseLV > 0) then begin
					tk := tc.Skill[tc.MSkill];
					tl := tc.Skill[tc.MSkill].Data;
					k := UseFieldSkill(tc,timeGetTime());
					if k <> 0 then SendSkillError(tc,k);
				end;
			end;
		//--------------------------------------------------------------------------
		$0118: //攻撃キャンセル
			begin
				if (tc.AMode = 1) or (tc.AMode = 2) then tc.AMode := 0;
				//DebugOut.Lines.Add(Format('3:%.8d AMode = %d', [tc.ID, tc.AMode]));
			end;
		//--------------------------------------------------------------------------
		$011b: //テレポorポータル場所選択
			begin
        if (tc.Sit <> 1) then begin
				tm := tc.MData;
				RFIFOW(2, w);
				if (w <> 26) and (w <> 27) then continue;
				str := RFIFOS(4, 16);

				if tc.SP < tc.Skill[w].Data.SP[tc.Skill[w].Lv] then begin
					//SP不足
					WFIFOW( 0, $0110);
					WFIFOW( 2, 26);
					WFIFOW( 4, 0);
					WFIFOW( 6, 0);
					WFIFOB( 8, 0);
					WFIFOB( 9, 1);
					Socket.SendBuf(buf, 10);
					continue;
				end;
				if tc.Weight * 100 div tc.MaxWeight >= 90 then begin
					//重量オーバー
					WFIFOW(0, $013b);
					WFIFOW(2, 2);
					Socket.SendBuf(buf, 4);
					continue;
				end;
				if (w = 26) then begin //テレポート
					if (tc.Skill[26].Lv >= 1) and (str = 'Random') then begin //ランダムワープ
						//座標移動
						j := 0;
						repeat
							xy.X := Random(tm.Size.X - 2) + 1; //画面端の隙間には飛ばないように
							xy.Y := Random(tm.Size.Y - 2) + 1;
							Inc(j);
						until ( ((tm.gat[xy.X, xy.Y] <> 1) and (tm.gat[xy.X, xy.Y] <> 5)) or (j = 100) );
						if j = 100 then begin
							//飛べないということはないと思うけど一応、フェイルセーフ
							WFIFOW( 0, $0110);
							WFIFOW( 2, 26);
							WFIFOW( 4, 0);
							WFIFOW( 6, 0);
							WFIFOB( 8, 0);
							WFIFOB( 9, 0);
							Socket.SendBuf(buf, 10);
							continue;
						end;
						//マップ移動
						DecSP(tc, 26, tc.Skill[26].Lv);
                                                    tc.MMode := 0;
						SendCLeave(tc, 3);
						tc.Point := xy;
						MapMove(Socket, tc.Map, tc.Point);
					end else if (tc.Skill[26].Lv = 2) and (ChangeFileExt(str, '') = tc.SaveMap) then begin //セーブ場所へ帰る
						DecSP(tc, 26, 2);
            tc.MMode := 0;
						SendCLeave(tc, 0);
						tc.Map := tc.SaveMap;
						tc.Point := tc.SavePoint;
						MapMove(Socket, tc.Map, tc.Point);
					end;
				end else begin //ワープポータル
					j := -1;
					if ChangeFileExt(str, '') = tc.SaveMap then begin
						xy := tc.SavePoint;
						j := 3;
					end else begin
						for i := 0 to tc.Skill[27].Data.Data1[tc.Skill[27].Lv] - 1 do begin
							if ChangeFileExt(str, '') = tc.MemoMap[i] then begin
								xy := tc.MemoPoint[i];
								j := i;
								break;
							end;
						end;
					end;
					if j = -1 then continue; //不正パケット
					//ワープがループしないかどうかチェック
					if (tc.Map = ChangeFileExt(str, '')) and (tc.MPoint.X = xy.X) and (tc.MPoint.Y = xy.Y) then begin
						WFIFOW( 0, $0110);
						WFIFOW( 2, 27);
						WFIFOW( 4, 0);
						WFIFOW( 6, 0);
						WFIFOB( 8, 0);
						WFIFOB( 9, 3); //一応、memo無しエラーを送る
						Socket.SendBuf(buf, 10);
						continue;
					end;
					if tc.Skill[27].Data.UseItem <> 0 then begin
						//アイテムチェック&消費(未)
					end;

            j := SearchCInventory(tc, 717, false);
						if ((j <> 0) and (tc.Item[j].Amount >= 1)) or (tc.NoJamstone = True) then begin

              if tc.NoJamstone = False then UseItem(tc, j);

              tn := SetSkillUnit(tm, tc.ID, Point(tc.MPoint.X, tc.MPoint.Y), timeGetTime(), $81,
  	  				tc.Skill[27].Data.Data2[tc.Skill[27].Lv], 2000);
    					tn.WarpMap := ChangeFileExt(str, '');
    					tn.WarpPoint := xy;
  	  				DecSP(tc, 27, tc.Skill[27].Lv);
              tc.MMode := 0;
              tc.MPoint.X := 0;
              tc.MPoint.Y := 0;
  					end else begin
              SendSkillError(tc, 8); //No Blue Gemstone
							tc.MMode := 0;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
							Exit;
						end;

				end;
        end;
			end;
		//--------------------------------------------------------------------------
		$011d: //ポータルメモ
			begin
				if tc.Skill[27].Lv < 2 then begin //メモ不可能
					WFIFOW(0, $011e);
					WFIFOB(2, 1);
					Socket.SendBuf(buf, 3);
					continue;
				end;
				tm := tc.MData;
{NPCイベント追加}
				i := MapInfo.IndexOf(tc.Map);
				j := -1;
				if (i <> -1) then begin
					mi := MapInfo.Objects[i] as MapTbl;
					if (mi.noMemo = true) then j := 0;
				end;
				if (j = 0) then begin //メモ不可能
					WFIFOW(0, $0189);
					WFIFOW(2, 1);
					Socket.SendBuf(buf, 4);
					continue;
				end;
{NPCイベント追加ココまで}
				if (tm.gat[tc.Point.X][tc.Point.Y] = 1) or (tm.gat[tc.Point.X][tc.Point.Y] = 5) then begin //移動不能場所はメモ不可
					WFIFOW(0, $0189);
					WFIFOW(2, 1);
					Socket.SendBuf(buf, 4);
					continue;
				end;
				j := -1;
				k := tc.Skill[27].Data.Data1[tc.Skill[27].Lv];
				for i := 0 to k - 1 do begin
					if tc.MemoMap[i] = tc.Map then begin
						j := i;
						break;
					end;
				end;
				if j = -1 then begin
					for i := 0 to k - 1 do begin
						if tc.MemoMap[i] = '' then begin
							j := i;
							tc.MemoMap[i] := tc.Map;
							tc.MemoPoint[i] := tc.Point;
							break;
						end;
					end;
					if j <> -1 then begin
						//メモ成功
						WFIFOW(0, $011e);
						WFIFOB(2, 0);
						Socket.SendBuf(buf, 3);
						//DebugOut.Lines.Add(Format('Memo %d: %s (%d,%d)', [i, tc.Map, tc.Point.X, tc.Point.Y]));
						continue;
					end;
					j := 0;
				end;
				for i := j + 1 to k - 1 do begin
					tc.MemoMap[i-1] := tc.MemoMap[i];
					tc.MemoPoint[i-1] := tc.MemoPoint[i];
				end;
				tc.MemoMap[k-1] := '';
				tc.MemoPoint[k-1] := Point(0,0);
				for i := 0 to k - 1 do begin
					if tc.MemoMap[i] = '' then begin
						tc.MemoMap[i] := tc.Map;
						tc.MemoPoint[i] := tc.Point;
						break;
					end;
				end;
				//メモ成功
				WFIFOW(0, $011e);
				WFIFOB(2, 0);
				Socket.SendBuf(buf, 3);
				//DebugOut.Lines.Add(Format('Memo %d: %s (%d,%d)', [i, tc.Map, tc.Point.X, tc.Point.Y]));
				continue;
			end;
		//--------------------------------------------------------------------------
{カート機能追加}
		$0126: //Inventoryからカートにアイテムを入れる
			begin
{露店スキル追加}
				if(tc.VenderID <> 0) then continue;
{露店スキル追加ココまで}
				RFIFOW(2, w1);//inventory内でのアイテムID
				RFIFOL(4, l);//移動させる個数
				if l > 30000 then l := 30000;//上限は30000個である
				w2 := l;

				//指定アイテムを持っていない、要求された以上の個数を所持していなければ処理から抜ける(不正パケット対策)
				if (tc.Item[w1].ID = 0) or (tc.Item[w1].Amount < w2) then begin
					continue;
				end;

				//カート内部検索
				j := SearchInventory(tc.Cart, tc.Item[w1].ID, tc.Item[w1].Data.IEquip);

				//j = 0のときは最大種類数オーバーのはずなのでエラーメッセージを送り処理から抜ける(パケットに自身無し)
				if j = 0 then begin
					WFIFOW(0, $00ca);
					WFIFOB(2, 3);//2=重量オーバー 3=アイテム最大種類数オーバー
					Socket.SendBuf(buf, 3);
					continue;
				end;

				k := GetItemStore(tc.Cart,tc.Item[w1],w2);
				if k = 2 then begin
					//重量オーバーのパケットを送り、処理から抜ける
					WFIFOW(0, $012c);
					WFIFOB(2, 0);
					Socket.SendBuf(buf, 3);
					continue;
				end;
				//対象アイテムの現所持数と合わせて30000個を超えるなら処理から抜ける(本来の処理は不明)
				if k <> 0 then begin
						continue;
				end;

				//カートに追加されたアイテムを表示するパケットを送信する
				WFIFOW( 0, $0124);
				WFIFOW( 2, j);
				WFIFOL( 4, l);
				WFIFOW( 8, tc.Cart.Item[j].ID);
				WFIFOB(10, tc.Cart.Item[j].Identify);
				WFIFOB(11, tc.Cart.Item[j].Attr);
				WFIFOB(12, tc.Cart.Item[j].Refine);
				WFIFOW(13, tc.Cart.Item[j].Card[0]);
				WFIFOW(15, tc.Cart.Item[j].Card[1]);
				WFIFOW(17, tc.Cart.Item[j].Card[2]);
				WFIFOW(19, tc.Cart.Item[j].Card[3]);
				Socket.SendBuf(buf, 21);

				//プレイヤーーのInventory内のアイテム数減少
				Dec(tc.Item[w1].Amount, w2);
				if tc.Item[w1].Amount = 0 then tc.Item[w1].ID := 0;
				WFIFOW( 0, $00af);
				WFIFOW( 2, w1);
				WFIFOW( 4, w2);
				Socket.SendBuf(buf, 6);

				//プレイヤーの重量変更
				tc.Weight := tc.Weight - tc.Item[w1].Data.Weight * w2;
				SendCStat1(tc, 0, $0018, tc.Weight);

				//カート重量、容量データの送信
				//0121 <num>.w <num limit>.w <weight>.l <weight limit>l
				WFIFOW(0, $0121);
				WFIFOW(2, tc.Cart.Count);
				WFIFOW(4, 100);
				WFIFOL(6, tc.Cart.Weight);
				WFIFOL(10, tc.Cart.MaxWeight);
				Socket.SendBuf(buf, 14);
			end;
{カート機能追加ココまで}
		//--------------------------------------------------------------------------
{カート機能追加}
		$0127: //カートからInventoryにアイテム取り出し
			begin
{露店スキル追加}
				if(tc.VenderID <> 0) then continue;
{露店スキル追加ココまで}
				RFIFOW(2, w1);//inventory内でのアイテムID
				RFIFOL(4, l);//移動させる個数
				if l > 30000 then l := 30000;//上限は30000個である
				w2 := l;

				weight := tc.Cart.item[w1].Data.Weight * w2;//カートから取り出すアイテムの重量

				//重量オーバーの場合はエラーメッセージを送って処理を抜ける

                                if longint(tc.MaxWeight) - longint(tc.Weight) < longint(weight) then begin // AlexKreuz: Integer Overflow Protection
					WFIFOW(0, $012c);
					WFIFOB(2, 0);
					Socket.SendBuf(buf, 3);
                                end

                                // AlexKreuz: User Overweight - Merchant Cart Protection
                                else begin

					//指定アイテムを持っていない、処理から抜ける(不正パケット対策)
					if (tc.Cart.item[w1].ID = 0) then begin
						continue;
					end;

					//Inventory内検索
					j := SearchCInventory(tc, tc.Cart.item[w1].ID, tc.Cart.item[w1].Data.IEquip);
	
					//j = 0のときは最大種類数オーバーのはずなのでエラーメッセージを送り処理から抜ける
					if j = 0 then begin
						WFIFOW(0, $00ca);
						WFIFOB(2, 3);//2=重量オーバー 3=アイテム最大種類数オーバー
						Socket.SendBuf(buf, 3);
						continue;
					end;
	
					//対象アイテムの現所持数と合わせて30000個を超えるなら処理から抜ける(本来の処理は不明)
					if tc.Item[j].Amount + w2 > 30000 then begin
						continue;
					end;
	
					//カートからInventoryにアイテム追加
					tc.Item[j].ID := tc.Cart.item[w1].ID;
					Inc(tc.Item[j].Amount, w2);
					tc.Item[j].Equip := 0;
					tc.Item[j].Identify := tc.Cart.item[w1].Identify;
					tc.Item[j].Refine := tc.Cart.item[w1].Refine;
					tc.Item[j].Attr := tc.Cart.item[w1].Attr;
					tc.Item[j].Card[0] := tc.Cart.item[w1].Card[0];
					tc.Item[j].Card[1] := tc.Cart.item[w1].Card[1];
					tc.Item[j].Card[2] := tc.Cart.item[w1].Card[2];
					tc.Item[j].Card[3] := tc.Cart.item[w1].Card[3];
					tc.Item[j].Data := tc.Cart.item[w1].Data;
	
					//アイテム取得表示
					SendCGetItem(tc, j, w2);
	
					//カート内のアイテム数減少
					Dec(tc.Cart.item[w1].Amount, w2);
	
					//カートの重量変更
					tc.Cart.Weight := tc.Cart.Weight - weight;
	
					//所時数が0になったらID 0にしてカート内アイテム種類数を減らす
					if tc.Cart.item[w1].Amount = 0 then begin
						tc.Cart.item[w1].ID := 0;
						Dec(tc.Cart.Count);
					end;
	
					//カート内の対象アイテムの所持数表示変更
					WFIFOW( 0, $0125);
					WFIFOW( 2, w1);
					WFIFOL( 4, l);
					Socket.SendBuf(buf, 8);

					//カート重量、容量データの送信
					WFIFOW(0, $0121);
					WFIFOW(2, tc.Cart.Count);
					WFIFOW(4, 100);
					WFIFOL(6, tc.Cart.Weight);
					WFIFOL(10, tc.Cart.MaxWeight);
					Socket.SendBuf(buf, 14);
	
					//プレイヤーの重量変更
					tc.Weight := tc.Weight + weight;
					SendCStat1(tc, 0, $0018, tc.Weight);
                                end;
			end;
{カート機能追加ココまで}
		//--------------------------------------------------------------------------
{カート機能追加}
		$0128: //倉庫からカートへアイテム移動
			begin
{露店スキル追加}
				if(tc.VenderID <> 0) then continue;
{露店スキル追加ココまで}
				tp := tc.PData;

				RFIFOW(2, w1);//倉庫内での対象アイテムID
				RFIFOL(4, l);//移動させる個数

				if tp.Kafra.Item[w1].ID = 0 then Continue;
				if tp.Kafra.Item[w1].Amount < l then
					l := tp.Kafra.Item[w1].Amount;
				j := SearchInventory(tc.Cart, tp.Kafra.Item[w1].ID, tp.Kafra.Item[w1].Data.IEquip);

				//tp.Kafra.Weight := 80000;
				k := MoveItem(tc.Cart,tp.Kafra,w1,l);
				if k = -1 then Continue;
				if k = 2 then begin
					//重量オーバーのパケットを送り、処理から抜ける
					WFIFOW(0, $012c);
					WFIFOB(2, 0);
					Socket.SendBuf(buf, 3);
					continue;
				end else if k = 3 then begin
					WFIFOW(0, $00ca);
					WFIFOB(2, 3);	//1=お金が足りない 2=重量オーバー 3=アイテム最大種類数オーバー
					Socket.SendBuf(buf, 3);
					continue;
				end;

			//倉庫内の対象アイテムの個数変更
				WFIFOW( 0, $00f6);
				WFIFOW( 2, w1);
				WFIFOL( 4, l);
				Socket.SendBuf(buf, 8);

				//倉庫アイテム数変更
				WFIFOW(0, $00f2);
				WFIFOW(2, tp.Kafra.Count);
				WFIFOW(4, 100);
				tc.Socket.SendBuf(buf, 6);

				//カートに追加されたアイテムの表示
				WFIFOW( 0, $0124);
				WFIFOW( 2, j);
				WFIFOL( 4, l);
				WFIFOW( 8, tc.Cart.item[j].ID);
				WFIFOB(10, tc.Cart.item[j].Identify);
				WFIFOB(11, tc.Cart.item[j].Attr);
				WFIFOB(12, tc.Cart.item[j].Refine);
				WFIFOW(13, tc.Cart.item[j].Card[0]);
				WFIFOW(15, tc.Cart.item[j].Card[1]);
				WFIFOW(17, tc.Cart.item[j].Card[2]);
				WFIFOW(19, tc.Cart.item[j].Card[3]);
				Socket.SendBuf(buf, 21);

				//カート重量、容量データの送信
				WFIFOW(0, $0121);
				WFIFOW(2, tc.Cart.Count);
				WFIFOW(4, 100);
				WFIFOL(6, tc.Cart.Weight);
				WFIFOL(10, tc.Cart.MaxWeight);
				Socket.SendBuf(buf, 14);

			end;
{カート機能追加ココまで}
		//--------------------------------------------------------------------------
{カート機能追加}
		$0129: //カートから倉庫へアイテム移動
			begin
{露店スキル追加}
				if(tc.VenderID <> 0) then continue;
{露店スキル追加ココまで}
				tp := tc.PData;

				RFIFOW(2, w1);//カート内での対象アイテムID
				RFIFOL(4, l);//移動させる個数

				if tc.Cart.Item[w1].ID = 0 then Continue;
				if tc.Cart.Item[w1].Amount < l then
					l := tc.Cart.Item[w1].Amount;
				j := SearchInventory(tp.Kafra, tc.Cart.Item[w1].ID, tc.Cart.Item[w1].Data.IEquip);

				k := MoveItem(tp.Kafra,tc.Cart,w1,l);
				if k = -1 then Continue
				else if k = 3 then begin
					WFIFOW(0, $00ca);
					WFIFOB(2, 3);	//1=お金が足りない 2=重量オーバー 3=アイテム最大種類数オーバー
					Socket.SendBuf(buf, 3);
					continue;
				end;

				//カート内の対象アイテムの所持数表示変更
				WFIFOW( 0, $0125);
				WFIFOW( 2, w1);
				WFIFOL( 4, l);
				Socket.SendBuf(buf, 8);

				//カート重量、容量データの送信
				WFIFOW(0, $0121);
				WFIFOW(2, tc.Cart.Count);
				WFIFOW(4, 100);
				WFIFOL(6, tc.Cart.Weight);
				WFIFOL(10, tc.Cart.MaxWeight);
				Socket.SendBuf(buf, 14);

				//倉庫追加アイテムの表示
				WFIFOW( 0, $00f4);
				WFIFOW( 2, j);
				WFIFOL( 4, l);
				WFIFOW( 8, tp.Kafra.Item[j].ID);
				WFIFOB(10, tp.Kafra.Item[j].Identify);
				WFIFOB(11, tp.Kafra.Item[j].Attr);
				WFIFOB(12, tp.Kafra.Item[j].Refine);
				WFIFOW(13, tp.Kafra.Item[j].Card[0]);
				WFIFOW(15, tp.Kafra.Item[j].Card[1]);
				WFIFOW(17, tp.Kafra.Item[j].Card[2]);
				WFIFOW(19, tp.Kafra.Item[j].Card[3]);
				Socket.SendBuf(buf, 21);

				//倉庫アイテム数変更
				WFIFOW(0, $00f2);
				WFIFOW(2, tp.Kafra.Count);
				WFIFOW(4, 100);
				tc.Socket.SendBuf(buf, 6);
			end;
{カート機能追加ココまで}
		//--------------------------------------------------------------------------
		$012a: // Remove peco/cart/falcon options (clicked 'off').
			begin
				tc.Option := tc.Option and $F847;
        UpdateOption(tm, tc);
			end;
		//--------------------------------------------------------------------------
{露店スキル追加}
		$012e: //露店閉鎖
			begin
				VenderExit(tc);
			end;
		//--------------------------------------------------------------------------
		$0130: //露店アイテムリスト
			begin
				RFIFOL(2, l);
				i := VenderList.IndexOf(l);
				if (i <> -1) then begin
					tv := VenderList.Objects[i] as TVender;
					tc1 := Chara.IndexOfObject(tv.CID) as TChara;
					if (tc1 <> nil) then begin
						w := 8 + tv.Cnt * 22;
						WFIFOW( 0, $0133);
						WFIFOW( 2, w);
						WFIFOL( 4, tv.ID);
						k := 0;
						for j := 0 to tv.MaxCnt - 1 do begin
							if (tv.Idx[j] <> 0) then begin
								td := tc1.Cart.Item[tv.Idx[j]].Data;
								WFIFOL( 8+k*22, tv.Price[j]);
								WFIFOW(12+k*22, tv.Amount[j]);
								WFIFOW(14+k*22, tv.Idx[j]);
								WFIFOB(16+k*22, td.IType);
								WFIFOW(17+k*22, tc1.Cart.Item[tv.Idx[j]].ID);
								WFIFOB(19+k*22, tc1.Cart.Item[tv.Idx[j]].Identify);
								WFIFOB(20+k*22, tc1.Cart.Item[tv.Idx[j]].Attr);
								WFIFOB(21+k*22, tc1.Cart.Item[tv.Idx[j]].Refine);
								WFIFOW(22+k*22, tc1.Cart.Item[tv.Idx[j]].Card[0]);
								WFIFOW(24+k*22, tc1.Cart.Item[tv.Idx[j]].Card[1]);
								WFIFOW(26+k*22, tc1.Cart.Item[tv.Idx[j]].Card[2]);
								WFIFOW(28+k*22, tc1.Cart.Item[tv.Idx[j]].Card[3]);
								k := k + 1;
							end;
						end;
						if (k <> 0) then Socket.SendBuf(buf, w);
					end;
				end;
			end;
		//--------------------------------------------------------------------------
		$0134: //露店アイテム購入
			begin
				RFIFOW(2, w);
				if (w - 8 < 4) then continue;
				RFIFOL(4, l);
				i := VenderList.IndexOf(l);
				if (i = -1) then continue;
				tv := VenderList.Objects[i] as TVender;
				if (tv = nil) then continue;
				tc1 := Chara.IndexOfObject(tv.CID) as TChara;
				if (tc1 = nil) then continue;
				if (tc1.Map <> tc.Map) or (abs(tc1.Point.X - tc.Point.X) > 15)
					or (abs(tc1.Point.Y - tc.Point.Y) > 15) then continue;

				//アイテム格納
				SetLength(ww, ((w - 8) div 4), 2);
				for i := 0 to (w - 8) div 4 - 1 do begin
					RFIFOW( 8+i*4, ww[i][0]);
					RFIFOW(10+i*4, ww[i][1]);
				end;

				//購入メイン
				b := 0;
				for i := 0 to (w - 8) div 4 - 1 do begin
					w1 := ww[i][0];
					w2 := ww[i][1];
					k := -1;
					for j := 0 to tv.MaxCnt - 1 do begin
						if (tv.Idx[j] = w2) then begin
							if (tv.Amount[j] < w1) then begin
								w1 := tv.Amount[j];
								if (w1 = 0) then b := 3;
							end;
							k := j;
							break;
						end;
					end;

					//購入可能かチェック
					td := tc1.Cart.Item[w2].Data;
					j := SearchCInventory(tc, td.ID, td.IEquip);
					if (tc.Zeny < tv.Price[w2] * w1) then begin
						b := 1;//所持金不足
					end else if (tc.MaxWeight - tc.Weight < tv.Weight[w2] * w1) then begin
						b := 2;//重量オーバー
					end else if (j = 0) then begin
						b := 2;//種類オーバー
					end else if (k = -1) then begin
						b := 3;//インデックス不正
					end;
					if (b <> 0) then begin
						break;
					end;

					//---露店側処理---
					//カートの数量変更Part1
					Dec(tc1.Cart.Item[w2].Amount, w1);
					//カートの重量変更
					tc1.Cart.Weight := tc1.Cart.Weight - tv.Weight[k] * w1;
					// Update zeny
					tc1.Zeny := tc1.Zeny + tv.Price[k] * w1;
          SendCStat1(tc1, 1, $0014, tc1.Zeny);
					//露店リストの数量変更
					Dec(tv.Amount[k], w1);
					//販売報告パケ
					WFIFOW(0, $0137);
					WFIFOW(2, w2);
					WFIFOW(4, w1);
					tc1.Socket.SendBuf(buf, 6);

					//---購入側処理---
					// Update zeny
					tc.Zeny := tc.Zeny - tv.Price[k] * w1;
          SendCStat1(tc, 1, $0014, tc.Zeny);
					//アイテム追加
					with tc1.Cart.Item[w2] do begin
						tc.Item[j].ID := ID;
						tc.Item[j].Amount := tc.Item[j].Amount + w1;
						tc.Item[j].Equip := Equip;
						tc.Item[j].Identify := Identify;
						tc.Item[j].Refine := Refine;
						tc.Item[j].Attr := Attr;
						tc.Item[j].Card[0] := Card[0];
						tc.Item[j].Card[1] := Card[1];
						tc.Item[j].Card[2] := Card[2];
						tc.Item[j].Card[3] := Card[3];
						tc.Item[j].Data := td;
					end;
					SendCGetItem(tc, j, w1);
					//重量更新
					tc.Weight := tc.Weight + tv.Weight[k] * w1;
					SendCStat1(tc, 0, $0018, tc.Weight);

					//---保留処理消化---
					//カートの数量変更Part2
					if (tc1.Cart.Item[w2].Amount = 0) then begin
						tc1.Cart.Item[w2].ID := 0;
						Dec(tc1.Cart.Count);
					end;
					//売り切れ処理
					if (tv.Amount[k] = 0) then begin
						tv.Idx[k] := 0;
						tv.Price[k] := 0;
						tv.Weight[k] := 0;
						tv.Cnt := tv.Cnt - 1;
					end;
				end;

				if (b <> 0) then begin
					//購入エラー
					WFIFOW(0, $0135);
					WFIFOW(2, w2);
					WFIFOW(4, w1);
					WFIFOB(6, b);
					Socket.SendBuf(buf, 7);
				end else begin
					if tv.Cnt = 0 then begin
						//完売処理
						tc1.VenderID := 0;
						//カートの重量更新パケ
						WFIFOW(0, $0121);
						WFIFOW(2, tc1.Cart.Count);
						WFIFOW(4, 100);
						WFIFOL(6, tc1.Cart.Weight);
						WFIFOL(10, tc1.Cart.MaxWeight);
						tc.Socket.SendBuf(buf, 14);
						//看板消去を周囲に通知
						WFIFOW(0, $0132);
						WFIFOL(2, tv.ID);
						SendBCmd(tc1.MData, tc1.Point, 6, tc1);
						//露店リスト削除
						//DebugOut.Lines.Add(Format('Vender(%s) was close / Remaining Vender(%d)', [tv.Title,VenderList.Count-1]));
						VenderList.Delete(VenderList.IndexOf(tv.ID));
						tv.Free;
					end;
				end;
			end;
{露店スキル追加ココまで}
		//--------------------------------------------------------------------------
		$013f: //GM /item /monster
		//monster
		//item

			begin
      tp := tc.PData;
      h := IDTableDB.IndexOf(tc.ID);
      if (h <> -1) then begin
      tid := IDTableDB.Objects[h] as TIDTbl;

      str := RFIFOS(2, 24);
      tm := tc.MData;

      if (ItemDBName.IndexOf(str) <> -1) and (tid.ItemSummon = 1) then begin
      td := ItemDBName.Objects[ItemDBName.IndexOf(str)] as TItemDB;

					if td.IEquip then begin
						j := 1;
					end else begin
						j := 30;
					end;

				if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) * cardinal(j) then begin
					k := SearchCInventory(tc, td.ID, td.IEquip);
					if k <> 0 then begin
              if tc.Item[k].Amount + j > 30000 then continue;
							tc.Item[k].ID := td.ID;
							tc.Item[k].Amount := tc.Item[k].Amount + j;
							tc.Item[k].Equip := 0;
							tc.Item[k].Identify := 1;
							tc.Item[k].Refine := 0;
							tc.Item[k].Attr := 0;
							tc.Item[k].Card[0] := 0;
							tc.Item[k].Card[1] := 0;
							tc.Item[k].Card[2] := 0;
							tc.Item[k].Card[3] := 0;
							tc.Item[k].Data := td;
							tc.Weight := tc.Weight + cardinal(td.Weight) * cardinal(j);
							SendCStat1(tc, 0, $0018, tc.Weight);
							SendCGetItem(tc, k, j);
					end;
					end else begin
						WFIFOW( 0, $00a0);
						WFIFOB(22, 2);
						Socket.SendBuf(buf, 23);
					end;
        end;

        if (MobDBName.IndexOf(str) <> -1) and (tid.MonsterSummon = 1) then begin
          ts := TMob.Create;
					ts.Data := MobDBName.Objects[MobDBName.IndexOf(str)] as TMobDB;
					ts.ID := NowMobID;
					Inc(NowMobID);
					ts.Name := ts.Data.JName;
					ts.JID := ts.Data.ID;
					ts.Map := tc.Map;
          ts.Data.isLink :=false;
          //ts.Data.isLoot :=false;
					//プレイヤーの周囲9マスのどこかに召還
					ts.Point.X := tc.Point.X + Random(2) - 1;
					ts.Point.Y := tc.Point.Y + Random(2) - 1;

					ts.Dir := Random(8);
					ts.HP := ts.Data.HP;
					ts.Speed := ts.Data.Speed;

					//沸き間隔を極大に設定
					//ここはちょっと処理が適当かな？

					ts.SpawnDelay1 := $7FFFFFFF;
					ts.SpawnDelay2 := 0;

					ts.SpawnType := 0;
					ts.SpawnTick := 0;
					if ts.Data.isDontMove then
						ts.MoveWait := $FFFFFFFF
					else
          ts.MoveWait := timeGetTime();
					ts.ATarget := 0;
					ts.ATKPer := 100;
					ts.DEFPer := 100;
					ts.DmgTick := 0;

          ts.Element := ts.Data.Element;

          if (SummonMonsterName = true) then begin
          ts.Name := ts.Data.JName;
          end else begin
					ts.Name := 'Summon Monster';
          end;

          if (SummonMonsterExp = false) then begin
					ts.Data.MEXP := 0;
					ts.Data.EXP := 0;
					ts.Data.JEXP := 0;
          end;

          if (SummonMonsterAgo = true) then begin
					ts.isActive := true;
          end else begin
          ts.isActive := ts.Data.isActive;
          end;

					ts.MoveWait := timeGetTime();

					for j := 0 to 31 do begin
						ts.EXPDist[j].CData := nil;
						ts.EXPDist[j].Dmg := 0;
					end;
					if ts.Data.MEXP <> 0 then begin
						for j := 0 to 31 do begin
							ts.MVPDist[j].CData := nil;
							ts.MVPDist[j].Dmg := 0;
						end;
						ts.MVPDist[0].Dmg := ts.Data.HP * 30 div 100; //FAに30%加算
					end;
          ts.isSummon := True;
          ts.EmperiumID := 0;

					tm.Mob.AddObject(ts.ID, ts);
					tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);

					SendMData(tc.Socket, ts);
					//周囲に送信
					SendBCmd(tm,ts.Point,41,tc,False);


if (SummonMonsterMob = true) then begin
    k := SlaveDBName.IndexOf(str);
    if (k <> -1) then begin
     ts.isLeader := true;
     
     tss := SlaveDBName.Objects[k] as TSlaveDB;
     if str = tss.Name then begin

     h := tss.TotalSlaves;
     ts.SlaveCount := h;
     repeat
      for i := 0 to 4 do begin
        if (tss.Slaves[i] <> -1) and (h <> 0) then begin
          ts1 := TMob.Create;
					ts1.Data := MobDBName.Objects[tss.Slaves[i]] as TMobDB;
					ts1.ID := NowMobID;
					Inc(NowMobID);
					ts1.Name := ts1.Data.JName;
					ts1.JID := ts1.Data.ID;
          ts1.LeaderID := ts.ID;
          ts1.Data.isLink := false;
					ts1.Map := ts.Map;
					ts1.Point.X := ts.Point.X;
					ts1.Point.Y := ts.Point.Y;
					ts1.Dir := ts.Dir;
					ts1.HP := ts1.Data.HP;
          if ts.Data.Speed < ts1.Data.Speed then begin
					ts1.Speed := ts.Data.Speed;
          end else begin
          ts1.Speed := ts1.Data.Speed;
          end;
					ts1.SpawnDelay1 := $7FFFFFFF;
					ts1.SpawnDelay2 := 0;
					ts1.SpawnType := 0;
					ts1.SpawnTick := 0;
					if ts1.Data.isDontMove then
						ts1.MoveWait := $FFFFFFFF
					else
          ts1.MoveWait := timeGetTime();
					ts1.ATarget := 0;
					ts1.ATKPer := 100;
					ts1.DEFPer := 100;
					ts1.DmgTick := 0;
          ts1.Element := ts1.Data.Element;
          ts1.isActive := false;
					for j := 0 to 31 do begin
						ts1.EXPDist[j].CData := nil;
						ts1.EXPDist[j].Dmg := 0;
					end;
					if ts1.Data.MEXP <> 0 then begin
						for j := 0 to 31 do begin
							ts1.MVPDist[j].CData := nil;
							ts1.MVPDist[j].Dmg := 0;
						end;
						ts1.MVPDist[0].Dmg := ts1.Data.HP * 30 div 100; //FAに30%加算
					end;
					tm.Mob.AddObject(ts1.ID, ts1);
					tm.Block[ts1.Point.X div 8][ts1.Point.Y div 8].Mob.AddObject(ts1.ID, ts1);
					ts1.isSummon := true;
          ts1.isSlave := true;
          ts1.EmperiumID := 0;
          
					SendMData(tc.Socket, ts1);
					//周囲に送信
					SendBCmd(tm,ts1.Point,41,tc,False);

          h := h - 1;
        end;
      end;
     until (h <= 0);

     end;
    end;
end;
end;

      end;
			end;

		//--------------------------------------------------------------------------
		$0143: //NPC会話でInputNumber入力
			begin
				RFIFOL(2, l);
				if tc.TalkNPCID <> l then continue;
				RFIFOL(6, l);
				NPCScript(tc, l + 1);
			end;
		//--------------------------------------------------------------------------
		$0146: //NPC会話でCLOSEを選択した
			begin
				//RFIFOL(2, l);
				//if tc.TalkNPCID <> l then continue;
				tc.AMode := 0;
			end;
{ギルド機能追加}
		$014d: //ギルド情報表示開始
			begin
				j := GuildList.IndexOf(tc.GuildID);
				if (j = -1) then continue;
				tg := GuildList.Objects[j] as TGuild;
				WFIFOW( 0, $014e);
				if (tg.MasterName = tc.Name) then begin
					WFIFOL( 2, $d7); //ギルドマスター
				end else begin
					WFIFOL( 2, $57); //一般
				end;
				Socket.SendBuf(buf, 6);
			end;
		//--------------------------------------------------------------------------
		$014f: //ギルド表示タブ
			begin
				RFIFOL(2, l);
				SendGuildInfo(tc, l);
			end;
		//--------------------------------------------------------------------------
		$0151: //エンブレム要求
			begin
				RFIFOL(2, l);
				j := GuildList.IndexOf(l);
				if (j = -1) then continue;
				tg := GuildList.Objects[j] as TGuild;
				if (tg.Emblem = 0) then continue;
				w := LoadEmblem(tg);
				if (w = 0) then continue;
				Socket.SendBuf(buf, w);
			end;
		//--------------------------------------------------------------------------
		$0153: //エンブレム変更
			begin
				RFIFOW(2, w);
				if (w <= 4) then continue;
				j := GuildList.IndexOf(tc.GuildID);
				if (j = -1) then continue;
				tg := GuildList.Objects[j] as TGuild;
				if (tg.MasterName = tc.Name) then begin
					if (tg.Emblem > 0) then begin
						//現在のエンブレムを削除
						str := AppPath + 'emblem\' + IntToStr(tg.ID) + '_' + IntToStr(tg.Emblem) + '.emb';
						if FileExists(str) then DeleteFile(str);
					end;

					//エンブレム更新
					Inc(tg.Emblem);
					SaveEmblem(tg, w - 4);
				end;
			end;
		//--------------------------------------------------------------------------
		$0155: //ギルド員情報変更
			begin
				RFIFOW( 2, w);
				j := GuildList.IndexOf(tc.GuildID);
				if (j = -1) then continue;
				tg := GuildList.Objects[j] as TGuild;
				if (tg.MasterName = tc.Name) then begin
					for i := 0 to (w - 4) div 12 - 1 do begin
						RFIFOL(i * 12 + 8, l);
						RFIFOL(i * 12 + 12, l2);
						if (l2 >= 20) then continue;
						tc1 := Chara.IndexOfObject(l) as TChara;
						if (tc1 = nil) then continue;
						if (tc1.Name <> tg.MasterName) and (l2 <> 0) then begin
							tg.MemberPos[tc1.GuildPos] := l2;
							tc1.ClassName := tg.PosName[l2];
						end;
					end;
					//変更通知
					WFIFOW( 0, $0156);
					SendGuildMCmd(tc, w);
				end;
			end;
		//--------------------------------------------------------------------------
		$0159: //ギルド脱退
			begin
				RFIFOL( 2, l);
				str := RFIFOS(14, 40);
				j := GuildList.IndexOf(tc.GuildID);
				if (j = -1) then continue;
				tg := GuildList.Objects[j] as TGuild;
				if (tg.ID <> l) then continue;

				if (tc.Name <> tg.MasterName) and (tg.RegUsers > 1) then begin
					//通知
					WFIFOW( 0, $015a);
					WFIFOS( 2, tc.Name, 24);
					WFIFOS(26, str, 40);
					SendGuildMCmd(tc, 66);
					//メンバー削除処理
					for i := tc.GuildPos to 35 do begin
						tg.MemberID[i] := tg.MemberID[i + 1];
						tg.Member[i] := tg.Member[i + 1];
						tg.MemberPos[i] := tg.MemberPos[i + 1];
						tg.MemberEXP[i] := tg.MemberEXP[i + 1];
					end;
					if UseSQL then DeleteGuildMember(tc.CID,1,nil,0);
					Dec(tg.RegUsers);
					tc.GuildID := 0;
					tc.GuildName := '';
					tc.ClassName := '';
					tc.GuildPos := 0;
				end;
			end;
		//--------------------------------------------------------------------------
		$015b: //ギルド追放
			begin
				RFIFOL( 2, l);
				RFIFOL(10, l2);
				str := RFIFOS(14, 40);
				j := GuildList.IndexOf(tc.GuildID);
				if (j = -1) then continue;
				tg := GuildList.Objects[j] as TGuild;
				if (tg.ID <> l) then continue;
				tc1 := Chara.IndexOfObject(l2) as TChara;
				if tc1 = nil then Continue;
				tp1 := Player.IndexOfObject(tc1.ID) as TPlayer;

				//通知
				WFIFOW( 0, $015c);
				WFIFOS( 2, tc1.Name, 24);
				WFIFOS(26, str, 40);
				WFIFOS(66, tp1.Name, 24);
				SendGuildMCmd(tc, 90);
				//追放者リストに追加
				tgb := TGBan.Create;
				tgb.Name := tc1.Name;
				tgb.AccName := tp1.Name;
				tgb.Reason := str;
				tg.GuildBanList.AddObject(tgb.Name, tgb);
				//メンバー削除処理
				for i := tc1.GuildPos to 35 do begin
					tg.MemberID[i] := tg.MemberID[i + 1];
					tg.Member[i] := tg.Member[i + 1];
					tg.MemberPos[i] := tg.MemberPos[i + 1];
					tg.MemberEXP[i] := tg.MemberEXP[i + 1];
				end;
				if UseSQL then DeleteGuildMember(tc1.CID,2,tgb,tg.ID);
				Dec(tg.RegUsers);
				tc1.GuildID := 0;
				tc1.GuildName := '';
				tc1.ClassName := '';
				tc1.GuildPos := 0;
			end;
		//--------------------------------------------------------------------------
		$015d: //ギルド解散
			begin
				str := RFIFOS(2, 24);
				j := GuildList.IndexOf(tc.GuildID);
				if (j = -1) then continue;
				tg := GuildList.Objects[j] as TGuild;
				if (tg.Name = str) and (tg.RegUsers = 1) and (tg.MasterName = tc.Name) then begin
					//通知
					WFIFOW( 0, $016c);
					WFIFOL( 2, 0);
					WFIFOL( 6, 0);
					WFIFOL(10, 0);
					WFIFOB(14, 0);
					WFIFOL(15, 0);
					WFIFOS(19, tg.Name, 24);
					Socket.SendBuf(buf, 43);
					WFIFOW( 0, $015e);
					WFIFOL( 2, 0);
					Socket.SendBuf(buf, 6);

					//ギルド削除処理
					if UseSQL then DeleteGuildInfo(tc.GuildID);
					GuildList.Delete(GuildList.IndexOf(tc.GuildID));
					tc.GuildID := 0;
					tc.GuildName := '';
					tc.ClassName := '';
					tc.GuildPos := 0;
				end;
			end;
		//--------------------------------------------------------------------------
		$0161: //職位情報変更
			begin
				RFIFOW( 2, w);
				j := GuildList.IndexOf(tc.GuildID);
				if (j = -1) then continue;
				tg := GuildList.Objects[j] as TGuild;
				if (tg.MasterName = tc.Name) then begin
					for i := 0 to (w - 4) div 40 - 1 do begin
						RFIFOL(i * 40 + 4, l);
						RFIFOL(i * 40 + 8, l2);
						if (l2 div 16 = 1) then tg.PosInvite[l] := true else tg.PosInvite[l] := false;
						if (l2 mod 16 = 1) then tg.PosPunish[l] := true else tg.PosPunish[l] := false;
						RFIFOL(i * 40 + 16, l2);
						if (l2 > 50) then begin
							l2 := 50;//50超は1ではなく50に設定
							WFIFOL(i * 40 + 8, l2);
						end;
						tg.PosEXP[l] := l2;
						tg.PosName[l] := RFIFOS(i * 40 + 20, 24);
						if UseSQL then SaveGuildMPosition(tg.ID, tg.PosName[l], tg.PosInvite[l], tg.PosPunish[l], tg.PosEXP[l], l);
					end;
					//変更通知
					WFIFOW( 0, $0174);
					SendGuildMCmd(tc, w, false);
				end;
			end;
		//--------------------------------------------------------------------------
		$0165: //ギルド作成
			begin
				RFIFOL(2, l);
				str := RFIFOS(6, 24);
				if (str = '') then continue;
        SendGuildInfo(tc,1,true,false);        
				//エンペリウムチェック
				w := 0;
				i := 0;
				for j := 1 to 100 do begin
					if (tc.Item[j].ID = 714) then begin
						w := j;
						break;
					end;
				end;
				if (w = 0) then begin
					//アイテム不足
					i := 3;;
				end else if (tc.GuildID <> 0) then begin
					//既に他ギルドに加入済
					i := 1;
				end else begin
					for j := 0 to GuildList.Count - 1 do begin
						tg := GuildList.Objects[j] as TGuild;
						if (tg.Name = str) then begin
							//同名ギルド存在
							i := 2;
							break;
						end;
					end;
				end;
				if (i <> 0) then begin
					//作成エラー
					WFIFOW( 0, $0167);
					WFIFOB( 2, i);
					Socket.SendBuf(buf, 3);
					continue;
				end;

				//アイテム減少
				Dec(tc.Item[w].Amount);
				if tc.Item[w].Amount = 0 then tc.Item[w].ID := 0;
				tc.Weight := tc.Weight - tc.Item[w].Data.Weight;
				WFIFOW( 0, $00af);
				WFIFOW( 2, w);
				WFIFOW( 4, 1);
				Socket.SendBuf(buf, 6);
				// Update weight
				SendCStat1(tc, 0, $0018, tc.Weight);

				//ギルド作成
				tg := TGuild.Create;
				NowGuildID := NowGuildID + 1;
				with tg do begin
					ID := NowGuildID;
					Name := str;
					LV := 1;
					EXP := 0;
          tg.NextEXP := GExpTable[tg.LV];
					MasterName := tc.Name;
					RegUsers := 1;
					MaxUsers := 16;
					SLV := tc.BaseLV;
					MemberID[0] := tc.CID;
					Member[0] := tc;
					for j := 0 to 19 do begin
						if (j = 0) then begin
							PosName[j] := 'Master';
							PosInvite[j] := true;
							PosPunish[j] := true;
						end else begin
							PosName[j] := 'Position ' + IntToStr(j + 1);
							PosInvite[j] := false;
							PosPunish[j] := false;
						end;
						PosEXP[j] := 0;
						if UseSQL then SaveGuildMPosition(ID, PosName[j], PosInvite[j], PosPunish[j], PosEXP[j], j);
					end;
					for j := 10000 to 10004 do begin
						if GSkillDB.IndexOf(j) <> -1 then begin
							GSkill[j].Data := GSkillDB.IndexOfObject(j) as TSkillDB;
						end;
					end;
					tc.GuildName := Name;
					tc.GuildID := ID;
					tc.ClassName := PosName[0];
				end;
				GuildList.AddObject(tg.ID, tg);
				//DebugOut.Lines.Add(Format('GuildName %s : ID = %d : Name = %s', [tg.Name, tg.MemberID[0], tg.Member[0].Name]));

				//作成成功応答
				WFIFOW( 0, $0167);
				WFIFOB( 2, 0);
				Socket.SendBuf(buf, 3);

        WFIFOW( 0, $016d);
        WFIFOL( 2, tc.ID);
        WFIFOL( 6, tc.CID);
        WFIFOL(10, 1);
        SendGuildMCmd(tc, 14);

        SendGLoginInfo(tg, tc);


        

				//ギルド情報送信
				
			end;
		//--------------------------------------------------------------------------
		$0168: //ギルド勧誘
			begin
				if (tc.GuildInv <> 0) then continue;//他に勧誘中(鯖キャン未対応)
				RFIFOL( 2, l);
				tc1 := CharaPID.IndexOfObject(l) as TChara;
				if tc1 = nil then Continue;
				j := GuildList.IndexOf(tc.GuildID);
				if (j = -1) then continue;
				tg := GuildList.Objects[j] as TGuild;
				if (tg.GuildBanList.IndexOf(tc1.Name) <> -1) then continue;
				if (tc1.GuildID = 0) then begin
					if (tg.RegUsers < tg.MaxUsers) then begin
						tc.GuildInv := tc1.CID;
						WFIFOW( 0, $016a);
						WFIFOL( 2, tc.GuildID);
						WFIFOS( 6, tc.GuildName, 24);
						tc1.Socket.SendBuf(buf, 30);
					end else begin
						WFIFOW( 0, $0169);
						WFIFOB( 2, 3);
						Socket.SendBuf(buf, 3);
					end;
				end else begin
					WFIFOW( 0, $0169);
					WFIFOB( 2, 0);
					Socket.SendBuf(buf, 3);
				end;
			end;
		//--------------------------------------------------------------------------
		$016b: //ギルド勧誘応答
			begin
      //DebugOut.Lines.Add('Guild Invite');

RFIFOL(2, l);
RFIFOL(6, l2);
j := GuildList.IndexOf(l);
if (j <> -1) then begin
tg := GuildList.Objects[j] as TGuild;
				tc1 := nil;
				for i := 0 to 35 do begin
					if (tg.Member[i].GuildInv = tc.CID) then begin
						tc1 := tg.Member[i];
						break;
					end;
				end;
				tg.Member[tc1.GuildPos].GuildInv := 0;
				if (tc1 = nil) or (l2 > 1) then continue;
if (l2 = 1) then begin
with tg do begin
k := RegUsers;
if (k < MaxUsers) and (MemberID[k] = 0) then begin	
MemberID[k] := tc.CID;
Member[k] := tc;
MemberPos[k] := 19;
MemberEXP[k] := 0;
SLV := SLV + tc.BaseLV;
RegUsers := RegUsers + 1;
tc.GuildID := ID;
tc.GuildName := Name;
tc.GuildPos := k;
tc.ClassName := PosName[19];
WFIFOW( 0, $0169);
WFIFOB( 2, 2);
tc.Socket.SendBuf(buf, 3);
//tc1.Socket.SendBuf(buf, 3);

//WFIFOW( 0, $016d);
//WFIFOL( 2, tc.ID);
//WFIFOL( 6, tc.CID);
//WFIFOL(10, 1);
//SendGuildMCmd(tc, 14, true);

SendGLoginInfo(tg, tc);
end;
end;
end else begin
//WFIFOW( 0, $0169);
//WFIFOB( 2, 1);
//tc1.Socket.SendBuf(buf, 3);
end;
end;
//end;
			end;
		//--------------------------------------------------------------------------
		$016e: //ギルド告知設定
			begin
				RFIFOL(2, l);
				j := GuildList.IndexOf(tc.GuildID);
				if (j = -1) then continue;
				tg := GuildList.Objects[j] as TGuild;
				if (tg.ID = l) and (tg.MasterName = tc.Name) then begin
					tg.Notice[0] := RFIFOS(6, 60);
					tg.Notice[1] := RFIFOS(66, 120);
					WFIFOW( 0, $016f);
					WFIFOS( 2, tg.Notice[0], 60);
					WFIFOS(62, tg.Notice[1], 120);
					SendGuildMCmd(tc, 182);
				end;
			end;
		//--------------------------------------------------------------------------
		$0170: //ギルド同盟要請
			begin
				RFIFOL( 2, l);
				RFIFOL(10, l2);
				j := GuildList.IndexOf(tc.GuildID);
				if (j = -1) then continue;
				tg := GuildList.Objects[j] as TGuild;
				tc1 := CharaPID.IndexOfObject(l) as TChara;
				if tc1 = nil then Continue;
				if (tg.MasterName <> tc.Name) then continue;
				j := GuildList.IndexOf(tc1.GuildID);
				if (j = -1) then continue;
				tg1 := GuildList.Objects[j] as TGuild;

				//同盟数チェック
				k := -1;
				if (tg.RelAlliance.IndexOf(tg1.Name) <> -1) then k := 0
				else if (tg.RelAlliance.Count >= 3) then k := 4
				else if (tg1.RelAlliance.Count >= 3) then k := 3;

				//送信
				if (k <> -1) then begin
					WFIFOW( 0, $0173);
					WFIFOB( 2, k);
					Socket.SendBuf(buf, 3);
				end else begin
					WFIFOW( 0, $0171);
					WFIFOL( 2, tc.CID);
					WFIFOS( 6, tg.Name, 24);
					tc1.Socket.SendBuf(buf, 30);
				end;
			end;
		//--------------------------------------------------------------------------
		$0172: //ギルド同盟要請応答
			begin
				RFIFOL( 2, l);
				RFIFOL( 6, l2);
				j := GuildList.IndexOf(tc.GuildID);
				if (j = -1) then continue;
				tg := GuildList.Objects[j] as TGuild;
				tc1 := Chara.IndexOfObject(l) as TChara;
				if tc1 = nil then Continue;
				if (tg.MasterName <> tc.Name) then continue;
				j := GuildList.IndexOf(tc1.GuildID);
				if (j = -1) then continue;
				tg1 := GuildList.Objects[j] as TGuild;

				//自分のギルドの同盟数チェック
				k := -1;
				if (tg.RelAlliance.IndexOf(tg1.Name) <> -1) then k := 0
				else if (tg.RelAlliance.Count >= 3) then k := 4
				else if (tg1.RelAlliance.Count >= 3) then k := 3;

				if (l2 = 0) then begin
					//拒否
					k := 1;
				end else if (k = -1) then begin
					//承諾
					if (tg1.RelHostility.IndexOf(tg.Name) <> -1) then KillGuildRelation(tg1, tg, tc1, tc, 1);
					tgl := TGRel.Create;
					tgl.ID := tg1.ID;
					tgl.GuildName := tg1.Name;
					tg.RelAlliance.AddObject(tgl.GuildName, tgl);
					if UseSQL then SaveGuildAllyInfo(tgl.ID, tgl.GuildName, 1);
					tgl := TGRel.Create;
					tgl.ID := tg.ID;
					tgl.GuildName := tg.Name;
					tg1.RelAlliance.AddObject(tgl.GuildName, tgl);
					if UseSQL then SaveGuildAllyInfo(tgl.ID, tgl.GuildName, 1);
					k := 2;
				end;

				//送信
				WFIFOW( 0, $0173);
				WFIFOB( 2, k);
				Socket.SendBuf(buf, 3);
				tc1.Socket.SendBuf(buf, 3);

				if (k = 2) then begin
					WFIFOW( 0, $0185);
					WFIFOL( 2, 0);
					WFIFOL( 6, tg1.ID);
					WFIFOS(10, tg1.Name, 24);
					SendGuildMCmd(tc, 34);
					WFIFOL( 6, tg.ID);
					WFIFOS(10, tg.Name, 24);
					SendGuildMCmd(tc1, 34);
				end;
			end;
{ギルド機能追加ココまで}
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		$0178: //アイテム鑑定
			begin
				RFIFOW(2, w);
				if (w < 1) or (w > 100) or (tc.Item[w].Identify = 1) then begin
					WFIFOW(0, $0179);
					WFIFOW(2, w);
					WFIFOB(4, 1);
					Socket.SendBuf(buf, 5);
					continue;
				end;

				tc.Item[w].Identify := 1;
				WFIFOW(0, $0179);
				WFIFOW(2, w);
				WFIFOB(4, 0);
				Socket.SendBuf(buf, 5);

				w := tc.UseItemID;
				tc.UseItemID := 0;
        if (w <> 0) then begin
				Dec(tc.Item[w].Amount);
				WFIFOW( 0, $00a8);
				WFIFOW( 2, w);
				WFIFOW( 4, tc.Item[w].Amount);
				WFIFOB( 6, 1);
				Socket.SendBuf(buf, 7);


				//030316追加 Cardinal
				if tc.Item[w].Amount <= 0 then tc.Item[w].ID := 0;
				tc.Weight := tc.Weight - tc.Item[w].Data.Weight;
				//アイテム数減少
				WFIFOW( 0, $00af);
				WFIFOW( 2, w);
				WFIFOW( 4, 1);
				// Update weight
				SendCStat1(tc, 0, $0018, tc.Weight);
        end;
			end;
		//--------------------------------------------------------------------------
		$017a: //カードWクリック
			begin
				RFIFOW(2, w);
				if (w = 0) or (w > 100) or (tc.Item[w].ID = 0) or
					 (tc.Item[w].Amount = 0) or (tc.Item[w].Data.IType <> 6) then continue;
				td := tc.Item[w].Data;

				j := 4;
				for i := 1 to 100 do begin
					if (tc.Item[i].ID <> 0) and (tc.Item[i].Amount > 0) and (tc.Item[i].Data.IEquip) and
						 (tc.Item[i].Data.Slot > 0) and (tc.Item[i].Card[tc.Item[i].Data.Slot - 1] = 0) and
						 (tc.Item[i].Equip = 0) then begin // スロットを持っていてスロットの最後が埋まってなければ
						if td.Loc = 0 then begin
							//武器
							if tc.Item[i].Data.IType = 4 then begin
								WFIFOW(j, i);
								j := j + 2;
							end;
						end else begin
							//防具
							if (tc.Item[i].Data.IType = 5) and ((tc.Item[i].Data.Loc and td.Loc) <> 0) then begin
								WFIFOW(j, i);
								j := j + 2;
							end;
						end;
					end;
				end;

				if j <> 4 then begin //挿入可能なアイテムがある場合
					WFIFOW(0, $017b);
					WFIFOW(2, j);
					Socket.SendBuf(buf, j);
				end;
			end;
		//--------------------------------------------------------------------------
		$017c: //Card insertion

			begin
				RFIFOW(2, w1); //src
				RFIFOW(4, w2); //dest
				if (w1 = 0) or (w1 > 100) or (tc.Item[w1].ID = 0) or (tc.Item[w1].Amount = 0) or
					 (tc.Item[w1].Data.IType <> 6) or
					 (w2 = 0) or (w2 > 100) or (tc.Item[w2].ID = 0) or (tc.Item[w2].Amount = 0) or
					 (not tc.Item[w2].Data.IEquip) or (tc.Item[w2].Data.Slot = 0) or
					 (tc.Item[w2].Card[tc.Item[w2].Data.Slot - 1] <> 0) or
					 (tc.Item[w2].Equip <> 0) then begin //カードをさせる状態でない場合
					WFIFOW(0, $017d);
					WFIFOW(2, w1);
					WFIFOW(4, w2);
					WFIFOB(6, 1);
					Socket.SendBuf(buf, 7);
					continue;
				end;
				ti := tc.Item[w2];
				td := tc.Item[w2].Data;
				if tc.Item[w1].Data.Loc = 0 then begin
					if td.IType <> 4 then continue;
				end else begin
					if (td.IType <> 5) or ((td.Loc and tc.Item[w1].Data.Loc) = 0) then continue;
				end;

				for i := 0 to 3 do begin
					if(ti.Card[i] = 0) then begin
						ti.Card[i] := tc.Item[w1].Data.ID;
						WFIFOW(0, $017d);
						WFIFOW(2, w1);
						WFIFOW(4, w2);
						WFIFOB(6, 0);
						Socket.SendBuf(buf, 7);
						break;
					end;
				end;

				//カードを消す
				Dec(tc.Item[w1].Amount);
				WFIFOW( 0, $00a8);
				WFIFOW( 2, w1);
				WFIFOW( 4, tc.Item[w1].Amount);
				WFIFOB( 6, 1);
				Socket.SendBuf(buf, 7);
				//
				if tc.Item[w1].Amount = 0 then tc.Item[w1].ID := 0;
				tc.Weight := tc.Weight - tc.Item[w1].Data.Weight;
				//アイテム数減少
				WFIFOW( 0, $00af);
				WFIFOW( 2, w1);
				WFIFOW( 4, 1);
				// Update weight
				SendCStat1(tc, 0, $0018, tc.Weight);

				//スロット指したアイテムを再入手
				SendCGetItem(tc, w2, 1);
                                end;
{ギルド機能追加}
		$017e: //ギルドチャット
			begin
				RFIFOW(2, w);
				str := RFIFOS(4, w - 2);
				if (GuildList.IndexOf(tc.GuildID) <> -1) then begin
					WFIFOW(0, $017f);
					WFIFOW(2, w);
					WFIFOS(4, str, w);
					SendGuildMCmd(tc, w);
				end;
			end;
		//--------------------------------------------------------------------------
		$0180: //ギルド敵対設定
			begin
				RFIFOL( 2, l);
				j := GuildList.IndexOf(tc.GuildID);
				if (j = -1) then continue;
				tg := GuildList.Objects[j] as TGuild;
				if (tg.MasterName <> tc.Name) then continue;
				tc1 := CharaPID.IndexOfObject(l) as TChara;
				if tc1 = nil then Continue;
				j := GuildList.IndexOf(tc1.GuildID);
				if (j = -1) then continue;
				tg1 := GuildList.Objects[j] as TGuild;

				//同盟チェック
				b := 0;
				if (tg.RelAlliance.IndexOf(tg1.Name) <> -1) then KillGuildRelation(tg, tg1, tc, tc1, 0);
				if (tg.RelHostility.IndexOf(tg1.Name) <> -1) then b := 2
				else if (tg.RelHostility.Count >= 3) then b := 1;

				if (b = 0) then begin
					//敵対追加
					tgl := TGRel.Create;
					tgl.ID := tg1.ID;
					tgl.GuildName := tg1.Name;
					tg.RelHostility.AddObject(tgl.GuildName, tgl);
					if UseSQL then SaveGuildAllyInfo(tgl.ID, tgl.GuildName, 2);

					//パケ送信
					WFIFOW( 0, $0185);
					WFIFOL( 2, 1);
					WFIFOL( 6, tg1.ID);
					WFIFOS(10, tg1.Name, 24);
					SendGuildMCmd(tc, 34);
				end;

				//正否送信
				WFIFOW( 0, $0181);
				WFIFOB( 0, b);
				Socket.SendBuf(buf, 3);
			end;
		//--------------------------------------------------------------------------
		$0183: //同盟・敵対解消
			begin
				RFIFOL( 2, l);
				RFIFOL( 6, l2);
				j := GuildList.IndexOf(tc.GuildID);
				if (j = -1) then continue;
				tg := GuildList.Objects[j] as TGuild;
				if (tg.MasterName <> tc.Name) then continue;
				j := GuildList.IndexOf(l);
				if (j = -1) then continue;
				tg1 := GuildList.Objects[j] as TGuild;
				j := CharaName.IndexOf(tg1.MasterName);
				if (j = -1) then continue;
				tc1 := CharaName.Objects[j] as TChara;

				//解消
				KillGuildRelation(tg, tg1, tc, tc1, l2);
			end;
{ギルド機能追加ココまで}
		//--------------------------------------------------------------------------
			//end;
		//--------------------------------------------------------------------------
		$018a: //ゲーム終了
			begin
				SendCLeave(Socket.Data, 2);

				WFIFOW(0, $018b);
				WFIFOW(2, 0);
				Socket.SendBuf(buf, 4);
			end;
		//--------------------------------------------------------------------------
{アイテム製造追加}
		$018e: //アイテム製造
			begin
				RFIFOW(2, m1);//作りたいアイテムのID
				RFIFOW(4, m[0]);//埋めるもの1
				RFIFOW(6, m[1]);//埋めるもの2
				RFIFOW(8, m[2]);//埋めるもの3
				tm := tc.MData;
				w1 := 0;
				w2 := 0;
				anvil := 0;
				i := 1;//製造の正否判定フラグとして活用

				if MaterialDB.IndexOf(m1) <> -1 then begin
					tma := MaterialDB.IndexOfObject(m1) as TMaterialDB;//材料データの呼び出し
					for j := 0 to 2 do begin
						if tma.MaterialID[j] = 0 then continue;
						e := SearchCInventory(tc, tma.MaterialID[j], false);
						if (e <> 0) and (tc.Item[e].Amount >= tma.MaterialAmount[j]) then begin

							//アイテム数減少
							WFIFOW( 0, $00af);
							WFIFOW( 2, e);
							WFIFOW( 4, tma.MaterialAmount[j]);
			 				Socket.SendBuf(buf, 6);

							tc.Item[e].Amount := tc.Item[e].Amount - tma.MaterialAmount[j];
							if tc.Item[e].Amount = 0 then tc.Item[e].ID := 0;
							tc.Weight := tc.Weight - tc.Item[e].Data.Weight * tma.MaterialAmount[j];

							// Update weight
							SendCStat1(tc, 0, $0018, tc.Weight);

						end else begin

							i := 2;
							continue;

						end;
					end;

					//追加する属性石、星のかけらの処理
					for k := 0 to 2 do begin

						e := SearchCInventory(tc, m[k], false);

						if (e <> 0) and (tc.Item[e].Amount <> 0) then begin

							tc.Item[e].Amount := tc.Item[e].Amount - 1;
							if tc.Item[e].Amount = 0 then tc.Item[e].ID := 0;
							tc.Weight := tc.Weight - tc.Item[e].Data.Weight;

							// Update weight
							SendCStat1(tc, 0, $0018, tc.Weight);

							case m[k] of

								994://火属性石(成功率25%ダウン)
									begin
										w1 := w1 + $0003;
										w2 := w2 + 250;
									end;
								995://水属性石(成功率25%ダウン)
									begin
										w1 := w1 + $0001;
										w2 := w2 + 250;
									end;
								996://風属性石(成功率25%ダウン)
									begin
										w1 := w1 + $0004;
										w2 := w2 + 250;
									end;
								997://土属性石(成功率25%ダウン)
									begin
										w1 := w1 + $0002;
										w2 := w2 + 250;
									end;
								1000://星のかけら(成功率15%ダウン)
									begin
										w1 := w1 + $0500;
										w2 := w2 + 150;
									end;
							end;
						end;
					end;

					//金敷の所持チェック

					e := SearchCInventory(tc, 987, false);//オリデオコン金敷(成功率3%アップ)
						if (e <> 0) and (tc.Item[e].Amount <> 0) then begin
							anvil := 30;
						end;
					e := SearchCInventory(tc, 988, false);//黄金金敷(成功率3%アップ)
						if (e <> 0) and (tc.Item[e].Amount <> 0) then begin
							anvil := 50;
						end;
					e := SearchCInventory(tc, 989, false);//エンペリウム金敷(成功率10%アップ)
						if (e <> 0) and (tc.Item[e].Amount <> 0) then begin
							anvil := 100;
						end;

					if (i <> 2) then begin

						case m1 of
							994,995,996,997://属性石製造(成功率はjobLv * 0.3 + DEX * 0.1 + LUK * 0.1 + スキル補正 + 15と仮定)
								begin
									if (Random(1000) < (tc.JobLV * 3.5 + tc.Param[4] + tc.Param[5]) + tc.Skill[96].Data.Data1[tc.Skill[96].Lv] + 150 ) then i := 0;
								end;
							998://鉄製造(成功率はjobLv * 0.3 + DEX * 0.1 + LUK * 0.1 + スキル補正 + 15 と仮定)
							begin
									if (Random(1000) < (tc.JobLV * 3.5 + tc.Param[4] + tc.Param[5]) + tc.Skill[94].Data.Data1[tc.Skill[94].Lv] + 150) then i := 0;
								end;
							999://鋼鉄製造(成功率はjobLv * 0.3 + DEX * 0.1 + LUK * 0.1 + スキル補正 + 15 と仮定)
								begin
									if (Random(1000) < (tc.JobLV * 3.5 + tc.Param[4] + tc.Param[5]) + tc.Skill[95].Data.Data1[tc.Skill[95].Lv] + 150) then i := 0;
								end;
							1000://星のかけら製造(かならず成功と仮定)
								begin
									i := 0;
								end;
							else begin//武器製造(成功率はjobLv * 0.3 + DEX * 0.1 + LUK * 0.1 + スキル補正 + 15 と仮定)
                // Colus, 20040224: Updated calculation for Pharmacy.  Not correct, but closer.
                // Like Steal, the exact formula is not known to anybody yet...
                // Some formulas given:
                //
                // LPﾗ3 + Phaﾗ2 + JobLvﾗ0.3 + Dexﾗ0.1 + Intﾗ0.05 + 10
                // LPﾗ1 + Phaﾗ3 + JobLvﾗ0.2 + Dexﾗ0.1 + Lukﾗ0.1 + 20
                // Phaﾗ4 + JobLvﾗ0.3 + Dexﾗ0.1 + Intﾗ0.05 + 20
                // LP + Pha * 3 + PP + JovLV * 0.5 + LUK * 0.1 + DEX * 0.1 + 5
                // LP + Phaﾗ3 + PP + Jobﾗ0.2 + Dexﾗ0.1 + Lukﾗ0.05 + 15

                // Somebody shoot me.  Anyway, I'm going to use this one for now:
                // LP + Pha * 3 + PP + JovLV * 0.5 + LUK * 0.1 + DEX * 0.1 + 5
                // Why?  It's got a lot of trials behind it.  It'll do for now.

                if (tma.RequireSkill = 228) then begin
                  if (Random(1000) < ((tc.Skill[227].Lv * 10) +  // 100
                     (tc.Skill[tma.RequireSkill].Lv * 30) +      // 300
                      (tc.Skill[231].Lv * 10) +                  // 50
                      tc.JobLV * 5 +                             // 250
                      tc.Param[4] + tc.Param[5]) +               // 200
                      5 ) then i := 0;                           // 5 = 905
                end else begin
                  if (Random(1000) < (tc.JobLV * 3 + tc.Param[4] + tc.Param[5]) + (tc.Skill[tma.RequireSkill].Lv * 100) + 150 + (tc.Skill[107].Lv * 10) + anvil - (w2 + (tma.ItemLV -1) * 100)) then i := 0;
                end;
              end;
						end;

					end;

					//デバッグ用
					//i := 0;

					//完成品の取得処理
					//製造で重量が増えることはありえないので重量チェックはしない
					//名前の表示にはCard[2]とCard[3]にキャラクター固有のIDを入れる必要があるけど
					//0194パケットの処理が未実装のためとりあえず放置

					if (i = 0) then begin

						td := ItemDB.IndexOfObject(m1) as TItemDB;
						k := SearchCInventory(tc, m1, td.IEquip);

						if k <> 0 then begin

							if tc.Item[k].Amount  >= 30000 then continue;

							if (td.IEquip = false) then begin
								//鉱石類の場合
								tc.Item[k].ID := m1;
								tc.Item[k].Amount := tc.Item[k].Amount + 1;
								tc.Item[k].Equip := 0;
								tc.Item[k].Identify := 1;
								tc.Item[k].Refine := 0;
								tc.Item[k].Attr := 0;
								tc.Item[k].Card[0] := 0;
								tc.Item[k].Card[1] := 0;
								tc.Item[k].Card[2] := 0;
								tc.Item[k].Card[3] := 0;
								tc.Item[k].Data := td;
							end else begin
								e := tc.CID mod $10000;
								e2 := tc.CID div $10000;
								tc.Item[k].ID := m1;
								tc.Item[k].Amount := tc.Item[k].Amount + 1;
								tc.Item[k].Equip := 0;
								tc.Item[k].Identify := 1;
								tc.Item[k].Refine := 0;
								tc.Item[k].Attr := 0;
								tc.Item[k].Card[0] := $00FF;//製造武器フラグ($00FFのとき製造武器と判定)
								tc.Item[k].Card[1] := w1;//武器の特性情報($0500 * 星の数 + 属性番号)
								tc.Item[k].Card[2] := e;//製造者情報1
								tc.Item[k].Card[3] := e2;//製造者情報2
								tc.Item[k].Data := td;
							end;

							// Update weight
							tc.Weight := tc.Weight + cardinal(td.Weight);
							SendCStat1(tc, 0, $0018, tc.Weight);

							//アイテムゲット通知
							SendCGetItem(tc, k, 1);
						end;
					end;

					//製造エフェクトパケット送信
          // Colus, 20040117: Send results to creator (fixed packet composition)
          // flag = 00 is success of Forging
          // flag = 01 is failure of Forging
          // flag = 02 is success of Pharmacy
          // flag = 03 is failure of Pharmacy
					WFIFOW(0, $018f);
          if (tma.RequireSkill = 228) then begin
            WFIFOW(2, i+2);
          end else begin
					  WFIFOW(2, i);
          end;
          
					WFIFOW(4, m1);
          Socket.SendBuf(buf, 6);

          // ...now send the results to others with $019b.
          // (Nice messed-up types here...)
          // type=2 Refining failure
          // type=3 Refining success
          // type=4 ?
          // type=5 Pharmacy success
          // type=6 Pharmacy failure

          WFIFOW(0, $019b);
          WFIFOL(2, tc.ID);
          if (i = 0) then begin
            if (tma.RequireSkill = 228) then begin
              WFIFOL(6, 5);
            end else begin
              WFIFOL(6, 3);
            end;
          end else begin
            if (tma.RequireSkill = 228) then begin
              WFIFOL(6, 6);
            end else begin
              WFIFOL(6, 2);
            end;
          end;

					SendBCmd(tm, tc.Point, 10);

				end;
			end;

		//--------------------------------------------------------------------------
    $0190: {Graffiti/Talkie Box}
      begin
        RFIFOW(2, w); // Level (always 1)
        RFIFOW(4, w1); // Code: $DC for Graffiti, $7D for Talkie
        RFIFOW(6, w2); // X
        RFIFOW(8, w3); // Y

        s := RFIFOS(10, 80);  // 78 + 2 bytes for length.
        //RFIFOW(88, e);  // This doesn't seem to get read...

        xy.X := w2;
        xy.Y := w3;
        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;

        if w1 = $DC then begin

           j := SearchCInventory(tc, 716, false);
					 if ((j <> 0) and (tc.Item[j].Amount >= 1)) or (tc.NoJamstone = True) then begin
						 if tc.NoJamstone = False then UseItem(tc, j);
             WFIFOW( 0, $0117);
             WFIFOW( 2, w1);
             WFIFOL( 4, tc.ID);
             WFIFOW( 8, 1);
             WFIFOW(10, xy.X);
             WFIFOW(12, xy.Y);
             WFIFOL(14, timeGetTime());
             SendBCmd(tm, xy, 18);
						 tn := SetSkillUnit(tm, tc.ID, xy, timeGetTime(), $B0, 0, 30000, tc, nil, s);
	      		 tn.MSkill := tc.MSkill;
      		   tn.MUseLV := tc.MUseLV;

					 end else begin
             SendSkillError(tc, 7); //No Red Gemstone
						 //tc.MMode := 4;
						 tc.MPoint.X := 0;
						 tc.MPoint.Y := 0;
						 Exit;
					 end;

          //SetSkillUnit(tm, tc.ID, xy, timeGetTime(), $B0, 0, 30000, tc, nil, s);
        end else begin
           j := SearchCInventory(tc, 1065, false);
					 if ((j <> 0) and (tc.Item[j].Amount >= 1)) then begin
						 UseItem(tc, j);
             WFIFOW( 0, $0117);
             WFIFOW( 2, w1);
             WFIFOL( 4, tc.ID);
             WFIFOW( 8, 1);
             WFIFOW(10, xy.X);
             WFIFOW(12, xy.Y);
             WFIFOL(14, timeGetTime());
             SendBCmd(tm, xy, 18);
						 tn := SetSkillUnit(tm, tc.ID, xy, timeGetTime(), $99, 0, 3000, tc, nil, s);
	      		 tn.MSkill := tc.MSkill;
      		   tn.MUseLV := tc.MUseLV;

					 end else begin
             //SendSkillError(tc, 7); //No Red Gemstone
						 //tc.MMode := 4;
						 tc.MPoint.X := 0;
						 tc.MPoint.Y := 0;
						 Exit;
					 end;
          //SetSkillUnit(tm, tc.ID, xy, timeGetTime(), $99, 0, 30000, tc, nil, s);
        end;
 {
        WFIFOW(0, $01c9);
        WFIFOL(2, 0); // Should be NPC ID of the skillunit...
        WFIFOL(6, tc.ID);
        WFIFOW(10, w2); // Position
        WFIFOW(12, w3);

        if (w1 = $DC) then begin
          WFIFOB(14, $b0);
          WFIFOB(15, 1);  // fail (?)
          WFIFOB(16, 1);  // Message display?
        end else begin
          WFIFOB(14, $99);
          WFIFOB(15, 1);  // fail (?)
          WFIFOB(16, 0);  // Do not display?
        end;

        WFIFOS(17, s, 80); // Write back the message.

        Socket.SendBuf(buf, 97);
 }
      end;
{アイテム製造追加ココまで}
		//--------------------------------------------------------------------------
{アイテム製造追加}
		$0193: //指定IDのキャラ、NPCの名前を要求
			begin
				RFIFOL(2, l);
				if Chara.IndexOf(l) <> -1 then begin
					tc := Chara.IndexOfObject(l) as TChara;
						WFIFOW(0, $0194);
						with tc do begin
							WFIFOL( 2, l);
							WFIFOS( 6, Name, 24);
						end;
					Socket.SendBuf(buf, 30);
				end;
			end;
{アイテム製造追加ココまで}
		//--------------------------------------------------------------------------
		$0197: //GMコマンド /resetstate /resetskill(将来的にはGMチェックを入れる)
			begin
                           {GMかチェック}
                           tp := tc.PData;
      h := IDTableDB.IndexOf(tc.ID);
      if (h <> -1) then begin
      tid := IDTableDB.Objects[h] as TIDTbl;

				RFIFOW(2, w);

				if (w = 0) and (tid.ChangeStatSkill = 1) then begin// Resetstate
					for i := 0 to 5 do begin
						tc.ParamBase[i] := 1;
					end;
					//Lv1時の基本ポイント48をまず与える
					tc.StatusPoint := 48;
					//現在レベルまでのステータスポイント計算を逐一行う
					//ここはもっと上手い方法があると思いますが私には無理(;´Д`)
					for i := 1 to tc.BaseLV - 1 do begin
						tc.StatusPoint := tc.StatusPoint + i div 5 + 3;
				end;
          CalcStat(tc);
          SendCStat(tc);
					end;
					//各種ステータスを再計算し、クライアントに変更を通知
					CalcStat(tc);

				if (w = 1) and (tid.ChangeStatSkill = 1) then begin // ResetSkill

                                        j := 0;
					for i := 2 to MAX_SKILL_NUMBER do begin
                                                j := j + tc.Skill[i].Lv;
            if not tc.Skill[i].Card then
							tc.Skill[i].Lv := 0;
					end;
          if (tc.Plag <> 0) then begin
          tc.Skill[tc.Plag].Plag := false;
          tc.Skill[tc.Plag].Lv := 0;
          tc.Plag := 0;
          tc.PLv := 0;
          end;
					if tc.JID = 0 then begin
                                        end else begin
                                                tc.skillpoint := j;
                                        end;

					SendCSkillList(tc);
          CalcStat(tc);
          SendCStat(tc);
				end;
{追加ココまで}
				//if w = 1 then begin // ResetSkill(スキルポイント再分配)の処理

				//	//減らしたポイント記録用にjを0にする
				//	j := 0;
				//	//スキルレベルを0にし、減らしたポイントをjに加えていく
				//	for i := 1 to 157 do begin
				//		if (tc.Skill[i].Lv <> 0) then begin
				//			j := j + tc.Skill[i].Lv;
				//			tc.Skill[i].Lv := 0;
				//		end;
				//	end;
				//		tc.SkillPoint := j;

				//	//スキル送信
				//	//スキル計算系の関数ができたらそっちに飛ばす
				//	//現在はスキルを全部真っ白にするだけ

				//	WFIFOW( 0, $010f);
				//	WFIFOW( 2, 4);
				//	Socket.SendBuf(buf, 4);

				//	//スキルポイントの変更を通知
				//	SendCStat(tc);
				//end;
                                               //スキルポイントの変更を通知
						SendCStat(tc);
			end;
								end;
		//--------------------------------------------------------------------------
		$019d: //GMハイドコマンド
			begin    
                           {GMかチェック}
                           tp := tc.PData;
      h := IDTableDB.IndexOf(tc.ID);
      if (h <> -1) then begin
      tid := IDTableDB.Objects[h] as TIDTbl;
      if (tid.ChangeOption = 1) then begin
				tm := tc.MData;

				if (tc.Option and 64 = 0) then begin
					tc.Option := tc.Option or 64;
          tc.Hidden := true;
				end else begin
					tc.Option := tc.Option and $FFBF;
          tc.Hidden := false;
				end;


				WFIFOW(0, $0119);
				WFIFOL(2, tc.ID);
				WFIFOW(6, 0);
				WFIFOW(8, 0);
				WFIFOW(10, tc.Option);
				WFIFOB(12, 0);
				SendBCmd(tm, tc.Point, 13);
                           end;
			end;
			end;
		//--------------------------------------------------------------------------
{キューペット}
                $019f: // ペットテイミング スロット停止
                        begin
                                if( tc.UseItemID = 0 ) then continue;
                                
                                b := 0;
                                // l = モンスター ID
                                RFIFOL( 2, l );
                                tm := tc.Mdata;
                                if tm.Mob.IndexOf( l ) <> -1 then begin
                                        ts := tm.Mob.IndexOfObject(l) as TMob;

                                        if PetDB.IndexOf( ts.JID ) <> -1 then begin
                                                tpd := PetDB.IndexOfObject( ts.JID ) as TPetDB;

                                                if( tc.UseItemID = tpd.ItemID ) then begin

                                                        // 捕獲率。LUK とかも絡めると楽しいかも。
                                                        k := tpd.Capture;
                                                        //k := 1000;
                                                        if Random( 1000 ) < k then begin

                                                                b := 1;

                                                                // モンス消滅
                                                                WFIFOW( 0, $0080 );
                                                                WFIFOL( 2, l );
                                                                WFIFOB( 6, 0 );
																																SendBCmd( tm, ts.Point, 7 );

                                                                ts.HP := 0;
                                                                ts.pcnt := 0;
                                                                ts.Stat1 :=0;
                                                                ts.Stat2 :=0;
                                                                ts.Element := ts.Data.Element;
                                                                ts.BodyTick := 0;
                                                                for i := 0 to 4 do ts.HealthTick[i] := 0;
                                                                ts.isLooting := False;
                                                                ts.LeaderID := 0;
                                                                ts.SpawnTick := timeGettime();

                                                                i := tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.IndexOf(ts.ID);
                                                                if i = -1 then continue;
                                                                tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.Delete(i);

                                                                //ターゲット解除
                                                                for j1 := ts.Point.Y div 8 - 2 to ts.Point.Y div 8 + 2 do begin
                                                                        for i1 := ts.Point.X div 8 - 2 to ts.Point.X div 8 + 2 do begin
                                                                                for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
                                                                                        tc1 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
                                                                                        if ((tc1.AMode = 1) or (tc1.AMode = 2)) and (tc1.ATarget = ts.ID) then begin
                                                                                                tc1.AMode := 0;
                                                                                                tc1.ATarget := 0;
                                                                                        end;
                                                                                        if (tc1.MMode <> 0) and (tc1.MTarget = ts.ID) then begin
                                                                                                tc1.MMode := 0;
																																																tc1.MTarget := 0;
                                                                                        end;
                                                                                end;
                                                                        end;
                                                                end;

                                                                // 経験地リセット
                                                                for i := 0 to 31 do begin
                                                                        ts.EXPDist[i].CData := nil;
                                                                        ts.EXPDist[i].Dmg := 0;
                                                                end;

                                                                // MVP ペットなんていないと思うけど一応リセット
                                                                if ts.Data.MEXP <> 0 then begin
		                                                        for j := 0 to 31 do begin
			                                                        ts.MVPDist[j].CData := nil;
			                                                        ts.MVPDist[j].Dmg := 0;
		                                                        end;
	                                                        end;

                                                                //召還モンスは消滅
                                                                if ts.isSummon then begin
		                                                        i := tm.Mob.IndexOf(ts.ID);
		                                                        if i <> -1 then begin
		                                                                tm.Mob.Delete(i);
		                                                                ts.Free;
                                                                        end;
                                                                end;

                                                                td := ItemDB.IndexOfObject( tpd.EggID ) as TItemDB;

                                                                // 卵獲得プロセス
                                                                // 重量判定
                                                                if tc.MaxWeight >= tc.Weight + td.Weight then begin
                                                                        j := SearchCInventory(tc, td.ID, td.IEquip );
					                                if j <> 0 then begin
						                                //アイテム追加

						                                with tc.Item[j] do begin
                                                                                        ID := td.ID;
                                                                                        Amount := tc.Item[j].Amount + 1;
							                                Equip := 0;
							                                Identify := 1;
							                                Refine := 0;
							                                Attr := 0;
							                                Card[0] := 0;
							                                Card[1] := 0;
							                                Card[2] := 0;
							                                Card[3] := 0;
							                                Data := td;
                                                                                end;

						                                // Update weight
						                                tc.Weight := tc.Weight + td.Weight;
						                                SendCStat1(tc, 0, $0018, tc.Weight);

						                                //アイテムゲット通知
        					                                SendCGetItem(tc, j, 1);
					                                end else begin
                                                                                //これ以上もてない
						                                WFIFOW( 0, $00a0);
						                                WFIFOB(22, 1);
						                                Socket.SendBuf(buf, 23);
                                                                        end;
                                                                end else begin
					                                //重量オーバー
					                                WFIFOW( 0, $00a0);
					                                WFIFOB(22, 2);
					                                Socket.SendBuf(buf, 23);
				                                end;
                                                        end;
                                                end;
                                                tc.UseItemID := 0;
                                        end;
                                end;

                                // 成否判定
                                WFIFOW( 0, $01a0 );
                                WFIFOB( 2, b );
                                Socket.SendBuf( buf, 3 );
                        end;

                //--------------------------------------------------------------------------
                $01a1: // ペットメニュー
                        begin
                                RFIFOB( 2, b );
                                tm := tc.MData;

                                if ( tc.PetData <> nil ) and ( tc.PetNPC <> nil ) then begin
                                        tpe := tc.PetData;
                                        tn := tc.PetNPC;

                                        case b of
                                                0: // ペットステータス表示
                                                begin
                                                        WFIFOW( 0, $01a2 );
                                                        WFIFOS( 2, tpe.Name, 24 );
                                                        WFIFOB( 26, tpe.Renamed );
                                                        WFIFOW( 27, tpe.LV );
                                                        WFIFOW( 29, tpe.Fullness );
                                                        WFIFOW( 31, tpe.Relation );
                                                        WFIFOW( 33, tpe.Accessory );
                                                        Socket.SendBuf( buf, 35 );
                                                end;
                                                1: // エサをあげる
                                                begin
                                                        w := 0;
                                                        j := 0;

																												for i := 1 to 100 do begin
                                                                if( tc.Item[i].ID = tpe.Data.FoodID ) and ( tc.Item[i].Amount > 0 ) then begin
                                                                        w := i;
                                                                        break;
                                                                end;
                                                        end;

                                                        if w > 0 then begin

                                                                // アイテム減少
                                                                Dec(tc.Item[w].Amount);
                                                                if tc.Item[w].Amount = 0 then tc.Item[w].ID := 0;
				                                tc.Weight := tc.Weight - tc.Item[w].Data.Weight;

                                                                //アイテム数減少
				                                WFIFOW( 0, $00af);
				                                WFIFOW( 2, w);
				                                WFIFOW( 4, 1);
                                                                Socket.SendBuf( buf, 6 );

				                                // Update weight
				                                SendCStat1(tc, 0, $0018, tc.Weight);

																																if tpe.Fullness < 26  then tpe.Relation := tpe.Relation + tpe.Data.Hungry
                                                                else if tpe.Fullness >= 76 then  tpe.Relation := tpe.Relation - tpe.Data.Full
																																else tpe.Relation := tpe.Relation + ( tpe.Data.Hungry div 2 );

                                                                if tpe.Relation > 1000 then tpe.Relation := 1000
                                                                else if tpe.Relation < 0 then tpe.Relation := 0;

                                                                tpe.Fullness := tpe.Fullness + tpe.Data.Fullness;
                                                                if tpe.Fullness > 100 then tpe.Fullness := 100;

                                                                WFIFOW( 0, $01a4 );
                                                                WFIFOB( 2, 1 );
                                                                WFIFOL( 3, tn.ID );
                                                                WFIFOL( 7, tpe.Relation );
                                                                Socket.SendBuf( buf, 11 );

                                                                WFIFOW( 0, $01a4 );
                                                                WFIFOB( 2, 2 );
                                                                WFIFOL( 3, tn.ID );
                                                                WFIFOL( 7, tpe.Fullness );
                                                                Socket.SendBuf( buf, 11 );

                                                                j := 1;
                                                        end;

                                                        WFIFOW( 0, $01a3 );
                                                        WFIFOB( 2, j );
                                                        WFIFOW( 3, tpe.Data.FoodID );
                                                        Socket.SendBuf( buf, 5 );
                                                end;
																								2: // パフォーマンス
                                                begin
                                                        // 親密度が高いほど、多くのアクションを見せるようにしてみる
                                                        if tpe.Relation <= 100 then i := 0
                                                        else if tpe.Relation <= 250 then i := 1
                                                        else if tpe.Relation <= 750 then i := 2
                                                        else i := 3;

                                                        WFIFOW( 0, $01a4 );
                                                        WFIFOB( 2, 4 );
                                                        WFIFOL( 3, tn.ID );
                                                        WFIFOL( 7, Random(i) );
                                                        SendBCmd( tm, tn.Point, 11 );
                                                end;
                                                3: // 卵に戻す
                                                begin
                                                        for i := 1 to 100 do begin
                                                                if( tc.Item[i].ID <> 0 ) and ( tc.Item[i].Amount > 0 ) and
                                                                ( tc.Item[i].Card[0] = $FF00 ) and ( tc.Item[i].Attr <> 0 ) then begin

                                                                        tc.Item[i].Attr := 0;

                                                                        WFIFOW( 0, $0080 );
                                                                        WFIFOL( 2, tn.ID );
                                                                        WFIFOB( 6, 0 );
                                                                        SendBCmd( tm, tn.Point, 7 );

                                                                        if UseSQL then begin
                                                                          tpe.Incubated := 0;
                                                                          SavePetData(tpe, i, 1);
                                                                        end;
                                                                        //ペット削除
																																				j := tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.IndexOf(tn.ID);
                                                                        if j <> -1 then begin
                                                                                tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.Delete(j);
                                                                        end;

                                                                        j := tm.NPC.IndexOf( tn.ID );
                                                                        if j <> -1 then begin
                                                                                tm.NPC.Delete(j);
                                                                        end;

                                                                        tn.Free;
                                                                        tc.PetData := nil;
                                                                        tc.PetNPC := nil;

                                                                        break;
                                                                end;
                                                        end;

                                                end;
                                                4: // アクセサリ解除
                                                begin
                                                        if tpe.Accessory <> 0 then begin

                                                                if ItemDB.IndexOf( tpe.Accessory ) <> -1 then begin
                                                                        td := ItemDB.IndexOfObject( tpe.Accessory ) as TItemDB;

                                                                        // 重量判定
                                                                        if tc.MaxWeight >= tc.Weight + td.Weight then begin
																																								j := SearchCInventory(tc, td.ID, td.IEquip );
                                                                                if j <> 0 then begin
                                                                                        //アイテム追加
                                                                                        tc.Item[j].ID := td.ID;
                                                                                        tc.Item[j].Amount := tc.Item[j].Amount + 1;
                                                                                        tc.Item[j].Equip := 0;
                                                                                        tc.Item[j].Identify := 1;
                                                                                        tc.Item[j].Refine := 0;
                                                                                        tc.Item[j].Attr := 0;
                                                                                        tc.Item[j].Card[0] := 0;
                                                                                        tc.Item[j].Card[1] := 0;
                                                                                        tc.Item[j].Card[2] := 0;
                                                                                        tc.Item[j].Card[3] := 0;

                                                                                        tc.Item[j].Data := td;

                                                                                        //アイテムゲット通知
                                                                                        SendCGetItem(tc, j, 1);

                                                                                        // Update weight
                                                                                        tc.Weight := tc.Weight + td.Weight;
                                                                                        SendCStat1(tc, 0, $0018, tc.Weight);
                                                                                end else begin
                                                                                        //これ以上もてない
                                                                                        WFIFOW( 0, $00a0);
																																												WFIFOB(22, 1);
                                                                                        Socket.SendBuf(buf, 23);
                                                                                end;
                                                                        end else begin
                                                                                //重量オーバー
                                                                                WFIFOW( 0, $00a0);
                                                                                WFIFOB(22, 2);
                                                                                Socket.SendBuf(buf, 23);
                                                                        end;
                                                                end;
                                                                
                                                                tpe.Accessory := 0;

                                                                WFIFOW( 0, $01a4 );
                                                                WFIFOB( 2, 3 );
                                                                WFIFOL( 3, tn.ID );
                                                                WFIFOL( 7, tpe.Accessory );
                                                                SendBCmd( tm, tn.Point, 11 );

                                                        end;
                                                end;
                                        end;
                                end;
                        end;
                //--------------------------------------------------------------------------
                $01a5: // ペットの名前変更
                        begin
                                if ( tc.PetData <> nil ) and ( tc.PetNPC <> nil ) then begin

                                        tpe := tc.PetData;
                                        tn := tc.PetNPC;

                                        str := RFIFOS( 2, 24 );
                                        tn.Name := str;
                                        tpe.Name := str;
                                        tpe.Renamed := 1;

                                        WFIFOW( 0, $0095 );
                                        WFIFOL( 2, tn.ID );
                                        WFIFOS( 6, tn.Name, 24 );
                                        Socket.SendBuf( buf, 30 );
                                end;
                        end;
                //--------------------------------------------------------------------------
                $01a7: // 卵孵化機使用時 卵選択
                        begin
                                // w = 卵の index
                                RFIFOW( 2, w );

                                if( tc.Item[tc.UseItemID].Data.Effect = 121 ) and
                                ( tc.Item[w].Data.IType = 4 ) and ( tc.Item[w].Data.Loc = 0 ) and
                                ( tc.Item[w].Data.Effect = 122 ) then begin

				        Dec(tc.Item[tc.UseItemID].Amount);
				        WFIFOW( 0, $00a8);
				        WFIFOW( 2, tc.UseItemID);
								WFIFOW( 4, tc.Item[tc.UseItemID].Amount);
				        WFIFOB( 6, 1);
				        Socket.SendBuf(buf, 7);

				        if tc.Item[tc.UseItemID].Amount = 0 then tc.Item[tc.UseItemID].ID := 0;
				        tc.Weight := tc.Weight - tc.Item[tc.UseItemID].Data.Weight;

				        //アイテム数減少
				        WFIFOW( 0, $00af);
				        WFIFOW( 2, tc.UseItemID);
				        WFIFOW( 4, 1);

				        //Update weight
				        SendCStat1(tc, 0, $0018, tc.Weight);

                                        tc.UseItemID := 0;

                                        tm := tc.MData;

                                        k := -1;
                                        tpd := PetDB.Objects[0] as TPetDB;
                                        for i := 0 to PetDB.Count - 1 do begin
                                                tpd := PetDB.Objects[i] as TPetDB;
                                                if( tpd.EggID = tc.Item[w].ID ) then begin
                                                        k := tpd.MobID;
																												break;
                                                end;
                                        end;

                                        if ( k <> -1 ) and ( MobDB.IndexOf( k ) <> -1 ) then begin

                                                tmd := MobDB.IndexOfObject( k ) as TMobDB;
                                                tn := TNPC.Create;
                                                tn.ID := NowNPCID;
                                                Inc(NowNPCID);

                                                tpe := nil;

                                                if tc.Item[w].Card[0] = $FF00 then begin
                                                        i := PetList.IndexOf( tc.Item[w].Card[2] + tc.Item[w].Card[3] * $10000 );
                                                        if (i <> -1) then begin
                                                                tpe := PetList.Objects[i] as TPet;
                                                        end;
                                                end;

                                                if tpe = nil then begin
                                                        tpe := TPet.Create;

                                                        tpe.PlayerID := tc.ID;
                                                        tpe.CharaID := tc.CID;
																												if UseSQL then tpe.PetID := GetNowPetID()
                                                        else tpe.PetID := NowPetID;
                                                        tpe.JID := tmd.ID;
                                                        tpe.Name := tmd.JName;
																												tpe.Renamed := 0;
                                                        tpe.LV := tmd.LV;
                                                        tpe.Relation := 250;
                                                        tpe.Fullness := 25;
                                                        tpe.Accessory := 0;
                                                        tpe.Index := w;


                                                        PetList.AddObject( tpe.PetID, tpe );

                                                        tc.Item[w].Card[0] := $FF00;
                                                        tc.Item[w].Card[2] := tpe.PetID mod $10000;
                                                        tc.Item[w].Card[3] := tpe.PetID div $10000;

                                                        if UseSQL then SavePetData(tpe, 0, 1)
																												else Inc( NowPetID );
                                                end;

                                                tpe.MobData := MobDB.IndexOfObject(tpe.JID) as TMobDB;
                                                tn.Name := tpe.Name;
                                                tn.JID := tpe.JID;
                                                tn.Map := tc.Map;

                                                repeat
                                                        tn.Point.X := tc.Point.X + Random(5) - 2;
                                                        tn.Point.Y := tc.Point.Y + Random(5) - 2;
                                                until ( tn.Point.X <> tc.Point.X ) or ( tn.Point.Y <> tc.Point.Y );

                                                tn.Dir := Random(8);
                                                tn.CType := 2;
                                                tn.HungryTick := timeGettime();

																								tpe.Data := tpd;
                                                tpe.Incubated := 1;

                                                tm.NPC.AddObject(tn.ID, tn);
                                                tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.AddObject(tn.ID, tn);

                                                SendNData(tc.Socket, tn, tc.ver2 );
                                                SendBCmd(tm, tn.Point, 41, tc, False);

                                                tc.PetData := tpe;
                                                tc.PetNPC := tn;
                                                tc.Item[w].Attr := 1;

                                                WFIFOW( 0, $01a4 );
                                                WFIFOB( 2, 0 );
                                                WFIFOL( 3, tn.ID );
                                                WFIFOL( 7, 0 );
                                                Socket.SendBuf( buf, 11 );

                                                if tpe.Accessory <> 0 then begin
                                                        WFIFOB( 2, 3 );
                                                        WFIFOL( 7, tpe.Accessory );
                                                        Socket.SendBuf( buf, 11 );
                                                end;

                                                WFIFOB( 2, 5 );
                                                WFIFOL( 7, 20 ); // 謎
                                                Socket.SendBuf( buf, 11 );

																								WFIFOW( 0, $01a2 );
                                                WFIFOS( 2, tpe.Name, 24 );
																								WFIFOB( 26, tpe.Renamed );
                                                WFIFOW( 27, tpe.LV );
                                                WFIFOW( 29, tpe.Fullness );
																								WFIFOW( 31, tpe.Relation );
                                                WFIFOW( 33, tpe.Accessory );
                                                Socket.SendBuf( buf, 35 );

                                        end;
                                end;
                        end;
                $01a9: // エモーション
                        begin
                                RFIFOL( 2, l );

                                tm := tc.MData;
                                if ( tc.PetData <> nil ) and ( tc.PetNPC <> nil ) then begin
                                        tn := tc.PetNPC;

                                        WFIFOW( 0, $01aa );
                                        WFIFOL( 2, tn.ID );
                                        WFIFOL( 6, l );
                                        SendBCmd( tm, tn.Point, 10 );
                                end;
                        end;
{キューペットここまで}
		//--------------------------------------------------------------------------
    $01ae:
      begin
              RFIFOW(2, w);
              if (w = 65535) or (w < 1) then continue;

              ma := MArrowDB.IndexOfObject(w) as TMArrowDB;

              for i := 0 to 2 do begin
              if (ma.CID[i] <> 0) then begin
              td := ItemDB.IndexOfObject(ma.CID[i]) as TItemDB;
							if tc.MaxWeight >= tc.Weight + cardinal(td.Weight * ma.CNum[i]) then begin
								k := SearchCInventory(tc, td.ID, td.IEquip);
								if k <> 0 then begin
									if tc.Item[k].Amount < 30000 then begin
									//アイテム追加
									tc.Item[k].ID := td.ID;
                  tc.Item[k].Amount := tc.Item[k].Amount + ma.CNum[i];
                  tc.Item[k].Equip := 0;
                  tc.Item[k].Identify := 1;
                  tc.Item[k].Refine := 0;
                  tc.Item[k].Attr := 0;
                  tc.Item[k].Card[0] := 0;
                  tc.Item[k].Card[1] := 0;
                  tc.Item[k].Card[2] := 0;
                  tc.Item[k].Card[3] := 0;
                  tc.Item[k].Data := td;
									// Update weight
									tc.Weight := tc.Weight + cardinal(td.Weight * ma.CNum[i]);
									SendCStat1(tc, 0, $0018, tc.Weight);

									//アイテムゲット通知
									SendCGetItem(tc, k, ma.CNum[i]);
                end;
								end;
							end else begin
								//重量オーバー
								WFIFOW( 0, $00a0);
								WFIFOB(22, 2);
								Socket.SendBuf(buf, 23);
							end;
              end;
              end;

                w1 := SearchCInventory(tc,w,false);
                td := tc.Item[w1].Data;
								Dec(tc.Item[w1].Amount);
								WFIFOW( 0, $00a8);
								WFIFOW( 2, w1);
								WFIFOW( 4, tc.Item[w1].Amount);
								WFIFOB( 6, 1);
								Socket.SendBuf(buf, 7);

								if tc.Item[w1].Amount = 0 then tc.Item[w1].ID := 0;
								tc.Weight := tc.Weight - td.Weight;

								WFIFOW( 0, $00af);
								WFIFOW( 2, w1);
								WFIFOW( 4, 1);

								SendCStat1(tc, 0, $0018, tc.Weight);
      end;

		$01af: // Change your cart.
			begin
        tm := tc.MData;
				RFIFOW(2, w);
				case w of
					1: tc.Option := (tc.Option and $F877) or $0008; // Cart 1
					2: tc.Option := (tc.Option and $F877) or $0080; // Cart 2
					3: tc.Option := (tc.Option and $F877) or $0100; // Cart 3
					4: tc.Option := (tc.Option and $F877) or $0200; // Cart 4
					5: tc.Option := (tc.Option and $F877) or $0400; // Cart 5
				end;
				// Send the new option value.
        UpdateOption(tm, tc);

        SendCStat(tc);

                        end;
		//--------------------------------------------------------------------------
{露店スキル追加}
		$01b2: //露店開設
			begin
				//職業＆スキルチェック
				if (tc.JID <> 5) and (tc.JID <> 10) and (tc.JID <> 18) then continue;
				if (tc.Skill[41].Lv = 0) then continue;

				//キャンセル判定
				RFIFOB(84, b);//0=キャンセル,1=オープン
				if (b = 0) then continue;
				RFIFOW(2, w);
				if (w - 85 < 8) then continue;
				tv := TVender.Create;

				//露店情報設定
				tv.Title := RFIFOS(4, 80);//タイトル
				for j := 0 to (w - 85) div 8 - 1 do begin
					//IDチェック
					RFIFOW(85+j*8, w1);
					if (tc.Cart.Item[w1].ID = 0) then begin
						exit;
					end;
					tv.Idx[j] := w1;
					//数量チェック
					RFIFOW(87+j*8, w2);
					if (w2 > tc.Cart.Item[w1].Amount) then begin
						w2 := tc.Cart.Item[w1].Amount;
					end;
					tv.Amount[j] := w2;
					//価格チェック
					RFIFOL(89+j*8, l);//Price
					if (l > 10000000) then l := 10000000;//価格上限(10M)
					tv.Price[j] := l;
					//重量
					td := tc.Cart.Item[w1].Data;
					tv.Weight[j] := td.Weight;
					tv.Cnt := tv.Cnt + 1;
				end;

				tv.ID := tc.ID;
				tv.CID := tc.CID;
				tc.VenderID := tv.ID;
				tv.MaxCnt := tv.Cnt;
				VenderList.AddObject(tv.ID, tv);

				//カートからアイテム削除
				for j := 0 to (w - 85) div 8 - 1 do begin
					WFIFOW( 0, $0125);
					WFIFOW( 2, tv.Idx[j]);
					WFIFOL( 4, tv.Amount[j]);
					Socket.SendBuf(buf, 8);
				end;

				//露店開始通知
				w := 8 + tv.Cnt * 22;
				WFIFOW( 0, $0136);
				WFIFOW( 2, w);
				WFIFOL( 4, tv.CID);
				for j := 0 to tv.Cnt - 1 do begin
					td := tc.Cart.Item[tv.Idx[j]].Data;
					WFIFOL( 8+j*22, tv.Price[j]);
					WFIFOW(12+j*22, tv.Idx[j]);
					WFIFOW(14+j*22, tv.Amount[j]);
					WFIFOB(16+j*22, td.IType);
					WFIFOW(17+j*22, tc.Cart.Item[tv.Idx[j]].ID);
					WFIFOB(19+j*22, tc.Cart.Item[tv.Idx[j]].Identify);
					WFIFOB(20+j*22, tc.Cart.Item[tv.Idx[j]].Attr);
					WFIFOB(21+j*22, tc.Cart.Item[tv.Idx[j]].Refine);
					WFIFOW(22+j*22, tc.Cart.Item[tv.Idx[j]].Card[0]);
					WFIFOW(24+j*22, tc.Cart.Item[tv.Idx[j]].Card[1]);
					WFIFOW(26+j*22, tc.Cart.Item[tv.Idx[j]].Card[2]);
					WFIFOW(28+j*22, tc.Cart.Item[tv.Idx[j]].Card[3]);
				end;
				Socket.SendBuf(buf, w);
				//DebugOut.Lines.Add(Format('VenderTitle = %s : OwnerID = %d : OwnerName = %s', [tv.Title, tc.CID, tc.Name]));

				//周囲に看板通知
				WFIFOW(0, $0131);
				WFIFOL(2, tv.ID);
				WFIFOS(6, tv.Title, 80);
				SendBCmd(tc.MData, tc.Point, 86, tc);
			end;
//--------------------------------------------------------------------------

		$01ce: // Choose AutoCast spell
      begin
        RFIFOL(2, l); // This is the ID of the skill chosen.

        // INFO: This choice is the skill that must be used in autocast.
        // Instead of choosing a random skill when attacking, use this
        // spell to the possible level available.

        tc.Skill[279].Effect1 := l;
      end;
//--------------------------------------------------------------------------
		$01e8: // Request to organize a party - 00f9's updated version
			begin
				str := RFIFOS(2, 24);

        // TODO: These two bytes control item share and loot share.
        RFIFOB(26, b);
        RFIFOB(27, b1);
				if (tc.Skill[1].Lv < 7) and (not DisableSkillLimit) then begin
          w := tc.MSkill;
          // This is for a basic skill.
          tc.MSkill := 1;
          SendSkillError(tc, 0, 4);
          tc.MSkill := w;
				end else begin
					if tc.PartyName <> '' then begin
						i := 2;
					end else if (str = '') or (PartyNameList.IndexOf(str) <> -1) then begin
						i := 1;
					end else begin
						//パーティー名が重複してはいけない
						tpa := TParty.Create;
						tpa.Name := str;
						tpa.EXPShare := 0;
						tpa.ITEMShare := 1;
						tpa.MemberID[0] := tc.CID; //リーダ:0
						tpa.Member[0] := tc;
                                                if tc.JID = 19 then begin
                                                        tpa.PartyBard[0] := tc;
                                                        //DebugOut.Lines.Add(Format('Bard Added To Party', [tpa.Name, tpa.MinLV, tpa.MaxLV, tpa.MemberID[0], tpa.Member[0].Name]));
                                                end else if tc.JID = 20 then begin
                                                        tpa.PartyDancer[0] := tc;
                                                        //DebugOut.Lines.Add(Format('Dancer Added To Party', [tpa.Name, tpa.MinLV, tpa.MaxLV, tpa.MemberID[0], tpa.Member[0].Name]));
                                                end;
						tc.PartyName := tpa.Name;
						PartyNameList.AddObject(tpa.Name, tpa);
						//DebugOut.Lines.Add(Format('PartyName %s : from %d to %d : ID = %d : Name = %s', [tpa.Name, tpa.MinLV, tpa.MaxLV, tpa.MemberID[0], tpa.Member[0].Name]));
						SendPartyList(tc);
						i := 0;
					end;

					//パーティー作成正否応答
					WFIFOW( 0, $00fa);
					WFIFOB( 2, i);         // 1:同名～ 2:既に～
					Socket.SendBuf(buf, 3);
				end;
				//DebugOut.Lines.Add(Format('PartyNameList.Count = %d', [PartyNameList.Count]));

			end;
{露店スキル追加ココまで}
		end;
  end;
End;(* Proc sv3PacketProcess()
*-----------------------------------------------------------------------------*)

//==============================================================================
end.
