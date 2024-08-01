unit Game;



interface

uses
	Windows, MMSystem, Forms, Classes, Math, SysUtils, ScktComp,
	Path, Script, Common, Zip, SQLData, FusionSQL;

//==============================================================================
// ä÷êîíËã`
		procedure sv3PacketProcess(Socket: TCustomWinSocket);
//==============================================================================










implementation
//==============================================================================
// ÉQÅ[ÉÄÉTÅ[ÉoÅ[ÉpÉPÉbÉgèàóù
procedure sv3PacketProcess(Socket: TCustomWinSocket);
var
	i    :integer;
  h    :integer;
	j    :integer;
	k    :integer;
	ii   :integer;
	cmd  :word;
	w    :word;
	w1   :word;
	w2   :word;
  w3   :word;
{í«â¡}
	wjob:Int64;
{í«â¡ÉRÉRÇ‹Ç≈}
{ÉAÉCÉeÉÄêªë¢í«â¡}
	m1     :word;//éÂÇ…êªë¢Ç≥ÇÍÇÈÉAÉCÉeÉÄÇÃIDÇ∆ÇµÇƒóòóp
	m      :array[0..2] of word;//éÂÇ…êªë¢ÉAÉCÉeÉÄÇ…ïsâ¬Ç≥ÇÍÇÈëÆê´êŒÅAêØÇÃÇ©ÇØÇÁÇÃIDÇ∆ÇµÇƒóòóp
	e,e2   :word;//éÂÇ…êªë¢éûè¡îÔÉAÉCÉeÉÄÇÃInventoryì‡åüçıéûÇ…óòóp
	anvil  :word;//ã‡ï~Ç…ÇÊÇ¡Çƒè„Ç™ÇÈê¨å˜ó¶
{ÉAÉCÉeÉÄêªë¢í«â¡ÉRÉRÇ‹Ç≈}
	id1,id2:cardinal;
	l         :cardinal;
	l2        :cardinal;
	weight    :cardinal;
  c         :cardinal;
	b         :byte;
  b1        :byte;
	len       :integer;
	str       :string;
  str2      :string;
	accountid :string;
	charaid   :string;
	npcid     :string;
	tp  :TPlayer;
	tc  :TChara;
	tc1 :TChara;
	tm  :TMap;
	tn  :TNPC;
	ts  :TMob;
  ts1 :TMob;
  tss :TSlaveDB;
  ma  :TMArrowDB;
  tid :TIDTbl;
	ti  :TItem;
	tk  :TSkill;
	tl  :TSkillDB;
	td  :TItemDB;
{ÉAÉCÉeÉÄêªë¢í«â¡}
	tma :TMaterialDB;
{ÉAÉCÉeÉÄêªë¢í«â¡ÉRÉRÇ‹Ç≈}
{ÉpÅ[ÉeÉBÅ[ã@î\í«â¡}
	tpa :TParty;
{ÉpÅ[ÉeÉBÅ[ã@î\í«â¡ÉRÉRÇ‹Ç≈}
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡}
	tcr :TChatRoom;
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡ÉRÉRÇ‹Ç≈}
{òIìXÉXÉLÉãí«â¡}
	tv  :TVender;
{òIìXÉXÉLÉãí«â¡ÉRÉRÇ‹Ç≈}  
{éÊà¯ã@î\í«â¡}
	tdl :TDealings;
{éÊà¯ã@î\í«â¡ÉRÉRÇ‹Ç≈}
{ÉLÉÖÅ[ÉyÉbÉg}
        tpd             :TPetDB;
        tmd             :TMobDB;
{éÅ{î†í«â¡}
	tsmn	:TSummon;
{éÅ{î†í«â¡ÉRÉRÇ‹Ç≈}
        tpe             :TPet;
        i1, j1, k1      :integer;
{ÉLÉÖÅ[ÉyÉbÉgÇ±Ç±Ç‹Ç≈}
{NPCÉCÉxÉìÉgí«â¡}
	mi  :MapTbl;
{NPCÉCÉxÉìÉgí«â¡ÉRÉRÇ‹Ç≈}
{ÉMÉãÉhã@î\í«â¡}
	tg    :TGuild;
	tg1   :TGuild;
	tgb   :TGBan;
	tgl   :TGRel;
	tp1   :TPlayer;
{ÉMÉãÉhã@î\í«â¡ÉRÉRÇ‹Ç≈}
	ta  :TMapList;
	xy  :TPoint;
  s   :string;
	sl  :TStringList;
	ww  :array of array of word;
	tmpbuf:array of byte;

        afm_compressed :TZip;
        afm :textfile;
        letter :char;
        MapName :string;
        dat     :TMemoryStream;
        h2  :array[0..3] of single;
        maptype :integer;

begin
  j := 0;
  tcr := nil;
	while Socket.ReceiveLength >= 2 do begin
		//len := Socket.ReceiveLength;
		Socket.ReceiveBuf(buf[0], 2);
		RFIFOW(0, cmd);
		//if cmd = $00c8 then
		//	//DebugOut.Lines.Add('!');
		tc := Socket.Data;
		if (cmd > $200) then begin
			//DebugOut.Lines.Add('ïsñæÇ»ÉpÉPÉbÉg' + IntToStr(Socket.ReceiveLength) + 'ÉoÉCÉgÇîjä¸ÇµÇ‹ÇµÇΩ');
			SetLength(tmpbuf, Socket.ReceiveLength);
			Socket.ReceiveBuf(tmpbuf[0], Socket.ReceiveLength);
			continue;
		end;
		Assert((cmd > 0) and (cmd <= $200), 'Packet Type: index error ' + IntToStr(cmd));
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

		$0072: //ÉQÅ[ÉÄéIê⁄ë±óvãÅ
			begin
				RFIFOL( 2, l);
				accountid := IntToStr(l);
				//DebugOut.Lines.Add(Format('3:%.8d CMD %.4x', [l, cmd]));
				//DebugOut.Lines.Add('		AccountID = ' + IntToHex(l, 4));
				RFIFOL( 6, l2);
				charaid := IntToStr(l2);
				//DebugOut.Lines.Add('		CharaID = ' + IntToHex(l, 4));
				RFIFOL(10, id1);
				//DebugOut.Lines.Add('		LoginID1 = ' + IntToHex(id1, 4));
				//RFIFOL(14, id2);
				if (Player.IndexOf(l) <> -1) and (Chara.IndexOf(l2) <> -1) then begin
					tp := Player.IndexOfObject(l) as TPlayer;
					tc := Chara.IndexOfObject(l2) as TChara;

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

						//ëOâÒÉèÅ[ÉvÇ…é∏îsÇµÇƒóéÇøÇΩÇ∆Ç´ÇÃïúãåèàóù
						if tc.tmpMap <> '' then begin
							tc.Map := tc.tmpMap;
							tc.tmpMap := '';
						end;

						//É}ÉbÉvÉçÅ[Éh
						if Map.IndexOf(tc.Map) = -1 then begin
							MapLoad(tc.Map);
						end;
{ÉMÉãÉhã@î\í«â¡}
						j := GuildList.IndexOf(tc.GuildID);
						if (j <> -1) then begin
							tg := GuildList.Objects[j] as TGuild;
							//ÉÅÉìÉoÅ[Ç…í ím
							WFIFOW( 0, $016d);
							WFIFOL( 2, tc.ID);
							WFIFOL( 6, tc.CID);
							WFIFOL(10, 1);
							SendGuildMCmd(tc, 14, true);
							//ÉMÉãÉhèÓïÒ
							SendGLoginInfo(tg, tc);
						end;

                        if (Option_WelcomeMsg) then begin
                            str2 := 'blueWelcome, '+tc.Name+', to the '+ServerName+' Ragnarok Online Server - Powered by Fusion Server Technology';
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
                        end;

{ÉMÉãÉhã@î\í«â¡ÉRÉRÇ‹Ç≈}
					end else begin
						WFIFOW(0, $0074); //Ç†Ç¡ÇƒÇÈÇ©Ç»ÅH
						WFIFOB(2, 0);
						Socket.SendBuf(buf, 3);
					end;
				end;
			end;
		//--------------------------------------------------------------------------
		$007d: //MAPÉçÅ[ÉhäÆóπ
			begin
				if tc.tmpMap <> '' then begin
					tc.Map := tc.tmpMap;
					tc.tmpMap := '';
				end;

				tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
				while tm.Mode < 2 do
					Application.ProcessMessages;

				tc.MData := tm;
				if CharaPID.IndexOf(tc.ID) = -1 then CharaPID.AddObject(tc.ID, tc);

                                mi := MapInfo.Objects[MapInfo.IndexOf(tm.Name)] as MapTbl;
				//É}ÉbÉvÇ…é©ï™Ç™ãèÇÈÇ±Ç∆ÇãLò^
				tm.CList.AddObject(tc.ID, tc);
				tm.Block[tc.Point.X div 8][tc.Point.Y div 8].CList.AddObject(tc.ID, tc);

                                //Grace Time
                                if mi.PvPG = true then begin
                                        tc.GraceTick := timeGetTime() + 15000;
                                end else begin
                                        tc.GraceTick := timeGetTime() + 5000;
                                end;


				//ê∂Ç´ï‘ÇËèàóù
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

{òIìXÉXÉLÉãí«â¡}
				tc.VenderID := 0;
{òIìXÉXÉLÉãí«â¡ÉRÉRÇ‹Ç≈}
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡}
				tc.ChatRoomID := 0;
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡ÉRÉRÇ‹Ç≈}
{éÊà¯ã@î\í«â¡}
				tc.DealingID := 0;
				tc.PreDealID := 0;
{éÊà¯ã@î\í«â¡ÉRÉRÇ‹Ç≈}

				//ÉuÉçÉbÉNèàóù
				for j := tc.Point.Y div 8 - 2 to tc.Point.Y div 8 + 2 do begin
					for i := tc.Point.X div 8 - 2 to tc.Point.X div 8 + 2 do begin
						//NPCÉçÅ[Éh
						for k := 0 to tm.Block[i][j].NPC.Count - 1 do begin
							tn := tm.Block[i][j].NPC.Objects[k] as TNPC;
							if (abs(tc.Point.X - tn.Point.X) < 16) and (abs(tc.Point.Y - tn.Point.Y) < 16) then begin
{NPCÉCÉxÉìÉgí«â¡}
                //SendNData(Socket, tn, tc.ver2);
								if (tn.Enable = true) then begin
									SendNData(Socket, tn,tc.ver2);
									if (tn.ScriptInitS <> -1) and (tn.ScriptInitD = false) then begin
										//OnInitÉâÉxÉãÇé¿çs
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
										//É`ÉÉÉbÉgÉãÅ[ÉÄÇï\é¶Ç∑ÇÈ
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
{NPCÉCÉxÉìÉgí«â¡ÉRÉRÇ‹Ç≈}
							end;
						end;
						//é¸ÇËÇÃêlÇ…í ím&é¸ÇËÇ…Ç¢ÇÈêlÇï\é¶Ç≥ÇπÇÈ
						for k := 0 to tm.Block[i][j].CList.Count - 1 do begin
							tc1 := tm.Block[i][j].CList.Objects[k] as TChara;
							if (tc <> tc1) and (abs(tc.Point.X - tc1.Point.X) < 16) and (abs(tc.Point.Y - tc1.Point.Y) < 16) then begin
								SendCData(tc, tc1);
								SendCData(tc1, tc);
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡}
								//é¸ï”ÇÃÉ`ÉÉÉbÉgÉãÅ[ÉÄÇï\é¶
								ChatRoomDisp(tc.Socket, tc1);
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡ÉRÉRÇ‹Ç≈}
{òIìXÉXÉLÉãí«â¡}
								//é¸ï”ÇÃòIìXÇï\é¶
								VenderDisp(tc.Socket, tc1);
{òIìXÉXÉLÉãí«â¡ÉRÉRÇ‹Ç≈}
							end;
						end;
						//ÉÇÉìÉXÉ^Å[ÉçÅ[Éh
						for k := 0 to tm.Block[i][j].Mob.Count - 1 do begin
							ts := tm.Block[i][j].Mob.Objects[k] as TMob;
							if (abs(tc.Point.X - ts.Point.X) < 16) and (abs(tc.Point.Y - ts.Point.Y) < 16) then begin
								SendMData(Socket, ts);
							end;
						end;
					end;
				end;

				//ÉXÉLÉãëóêM
				SendCSkillList(tc);
				{
				WFIFOW( 0, $010f);
				j := 0;
				for i := 1 to 157 do begin
					if tc.Skill[i].Lv <> 0 then begin
						WFIFOW( 0+37*j+4, i);
						WFIFOW( 2+37*j+4, tc.Skill[i].Data.SType);
						WFIFOW( 4+37*j+4, 0);
						WFIFOW( 6+37*j+4, tc.Skill[i].Lv);
						WFIFOW( 8+37*j+4, tc.Skill[i].Data.SP[tc.Skill[i].Lv]);
						WFIFOW(10+37*j+4, tc.Skill[i].Data.Range);
						WFIFOS(12+37*j+4, tc.Skill[i].Data.IDC, 24);
						WFIFOB(36+37*j+4, 0);
						Inc(j);
					end;
				end;
				WFIFOW( 2, 4+37*j);
				Socket.SendBuf(buf, 4+37*j);
				}

        {Colus, 20040113: This buffer makes no sense.  Why is it here?
         It causes items to screw up, rather badly.}
         {
                                WFIFOW( 2, 4+37*j);
                                Socket.SendBuf(buf, 4+37*j);
         }
				//ÉpÉâÉÅÅ[É^
				CalcStat(tc);
				SendCStat(tc, true);

				//ÉAÉCÉeÉÄÉfÅ[É
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
				//ëïîıÉfÅ[É^
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
				//ëïîıÇµÇƒÇ¢ÇÈã|
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

				//ÉJÅ[ÉgÉfÅ[É^ëóêM
        // Colus, 20040123: Other carts weren't getting checked.
        w3 := tc.Option and $0788;
				if (w3 <> 0) then begin
				    SendCart(tc);
				end;

				tc.HPTick := timeGetTime();
				tc.SPTick := timeGetTime();
				tc.HPRTick := timeGetTime() - 500;
				tc.SPRTick := timeGetTime();
				tc.Sit := 3;
				tc.AMode := 0;
				tc.DmgTick := 0;

				tc.Login := 2;
{ÉpÅ[ÉeÉBÅ[ã@î\í«â¡}
				SendPartyList(tc);
{ÉpÅ[ÉeÉBÅ[ã@î\ÉRÉRÇ‹Ç≈}
{ÉLÉÖÅ[ÉyÉbÉg}
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
{ÉLÉÖÅ[ÉyÉbÉgÇ±Ç±Ç‹Ç≈}

{ÉMÉãÉhã@î\í«â¡}
				j := GuildList.IndexOf(tc.GuildID);
				if (j <> -1) then begin
					tg := GuildList.Objects[j] as TGuild;
					//çêímëóêM
					WFIFOW( 0, $016f);
					WFIFOS( 2, tg.Notice[0], 60);
					WFIFOS(62, tg.Notice[1], 120);
					Socket.SendBuf(buf, 182);
				end;

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

{ÉMÉãÉhã@î\í«â¡ÉRÉRÇ‹Ç≈}
			end;
		//--------------------------------------------------------------------------
		$007e: //tick
			begin
				WFIFOW(0, $007f);
				WFIFOL(2, timeGetTime());
				Socket.SendBuf(buf, 6);
			end;
		//--------------------------------------------------------------------------
		$0085: //à⁄ìÆóvãÅ (ç¿Ç¡ÇƒÇÈÇ∆Ç´Ç‚É`ÉÉÉbÉgÇ»Ç«Ç≈ÇÕà⁄ìÆÇ≈Ç´Ç»Ç¢ÇÊÇ§Ç…Ç∑ÇÈÇ±Ç∆)
			begin
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡}
        if tc.Sit = 1 then continue;

				if tc.ChatRoomID <> 0 then continue; //É`ÉÉÉbÉgíÜÇÃà⁄ìÆã÷é~
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡ÉRÉRÇ‹Ç≈}
{òIìXÉXÉLÉãí«â¡}
				if tc.VenderID <> 0 then continue; //òIìXíÜÇÃà⁄ìÆã÷é~
{òIìXÉXÉLÉãí«â¡ÉRÉRÇ‹Ç≈}
				RFIFOM1(2, xy);
				tc.NextFlag := true;
				tc.NextPoint := xy;
{ÉpÅ[ÉeÉBÅ[ã@î\í«â¡}
				//ìØàÍÉ}ÉbÉvì‡PTMÇ…èäç›ÇímÇÁÇπÇÈ
				if tc.PartyName <> '' then begin
					WFIFOW( 0, $0107);
					WFIFOL( 2, tc.ID);
					WFIFOW( 6, tc.NextPoint.X);
					WFIFOW( 8, tc.NextPoint.Y);
					SendPCmd(tc,10,true,true);
				end;
{ÉpÅ[ÉeÉBÅ[ã@î\í«â¡ÉRÉRÇ‹Ç≈}
			end;
		//--------------------------------------------------------------------------
		$0089: //çUåÇÅAç¿ÇË
			begin
        //DebugOut.Lines.Add(IntToStr(tc.ID));
        //DebugOut.Lines.Add(IntToStr(tc.AMode));
				if tc.AMode > 2 then continue;
				if tc.MMode <> 0 then continue;

				RFIFOB(6, b);
				//DebugOut.Lines.Add('Inside Attack Command');
				if (b = 0) or (b = 7) then begin
        //DebugOut.Lines.Add(IntToStr(b));
					//çUåÇ
					RFIFOL(2, l);
					tm := tc.MData;
          //DebugOut.Lines.Add(IntToStr(l));
////////////////////////////////////
																				//ÉÇÉìÉXÉ^Å[å^NPCÅiçUåÇÇµÇÊÇ§Ç∆Ç∑ÇÈÇ∆äJénÅj
if tm.NPC.IndexOf(l) <> -1 then begin
tn := tm.NPC.IndexOfObject(l) as TNPC;
									//ãóó£É`ÉFÉbÉN
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
							// Option Reset
              // Colus, 20040204: WHY?  You will lose your peco/falcon when
              // talking/shopping...you want to unhide, perhaps, but not
              // completely reset your options.
							if (tc.Option and 6 <> 0) then begin
								tc.Option := tc.Option and $FFF9;
								//å©ÇΩñ⁄ïœçX
                UpdateOption(tm, tc);
							end;
							        tc.AData := tn;
					        		NPCScript(tc);
					        	end;
					        end;
			        	end;
                                        //ÉÇÉìÉXÉ^Å[å^NPCÅ@Ç±Ç±Ç‹Ç≈
////////////////////////////////////


					if tm.Mob.IndexOf(l) <> -1 then begin
						//ëŒÉÇÉìÉXÉ^Å[
						ts := tm.Mob.IndexOfObject(l) as TMob;
						if tc.pcnt <> 0 then xy := tc.tgtPoint else xy := tc.Point;
						if (abs(xy.X - ts.Point.X) > tc.Range) or (abs(xy.Y - ts.Point.Y) > tc.Range) then begin
							//ãóó£Ç™âìÇ∑Ç¨ÇÈ
							WFIFOW( 0, $0139);
							WFIFOL( 2, ts.ID);
							WFIFOW( 6, ts.Point.X);
							WFIFOW( 8, ts.Point.Y);
							WFIFOW(10, tc.Point.X);
							WFIFOW(12, tc.Point.Y);
							WFIFOW(14, tc.Range); //éÀíˆ
							Socket.SendBuf(buf, 16);
						end else begin
							//çUåÇâ¬î\
							if b = 7 then tc.AMode := 2 else tc.AMode := 1;
							tc.ATarget := ts.ID;
							tc.AData := ts;
							if tc.ATick + tc.ADelay - 200 < timeGetTime() then
								tc.ATick := timeGetTime() - tc.ADelay + 200;
						end;
					end else begin
                                            //ÉÇÉìÉXÉ^Å[Ç≈Ç»Ç¢
          end;


          if tm.CList.IndexOf(l) <> -1 then begin
						tc1 := tm.CList.IndexOfObject(l) as TChara;
						if tc.pcnt <> 0 then xy := tc.tgtPoint else xy := tc.Point;
						if (abs(xy.X - tc1.Point.X) > tc.Range) or (abs(xy.Y - tc1.Point.Y) > tc.Range) then begin
							//ãóó£Ç™âìÇ∑Ç¨ÇÈ
							WFIFOW( 0, $0139);
							WFIFOL( 2, tc1.ID);
							WFIFOW( 6, tc1.Point.X);
							WFIFOW( 8, tc1.Point.Y);
							WFIFOW(10, tc.Point.X);
							WFIFOW(12, tc.Point.Y);
							WFIFOW(14, tc.Range); //éÀíˆ
							Socket.SendBuf(buf, 16);
						end else begin
							//çUåÇâ¬î\
							if b = 7 then tc.AMode := 2 else tc.AMode := 1;
							tc.ATarget := tc1.ID;
							tc.AData := tc1;
							if tc.ATick + tc.ADelay - 200 < timeGetTime() then
								tc.ATick := timeGetTime() - tc.ADelay + 200;
						end;
           end;

				end else if (b = 2) or (b = 3) then begin
        if (tc.Skill[1].Lv >= 3) then begin
					//ç¿ÇË
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
        end;
				end;
			end;
		//--------------------------------------------------------------------------
		$008c: //ÇµÇ·Ç◊ÇÈ
			begin
					tm := tc.MData;
        h := IDTableDB.IndexOf(tc.ID);

				RFIFOW(2, w);
				str := RFIFOS(4, w - 4);
{Edit - Miyuki}
        if (h <> - 1) and (Pos(' : ', str) <> 0) and (Copy(str, Pos(' : ', str) + 3, 1) = '#') then begin
					str := Copy(str, Pos(' : ', str) + 4, 256);
					//#Ç≈énÇ‹ÇÈÉRÉ}ÉìÉh(éÂÇ…Ç≈ÇŒÇÆóp)
          tid := IDTableDB.Objects[h] as TIDTbl;

					if (Copy(str, 1, 4) = 'save') and ((DebugCMD and $0001) <> 0) and (tid.SaveReturn = 1) then begin
						//åªç›ínÇÉZÅ[ÉuÇ∑ÇÈ
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
						//ÉZÅ[ÉuÉ|ÉCÉìÉgÇ‹Ç≈ñﬂÇÈ
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
					    end;
					    tc.StatusPoint := 48;
					    for i := 1 to tc.BaseLV - 1 do begin
						  tc.StatusPoint := tc.StatusPoint + i div 5 + 3;
				      end;

              end else begin
              w3 := tc.BaseLV;
              tc.BaseLV := i;
					    for i := w3 to tc.BaseLV - 1 do begin
						  tc.StatusPoint := tc.StatusPoint + i div 5 + 3;
				      end;
              end;

              tc.BaseEXP := tc.BaseNextEXP - 1;
              tc.BaseNextEXP := ExpTable[0][tc.BaseLV];
              CalcStat(tc);
              SendCStat(tc);
              SendCStat1(tc, 0, $000b, tc.BaseLV);
              SendCStat1(tc, 0, $0009, tc.StatusPoint);
              SendCStat1(tc, 1, $0001, tc.BaseEXP);
						end;
            end else if (Copy(str, 1, 7) = 'jlevel ') and ((DebugCMD and $0008) <> 0) and (tid.ChangeLevel = 1) then begin
						//ÉXÉsÅ[ÉhïœçX
						Val(Copy(str, 8, 256), i, k);
						if (k = 0) and (i >= 1) and (i <= 99) then begin
							tc.JobLV := i;

              for i := 2 to MAX_SKILL_NUMBER do begin
              if not tc.Skill[i].Card then
							tc.Skill[i].Lv := 0;
					    end;
					    if tc.JID = 0 then begin
					    end else if tc.JID < 7 then tc.SkillPoint := tc.JobLV -1
					    else tc.SkillPoint := tc.JobLV -1 + 49;
              SendCSkillList(tc);

              tc.JobEXP := tc.JobNextEXP - 1;
              if tc.JID < 13 then begin
				      j := (tc.JID + 5) div 6 + 1;
			        end else begin
				      j := 3;
			        end;
              tc.JobNextEXP := ExpTable[j][tc.JobLV];
              
              CalcStat(tc);
              SendCStat(tc);
              SendCStat1(tc, 0, $0037, tc.JobLV);
              SendCStat1(tc, 0, $000c, tc.SkillPoint);
              SendCStat1(tc, 1, $0002, tc.JobEXP);
						end;
					end else if (Copy(str, 1, 5) = 'warp ') and ((DebugCMD and $0004) <> 0) and (tid.Warp = 1) then begin
						//îCà”ÇÃèÍèäÇ…ÉèÅ[Év
						sl := TStringList.Create;
						sl.DelimitedText := Copy(str, 6, 256);
						try
							if sl.Count <> 3 then continue;
							Val(sl.Strings[1], i, k);
							if k <> 0 then continue;
							Val(sl.Strings[2], j, k);
							if k <> 0 then continue;
							//É}ÉbÉvë∂ç›É`ÉFÉbÉN
              // Colus, 20040122: Lower-case to prevent problems with 'Prontera' mapname
							if MapList.IndexOf(LowerCase(sl.Strings[0])) = -1 then continue;
							//ç¿ïWÉ`ÉFÉbÉN
							ta := MapList.Objects[MapList.IndexOf(LowerCase(sl.Strings[0]))] as TMapList;
							if (i < 0) or (i >= ta.Size.X) or (j < 0) or (j >= ta.Size.Y) then continue;
							//ÉèÅ[ÉväJén
							if (tc.Hidden = false) then SendCLeave(tc, 2);
							tc.tmpMap := LowerCase(sl.Strings[0]);
							tc.Point := Point(i,j);
							MapMove(Socket, LowerCase(sl.Strings[0]), Point(i,j));

						finally
							sl.Free();
						end;

          end else if (Copy(str, 1, 11) = 'skillpoint ') and ((DebugCMD and $0008) <> 0) and (tid.ChangeStatSkill = 1) then begin
						Val(Copy(str, 12, 256), i, k);
						if (k = 0) and (i >= 0) and (i <= 1001) then begin
            tc.SkillPoint := i;
            SendCStat1(tc, 0, $000c, tc.SkillPoint);
            end;

          end else if (Copy(str, 1, 11) = 'changestat ') and ((DebugCMD and $0004) <> 0) and (tid.ChangeStatSkill = 1) then begin
						sl := TStringList.Create;
						sl.DelimitedText := Copy(str, 12, 256);
						try
							if sl.Count = 2 then begin
							Val(sl.Strings[0], i, k);
              if(i >= 0) and (i <= 5) then begin
							Val(sl.Strings[1], j, k);
							if(j >= 1) and (j <= 99) then begin

              //if (i = 2) and (j >= 111) and (tc.BaseLV >= 100) then begin
              //j := 110 - tc.Bonus[2];
              //end;

							tc.ParamBase[i] := j;
              CalcStat(tc);
              SendCStat(tc);
              SendCStat1(tc, 0, $0009, tc.StatusPoint);
              end;
              end;
              end;
						finally
							sl.Free();
						end;

					end else if (Copy(str, 1, 6) = 'speed ') and ((DebugCMD and $0008) <> 0) and (tid.ChangeStatSkill = 1) then begin
						//ÉXÉsÅ[ÉhïœçX
						Val(Copy(str, 6, 256), i, k);
						if (k = 0) and (i >= 25) and (i <= 1000) then begin
							tc.DefaultSpeed := i;
							CalcStat(tc);
							WFIFOW(0, $00b0);
							WFIFOW(2, $0000);
							WFIFOL(4, tc.Speed);
							Socket.SendBuf(buf, 8);
						end;

      end else if (Copy(str, 1, 5) = 'whois') and ((DebugCMD and $0002) <> 0) and (tid.Whois = 1) then begin
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

        {Mitch 01-29-2004: Make w the correct length of the packet instead of just 200 }
        w := Length(str2) + 4;
        WFIFOW(0, $009a);
        WFIFOW(2, w);
        WFIFOS(4, str2, w - 4);
        tc.Socket.SendBuf(buf, w);
  end else if (Copy(str, 1, 8) = 'monster ') and ((DebugCMD and $0004) <> 0) and (tid.MonsterSummon = 1) then begin
      sl := TStringList.Create;
      sl.DelimitedText := Copy(str, 9, 256);
							if sl.Count = 2 then begin
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
					//ÉvÉåÉCÉÑÅ[ÇÃé¸àÕ9É}ÉXÇÃÇ«Ç±Ç©Ç…è¢ä“
					ts.Point.X := tc.Point.X + Random(2) - 1;
					ts.Point.Y := tc.Point.Y + Random(2) - 1;

					ts.Dir := Random(8);
					ts.HP := ts.Data.HP;
					ts.Speed := ts.Data.Speed;

					//ï¶Ç´ä‘äuÇã…ëÂÇ…ê›íË
					//Ç±Ç±ÇÕÇøÇÂÇ¡Ç∆èàóùÇ™ìKìñÇ©Ç»ÅH

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
						ts.MVPDist[0].Dmg := ts.Data.HP * 30 div 100; //FAÇ…30%â¡éZ
					end;
          ts.isSummon := True;
          ts.EmperiumID := 0;
          
					tm.Mob.AddObject(ts.ID, ts);
					tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);

					SendMData(tc.Socket, ts);
					//é¸àÕÇ…ëóêM
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
        if (tss.Slaves[i] <> -1) and (h <> 0) then begin
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
						ts1.MVPDist[0].Dmg := ts1.Data.HP * 30 div 100; //FAÇ…30%â¡éZ
					end;
					tm.Mob.AddObject(ts1.ID, ts1);
					tm.Block[ts1.Point.X div 8][ts1.Point.Y div 8].Mob.AddObject(ts1.ID, ts1);
					ts1.isSummon := true;
          ts1.isSlave := true;
          ts1.EmperiumID := 0;
          
					SendMData(tc.Socket, ts1);
					//é¸àÕÇ…ëóêM
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
          end else if (Copy(str, 1, 5) = 'zeny ') and ((DebugCMD and $0008) <> 0) and (tid.ChangeStatSkill = 1) then begin
						Val(Copy(str, 6, 256), i, k);
            // Colus, 20040203: Zeny limit was off by a 0.  Bumped the limit up to 1BZ (it can handle it!)
						if (k = 0) and (i >= 0) and (i <= 999999999) and (tc.Zeny + i <= 999999999) then begin
                                                        if tc.Zeny > 1000000000 then exit;
							tc.Zeny := tc.Zeny + i;
							WFIFOW(0, $00b1);
					    WFIFOW(2, $0014);
					    WFIFOL(4, tc.Zeny);
					    Socket.SendBuf(buf, 8);
						end;

          end else if (Copy(str, 1, 5) = 'goto ') and ((DebugCMD and $0008) <> 0) and (tid.GotoSummonBanish = 1) then begin
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

          end else if (Copy(str, 1, 5) = 'kill ') and ((DebugCMD and $0008) <> 0) and (tid.KillDieAlive = 1) then begin
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


        end else if (Copy(str, 1, 5) = 'where') and (tid.BroadCast = 1) then begin
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
        { Mitch 01-29-2004: Revive goes under "killdiealive" }
        end else if (Copy(str, 1, 7) = 'revive ') and ((DebugCMD and $0008) <> 0) and (tid.KillDieAlive = 1) then begin
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

        end else if (Copy(str, 1, 7) = 'summon ') and ((DebugCMD and $0008) <> 0) and (tid.GotoSummonBanish = 1) then begin
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

end else if (Copy(str, 1, 7) = 'banish ') and ((DebugCMD and $0008) <> 0) and (tid.GotoSummonBanish = 1) then begin
  sl := TStringList.Create;
  sl.DelimitedText := Copy(str, 8, 256);
  try
    Val(sl.Strings[sl.Count - 2], i, k);
    if k <> 0 then continue;
  
    Val(sl.Strings[sl.Count - 1], j, k);
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
          xy.X := i;
          xy.Y := j;
          tc1.Point := xy;
          MapMove(tc1.Socket, tc1.tmpMap, tc1.Point);
        end
        else begin
          tc1.Map := sl.Strings[sl.Count - 3];
          tc1.Point.X := i;
          tc1.Point.Y := j;
        end;
      end;
  
    end;
  finally
  sl.Free();
  end;
end

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
      end
      else begin
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
    end;
  finally
  end
end

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

					end else if (Copy(str, 1, 4) = 'job ') and ((DebugCMD and $0010) <> 0) and (tid.ChangeJob = 1) then begin
{èCê≥}                                          if (tc.JID <> 0) or ((DebugCMD and $0020) <> 0) then //ÉmÅ[ÉrÉXÇ©ÇÁÇÕèoóàÇ»Ç¢
                                                begin
						        //êEã∆ïœçX
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
	  					        WFIFOW(0, $0196);
		  				        WFIFOW(2, tc.Skill[j].Data.Icon);
			  			        WFIFOL(4, tc.ID);
				  		        WFIFOB(8, 0);
                      SendBCmd(tm, tc.Point, 9);
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
											//ÉXÉeÅ[É^ÉXçƒåvéZ

											//ÉIÉvÉVÉáÉìèâä˙âª
											if (tc.Option <> 0) then begin
												tc.Option := 0;
												//å©ÇΩñ⁄ïœçX
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
											WFIFOW(0, $01d7);
											WFIFOL(2, tc.ID);
						        	WFIFOB(6, 0);
											WFIFOW(7, i);
                      WFIFOW(9, 0);
											SendBCmd(tm, tc.Point, 11);
										end;
                end;
					end else if (Copy(str, 1, 5) = 'icon ') and ((DebugCMD and $0040) <> 0) then begin
            // Set the specified icon
						Val(Copy(str, 6, 256), i, k);

						if (k = 0) then begin
            for j := i to i do begin
            WFIFOW(0, $0196);
            WFIFOW(2, j);
            WFIFOL(4, tc.ID);
            WFIFOB(8, 1);
            tc.Socket.SendBuf(buf, 9);
            end;
						end;
					end else if (Copy(str, 1, 7) = 'unicon ') and ((DebugCMD and $0040) <> 0) then begin
            // Set the specified icon
						Val(Copy(str, 8, 256), i, k);

						if (k = 0) then begin
            for j := i to i do begin
            WFIFOW(0, $0196);
            WFIFOW(2, j);
            WFIFOL(4, tc.ID);
            WFIFOB(8, 0);
            tc.Socket.SendBuf(buf, 9);
            end;
						end;
{èCê≥ÉRÉRÇ‹Ç≈}
					end else if (Copy(str, 1, 7) = 'ccolor ') and ((DebugCMD and $0040) <> 0)  and (tid.ChangeColorStyle = 1) then begin
						//ïûÇÃêFïœçX
						Val(Copy(str, 8, 256), i, k);
						if (k = 0) and (i >= 0) and (i <= 77) then begin
							tc.ClothesColor := i;
							WFIFOW(0, $00c3);
							WFIFOL(2, tc.ID);
							WFIFOB(6, 7);
							WFIFOB(7, i);
							SendBCmd(tm, tc.Point, 8);
						end;
{îØêFïœçXí«â¡}
					end else if (Copy(str, 1, 7) = 'hcolor ') and (tid.ChangeColorStyle = 1) then begin
						//îØÇÃêFïœçX
						Val(Copy(str, 8, 256), i, k);
						if (k = 0) and (i >= 0) and (i <= 8) then begin
							tc.HairColor := i;
							WFIFOW(0, $00c3);
							WFIFOL(2, tc.ID);
							WFIFOB(6, 6);
							WFIFOB(7, i);
							SendBCmd(tm, tc.Point, 8);
						end;

          end else if (Copy(str, 1, 7) = 'hstyle ') and (tid.ChangeColorStyle = 1) then begin
						//îØÇÃêFïœçX
						Val(Copy(str, 8, 256), i, k);
						if (k = 0) and (i >= 0) and (i <= 19) then begin
							tc.Hair := i;
							WFIFOW(0, $00c3);
							WFIFOL(2, tc.ID);
							WFIFOB(6, 1);
							WFIFOB(7, i);
							SendBCmd(tm, tc.Point, 8);
						end;

					end else if (Copy(str, 1, 3) = 'die') and ((DebugCMD and $0080) <> 0) and (tid.KillDieAlive = 1) then begin
						//é©éE
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
					end else if (Copy(str, 1, 5) = 'alive') and ((DebugCMD and $0100) <> 0) and (tid.KillDieAlive =1 ) then begin
						//ê∂Ç´ï‘ÇË
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
					end else if (Copy(str, 1, 5) = 'item ') and ((DebugCMD and $0200) <> 0) and (tid.ItemSummon = 1) then begin
						//ÉAÉCÉeÉÄçÏê¨
						sl := TStringList.Create;
						sl.DelimitedText := Copy(str, 6, 256);
						if sl.Count = 2 then begin
							Val(sl.Strings[0], i, k);
							if k <> 0 then continue;
							if ItemDB.IndexOf(i) = -1 then continue;
							Val(sl.Strings[1], j, k);
							if k <> 0 then continue;
							if (j <= 0) or (j > 30000) then continue;
							td := ItemDB.IndexOfObject(i) as TItemDB;
							if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) * cardinal(j) then begin
								k := SearchCInventory(tc, i, td.IEquip);
								if k <> 0 then begin
									if tc.Item[k].Amount + j > 30000 then continue;
									if td.IEquip then j := 1;
									//ÉAÉCÉeÉÄí«â¡
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
									//èdó í«â¡
									tc.Weight := tc.Weight + cardinal(td.Weight) * cardinal(j);
									WFIFOW( 0, $00b0);
									WFIFOW( 2, $0018);
									WFIFOL( 4, tc.Weight);
									Socket.SendBuf(buf, 8);

									//ÉAÉCÉeÉÄÉQÉbÉgí ím
									SendCGetItem(tc, k, j);
								end;
							end else begin
								//èdó ÉIÅ[ÉoÅ[
								WFIFOW( 0, $00a0);
								WFIFOB(22, 2);
								Socket.SendBuf(buf, 23);
							end;
						end;
						sl.Free();

					end else if (Copy(str, 1, 7) = 'option ') and ((DebugCMD and $0400) <> 0) and (tid.ChangeOption = 1) then begin

						if Copy(str, 8, 5) = 'sight' then begin
							tc.Option := tc.Option or 1;
						end else if Copy(str, 8, 6) = 'ruwach' then begin
							tc.Option := tc.Option or 8192;
						end else if ((tc.JID = 5) or (tc.JID = 10) or (tc.JID = 18) or (tc.JID = 23) or (tc.JID = 4006) or (tc.JID = 4011) or (tc.JID = 4019)) and (Copy(str, 8, 4) = 'cart') then begin
							tc.Option := tc.Option or 8;
							//ÉJÅ[ÉgÉfÅ[É^ëóêM
{í«â¡}				SendCart(tc);
						end else if (((tc.JID = 11) or (tc.JID = 4012)) and (Copy(str, 8, 6) = 'falcon')) then begin
							tc.Option := tc.Option or $10;
						end else if ((tc.JID = 7) or (tc.JID = 14) or (tc.JID = 4008) or (tc.JID = 4015) or (tc.JID = 4014) or (tc.JID = 4023)) and ((Copy(str, 8, 4) = 'peko') or (Copy(str, 8, 4) = 'peco')) then begin
							tc.Option := tc.Option or $20;
						end else if Copy(str, 8, 3) = 'off' then begin
							tc.Option := 0;
						end;
            UpdateOption(tm, tc);

					end else if (Copy(str, 1, 7) = 'refine ') and ((DebugCMD and $0800) <> 0) and (tid.Refine = 1)  then begin
						//ëïîıíÜÇÃïêäÌñhãÔÇê∏òB
						Val(Copy(str, 8, 256), j, k);
						if (k <> 0) or (j < 0) or (j > 10) then continue;
						for i := 1 to 100 do begin
							if (tc.Item[i].ID <> 0) and (tc.Item[i].Amount <> 0) and tc.Item[i].Data.IEquip and
								 (tc.Item[i].Equip <> 0) then begin
								tc.Item[i].Refine := byte(j);
								WFIFOW(0, $0188);
								WFIFOW(2, 0);
								WFIFOW(4, i);
								WFIFOW(6, word(j));
								Socket.SendBuf(buf, 8);
							end;
						end;
						WFIFOW(0, $019b);
						WFIFOL(2, tc.ID);
						WFIFOL(6, 3);
						SendBCmd(tm, tc.Point, 10, tc);
						CalcStat(tc);
						SendCStat(tc);
					end else if (Copy(str, 1, 5) = 'unit ') and ((DebugCMD and $1000) <> 0) and (tid.AutoRawUnit = 1) then begin
						//ÉXÉLÉãå¯î\ínï\é¶ÉeÉXÉg
						Val(Copy(str, 6, 256), j, k);
						if (k <> 0) or (j < 0) or (j > 999) then continue;
						SetSkillUnit(tm, tc.ID, Point(tc.Point.X + 1, tc.Point.Y - 1), timeGetTime(), j, 1, 10000);

					end else if (Copy(str, 1, 5) = 'stat ') and ((DebugCMD and $2000) <> 0) and (tid.ChangeOption = 1) then begin
						//0x0119ÉpÉPÉeÉXÉg
						sl := TStringList.Create;
						sl.DelimitedText := Copy(str, 6, 256);
						try
							if sl.Count <> 4 then continue;
							Val(sl.Strings[0], i, ii);
							if ii <> 0 then continue;
							Val(sl.Strings[1], j, ii);
							if ii <> 0 then continue;
							Val(sl.Strings[2], k, ii);
							if ii <> 0 then continue;
							Val(sl.Strings[3], l, ii);
							if ii <> 0 then continue;
							WFIFOW(0, $0119);
							WFIFOL(2, tc.ID);
							WFIFOW(6, i);
							WFIFOW(8, j);
							WFIFOW(10, k);
							WFIFOB(12, l);
							SendBCmd(tm, tc.Point, 13);
						finally
							sl.Free();
						end;
					end else if (Copy(str, 1, 4) = 'raw ') and ((DebugCMD and $2000) <> 0) and (tid.AutoRawUnit = 1) then begin
						//îCà”ÉpÉPÉeÉXÉg
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
						//ëSÉXÉLÉãèKìæ
{èCê≥}
            j := tc.JID;
            if (j > UPPER_JOB_BEGIN) then j := j - UPPER_JOB_BEGIN + LOWER_JOB_END; // (RN 4001 - 4000 + 23 = 24
						for i := 1 to 157 do begin
              if (tc.Skill[i].Data.Job1[j]) or (tc.Skill[i].Data.Job2[j]) then begin
							tc.Skill[i].Lv := tc.Skill[i].Data.MasterLV;
              end;
            end;
						for i := 210 to MAX_SKILL_NUMBER do begin //äÿçëç˜à‰êÍóp
              if (tc.Skill[i].Data.Job1[j]) or (tc.Skill[i].Data.Job2[j]) then begin
							tc.Skill[i].Lv := tc.Skill[i].Data.MasterLV;
              end;
						end;
{èCê≥ÉRÉRÇ‹Ç≈}
						tc.SkillPoint := 1000;
						//DebugOut.Lines.Add('DEBUG* Added all skills to ' + tc.Name);
						SendCSkillList(tc);
{í«â¡}      CalcStat(tc);
            SendCStat(tc);
 					end else if (Copy(str, 1, 4) = 'auto') and ((DebugCMD and $8000) <> 0) and (tid.AutoRawUnit = 1) then begin
						//é©ìÆçsìÆÉeÉXÉg
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
{í«â¡ÉRÉRÇ‹Ç≈}
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
					//ÉuÉçÉbÉNèàóù
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡}
					if (tc.ChatRoomID <> 0) then begin
						SendCrCmd(tc, w + 4, true);
					end else begin
						SendNCrCmd(tm, tc.Point, w + 4, tc, true, true);
					end;

          

{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡ÉRÉRÇ‹Ç≈}
                                end;

			end;
		//--------------------------------------------------------------------------
		$0090: //NPCÇ…òbÇµÇ©ÇØÇÈ
			begin
				if tc.AMode <> 0 then continue;
				tm := tc.MData;
				RFIFOL(2, l);
				if tm.NPC.IndexOf(l) <> -1 then begin
					tn := tm.NPC.IndexOfObject(l) as TNPC;
					//ãóó£É`ÉFÉbÉN
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
		$0094: //éwíËIDÇÃÉLÉÉÉâÅANPCÇÃñºëOÇóvãÅ
   
			begin
      tm := tc.MData;
				RFIFOL(2, l);
				//accountid := IntToStr(l);
				if CharaPID.IndexOf(l) <> -1 then begin
					tc := CharaPID.IndexOfObject(l) as TChara;
{ÉMÉãÉhã@î\í«â¡}
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
{ÉMÉãÉhã@î\í«â¡ÉRÉRÇ‹Ç≈}
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
		$0096: //wisëóêM
			begin
				RFIFOW(2, w);
        //DebugOut.Lines.Add(IntToStr(w));
				str := RFIFOS(4, 24);
				i := CharaName.IndexOf(str);
				if i = -1 then begin
					//éwíËÇ≥ÇÍÇΩñºëOÇÃÉLÉÉÉâÇ™ãèÇ»Ç¢
					WFIFOW( 0, $0098);
					WFIFOB( 2, 1);
					Socket.SendBuf(buf, 3);
					continue;
				end;
				tc1 := CharaName.Objects[i] as TChara;
				if tc1.Login <> 2 then begin
					//ëäéËÇ™ÉçÉOÉCÉìÇµÇƒÇ¢Ç»Ç¢
					WFIFOW( 0, $0098);
					WFIFOB( 2, 1);
					Socket.SendBuf(buf, 3);
					continue;
				end;
				//wisëóêM
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
		$009b: //å¸Ç´ïœçX
			begin
				tm := tc.MData;

				RFIFOW(2, tc.HeadDir);
				RFIFOB(4, tc.Dir);

				WFIFOW(0, $009c);
				WFIFOL(2, tc.ID);
				WFIFOW(6, tc.HeadDir);
				WFIFOB(8, tc.Dir);

				//ÉuÉçÉbÉNèàóù
				SendBCmd(tm, tc.Point, 9, tc);
			end;
		//--------------------------------------------------------------------------
		$009f: //ÉAÉCÉeÉÄÇèEÇ§
			begin
				RFIFOL(2, l);
				PickUpItem(tc,l);
			end;
		//--------------------------------------------------------------------------
		$00a2: //ÉAÉCÉeÉÄÉhÉçÉbÉv
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
					//ÉAÉCÉeÉÄêîå∏è≠
					WFIFOW( 0, $00af);
					WFIFOW( 2, w1);
					WFIFOW( 4, w2);
					Socket.SendBuf(buf, 6);

					tc.Item[w1].Amount := tc.Item[w1].Amount - w2;
					if tc.Item[w1].Amount = 0 then tc.Item[w1].ID := 0;
					tc.Weight := tc.Weight - tc.Item[w1].Data.Weight * w2;
					//èdó ïœçX
					WFIFOW( 0, $00b0);
					WFIFOW( 2, $0018);
					WFIFOL( 4, tc.Weight);
					Socket.SendBuf(buf, 8);

					//é¸ÇËÇ…í ím
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

{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡}
				//ì¸é∫íÜÇÃÉAÉCÉeÉÄégópñ≥å¯
				if (tc.ChatRoomID <> 0) then continue;
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡ÉRÉRÇ‹Ç≈}
{òIìXÉXÉLÉãí«â¡}
				//òIìXíÜÇÃÉAÉCÉeÉÄégópñ≥å¯
{ÉAÉWÉgã@î\í«â¡}
				i := MapInfo.IndexOf(tc.Map);
				if (i <> -1) then begin
					mi := MapInfo.Objects[i] as MapTbl;
				end else begin
					mi := MapTbl.Create;
				end;
				if mi.noItem then continue;
{ÉAÉWÉgã@î\í«â¡ÉRÉRÇ‹Ç≈}
				if (tc.VenderID <> 0) then continue;

        //if (tc.Sit <> 1) then continue;
{òIìXÉXÉLÉãí«â¡ÉRÉRÇ‹Ç≈}
				RFIFOW(2, w);
				RFIFOL(4, l);
				if (l = tc.ID) and (w >= 1) and (w <= 100) then begin
        //DebugOut.Lines.Add('UsedItem:' + IntToStr(w));
					td := tc.Item[w].Data;
					b := 0;
                                        if tc.item[w].Amount <= 0 then exit;
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
									//030316í«â¡ Cardinal
									if tc.HP > tc.MAXHP then tc.HP := tc.MAXHP;
									SendCStat1(tc, 0, 5, tc.HP);
								end;
								if td.SP2 <> 0 then begin
									tc.SP := tc.SP + (td.SP1 + Random(td.SP2 - td.SP1 + 1)) * (100 + tc.Param[3]) div 100;

									//030316í«â¡ Cardinal
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
   WFIFOW( 0, $00b0); 
   WFIFOW( 2, $0018); 
   WFIFOL( 4, tc.Weight);
   Socket.SendBuf(buf, 8);

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
					2: //égópÉAÉCÉeÉÄ
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
							1: //ägëÂãæ
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
									if j <> 4 then begin //ñ¢ä”íËÉAÉCÉeÉÄÇ™Ç†ÇÈèÍçá
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
							3: //í±ÇÃâH
								begin
{NPCÉCÉxÉìÉgí«â¡}                                                       if tc.item[w].Amount <= 0 then exit;
									i := MapInfo.IndexOf(tc.Map);
									j := -1;
									if (i <> -1) then begin
										mi := MapInfo.Objects[i] as MapTbl;
										if (mi.noTele = true) then j := 0;
									end;
									if (j <> 0) then begin
{NPCÉCÉxÉìÉgí«â¡ÉRÉRÇ‹Ç≈}
									UseUsableItem(tc, w);

									b := 1;
									SendCLeave(tc, 0);
									tc.Map := tc.SaveMap;
									tc.Point := tc.SavePoint;
									MapMove(Socket, tc.Map, tc.Point);
{NPCÉCÉxÉìÉgí«â¡}
									end;
{NPCÉCÉxÉìÉgí«â¡ÉRÉRÇ‹Ç≈}
								end;
{éÅ{î†í«â¡}
							10: //å√ñÿÇÃé}
								begin
{ÉAÉWÉgã@î\í«â¡}
									if not mi.noBranch then begin
{ÉAÉWÉgã@î\í«â¡ÉRÉRÇ‹Ç≈}
									UseUsableItem(tc, w);

									if (SummonMobList.Count > 0) then begin
										tm := tc.MData;
										ts := TMob.Create;
										l := Random(SummonMobList.Count);
										tsmn := SummonMobList.Objects[l] as TSummon;
										str := tsmn.Name;
										ts.Data := MobDBName.Objects[MobDBName.IndexOf(str)] as TMobDB;
										ts.ID := NowMobID;
										Inc(NowMobID);

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
											ts.MVPDist[0].Dmg := ts.Data.HP * 30 div 100; //FAÇ…30%â¡éZ
										end;

										tm.Mob.AddObject(ts.ID, ts);
										tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);

										ts.isSummon := True;
                    ts.EmperiumID := 0;

										SendMData(tc.Socket, ts);
										//é¸àÕÇ…ëóêM
										SendBCmd(tm,ts.Point,41,tc,False);
										b := 1;
									end;
{ÉAÉWÉgã@î\í«â¡}
									end;
{ÉAÉWÉgã@î\í«â¡ÉRÉRÇ‹Ç≈}
								end;
							11,12,13,14: //ê¬î†ÅAéáî†ÅAÉJÅ[ÉhíüÅAÉvÉåî†
								begin
									UseUsableItem(tc, w);

									str := '';
									case td.Effect of
									11: //ê¬î†
										begin
											if (SummonIOBList.Count > 0) then begin
												l := Random(SummonIOBList.Count);
												tsmn := SummonIOBList.Objects[l] as TSummon;
												str := tsmn.Name;
											end;
										end;
									12: //éáî†
										begin
											if (SummonIOVList.Count > 0) then begin
												l := Random(SummonIOVList.Count);
												tsmn := SummonIOVList.Objects[l] as TSummon;
												str := tsmn.Name;
											end;
										end;
									13: //ÉJÅ[Éhíü
										begin
											if (SummonICAList.Count > 0) then begin
												l := Random(SummonICAList.Count);
												tsmn := SummonICAList.Objects[l] as TSummon;
												str := tsmn.Name;
											end;
										end;
									14: //ÉvÉåî†
										begin
											if (SummonIGBList.Count > 0) then begin
												l := Random(SummonIGBList.Count);
												tsmn := SummonIGBList.Objects[l] as TSummon;
												str := tsmn.Name;
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
													//ÉAÉCÉeÉÄí«â¡
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
													//èdó í«â¡
													tc.Weight := tc.Weight + cardinal(td.Weight);
													WFIFOW( 0, $00b0);
													WFIFOW( 2, $0018);
													WFIFOL( 4, tc.Weight);
													Socket.SendBuf(buf, 8);
													//ÉAÉCÉeÉÄÉQÉbÉgí ím
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
											//éÊìæé∏îs
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

									//ÉAÉCÉeÉÄÉäÉXÉgëóêM
									j := 4;

									for w1 := 0 to MaterialDB.Count-1 do begin
										e2 := 0;//e2Çêªë¢â¬î\Ç©ÇÃÉtÉâÉOÇ∆ÇµÇƒégÇ§
										tma := MaterialDB.Objects[w1] as TMaterialDB;

										case tma.RequireSkill of

										0,94,95,96://êØÇÃÇ©ÇØÇÁÅAäeéÌëÆê´êŒÇÃèÍçáÇÕégópÉAÉCÉeÉÄÇ™ónçzòFÇ©É`ÉFÉbÉN
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
										98,99,100,101,102,103,104://ïêäÌÇÃèÍçáÇÕégópÉAÉCÉeÉÄÇ™ÉåÉxÉãÇ…âûÇ∂ÇΩã‡í∆Ç©É`ÉFÉbÉN
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

                                                                                120: // ÉeÉCÉ~ÉìÉOÉAÉCÉeÉÄ
                                                                                        begin
                                                                                                tc.UseItemID := tc.Item[w].Data.ID;


Dec(tc.Item[w].Amount);
if tc.Item[w].Amount = 0 then tc.Item[w].ID := 0;
tc.Weight := tc.Weight - tc.Item[w].Data.Weight;

//èdó å∏è≠
WFIFOW( 0, $00b0);
WFIFOW( 2, $0018);
WFIFOL( 4, tc.Weight);
Socket.SendBuf(buf, 8);

// ÉAÉCÉeÉÄégópÉpÉPÉbÉgÇëóêM
WFIFOW( 0, $00a8);
WFIFOW( 2, w);
WFIFOW( 4, tc.Item[w].Amount);
WFIFOB( 6, 1);
{ê∏òBNPCã@î\í«â¡}
//ëïîıÉçÉbÉNÉ`ÉFÉbÉN
if tc.EqLock = true then continue;
{ê∏òBNPCã@î\í«â¡ÉRÉRÇ‹Ç≈}
Socket.SendBuf(buf, 7);

//ÉAÉCÉeÉÄêîå∏è≠
WFIFOW( 0, $00af);
WFIFOW( 2, w);
WFIFOW( 4, 1);
//Socket.SendBuf(buf,6);

b := 1;

// ÉÇÉìÉXÉ^Å[ëIëÉpÉPëóêM
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
{ÉLÉÖÅ[ÉyÉbÉgÇ±Ç±Ç‹Ç≈}
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
{ê∏òBNPCã@î\í«â¡}
				//ëïîıÉçÉbÉNÉ`ÉFÉbÉN
{ê∏òBNPCã@î\í«â¡ÉRÉRÇ‹Ç≈}
		$00a9: //ÉAÉCÉeÉÄëïîı
			begin
				if tc.EqLock = true then continue;
				RFIFOW(2, w1);
				RFIFOW(4, w2);
				//DebugOut.Lines.Add(Format('Index:%d EquipType:%d', [w1, w2]));
{èCê≥}
        // Colus, 20040304: Upper classes able to equip things now?
        i := tc.JID;
        if (i > UPPER_JOB_BEGIN) then i := i - UPPER_JOB_BEGIN + LOWER_JOB_END;
        // wjob := 1 shl tc.JID;
        wjob := Int64(1) shl i;
{èCê≥ÉRÉRÇ‹Ç≈}
				if (not DisableEquipLimit) and
					 ((tc.Item[w1].Identify = 0) or (tc.BaseLV < tc.Item[w1].Data.eLV) or
						((tc.Item[w1].Data.Gender <> 2) and (tc.Gender <> tc.Item[w1].Data.Gender)) or
						((tc.Item[w1].Data.Job and wjob) = 0)) then begin
					//ñ¢ä”íËÉAÉCÉeÉÄÇÕëïîıÇ≈Ç´Ç»Ç¢
					WFIFOW(0, $00aa);
					WFIFOW(2, w1);
					WFIFOW(4, 0);
					WFIFOB(6, 0);
					Socket.SendBuf(buf, 7);
					continue;
				end;

				if tc.Item[w1].Data.Loc = $88 then begin
					//ÉAÉNÉZÉTÉäópèàóù
					w := $88;
					j := 0;
					for i := 1 to 100 do begin //ëïîıâ”èäÇ™Ç†Ç¢ÇƒÇÈÇ©É`ÉFÉbÉN
						if (tc.Item[i].ID <> 0) and tc.Item[i].Data.IEquip then begin
							if (tc.Item[i].Equip = $8)	then begin w := (w and $80);				 end;
							if (tc.Item[i].Equip = $80) then begin w := (w and $8);	j := i; end;
						end;
					end;
					if w = 0 then begin //óºï˚ñÑÇ‹Ç¡ÇƒÇÈÇ∆Ç´ÇÕâEë§ÇÇÕÇ∏Ç∑
						WFIFOW(0, $00ac);
						WFIFOW(2, j);
						WFIFOW(4, tc.Item[j].Equip);
						tc.Item[j].Equip := 0;
						WFIFOB(6, 1);
						Socket.SendBuf(buf, 7);
						w := $80;
					end;
					if w = $88 then w := $8; //óºï˚Ç†Ç¢ÇƒÇÈÇ∆Ç´ÇÕç∂Ç…
					tc.Item[w1].Equip := w;

					WFIFOW(0, $00aa);
					WFIFOW(2, w1);
					WFIFOW(4, w);
					WFIFOB(6, 1);
					Socket.SendBuf(buf, 7);
				end else if (tc.Item[w1].Data.Loc = $2) and (tc.JID = 12) and (w2 = $22) then begin
					//ÉAÉTÉVÉììÒìÅó¨ópèàóù
					w := $22;
					j := 0;
					for i := 1 to 100 do begin //ëïîıâ”èäÇ™Ç†Ç¢ÇƒÇÈÇ©É`ÉFÉbÉN
						if (tc.Item[i].ID <> 0) and tc.Item[i].Data.IEquip then begin
							if (tc.Item[i].Equip = $2)	then begin w := (w and $20);				 end;
							if (tc.Item[i].Equip = $20) then begin w := (w and $2);	j := i; end;
							if (tc.Item[i].Equip = $22) then begin w := 0;					 j := i; end;
						end;
					end;
					if w = 0 then begin //óºï˚ñÑÇ‹Ç¡ÇƒÇÈÇ∆Ç´ÇÕâEë§Ç†ÇÈÇ¢ÇÕÉJÉ^Å[ÉãÇÇÕÇ∏Ç∑
						WFIFOW(0, $00ac);
						WFIFOW(2, j);
						WFIFOW(4, tc.Item[j].Equip);
						tc.Item[j].Equip := 0;
						WFIFOB(6, 1);
						Socket.SendBuf(buf, 7);
						w := $20;
					end;
					if w = $22 then w := $2; //óºï˚Ç†Ç¢ÇƒÇÈÇ∆Ç´ÇÕç∂Ç…
					tc.Item[w1].Equip := w;

					WFIFOW(0, $00aa);
					WFIFOW(2, w1);
					WFIFOW(4, w);
					WFIFOB(6, 1);
					Socket.SendBuf(buf, 7);
{ÉLÉÖÅ[ÉyÉbÉg}
                                // ÉyÉbÉgÉAÉNÉZÉTÉä
                                end else if tc.Item[w1].Data.Effect = 123 then begin

                                        if ( tc.PetData <> nil ) and ( tc.PetNPC <> nil ) then begin

                                                tpe := tc.PetData;
                                                tn := tc.PetNPC;

                                                if tc.Item[w1].Data.ID = tpe.Data.AcceID then begin

                                                        // ÉAÉCÉeÉÄå∏è≠
                                                        Dec(tc.Item[w1].Amount);
                                                        if tc.Item[w1].Amount = 0 then tc.Item[w1].ID := 0;
                                                        tc.Weight := tc.Weight - tc.Item[w1].Data.Weight;

                                                        //ÉAÉCÉeÉÄêîå∏è≠
                                                        WFIFOW( 0, $00af);
                                                        WFIFOW( 2, w1);
                                                        WFIFOW( 4, 1);
                                                        Socket.SendBuf( buf, 6 );

                                                        //èdó å∏è≠
                                                        WFIFOW( 0, $00b0);
                                                        WFIFOW( 2, $0018);
                                                        WFIFOL( 4, tc.Weight);
                                                        Socket.SendBuf(buf, 8);

                                                        if ( tpe.Accessory <> 0 ) and ( ItemDB.IndexOf( tpe.Accessory ) <> -1 ) then begin
                                                                td := ItemDB.IndexOfObject( tpe.Accessory ) as TItemDB;

                                                                if tc.MaxWeight >= tc.Weight + td.Weight then begin
                                                                        j := SearchCInventory(tc, td.ID, td.IEquip );
                                                                        if j <> 0 then begin
                                                                                //ÉAÉCÉeÉÄí«â¡
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
                                                                                //ÉAÉCÉeÉÄÉQÉbÉgí ím
                                                                                SendCGetItem(tc, j, 1);

                                                                                //èdó í«â¡
                                                                                tc.Weight := tc.Weight + td.Weight;
                                                                                WFIFOW( 0, $00b0);
                                                                                WFIFOW( 2, $0018);
                                                                                WFIFOL( 4, tc.Weight);
                                                                                Socket.SendBuf(buf, 8);
                                                                        end else begin
                                                                                //Ç±ÇÍà»è„Ç‡ÇƒÇ»Ç¢
                                                                                WFIFOW( 0, $00a0);
                                                                                WFIFOB(22, 1);
                                                                                Socket.SendBuf(buf, 23);
                                                                        end;
                                                                end else begin
                                                                        //èdó ÉIÅ[ÉoÅ[
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
{ÉLÉÖÅ[ÉyÉbÉgÇ±Ç±Ç‹Ç≈}
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
								//ëïîıâ”èäèdï°Ç…ÇÊÇËëïîıâèú
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

                                // Tumy
				CalcStat(tc);
{èCê≥}  SendCSkillList(tc);
        {Colus, 20040114: Moved sprite processing to SendCStat call}
{
                                        if (tc.Item[w1].Data.IType = 4) then begin

                                        WFIFOW(0, $01d7);
                                        WFIFOL(2, tc.ID);
                                        WFIFOB(6, 2);
                                        WFIFOW(7, tc.Item[w1].Data.id);
                                        WFIFOW(9, tc.Shield);
                                        Socket.SendBuf(buf, 11);
                                        end;
                                        if tc.Item[w1].Data.IType = 5 then begin 
                                           WFIFOW(0, $00c3);  // real packet is 01d7 not sand this pk
      WFIFOL(2, tc.ID); 
                              WFIFOB(6, 8); 
                              WFIFOB(7, tc.Item[w1].Data.view); 
                              Socket.SendBuf(buf, 8); 
                                        end;  }
            SendCStat(tc, true);
            // Tumy

         end;
		//--------------------------------------------------------------------------
		$00ab: //ÉAÉCÉeÉÄëïîıâèú
			begin
{ê∏òBNPCã@î\í«â¡}
				//ëïîıÉçÉbÉNÉ`ÉFÉbÉN
				if tc.EqLock = true then continue;
{ê∏òBNPCã@î\í«â¡ÉRÉRÇ‹Ç≈}
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
        {Colus, 20040114: Moved sprite processing to SendCStat call}
{                                if (tc.Item[w].Data.IType = 4) then begin
                                WFIFOW(0, $01d7);
                                WFIFOL(2, tc.ID);
                                WFIFOB(6, 2);
                                WFIFOW(7, 0);
                                WFIFOW(9, tc.Shield);
                                Socket.SendBuf(buf, 11);
                                end;
                                if (tc.Item[w].Data.IType = 5) then begin
                                WFIFOW(0, $00c3);
                                WFIFOL(2, tc.ID);
                                WFIFOB(6, 8);
                                WFIFOB(7, 0);
                                Socket.SendBuf(buf, 8);
                                end;
 }
            CalcStat(tc);
            SendCStat(tc, true);
            // Tumy

			end;
		//--------------------------------------------------------------------------
		$00b2: //ÉäÉXÉ^Å[ÉgÅAÉLÉÉÉâÉZÉåóvãÅ
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
		$00b8: //NPCâÔòbÇ≈ëIëéàÇëIëÇµÇΩ
			begin
				RFIFOL(2, l);
				if tc.TalkNPCID <> l then continue;
				RFIFOB(6, b);
				NPCScript(tc, b);
			end;
		//--------------------------------------------------------------------------
		$00b9: //NPCâÔòbÇ≈NEXTÇëIëÇµÇΩ
			begin
				RFIFOL(2, l);
				if tc.TalkNPCID <> l then continue;
				NPCScript(tc);
			end;
		//--------------------------------------------------------------------------
		$00bb: //ÉXÉeÅ[É^ÉXÉAÉbÉvóvãÅ
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
					WFIFOB(5, tc.ParamBase[w]);//èCê≥â”èä
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
		$00c1: //loginêlêîñ‚Ç¢çáÇÌÇπ
			begin
				WFIFOW(0, $00c2);
				WFIFOL(2, NowUsers);
				Socket.SendBuf(buf, 6);
			end;
		//--------------------------------------------------------------------------
		$00c5: //shop buy/sellëIë
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
      			 		WFIFOW(0, $00b0);
      					WFIFOW(2, $0018);
      					WFIFOL(4, tc.Weight);
      					Socket.SendBuf(buf, 8);
      					// Update zeny
      					WFIFOW(0, $00b1);
      					WFIFOW(2, $0014);
      					WFIFOL(4, tc.Zeny);
      					Socket.SendBuf(buf, 8);
      					// Send buy success message
      					WFIFOW(0, $00ca);
      					WFIFOB(2, 0);
      					Socket.SendBuf(buf, 3);
  						end else begin
                // This says something about no further processing (process time: not yet)?
  							//Ç±ÇÍà»è„Ç‡ÇƒÇ»Ç¢(éûÇÃèàóùÅFñ¢)
	  					end;
            end;
					end;
				end else begin
          // 'A cheating situation: Trying to buy from a nonexistent shop?'
					//ïsê≥Ç»èàóùÅiìXÇ…Ç»Ç¢Ç‡ÇÃÇîÉÇ®Ç§Ç∆ÇµÇΩÅj
					WFIFOW(0, $00ca);
					WFIFOB(2, 3);  // 'You have reached the maximum capacity' message?
					Socket.SendBuf(buf, 3);
				end;
			end;
		//--------------------------------------------------------------------------
		$00c9: //NPCÇÃÇ®ìXÇ…îÑÇÈ
			begin
				tm := tc.MData;
				tn := tm.NPC.IndexOfObject(tc.TalkNPCID) as TNPC;
				if (tn.Map <> tc.Map) or (abs(tn.Point.X - tc.Point.X) > 15)
															or (abs(tn.Point.Y - tc.Point.Y) > 15) then begin
					//éãäEÇÃäOÇÃNPCÇ…ÇÕîÑÇÍÇ»Ç¢
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
						//ÉAÉCÉeÉÄêîå∏è≠
						WFIFOW( 0, $00af);
						WFIFOW( 2, w1);
						WFIFOW( 4, w2);
						Socket.SendBuf(buf, 6);
						Dec(tc.Item[w1].Amount, w2);
						if tc.Item[w1].Amount = 0 then tc.Item[w1].ID := 0;
					end;
				end;
				//èdó çXêV
				WFIFOW(0, $00b0);
				WFIFOW(2, $0018);
				WFIFOL(4, tc.Weight);
				Socket.SendBuf(buf, 8);
				//èäéùã‡çXêV
				WFIFOW(0, $00b1);
				WFIFOW(2, $0014);
				WFIFOL(4, tc.Zeny);
				Socket.SendBuf(buf, 8);
				//éÊà¯Ç™Ç≈Ç´Ç‹ÇµÇΩ
				WFIFOW(0, $00cb);
				WFIFOB(2, 0);
				Socket.SendBuf(buf, 3);
			end;
		//--------------------------------------------------------------------------
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡}
		$00d5: //É`ÉÉÉbÉgÉãÅ[ÉÄçÏê¨
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

					tcr.MemberID[0] := tc.ID; //ÉIÅ[ÉiÅ[:0
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

        //É`ÉÉÉbÉgÉãÅ[ÉÄçÏê¨ê≥î€âûìö
				WFIFOW( 0, $00d6);
				WFIFOB( 2, i);         // 0:ê¨å˜ 1:é∏îs
				Socket.SendBuf(buf, 3);

        if i = 0 then begin
					//é¸ï”Ç…ÉpÉPëóêM
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
		$00d9: //É`ÉÉÉbÉgéQâ¡
			begin
				if (tc.ChatRoomID <> 0) then continue;
				RFIFOL(2, l);
				str := RFIFOS(6, 8);
				i := ChatRoomList.IndexOf(l);
				if (i <> -1) then begin
					tcr := ChatRoomList.Objects[i] as TChatRoom;
					k := -1;
					if (tcr.Pub = 0) and (tcr.Pass <> str) then begin
						//ÉpÉXÉèÅ[Éhä‘à·Ç¢
						k := 1;
					end else if (tcr.Users >= tcr.Limit) then begin
						//êlêîí¥âﬂ
						k := 0;
					end else begin
						//KickÉ`ÉFÉbÉN
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

					//êVÉÅÉìÉoÅ[ÇÃÉfÅ[É^í«â¡
					tcr.MemberID[tcr.Users] := tc.ID;
					tcr.MemberCID[tcr.Users] := tc.CID;
					tcr.MemberName[tcr.Users] := tc.Name;
					tcr.Users := tcr.Users + 1;
					tc.ChatRoomID := tcr.ID;

					//ÉãÅ[ÉÄì‡ÉÅÉìÉoÅ[Ç…êVãKéQâ¡é“í ím
					WFIFOW( 0, $00dc);
					WFIFOW( 2, tcr.Users);
					WFIFOS( 4, tc.Name, 24);
					SendCrCmd(tc, 28);

					//ÉãÅ[ÉÄì‡ÇÃä˘ë∂ÉÅÉìÉoÅ[ÉäÉXÉg
					WFIFOW( 0, $00db);
					w := 8 + tcr.Users * 28;
					WFIFOW( 2, w);
					WFIFOL( 4, tcr.ID);
					for j := 0 to tcr.Users -1 do begin
						WFIFOL( 8+j*28, j);
						WFIFOS( 12+j*28, tcr.MemberName[j], 24);
					end;
					Socket.SendBuf(buf, w);

					//É`ÉÉÉbÉgÉXÉeÅ[É^ÉXïœçXÇé¸àÕÇ…í ím
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
{NPCÉCÉxÉìÉgí«â¡}
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
{NPCÉCÉxÉìÉgí«â¡ÉRÉRÇ‹Ç≈}
				end;
			end;
		//--------------------------------------------------------------------------
		$00de: //É`ÉÉÉbÉgÉãÅ[ÉÄÇÃÉXÉeÅ[É^ÉXïœçX
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

						//ÉXÉeÅ[É^ÉXïœçXÉpÉPëóêM
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
		$00e0: //É`ÉÉÉbÉgÉãÅ[ÉÄÇÃÉIÅ[ÉiÅ[ïœçX
			begin
				str := RFIFOS(6, 24);
				i := ChatRoomList.IndexOf(tc.ChatRoomID);
				if (i <> -1) then begin
					//ÉÅÉìÉoÅ[åüçı
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
							//ÉIÅ[ÉiÅ[ïœçX
							tcr.MemberID[0] := tcr.MemberID[j];
							tcr.MemberID[j] := tc.ID;
							tcr.MemberCID[0] := tcr.MemberCID[j];
							tcr.MemberCID[j] := tc.CID;
							tcr.MemberName[j] := tc.Name;
							tcr.MemberName[0] := str;

							//ÉÅÉìÉoÅ[Ç…ïœçXí ím
							WFIFOW( 0, $00e1);
							WFIFOL( 2, j);
							WFIFOS( 6, tcr.MemberName[j], 24);
							SendCrCmd(tc, 30);
							WFIFOW( 0, $00e1);
							WFIFOL( 2, 0);
							WFIFOS( 6, tcr.MemberName[0], 24);
							SendCrCmd(tc, 30);

							//ÉIÅ[ÉiÅ[ïœçXÉ`ÉÉÉbÉgè¡ãé
							WFIFOW( 0, $00d8);
							WFIFOL( 2, tcr.ID);
							SendNCrCmd(tc.MData, tc.Point, 6, tc, true);

							//é¸ï”Ç…ÉIÅ[ÉiÅ[ïœçXí ím
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
		$00e2: //ÉÅÉìÉoÅ[kick
			begin
				str := RFIFOS(2, 24);
				i := ChatRoomList.IndexOf(tc.ChatRoomID);
				if (i <> -1) then begin
					//ÉÅÉìÉoÅ[åüçı
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
								//ÉÅÉìÉoÅ[çÌèú
								ChatRoomExit(tc1);
							end;
							//KickÉäÉXÉgÇ…í«â¡
							tcr.KickList.Add(tc1.CID);
						end;
					end;
				end;
			end;
		//--------------------------------------------------------------------------
		$00e3: //É`ÉÉÉbÉgÉãÅ[ÉÄî≤ÇØ
			begin
				ChatRoomExit(tc);
			end;
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡ÉRÉRÇ‹Ç≈}
{éÊà¯ã@î\í«â¡}
		//--------------------------------------------------------------------------
		$00e4: //éÊà¯óvêø
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
					//éÊà¯óvêøí ím
					WFIFOW(0, $00e5);
					WFIFOS(2, tc.Name, 24);
					tc1.Socket.SendBuf(buf, 26);
					continue;
				end;
				//éÊà¯óvêøÉGÉâÅ[
				WFIFOW(0, $00e7);
				WFIFOB(2, b);
				Socket.SendBuf(buf, 3);
			end;
		//--------------------------------------------------------------------------
		$00e6: //éÊà¯óvêøâûìö
			begin
				RFIFOB(2, b);
				tc1 := CharaPID.IndexOfObject(tc.PreDealID) as TChara;
				if (tc1 = nil) then begin
					//ëäéËÉLÉÉÉâïsë∂ç›
					tc.PreDealID := 0;
					WFIFOW(0, $00e7);
					WFIFOB(2, 1);
					Socket.SendBuf(buf, 3);
				end else if (b = 3) or (b = 4) then begin
					//óvêøï‘ìö(3=yes,4=no)
					tc.PreDealID := 0;
					tc1.PreDealID := 0;
					WFIFOW(0, $00e7);
					WFIFOB(2, b);
					Socket.SendBuf(buf, 3);
					tc1.Socket.SendBuf(buf, 3);
					//âºê›ëqå…çÏê¨
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
		$00e8: //ÉAÉCÉeÉÄí«â¡
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
				if (tdl.Mode[w1] <> 0) then continue;//ä˘Ç…OKçœ
				tc1 := CharaPID.IndexOfObject(tdl.UserID[w2]) as TChara;
				if (tc1 = nil) then continue;

				RFIFOW(2, w);
				RFIFOL(4, l);
				if (w <> 0) then begin
					//ÉAÉCÉeÉÄÉ`ÉFÉbÉN
					if (tc.Item[w].ID <> 0) and (tc.Item[w].Amount >= l) then begin
						td := tc.Item[w].Data;
						if (cardinal(td.Weight * l) > tc1.MaxWeight - tc1.Weight) then begin
							//ëäéËï˚èdó ÉIÅ[ÉoÅ[//100éÌóﬁà»è„É`ÉFÉbÉNñ¢çœ
							WFIFOW( 0, $00ea);
							WFIFOW( 2, w);
							WFIFOB( 4, 1);
							Socket.SendBuf(buf, 5);
						end else begin
							//âºê›ëqå…Ç…ÉAÉCÉeÉÄí«â¡
							tdl.ItemIdx[w1][tdl.Cnt[w1]] := w;
							tdl.Amount[w1][tdl.Cnt[w1]] := l;
							tdl.Cnt[w1] := tdl.Cnt[w1] + 1;
							//ÉAÉCÉeÉÄíÒé¶ê¨å˜ÉpÉP
							WFIFOW( 0, $00ea);
							WFIFOW( 2, w);
							WFIFOB( 4, 0);
							Socket.SendBuf(buf, 5);
							//ëäéËï˚Ç…ÉAÉCÉeÉÄíÒé¶ÉpÉP
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
					//É[ÉjÅ[É`ÉFÉbÉN
					if (tc.Zeny < l) then l := tc.Zeny;
					//âºê›ëqå…Ç…É[ÉjÅ[í«â¡
					tdl.Zeny[w1] := l;
					//ÉAÉCÉeÉÄíÒé¶ê¨å˜ÉpÉP
					WFIFOW( 0, $00ea);
					WFIFOW( 2, 0);
					WFIFOB( 4, 0);
					Socket.SendBuf(buf, 5);
					//É[ÉjÅ[íÒé¶ÉpÉP
					ZeroMemory(@buf[0], 19);
					WFIFOW( 0, $00e9);
					WFIFOL( 2, l);
					WFIFOB( 8, 1);
					tc1.Socket.SendBuf(buf, 19);
				end;
			end;
		//--------------------------------------------------------------------------
		$00eb: //ÉAÉCÉeÉÄí«â¡äÆóπ
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
				//í«â¡äÆóπÉpÉP
				WFIFOW(0, $00ec);
				WFIFOB(2, 0);
				Socket.SendBuf(buf, 3);
				WFIFOW(0, $00ec);
				WFIFOB(2, 1);
				tc1.Socket.SendBuf(buf, 3);
			end;
		//--------------------------------------------------------------------------
		$00ed: //éÊà¯ÉLÉÉÉìÉZÉã
			begin
				CancelDealings(tc);
			end;
		//--------------------------------------------------------------------------
		$00ef: //éÊà¯è≥ë¯
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
					continue;//OKñ¢çœ
				end else if (tdl.Mode[w1] = 1) then begin
					tdl.Mode[w1] := 2;
				end;
				if (tdl.Mode[w1] <> 2) or (tdl.Mode[w2] <> 2) then continue;//óºé“äÆóπë“Çø
				tc1 := CharaPID.IndexOfObject(tdl.UserID[w2]) as TChara;
				if (tc1 = nil) then continue;

				//ÉLÉÉÉâÇPÉAÉCÉeÉÄèàóù
				if (tdl.Cnt[w1] > 0) then begin
					for i := 0 to tdl.Cnt[w1] - 1 do begin
						w := tdl.ItemIdx[w1][i];
						if (tc.Item[w].ID <> 0) and (tc.Item[w].Amount > 0) then begin
							td := tc.Item[w].Data;
							//ëäéËÇ…ÉAÉCÉeÉÄí«â¡
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
							//ëäéËÇÃèdó ïœçX
							tc1.Weight := tc1.Weight + cardinal(td.Weight * tdl.Amount[w1][i]);
							//é©ï™ÇÃÉAÉCÉeÉÄçÌèú
							Dec(tc.Item[w].Amount, tdl.Amount[w1][i]);
							if (tc.Item[w].Amount = 0) then tc.Item[w].ID := 0;
							//é©ï™ÇÃèdó ïœçX
							tc.Weight := tc.Weight - cardinal(td.Weight * tdl.Amount[w1][i]);
						end;
					end;
				end;

				//ÉLÉÉÉâÇQÉAÉCÉeÉÄèàóù
				if (tdl.Cnt[w2] > 0) then begin
					for i := 0 to tdl.Cnt[w2] - 1 do begin
						w := tdl.ItemIdx[w2][i];
						if (tc1.Item[w].ID <> 0) and (tc1.Item[w].Amount > 0) then begin
							td := tc1.Item[w].Data;
							//ëäéËÇ…ÉAÉCÉeÉÄí«â¡
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
							//ëäéËÇÃèdó ïœçX
							tc.Weight := tc.Weight + cardinal(td.Weight * tdl.Amount[w2][i]);
							//é©ï™ÇÃÉAÉCÉeÉÄçÌèú
							Dec(tc1.Item[w].Amount, tdl.Amount[w2][i]);
							if (tc1.Item[w].Amount = 0) then tc1.Item[w].ID := 0;
							//é©ï™ÇÃèdó ïœçX
							tc1.Weight := tc1.Weight - cardinal(td.Weight * tdl.Amount[w2][i]);
						end;
					end;
				end;

				if (tdl.Zeny[w1] <> 0) or (tdl.Zeny[w2] <> 0) then begin
					//ÉLÉÉÉâÇPÇÃÉ[ÉjÅ[ïœçX
					tc.Zeny := tc.Zeny - tdl.Zeny[w1] + tdl.Zeny[w2];
					WFIFOW(0, $00b1);
					WFIFOW(2, $0014);
					WFIFOL(4, tc.Zeny);
					tc.Socket.SendBuf(buf, 8);
					//ÉLÉÉÉâÇQÇÃÉ[ÉjÅ[ïœçX
					tc1.Zeny := tc1.Zeny - tdl.Zeny[w2] + tdl.Zeny[w1];
					WFIFOW(0, $00b1);
					WFIFOW(2, $0014);
					WFIFOL(4, tc1.Zeny);
					tc1.Socket.SendBuf(buf, 8);
				end;

				//ÉLÉÉÉâÇPèdó çXêVÉpÉP
				WFIFOW(0, $00b0);
				WFIFOW(2, $0018);
				WFIFOL(4, tc.Weight);
				tc.Socket.SendBuf(buf, 8);
				//ÉLÉÉÉâÇQèdó çXêVÉpÉP
				WFIFOL(4, tc1.Weight);
				tc1.Socket.SendBuf(buf, 8);

				//éÊà¯äÆóπÉpÉP
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
{éÊà¯ã@î\í«â¡ÉRÉRÇ‹Ç≈}
		//--------------------------------------------------------------------------
		$00f3: //ëqå…Ç…ÉAÉCÉeÉÄï˙ÇËçûÇ›
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
				//ëqå…Ç…ÉAÉCÉeÉÄí«â¡
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
				//ÉpÉPëóêM
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
				//ëqå…ÉAÉCÉeÉÄêîïœçX
				Inc(tp.Kafra.Count);
				WFIFOW(0, $00f2);
				WFIFOW(2, tp.Kafra.Count);
				WFIFOW(4, 100);
				tc.Socket.SendBuf(buf, 6);
				//ÉAÉCÉeÉÄêîå∏è≠
				Dec(tc.Item[w1].Amount, w2);
				if tc.Item[w1].Amount = 0 then tc.Item[w1].ID := 0;
				WFIFOW( 0, $00af);
				WFIFOW( 2, w1);
				WFIFOW( 4, w2);
				Socket.SendBuf(buf, 6);
				//èdó ïœçX
				tc.Weight := tc.Weight - tc.Item[w1].Data.Weight * w2;
        Inc(tp.Kafra.Weight,(tc.Item[w1].Data.Weight * w2));
				WFIFOW( 0, $00b0);
				WFIFOW( 2, $0018);
				WFIFOL( 4, tc.Weight);
				Socket.SendBuf(buf, 8);
			end;
		//--------------------------------------------------------------------------
		$00f5: //ëqå…Ç©ÇÁÉAÉCÉeÉÄéÊÇËèoÇµ
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
					//èdó ÉIÅ[ÉoÅ[
					WFIFOW(0, $00ca);
					WFIFOB(2, 3);  //1=Ç®ã‡Ç™ë´ÇËÇ»Ç¢ 2=èdó ÉIÅ[ÉoÅ[ 3=ÉAÉCÉeÉÄç≈ëÂéÌóﬁêîÉIÅ[ÉoÅ[
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
		        		//ëqå…Ç©ÇÁÉAÉCÉeÉÄí«â¡
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
				        //ëqå…ÇÃÉAÉCÉeÉÄêîå∏è≠
			        	Dec(tp.Kafra.Item[w1].Amount, w2);
		        		if tp.Kafra.Item[w1].Amount = 0 then begin
                  tp.Kafra.Item[w1].ID := 0;
                  Dec(tp.Kafra.Count);
                end;
	        			WFIFOW( 0, $00f6);
        				WFIFOW( 2, w1);
				        WFIFOL( 4, l);
			        	Socket.SendBuf(buf, 8);
		        		//ëqå…ÉAÉCÉeÉÄêîïœçX
        				WFIFOW(0, $00f2);
				        WFIFOW(2, tp.Kafra.Count);
			        	WFIFOW(4, 100);
		        		tc.Socket.SendBuf(buf, 6);
	        			//èdó ïœçX
        				tc.Weight := tc.Weight + weight;
                                        Dec(tp.Kafra.Weight,weight);
			        	WFIFOW( 0, $00b0);
		        		WFIFOW( 2, $0018);
	        			WFIFOL( 4, tc.Weight);
        				Socket.SendBuf(buf, 8);
                                end;
			end;
		//--------------------------------------------------------------------------
		$00f7: //ëqå…ï¬Ç∂
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
						//ÉpÅ[ÉeÉBÅ[ñºÇ™èdï°ÇµÇƒÇÕÇ¢ÇØÇ»Ç¢
						tpa := TParty.Create;
						tpa.Name := str;
						tpa.EXPShare := 0;
						tpa.ITEMShare := 1;
						tpa.MemberID[0] := tc.CID; //ÉäÅ[É_:0
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

					//ÉpÅ[ÉeÉBÅ[çÏê¨ê≥î€âûìö
					WFIFOW( 0, $00fa);
					WFIFOB( 2, i);         // 1:ìØñºÅ` 2:ä˘Ç…Å`
					Socket.SendBuf(buf, 3);
				end;
				//DebugOut.Lines.Add(Format('PartyNameList.Count = %d', [PartyNameList.Count]));

			end;

		//--------------------------------------------------------------------------
		$00fc: //ÉpÅ[ÉeÉBÅ[ä©óU
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
		$00ff: //ÉpÅ[ÉeÉBÅ[ä©óUï‘ìö
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
		$0100: //ÉpÅ[ÉeÉBÅ[íEëﬁ
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
		$0102: //ÉpÅ[ÉeÉBÅ[ê›íËïœçX
			begin

				RFIFOW(2, w1);
				RFIFOW(4, w2);
				if (PartyNameList.IndexOf(tc.PartyName) <> -1) then begin
					tpa := PartyNameList.Objects[PartyNameList.IndexOf(tc.PartyName)] as TParty;

					//åˆïΩâ¬î\ÉåÉxÉãÇÃê›íËÇÕÇ±Ç±ÅBiniÇ≈ê›íËÇ≈Ç´ÇΩÇŸÇ§Ç™ï÷óòÇ©Ç»ÅH
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
		$0103: //ÉpÅ[ÉeÉBÅ[èúñº
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
		$0108: //ÉpÅ[ÉeÉBÅ[É`ÉÉÉbÉg
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
{ÉpÅ[ÉeÉBÅ[ã@î\í«â¡ÉRÉRÇ‹Ç≈}
		//--------------------------------------------------------------------------
		$0112: //ÉXÉLÉãÉåÉxÉãÉAÉbÉvóvãÅ
			begin
				RFIFOW(2, w);
{ÉMÉãÉhã@î\í«â¡}
				if (w >= 10000) then begin
					//ÉMÉãÉhÉXÉLÉã
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
{ÉMÉãÉhã@î\í«â¡ÉRÉRÇ‹Ç≈}
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
						//é∏îs
						WFIFOW(0, $010e);
						WFIFOW(2, w);
						WFIFOW(4, tc.Skill[w].Lv);
						WFIFOW(6, tc.Skill[w].Data.SP[tc.Skill[w].Lv]);
						WFIFOW(8, tc.Skill[w].Data.Range);
						if (tc.Skill[w].Lv < tc.Skill[w].Data.MasterLV) and (tc.SkillPoint > 0) then b := 1 else b := 0;
						WFIFOB(10, b);
						Socket.SendBuf(buf,11);
					end;
{ÉMÉãÉhã@î\í«â¡}
				end;
{ÉMÉãÉhã@î\í«â¡ÉRÉRÇ‹Ç≈}
			end;
		//--------------------------------------------------------------------------
		$0113: //É^Å[ÉQÉbÉgéwíËorèuéûî≠ìÆÉXÉLÉã
			begin
        // OK, you have to know what you're trying to cast first.  Is it
        // Cast Cancel?

        RFIFOW(4, w);

        //if ((tc.MMode <> 0) and (tc.MSkill <> 275)) then continue;   // <- Leave that in!
        //if ((tc.MMode = 0) and (tc.MTick > timeGetTime())) or (tc.MSkill = 277) then Continue;

				if (((tc.MMode <> 0) and (w <> 275)) or
            ((tc.MMode = 0) and ((tc.MTick > timeGetTime()) or (w = 275))) ) then continue;
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡}
				//ì¸é∫íÜÇÃÉXÉLÉãégópñ≥å¯
				if (tc.ChatRoomID <> 0) then continue;
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡ÉRÉRÇ‹Ç≈}
{òIìXÉXÉLÉãí«â¡}
				//òIìXíÜÇÃÉXÉLÉãégópñ≥å¯
				if (tc.VenderID <> 0) then continue;
{òIìXÉXÉLÉãí«â¡ÉRÉRÇ‹Ç≈}


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
{NPCÉCÉxÉìÉgí«â¡}
				i := MapInfo.IndexOf(tc.Map);
				j := -1;
				if (i <> -1) then begin
					mi := MapInfo.Objects[i] as MapTbl;
					if ((mi.noTele = true) or (mi.noPortal = true) or (tc.Option and 6 <> 0)) then j := 0;
				end;
				if (tc.MSkill = 26) and (j = 0) then continue;
{ÉAÉWÉgã@î\í«â¡ÉRÉRÇ‹Ç≈}
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
{èCê≥}	if (tc.ver2 = 9) and (tc.MUseLV > 30) then tc.MUseLV := tc.MUseLV - 30;
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
		$0116: //èÍèäéwíËÉXÉLÉã
			begin
				if tc.MMode <> 0 then continue;
        if (tc.MMode = 0) and (tc.MTick > timeGetTime()) then Continue;
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡}
				//ì¸é∫íÜÇÃÉXÉLÉãégópñ≥å¯
				if (tc.ChatRoomID <> 0) then continue;
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡ÉRÉRÇ‹Ç≈}
{òIìXÉXÉLÉãí«â¡}
				//òIìXíÜÇÃÉXÉLÉãégópñ≥å¯
				if (tc.VenderID <> 0) then continue;
{òIìXÉXÉLÉãí«â¡ÉRÉRÇ‹Ç≈}
{ÉAÉWÉgã@î\í«â¡}
				i := MapInfo.IndexOf(tc.Map);
				if (i <> -1) then begin
					mi := MapInfo.Objects[i] as MapTbl;
				end else begin
					mi := MapTbl.Create;
				end;
				if mi.noSkill then continue;
{ÉAÉWÉgã@î\í«â¡ÉRÉRÇ‹Ç≈}

				RFIFOW(2, tc.MUseLV);
				RFIFOW(4, tc.MSkill);
				RFIFOW(6, tc.MPoint.X);
				RFIFOW(8, tc.MPoint.Y);
				tc.MTarget := 0;

				if (tc.MSkill = 0) or (tc.MSkill > MAX_SKILL_NUMBER) then continue;
{ÉAÉWÉgã@î\í«â¡}
				if ((tc.MSkill = 27) and (mi.noTele or (tc.Option and 6 <> 0))) then continue;
{ÉAÉWÉgã@î\í«â¡ÉRÉRÇ‹Ç≈}
{èCê≥}	if (tc.ver2 = 9) and (tc.MUseLV > 30) then tc.MUseLV := tc.MUseLV - 30;
				if (tc.Skill[tc.MSkill].Lv >= tc.MUseLV) and (tc.MUseLV > 0) then begin
					tk := tc.Skill[tc.MSkill];
					tl := tc.Skill[tc.MSkill].Data;
					k := UseFieldSkill(tc,timeGetTime());
					if k <> 0 then SendSkillError(tc,k);
				end;
			end;
		//--------------------------------------------------------------------------
		$0118: //çUåÇÉLÉÉÉìÉZÉã
			begin
				if (tc.AMode = 1) or (tc.AMode = 2) then tc.AMode := 0;
				//DebugOut.Lines.Add(Format('3:%.8d AMode = %d', [tc.ID, tc.AMode]));
			end;
		//--------------------------------------------------------------------------
		$011b: //ÉeÉåÉ|orÉ|Å[É^ÉãèÍèäëIë
			begin
        if (tc.Sit <> 1) then begin
				tm := tc.MData;
				RFIFOW(2, w);
				if (w <> 26) and (w <> 27) then continue;
				str := RFIFOS(4, 16);

				if tc.SP < tc.Skill[w].Data.SP[tc.Skill[w].Lv] then begin
					//SPïsë´
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
					//èdó ÉIÅ[ÉoÅ[
					WFIFOW(0, $013b);
					WFIFOW(2, 2);
					Socket.SendBuf(buf, 4);
					continue;
				end;
				if (w = 26) then begin //ÉeÉåÉ|Å[Ég
					if (tc.Skill[26].Lv >= 1) and (str = 'Random') then begin //ÉâÉìÉ_ÉÄÉèÅ[Év
						//ç¿ïWà⁄ìÆ
						j := 0;
						repeat
							xy.X := Random(tm.Size.X - 2) + 1; //âÊñ í[ÇÃåÑä‘Ç…ÇÕîÚÇŒÇ»Ç¢ÇÊÇ§Ç…
							xy.Y := Random(tm.Size.Y - 2) + 1;
							Inc(j);
						until ( ((tm.gat[xy.X, xy.Y] <> 1) and (tm.gat[xy.X, xy.Y] <> 5)) or (j = 100) );
						if j = 100 then begin
							//îÚÇ◊Ç»Ç¢Ç∆Ç¢Ç§Ç±Ç∆ÇÕÇ»Ç¢Ç∆évÇ§ÇØÇ«àÍâûÅAÉtÉFÉCÉãÉZÅ[Ét
							WFIFOW( 0, $0110);
							WFIFOW( 2, 26);
							WFIFOW( 4, 0);
							WFIFOW( 6, 0);
							WFIFOB( 8, 0);
							WFIFOB( 9, 0);
							Socket.SendBuf(buf, 10);
							continue;
						end;
						//É}ÉbÉvà⁄ìÆ
						DecSP(tc, 26, tc.Skill[26].Lv);
                                                    tc.MMode := 0;
						SendCLeave(tc, 3);
						tc.Point := xy;
						MapMove(Socket, tc.Map, tc.Point);
					end else if (tc.Skill[26].Lv = 2) and (ChangeFileExt(str, '') = tc.SaveMap) then begin //ÉZÅ[ÉuèÍèäÇ÷ãAÇÈ
						DecSP(tc, 26, 2);
            tc.MMode := 0;
						SendCLeave(tc, 0);
						tc.Map := tc.SaveMap;
						tc.Point := tc.SavePoint;
						MapMove(Socket, tc.Map, tc.Point);
					end;
				end else begin //ÉèÅ[ÉvÉ|Å[É^Éã
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
					if j = -1 then continue; //ïsê≥ÉpÉPÉbÉg
					//ÉèÅ[ÉvÇ™ÉãÅ[ÉvÇµÇ»Ç¢Ç©Ç«Ç§Ç©É`ÉFÉbÉN
					if (tc.Map = ChangeFileExt(str, '')) and (tc.MPoint.X = xy.X) and (tc.MPoint.Y = xy.Y) then begin
						WFIFOW( 0, $0110);
						WFIFOW( 2, 27);
						WFIFOW( 4, 0);
						WFIFOW( 6, 0);
						WFIFOB( 8, 0);
						WFIFOB( 9, 3); //àÍâûÅAmemoñ≥ÇµÉGÉâÅ[ÇëóÇÈ
						Socket.SendBuf(buf, 10);
						continue;
					end;
					if tc.Skill[27].Data.UseItem <> 0 then begin
						//ÉAÉCÉeÉÄÉ`ÉFÉbÉN&è¡îÔ(ñ¢)
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
		$011d: //É|Å[É^ÉãÉÅÉÇ
			begin
				if tc.Skill[27].Lv < 2 then begin //ÉÅÉÇïsâ¬î\
					WFIFOW(0, $011e);
					WFIFOB(2, 1);
					Socket.SendBuf(buf, 3);
					continue;
				end;
				tm := tc.MData;
{NPCÉCÉxÉìÉgí«â¡}
				i := MapInfo.IndexOf(tc.Map);
				j := -1;
				if (i <> -1) then begin
					mi := MapInfo.Objects[i] as MapTbl;
					if (mi.noMemo = true) then j := 0;
				end;
				if (j = 0) then begin //ÉÅÉÇïsâ¬î\
					WFIFOW(0, $0189);
					WFIFOW(2, 1);
					Socket.SendBuf(buf, 4);
					continue;
				end;
{NPCÉCÉxÉìÉgí«â¡ÉRÉRÇ‹Ç≈}
				if (tm.gat[tc.Point.X][tc.Point.Y] = 1) or (tm.gat[tc.Point.X][tc.Point.Y] = 5) then begin //à⁄ìÆïsî\èÍèäÇÕÉÅÉÇïsâ¬
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
						//ÉÅÉÇê¨å˜
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
				//ÉÅÉÇê¨å˜
				WFIFOW(0, $011e);
				WFIFOB(2, 0);
				Socket.SendBuf(buf, 3);
				//DebugOut.Lines.Add(Format('Memo %d: %s (%d,%d)', [i, tc.Map, tc.Point.X, tc.Point.Y]));
				continue;
			end;
		//--------------------------------------------------------------------------
{ÉJÅ[Égã@î\í«â¡}
		$0126: //InventoryÇ©ÇÁÉJÅ[ÉgÇ…ÉAÉCÉeÉÄÇì¸ÇÍÇÈ
			begin
{òIìXÉXÉLÉãí«â¡}
				if(tc.VenderID <> 0) then continue;
{òIìXÉXÉLÉãí«â¡ÉRÉRÇ‹Ç≈}
				RFIFOW(2, w1);//inventoryì‡Ç≈ÇÃÉAÉCÉeÉÄID
				RFIFOL(4, l);//à⁄ìÆÇ≥ÇπÇÈå¬êî
				if l > 30000 then l := 30000;//è„å¿ÇÕ30000å¬Ç≈Ç†ÇÈ
				w2 := l;

				//éwíËÉAÉCÉeÉÄÇéùÇ¡ÇƒÇ¢Ç»Ç¢ÅAóvãÅÇ≥ÇÍÇΩà»è„ÇÃå¬êîÇèäéùÇµÇƒÇ¢Ç»ÇØÇÍÇŒèàóùÇ©ÇÁî≤ÇØÇÈ(ïsê≥ÉpÉPÉbÉgëŒçÙ)
				if (tc.Item[w1].ID = 0) or (tc.Item[w1].Amount < w2) then begin
					continue;
				end;

				//ÉJÅ[Égì‡ïîåüçı
				j := SearchInventory(tc.Cart, tc.Item[w1].ID, tc.Item[w1].Data.IEquip);

				//j = 0ÇÃÇ∆Ç´ÇÕç≈ëÂéÌóﬁêîÉIÅ[ÉoÅ[ÇÃÇÕÇ∏Ç»ÇÃÇ≈ÉGÉâÅ[ÉÅÉbÉZÅ[ÉWÇëóÇËèàóùÇ©ÇÁî≤ÇØÇÈ(ÉpÉPÉbÉgÇ…é©êgñ≥Çµ)
				if j = 0 then begin
					WFIFOW(0, $00ca);
					WFIFOB(2, 3);//2=èdó ÉIÅ[ÉoÅ[ 3=ÉAÉCÉeÉÄç≈ëÂéÌóﬁêîÉIÅ[ÉoÅ[
					Socket.SendBuf(buf, 3);
					continue;
				end;

				k := GetItemStore(tc.Cart,tc.Item[w1],w2);
				if k = 2 then begin
					//èdó ÉIÅ[ÉoÅ[ÇÃÉpÉPÉbÉgÇëóÇËÅAèàóùÇ©ÇÁî≤ÇØÇÈ
					WFIFOW(0, $012c);
					WFIFOB(2, 0);
					Socket.SendBuf(buf, 3);
					continue;
				end;
				//ëŒè€ÉAÉCÉeÉÄÇÃåªèäéùêîÇ∆çáÇÌÇπÇƒ30000å¬Çí¥Ç¶ÇÈÇ»ÇÁèàóùÇ©ÇÁî≤ÇØÇÈ(ñ{óàÇÃèàóùÇÕïsñæ)
				if k <> 0 then begin
						continue;
				end;

				//ÉJÅ[ÉgÇ…í«â¡Ç≥ÇÍÇΩÉAÉCÉeÉÄÇï\é¶Ç∑ÇÈÉpÉPÉbÉgÇëóêMÇ∑ÇÈ
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

				//ÉvÉåÉCÉÑÅ[Å[ÇÃInventoryì‡ÇÃÉAÉCÉeÉÄêîå∏è≠
				Dec(tc.Item[w1].Amount, w2);
				if tc.Item[w1].Amount = 0 then tc.Item[w1].ID := 0;
				WFIFOW( 0, $00af);
				WFIFOW( 2, w1);
				WFIFOW( 4, w2);
				Socket.SendBuf(buf, 6);

				//ÉvÉåÉCÉÑÅ[ÇÃèdó ïœçX
				tc.Weight := tc.Weight - tc.Item[w1].Data.Weight * w2;
				WFIFOW( 0, $00b0);
				WFIFOW( 2, $0018);
				WFIFOL( 4, tc.Weight);
				Socket.SendBuf(buf, 8);

				//ÉJÅ[Égèdó ÅAóeó ÉfÅ[É^ÇÃëóêM
				//0121 <num>.w <num limit>.w <weight>.l <weight limit>l
				WFIFOW(0, $0121);
				WFIFOW(2, tc.Cart.Count);
				WFIFOW(4, 100);
				WFIFOL(6, tc.Cart.Weight);
				WFIFOL(10, tc.Cart.MaxWeight);
				Socket.SendBuf(buf, 14);
			end;
{ÉJÅ[Égã@î\í«â¡ÉRÉRÇ‹Ç≈}
		//--------------------------------------------------------------------------
{ÉJÅ[Égã@î\í«â¡}
		$0127: //ÉJÅ[ÉgÇ©ÇÁInventoryÇ…ÉAÉCÉeÉÄéÊÇËèoÇµ
			begin
{òIìXÉXÉLÉãí«â¡}
				if(tc.VenderID <> 0) then continue;
{òIìXÉXÉLÉãí«â¡ÉRÉRÇ‹Ç≈}
				RFIFOW(2, w1);//inventoryì‡Ç≈ÇÃÉAÉCÉeÉÄID
				RFIFOL(4, l);//à⁄ìÆÇ≥ÇπÇÈå¬êî
				if l > 30000 then l := 30000;//è„å¿ÇÕ30000å¬Ç≈Ç†ÇÈ
				w2 := l;

				weight := tc.Cart.item[w1].Data.Weight * w2;//ÉJÅ[ÉgÇ©ÇÁéÊÇËèoÇ∑ÉAÉCÉeÉÄÇÃèdó 

				//èdó ÉIÅ[ÉoÅ[ÇÃèÍçáÇÕÉGÉâÅ[ÉÅÉbÉZÅ[ÉWÇëóÇ¡ÇƒèàóùÇî≤ÇØÇÈ

                                if longint(tc.MaxWeight) - longint(tc.Weight) < weight then begin // AlexKreuz: Integer Overflow Protection
					WFIFOW(0, $012c);
					WFIFOB(2, 0);
					Socket.SendBuf(buf, 3);
                                end

                                // AlexKreuz: User Overweight - Merchant Cart Protection
                                else begin

					//éwíËÉAÉCÉeÉÄÇéùÇ¡ÇƒÇ¢Ç»Ç¢ÅAèàóùÇ©ÇÁî≤ÇØÇÈ(ïsê≥ÉpÉPÉbÉgëŒçÙ)
					if (tc.Cart.item[w1].ID = 0) then begin
						continue;
					end;

					//Inventoryì‡åüçı
					j := SearchCInventory(tc, tc.Cart.item[w1].ID, tc.Cart.item[w1].Data.IEquip);
	
					//j = 0ÇÃÇ∆Ç´ÇÕç≈ëÂéÌóﬁêîÉIÅ[ÉoÅ[ÇÃÇÕÇ∏Ç»ÇÃÇ≈ÉGÉâÅ[ÉÅÉbÉZÅ[ÉWÇëóÇËèàóùÇ©ÇÁî≤ÇØÇÈ
					if j = 0 then begin
						WFIFOW(0, $00ca);
						WFIFOB(2, 3);//2=èdó ÉIÅ[ÉoÅ[ 3=ÉAÉCÉeÉÄç≈ëÂéÌóﬁêîÉIÅ[ÉoÅ[
						Socket.SendBuf(buf, 3);
						continue;
					end;
	
					//ëŒè€ÉAÉCÉeÉÄÇÃåªèäéùêîÇ∆çáÇÌÇπÇƒ30000å¬Çí¥Ç¶ÇÈÇ»ÇÁèàóùÇ©ÇÁî≤ÇØÇÈ(ñ{óàÇÃèàóùÇÕïsñæ)
					if tc.Item[j].Amount + w2 > 30000 then begin
						continue;
					end;
	
					//ÉJÅ[ÉgÇ©ÇÁInventoryÇ…ÉAÉCÉeÉÄí«â¡
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
	
					//ÉAÉCÉeÉÄéÊìæï\é¶
					SendCGetItem(tc, j, w2);
	
					//ÉJÅ[Égì‡ÇÃÉAÉCÉeÉÄêîå∏è≠
					Dec(tc.Cart.item[w1].Amount, w2);
	
					//ÉJÅ[ÉgÇÃèdó ïœçX
					tc.Cart.Weight := tc.Cart.Weight - weight;
	
					//èäéûêîÇ™0Ç…Ç»Ç¡ÇΩÇÁID 0Ç…ÇµÇƒÉJÅ[Égì‡ÉAÉCÉeÉÄéÌóﬁêîÇå∏ÇÁÇ∑
					if tc.Cart.item[w1].Amount = 0 then begin
						tc.Cart.item[w1].ID := 0;
						Dec(tc.Cart.Count);
					end;
	
					//ÉJÅ[Égì‡ÇÃëŒè€ÉAÉCÉeÉÄÇÃèäéùêîï\é¶ïœçX
					WFIFOW( 0, $0125);
					WFIFOW( 2, w1);
					WFIFOL( 4, l);
					Socket.SendBuf(buf, 8);

					//ÉJÅ[Égèdó ÅAóeó ÉfÅ[É^ÇÃëóêM
					WFIFOW(0, $0121);
					WFIFOW(2, tc.Cart.Count);
					WFIFOW(4, 100);
					WFIFOL(6, tc.Cart.Weight);
					WFIFOL(10, tc.Cart.MaxWeight);
					Socket.SendBuf(buf, 14);
	
					//ÉvÉåÉCÉÑÅ[ÇÃèdó ïœçX
					tc.Weight := tc.Weight + weight;
					WFIFOW( 0, $00b0);
					WFIFOW( 2, $0018);
					WFIFOL( 4, tc.Weight);
					Socket.SendBuf(buf, 8);
                                end;
			end;
{ÉJÅ[Égã@î\í«â¡ÉRÉRÇ‹Ç≈}
		//--------------------------------------------------------------------------
{ÉJÅ[Égã@î\í«â¡}
		$0128: //ëqå…Ç©ÇÁÉJÅ[ÉgÇ÷ÉAÉCÉeÉÄà⁄ìÆ
			begin
{òIìXÉXÉLÉãí«â¡}
				if(tc.VenderID <> 0) then continue;
{òIìXÉXÉLÉãí«â¡ÉRÉRÇ‹Ç≈}
				tp := tc.PData;

				RFIFOW(2, w1);//ëqå…ì‡Ç≈ÇÃëŒè€ÉAÉCÉeÉÄID
				RFIFOL(4, l);//à⁄ìÆÇ≥ÇπÇÈå¬êî

				if tp.Kafra.Item[w1].ID = 0 then Continue;
				if tp.Kafra.Item[w1].Amount < l then
					l := tp.Kafra.Item[w1].Amount;
				j := SearchInventory(tc.Cart, tp.Kafra.Item[w1].ID, tp.Kafra.Item[w1].Data.IEquip);

				//tp.Kafra.Weight := 80000;
				k := MoveItem(tc.Cart,tp.Kafra,w1,l);
				if k = -1 then Continue;
				if k = 2 then begin
					//èdó ÉIÅ[ÉoÅ[ÇÃÉpÉPÉbÉgÇëóÇËÅAèàóùÇ©ÇÁî≤ÇØÇÈ
					WFIFOW(0, $012c);
					WFIFOB(2, 0);
					Socket.SendBuf(buf, 3);
					continue;
				end else if k = 3 then begin
					WFIFOW(0, $00ca);
					WFIFOB(2, 3);	//1=Ç®ã‡Ç™ë´ÇËÇ»Ç¢ 2=èdó ÉIÅ[ÉoÅ[ 3=ÉAÉCÉeÉÄç≈ëÂéÌóﬁêîÉIÅ[ÉoÅ[
					Socket.SendBuf(buf, 3);
					continue;
				end;

			//ëqå…ì‡ÇÃëŒè€ÉAÉCÉeÉÄÇÃå¬êîïœçX
				WFIFOW( 0, $00f6);
				WFIFOW( 2, w1);
				WFIFOL( 4, l);
				Socket.SendBuf(buf, 8);

				//ëqå…ÉAÉCÉeÉÄêîïœçX
				WFIFOW(0, $00f2);
				WFIFOW(2, tp.Kafra.Count);
				WFIFOW(4, 100);
				tc.Socket.SendBuf(buf, 6);

				//ÉJÅ[ÉgÇ…í«â¡Ç≥ÇÍÇΩÉAÉCÉeÉÄÇÃï\é¶
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

				//ÉJÅ[Égèdó ÅAóeó ÉfÅ[É^ÇÃëóêM
				WFIFOW(0, $0121);
				WFIFOW(2, tc.Cart.Count);
				WFIFOW(4, 100);
				WFIFOL(6, tc.Cart.Weight);
				WFIFOL(10, tc.Cart.MaxWeight);
				Socket.SendBuf(buf, 14);

			end;
{ÉJÅ[Égã@î\í«â¡ÉRÉRÇ‹Ç≈}
		//--------------------------------------------------------------------------
{ÉJÅ[Égã@î\í«â¡}
		$0129: //ÉJÅ[ÉgÇ©ÇÁëqå…Ç÷ÉAÉCÉeÉÄà⁄ìÆ
			begin
{òIìXÉXÉLÉãí«â¡}
				if(tc.VenderID <> 0) then continue;
{òIìXÉXÉLÉãí«â¡ÉRÉRÇ‹Ç≈}
				tp := tc.PData;

				RFIFOW(2, w1);//ÉJÅ[Égì‡Ç≈ÇÃëŒè€ÉAÉCÉeÉÄID
				RFIFOL(4, l);//à⁄ìÆÇ≥ÇπÇÈå¬êî

				if tc.Cart.Item[w1].ID = 0 then Continue;
				if tc.Cart.Item[w1].Amount < l then
					l := tc.Cart.Item[w1].Amount;
				j := SearchInventory(tp.Kafra, tc.Cart.Item[w1].ID, tc.Cart.Item[w1].Data.IEquip);

				k := MoveItem(tp.Kafra,tc.Cart,w1,l);
				if k = -1 then Continue
				else if k = 3 then begin
					WFIFOW(0, $00ca);
					WFIFOB(2, 3);	//1=Ç®ã‡Ç™ë´ÇËÇ»Ç¢ 2=èdó ÉIÅ[ÉoÅ[ 3=ÉAÉCÉeÉÄç≈ëÂéÌóﬁêîÉIÅ[ÉoÅ[
					Socket.SendBuf(buf, 3);
					continue;
				end;

				//ÉJÅ[Égì‡ÇÃëŒè€ÉAÉCÉeÉÄÇÃèäéùêîï\é¶ïœçX
				WFIFOW( 0, $0125);
				WFIFOW( 2, w1);
				WFIFOL( 4, l);
				Socket.SendBuf(buf, 8);

				//ÉJÅ[Égèdó ÅAóeó ÉfÅ[É^ÇÃëóêM
				WFIFOW(0, $0121);
				WFIFOW(2, tc.Cart.Count);
				WFIFOW(4, 100);
				WFIFOL(6, tc.Cart.Weight);
				WFIFOL(10, tc.Cart.MaxWeight);
				Socket.SendBuf(buf, 14);

				//ëqå…í«â¡ÉAÉCÉeÉÄÇÃï\é¶
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

				//ëqå…ÉAÉCÉeÉÄêîïœçX
				WFIFOW(0, $00f2);
				WFIFOW(2, tp.Kafra.Count);
				WFIFOW(4, 100);
				tc.Socket.SendBuf(buf, 6);
			end;
{ÉJÅ[Égã@î\í«â¡ÉRÉRÇ‹Ç≈}
		//--------------------------------------------------------------------------
		$012a: //ëÈÅAÉyÉRÉyÉRÅAÉJÅ[ÉgÇäOÇ∑
			begin
				tc.Option := tc.Option and $F847;
				WFIFOW( 0, $0119);
				WFIFOL( 2, tc.ID);
				WFIFOW( 6, 0);
				WFIFOW( 8, 0);
				WFIFOW(10, tc.Option);
				WFIFOB(12, 0);
				SendBCmd(tc.MData, tc.Point, 13);
			end;
		//--------------------------------------------------------------------------
{òIìXÉXÉLÉãí«â¡}
		$012e: //òIìXï¬çΩ
			begin
				VenderExit(tc);
			end;
		//--------------------------------------------------------------------------
		$0130: //òIìXÉAÉCÉeÉÄÉäÉXÉg
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
		$0134: //òIìXÉAÉCÉeÉÄçwì¸
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

				//ÉAÉCÉeÉÄäiî[
				SetLength(ww, ((w - 8) div 4), 2);
				for i := 0 to (w - 8) div 4 - 1 do begin
					RFIFOW( 8+i*4, ww[i][0]);
					RFIFOW(10+i*4, ww[i][1]);
				end;

				//çwì¸ÉÅÉCÉì
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

					//çwì¸â¬î\Ç©É`ÉFÉbÉN
					td := tc1.Cart.Item[w2].Data;
					j := SearchCInventory(tc, td.ID, td.IEquip);
					if (tc.Zeny < tv.Price[w2] * w1) then begin
						b := 1;//èäéùã‡ïsë´
					end else if (tc.MaxWeight - tc.Weight < tv.Weight[w2] * w1) then begin
						b := 2;//èdó ÉIÅ[ÉoÅ[
					end else if (j = 0) then begin
						b := 2;//éÌóﬁÉIÅ[ÉoÅ[
					end else if (k = -1) then begin
						b := 3;//ÉCÉìÉfÉbÉNÉXïsê≥
					end;
					if (b <> 0) then begin
						break;
					end;

					//---òIìXë§èàóù---
					//ÉJÅ[ÉgÇÃêîó ïœçXPart1
					Dec(tc1.Cart.Item[w2].Amount, w1);
					//ÉJÅ[ÉgÇÃèdó ïœçX
					tc1.Cart.Weight := tc1.Cart.Weight - tv.Weight[k] * w1;
					//îÃîÑë§èäéùã‡ïœçX
					tc1.Zeny := tc1.Zeny + tv.Price[k] * w1;
					WFIFOW(0, $00b1);
					WFIFOW(2, $0014);
					WFIFOL(4, tc1.Zeny);
					tc1.Socket.SendBuf(buf, 8);
					//òIìXÉäÉXÉgÇÃêîó ïœçX
					Dec(tv.Amount[k], w1);
					//îÃîÑïÒçêÉpÉP
					WFIFOW(0, $0137);
					WFIFOW(2, w2);
					WFIFOW(4, w1);
					tc1.Socket.SendBuf(buf, 6);

					//---çwì¸ë§èàóù---
					//èäéùã‡çXêV
					tc.Zeny := tc.Zeny - tv.Price[k] * w1;
					WFIFOW(0, $00b1);
					WFIFOW(2, $0014);
					WFIFOL(4, tc.Zeny);
					Socket.SendBuf(buf, 8);
					//ÉAÉCÉeÉÄí«â¡
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
					//èdó çXêV
					tc.Weight := tc.Weight + tv.Weight[k] * w1;
					WFIFOW(0, $00b0);
					WFIFOW(2, $0018);
					WFIFOL(4, tc.Weight);
					Socket.SendBuf(buf, 8);

					//---ï€óØèàóùè¡âª---
					//ÉJÅ[ÉgÇÃêîó ïœçXPart2
					if (tc1.Cart.Item[w2].Amount = 0) then begin
						tc1.Cart.Item[w2].ID := 0;
						Dec(tc1.Cart.Count);
					end;
					//îÑÇËêÿÇÍèàóù
					if (tv.Amount[k] = 0) then begin
						tv.Idx[k] := 0;
						tv.Price[k] := 0;
						tv.Weight[k] := 0;
						tv.Cnt := tv.Cnt - 1;
					end;
				end;

				if (b <> 0) then begin
					//çwì¸ÉGÉâÅ[
					WFIFOW(0, $0135);
					WFIFOW(2, w2);
					WFIFOW(4, w1);
					WFIFOB(6, b);
					Socket.SendBuf(buf, 7);
				end else begin
					if tv.Cnt = 0 then begin
						//äÆîÑèàóù
						tc1.VenderID := 0;
						//ÉJÅ[ÉgÇÃèdó çXêVÉpÉP
						WFIFOW(0, $0121);
						WFIFOW(2, tc1.Cart.Count);
						WFIFOW(4, 100);
						WFIFOL(6, tc1.Cart.Weight);
						WFIFOL(10, tc1.Cart.MaxWeight);
						tc.Socket.SendBuf(buf, 14);
						//ä≈î¬è¡ãéÇé¸àÕÇ…í ím
						WFIFOW(0, $0132);
						WFIFOL(2, tv.ID);
						SendBCmd(tc1.MData, tc1.Point, 6, tc1);
						//òIìXÉäÉXÉgçÌèú
						//DebugOut.Lines.Add(Format('Vender(%s) was close / Remaining Vender(%d)', [tv.Title,VenderList.Count-1]));
						VenderList.Delete(VenderList.IndexOf(tv.ID));
						tv.Free;
					end;
				end;
			end;
{òIìXÉXÉLÉãí«â¡ÉRÉRÇ‹Ç≈}
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
							WFIFOW( 0, $00b0);
							WFIFOW( 2, $0018);
							WFIFOL( 4, tc.Weight);
							Socket.SendBuf(buf, 8);
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
					//ÉvÉåÉCÉÑÅ[ÇÃé¸àÕ9É}ÉXÇÃÇ«Ç±Ç©Ç…è¢ä“
					ts.Point.X := tc.Point.X + Random(2) - 1;
					ts.Point.Y := tc.Point.Y + Random(2) - 1;

					ts.Dir := Random(8);
					ts.HP := ts.Data.HP;
					ts.Speed := ts.Data.Speed;

					//ï¶Ç´ä‘äuÇã…ëÂÇ…ê›íË
					//Ç±Ç±ÇÕÇøÇÂÇ¡Ç∆èàóùÇ™ìKìñÇ©Ç»ÅH

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
						ts.MVPDist[0].Dmg := ts.Data.HP * 30 div 100; //FAÇ…30%â¡éZ
					end;
          ts.isSummon := True;
          ts.EmperiumID := 0;

					tm.Mob.AddObject(ts.ID, ts);
					tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);

					SendMData(tc.Socket, ts);
					//é¸àÕÇ…ëóêM
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
						ts1.MVPDist[0].Dmg := ts1.Data.HP * 30 div 100; //FAÇ…30%â¡éZ
					end;
					tm.Mob.AddObject(ts1.ID, ts1);
					tm.Block[ts1.Point.X div 8][ts1.Point.Y div 8].Mob.AddObject(ts1.ID, ts1);
					ts1.isSummon := true;
          ts1.isSlave := true;
          ts1.EmperiumID := 0;
          
					SendMData(tc.Socket, ts1);
					//é¸àÕÇ…ëóêM
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
		$0143: //NPCâÔòbÇ≈InputNumberì¸óÕ
			begin
				RFIFOL(2, l);
				if tc.TalkNPCID <> l then continue;
				RFIFOL(6, l);
				NPCScript(tc, l + 1);
			end;
		//--------------------------------------------------------------------------
		$0146: //NPCâÔòbÇ≈CLOSEÇëIëÇµÇΩ
			begin
				//RFIFOL(2, l);
				//if tc.TalkNPCID <> l then continue;
				tc.AMode := 0;
			end;
{ÉMÉãÉhã@î\í«â¡}
		$014d: //ÉMÉãÉhèÓïÒï\é¶äJén
			begin
				j := GuildList.IndexOf(tc.GuildID);
				if (j = -1) then continue;
				tg := GuildList.Objects[j] as TGuild;
				WFIFOW( 0, $014e);
				if (tg.MasterName = tc.Name) then begin
					WFIFOL( 2, $d7); //ÉMÉãÉhÉ}ÉXÉ^Å[
				end else begin
					WFIFOL( 2, $57); //àÍî 
				end;
				Socket.SendBuf(buf, 6);
			end;
		//--------------------------------------------------------------------------
		$014f: //ÉMÉãÉhï\é¶É^Éu
			begin
				RFIFOL(2, l);
				SendGuildInfo(tc, l);
			end;
		//--------------------------------------------------------------------------
		$0151: //ÉGÉìÉuÉåÉÄóvãÅ
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
		$0153: //ÉGÉìÉuÉåÉÄïœçX
			begin
				RFIFOW(2, w);
				if (w <= 4) then continue;
				j := GuildList.IndexOf(tc.GuildID);
				if (j = -1) then continue;
				tg := GuildList.Objects[j] as TGuild;
				if (tg.MasterName = tc.Name) then begin
					if (tg.Emblem > 0) then begin
						//åªç›ÇÃÉGÉìÉuÉåÉÄÇçÌèú
						str := AppPath + 'emblem\' + IntToStr(tg.ID) + '_' + IntToStr(tg.Emblem) + '.emb';
						if FileExists(str) then DeleteFile(str);
					end;

					//ÉGÉìÉuÉåÉÄçXêV
					Inc(tg.Emblem);
					SaveEmblem(tg, w - 4);
				end;
			end;
		//--------------------------------------------------------------------------
		$0155: //ÉMÉãÉhàıèÓïÒïœçX
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
					//ïœçXí ím
					WFIFOW( 0, $0156);
					SendGuildMCmd(tc, w);
				end;
			end;
		//--------------------------------------------------------------------------
		$0159: //ÉMÉãÉhíEëﬁ
			begin
				RFIFOL( 2, l);
				str := RFIFOS(14, 40);
				j := GuildList.IndexOf(tc.GuildID);
				if (j = -1) then continue;
				tg := GuildList.Objects[j] as TGuild;
				if (tg.ID <> l) then continue;

				if (tc.Name <> tg.MasterName) and (tg.RegUsers > 1) then begin
					//í ím
					WFIFOW( 0, $015a);
					WFIFOS( 2, tc.Name, 24);
					WFIFOS(26, str, 40);
					SendGuildMCmd(tc, 66);
					//ÉÅÉìÉoÅ[çÌèúèàóù
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
		$015b: //ÉMÉãÉhí«ï˙
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

				//í ím
				WFIFOW( 0, $015c);
				WFIFOS( 2, tc1.Name, 24);
				WFIFOS(26, str, 40);
				WFIFOS(66, tp1.Name, 24);
				SendGuildMCmd(tc, 90);
				//í«ï˙é“ÉäÉXÉgÇ…í«â¡
				tgb := TGBan.Create;
				tgb.Name := tc1.Name;
				tgb.AccName := tp1.Name;
				tgb.Reason := str;
				tg.GuildBanList.AddObject(tgb.Name, tgb);
				//ÉÅÉìÉoÅ[çÌèúèàóù
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
		$015d: //ÉMÉãÉhâéU
			begin
				str := RFIFOS(2, 24);
				j := GuildList.IndexOf(tc.GuildID);
				if (j = -1) then continue;
				tg := GuildList.Objects[j] as TGuild;
				if (tg.Name = str) and (tg.RegUsers = 1) and (tg.MasterName = tc.Name) then begin
					//í ím
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

					//ÉMÉãÉhçÌèúèàóù
					if UseSQL then DeleteGuildInfo(tc.GuildID);
					GuildList.Delete(GuildList.IndexOf(tc.GuildID));
					tc.GuildID := 0;
					tc.GuildName := '';
					tc.ClassName := '';
					tc.GuildPos := 0;
				end;
			end;
		//--------------------------------------------------------------------------
		$0161: //êEà èÓïÒïœçX
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
							l2 := 50;//50í¥ÇÕ1Ç≈ÇÕÇ»Ç≠50Ç…ê›íË
							WFIFOL(i * 40 + 8, l2);
						end;
						tg.PosEXP[l] := l2;
						tg.PosName[l] := RFIFOS(i * 40 + 20, 24);
						if UseSQL then SaveGuildMPosition(tg.ID, tg.PosName[l], tg.PosInvite[l], tg.PosPunish[l], tg.PosEXP[l], l);
					end;
					//ïœçXí ím
					WFIFOW( 0, $0174);
					SendGuildMCmd(tc, w, false);
				end;
			end;
		//--------------------------------------------------------------------------
		$0165: //ÉMÉãÉhçÏê¨
			begin
				RFIFOL(2, l);
				str := RFIFOS(6, 24);
				if (str = '') then continue;
        SendGuildInfo(tc,1,true,false);        
				//ÉGÉìÉyÉäÉEÉÄÉ`ÉFÉbÉN
				w := 0;
				i := 0;
				for j := 1 to 100 do begin
					if (tc.Item[j].ID = 714) then begin
						w := j;
						break;
					end;
				end;
				if (w = 0) then begin
					//ÉAÉCÉeÉÄïsë´
					i := 3;;
				end else if (tc.GuildID <> 0) then begin
					//ä˘Ç…ëºÉMÉãÉhÇ…â¡ì¸çœ
					i := 1;
				end else begin
					for j := 0 to GuildList.Count - 1 do begin
						tg := GuildList.Objects[j] as TGuild;
						if (tg.Name = str) then begin
							//ìØñºÉMÉãÉhë∂ç›
							i := 2;
							break;
						end;
					end;
				end;
				if (i <> 0) then begin
					//çÏê¨ÉGÉâÅ[
					WFIFOW( 0, $0167);
					WFIFOB( 2, i);
					Socket.SendBuf(buf, 3);
					continue;
				end;

				//ÉAÉCÉeÉÄå∏è≠
				Dec(tc.Item[w].Amount);
				if tc.Item[w].Amount = 0 then tc.Item[w].ID := 0;
				tc.Weight := tc.Weight - tc.Item[w].Data.Weight;
				WFIFOW( 0, $00af);
				WFIFOW( 2, w);
				WFIFOW( 4, 1);
				Socket.SendBuf(buf, 6);
				//èdó å∏è≠
				WFIFOW( 0, $00b0);
				WFIFOW( 2, $0018);
				WFIFOL( 4, tc.Weight);
				Socket.SendBuf(buf, 8);

				//ÉMÉãÉhçÏê¨
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

				//çÏê¨ê¨å˜âûìö
				WFIFOW( 0, $0167);
				WFIFOB( 2, 0);
				Socket.SendBuf(buf, 3);

        WFIFOW( 0, $016d);
        WFIFOL( 2, tc.ID);
        WFIFOL( 6, tc.CID);
        WFIFOL(10, 1);
        SendGuildMCmd(tc, 14);

        SendGLoginInfo(tg, tc);


        

				//ÉMÉãÉhèÓïÒëóêM
				
			end;
		//--------------------------------------------------------------------------
		$0168: //ÉMÉãÉhä©óU
			begin
				if (tc.GuildInv <> 0) then continue;//ëºÇ…ä©óUíÜ(éIÉLÉÉÉìñ¢ëŒâû)
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
		$016b: //ÉMÉãÉhä©óUâûìö
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
		$016e: //ÉMÉãÉhçêímê›íË
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
		$0170: //ÉMÉãÉhìØñøóvêø
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

				//ìØñøêîÉ`ÉFÉbÉN
				k := -1;
				if (tg.RelAlliance.IndexOf(tg1.Name) <> -1) then k := 0
				else if (tg.RelAlliance.Count >= 3) then k := 4
				else if (tg1.RelAlliance.Count >= 3) then k := 3;

				//ëóêM
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
		$0172: //ÉMÉãÉhìØñøóvêøâûìö
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

				//é©ï™ÇÃÉMÉãÉhÇÃìØñøêîÉ`ÉFÉbÉN
				k := -1;
				if (tg.RelAlliance.IndexOf(tg1.Name) <> -1) then k := 0
				else if (tg.RelAlliance.Count >= 3) then k := 4
				else if (tg1.RelAlliance.Count >= 3) then k := 3;

				if (l2 = 0) then begin
					//ãëî€
					k := 1;
				end else if (k = -1) then begin
					//è≥ë¯
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

				//ëóêM
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
{ÉMÉãÉhã@î\í«â¡ÉRÉRÇ‹Ç≈}
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		$0178: //ÉAÉCÉeÉÄä”íË
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


				//030316í«â¡ Cardinal
				if tc.Item[w].Amount <= 0 then tc.Item[w].ID := 0;
				tc.Weight := tc.Weight - tc.Item[w].Data.Weight;
				//ÉAÉCÉeÉÄêîå∏è≠
				WFIFOW( 0, $00af);
				WFIFOW( 2, w);
				WFIFOW( 4, 1);
				//èdó å∏è≠
				WFIFOW( 0, $00b0);
				WFIFOW( 2, $0018);
				WFIFOL( 4, tc.Weight);
				Socket.SendBuf(buf, 8);
        end;
			end;
		//--------------------------------------------------------------------------
		$017a: //ÉJÅ[ÉhWÉNÉäÉbÉN
			begin
				RFIFOW(2, w);
				if (w = 0) or (w > 100) or (tc.Item[w].ID = 0) or
					 (tc.Item[w].Amount = 0) or (tc.Item[w].Data.IType <> 6) then continue;
				td := tc.Item[w].Data;

				j := 4;
				for i := 1 to 100 do begin
					if (tc.Item[i].ID <> 0) and (tc.Item[i].Amount > 0) and (tc.Item[i].Data.IEquip) and
						 (tc.Item[i].Data.Slot > 0) and (tc.Item[i].Card[tc.Item[i].Data.Slot - 1] = 0) and
						 (tc.Item[i].Equip = 0) then begin // ÉXÉçÉbÉgÇéùÇ¡ÇƒÇ¢ÇƒÉXÉçÉbÉgÇÃç≈å„Ç™ñÑÇ‹Ç¡ÇƒÇ»ÇØÇÍÇŒ
						if td.Loc = 0 then begin
							//ïêäÌ
							if tc.Item[i].Data.IType = 4 then begin
								WFIFOW(j, i);
								j := j + 2;
							end;
						end else begin
							//ñhãÔ
							if (tc.Item[i].Data.IType = 5) and ((tc.Item[i].Data.Loc and td.Loc) <> 0) then begin
								WFIFOW(j, i);
								j := j + 2;
							end;
						end;
					end;
				end;

				if j <> 4 then begin //ë}ì¸â¬î\Ç»ÉAÉCÉeÉÄÇ™Ç†ÇÈèÍçá
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
					 (tc.Item[w2].Equip <> 0) then begin //ÉJÅ[ÉhÇÇ≥ÇπÇÈèÛë‘Ç≈Ç»Ç¢èÍçá
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

				//ÉJÅ[ÉhÇè¡Ç∑
				Dec(tc.Item[w1].Amount);
				WFIFOW( 0, $00a8);
				WFIFOW( 2, w1);
				WFIFOW( 4, tc.Item[w1].Amount);
				WFIFOB( 6, 1);
				Socket.SendBuf(buf, 7);
				//
				if tc.Item[w1].Amount = 0 then tc.Item[w1].ID := 0;
				tc.Weight := tc.Weight - tc.Item[w1].Data.Weight;
				//ÉAÉCÉeÉÄêîå∏è≠
				WFIFOW( 0, $00af);
				WFIFOW( 2, w1);
				WFIFOW( 4, 1);
				//èdó å∏è≠
				WFIFOW( 0, $00b0);
				WFIFOW( 2, $0018);
				WFIFOL( 4, tc.Weight);
				Socket.SendBuf(buf, 8);

				//ÉXÉçÉbÉgéwÇµÇΩÉAÉCÉeÉÄÇçƒì¸éË
				SendCGetItem(tc, w2, 1);
                                end;
{ÉMÉãÉhã@î\í«â¡}
		$017e: //ÉMÉãÉhÉ`ÉÉÉbÉg
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
		$0180: //ÉMÉãÉhìGëŒê›íË
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

				//ìØñøÉ`ÉFÉbÉN
				b := 0;
				if (tg.RelAlliance.IndexOf(tg1.Name) <> -1) then KillGuildRelation(tg, tg1, tc, tc1, 0);
				if (tg.RelHostility.IndexOf(tg1.Name) <> -1) then b := 2
				else if (tg.RelHostility.Count >= 3) then b := 1;

				if (b = 0) then begin
					//ìGëŒí«â¡
					tgl := TGRel.Create;
					tgl.ID := tg1.ID;
					tgl.GuildName := tg1.Name;
					tg.RelHostility.AddObject(tgl.GuildName, tgl);
					if UseSQL then SaveGuildAllyInfo(tgl.ID, tgl.GuildName, 2);

					//ÉpÉPëóêM
					WFIFOW( 0, $0185);
					WFIFOL( 2, 1);
					WFIFOL( 6, tg1.ID);
					WFIFOS(10, tg1.Name, 24);
					SendGuildMCmd(tc, 34);
				end;

				//ê≥î€ëóêM
				WFIFOW( 0, $0181);
				WFIFOB( 0, b);
				Socket.SendBuf(buf, 3);
			end;
		//--------------------------------------------------------------------------
		$0183: //ìØñøÅEìGëŒâè¡
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

				//âè¡
				KillGuildRelation(tg, tg1, tc, tc1, l2);
			end;
{ÉMÉãÉhã@î\í«â¡ÉRÉRÇ‹Ç≈}
		//--------------------------------------------------------------------------
			//end;
		//--------------------------------------------------------------------------
		$018a: //ÉQÅ[ÉÄèIóπ
			begin
				SendCLeave(Socket.Data, 2);

				WFIFOW(0, $018b);
				WFIFOW(2, 0);
				Socket.SendBuf(buf, 4);
			end;
		//--------------------------------------------------------------------------
{ÉAÉCÉeÉÄêªë¢í«â¡}
		$018e: //ÉAÉCÉeÉÄêªë¢
			begin
				RFIFOW(2, m1);//çÏÇËÇΩÇ¢ÉAÉCÉeÉÄÇÃID
				RFIFOW(4, m[0]);//ñÑÇﬂÇÈÇ‡ÇÃ1
				RFIFOW(6, m[1]);//ñÑÇﬂÇÈÇ‡ÇÃ2
				RFIFOW(8, m[2]);//ñÑÇﬂÇÈÇ‡ÇÃ3
				tm := tc.MData;
				w1 := 0;
				w2 := 0;
				anvil := 0;
				i := 1;//êªë¢ÇÃê≥î€îªíËÉtÉâÉOÇ∆ÇµÇƒäàóp

				if MaterialDB.IndexOf(m1) <> -1 then begin
					tma := MaterialDB.IndexOfObject(m1) as TMaterialDB;//çﬁóøÉfÅ[É^ÇÃåƒÇ—èoÇµ
					for j := 0 to 2 do begin
						if tma.MaterialID[j] = 0 then continue;
						e := SearchCInventory(tc, tma.MaterialID[j], false);
						if (e <> 0) and (tc.Item[e].Amount >= tma.MaterialAmount[j]) then begin

							//ÉAÉCÉeÉÄêîå∏è≠
							WFIFOW( 0, $00af);
							WFIFOW( 2, e);
							WFIFOW( 4, tma.MaterialAmount[j]);
			 				Socket.SendBuf(buf, 6);

							tc.Item[e].Amount := tc.Item[e].Amount - tma.MaterialAmount[j];
							if tc.Item[e].Amount = 0 then tc.Item[e].ID := 0;
							tc.Weight := tc.Weight - tc.Item[e].Data.Weight * tma.MaterialAmount[j];

							//èdó ïœçX
							WFIFOW( 0, $00b0);
							WFIFOW( 2, $0018);
							WFIFOL( 4, tc.Weight);
							Socket.SendBuf(buf, 8);

						end else begin

							i := 2;
							continue;

						end;
					end;

					//í«â¡Ç∑ÇÈëÆê´êŒÅAêØÇÃÇ©ÇØÇÁÇÃèàóù
					for k := 0 to 2 do begin

						e := SearchCInventory(tc, m[k], false);

						if (e <> 0) and (tc.Item[e].Amount <> 0) then begin

							tc.Item[e].Amount := tc.Item[e].Amount - 1;
							if tc.Item[e].Amount = 0 then tc.Item[e].ID := 0;
							tc.Weight := tc.Weight - tc.Item[e].Data.Weight;

							//èdó ïœçX
							WFIFOW( 0, $00b0);
							WFIFOW( 2, $0018);
							WFIFOL( 4, tc.Weight);
							Socket.SendBuf(buf, 8);

							case m[k] of

								994://âŒëÆê´êŒ(ê¨å˜ó¶25%É_ÉEÉì)
									begin
										w1 := w1 + $0003;
										w2 := w2 + 250;
									end;
								995://êÖëÆê´êŒ(ê¨å˜ó¶25%É_ÉEÉì)
									begin
										w1 := w1 + $0001;
										w2 := w2 + 250;
									end;
								996://ïóëÆê´êŒ(ê¨å˜ó¶25%É_ÉEÉì)
									begin
										w1 := w1 + $0004;
										w2 := w2 + 250;
									end;
								997://ìyëÆê´êŒ(ê¨å˜ó¶25%É_ÉEÉì)
									begin
										w1 := w1 + $0002;
										w2 := w2 + 250;
									end;
								1000://êØÇÃÇ©ÇØÇÁ(ê¨å˜ó¶15%É_ÉEÉì)
									begin
										w1 := w1 + $0500;
										w2 := w2 + 150;
									end;
							end;
						end;
					end;

					//ã‡ï~ÇÃèäéùÉ`ÉFÉbÉN

					e := SearchCInventory(tc, 987, false);//ÉIÉäÉfÉIÉRÉìã‡ï~(ê¨å˜ó¶3%ÉAÉbÉv)
						if (e <> 0) and (tc.Item[e].Amount <> 0) then begin
							anvil := 30;
						end;
					e := SearchCInventory(tc, 988, false);//â©ã‡ã‡ï~(ê¨å˜ó¶3%ÉAÉbÉv)
						if (e <> 0) and (tc.Item[e].Amount <> 0) then begin
							anvil := 50;
						end;
					e := SearchCInventory(tc, 989, false);//ÉGÉìÉyÉäÉEÉÄã‡ï~(ê¨å˜ó¶10%ÉAÉbÉv)
						if (e <> 0) and (tc.Item[e].Amount <> 0) then begin
							anvil := 100;
						end;

					if (i <> 2) then begin

						case m1 of
							994,995,996,997://ëÆê´êŒêªë¢(ê¨å˜ó¶ÇÕjobLv * 0.3 + DEX * 0.1 + LUK * 0.1 + ÉXÉLÉãï‚ê≥ + 15Ç∆âºíË)
								begin
									if (Random(1000) < (tc.JobLV * 3.5 + tc.Param[4] + tc.Param[5]) + tc.Skill[96].Data.Data1[tc.Skill[96].Lv] + 150 ) then i := 0;
								end;
							998://ìSêªë¢(ê¨å˜ó¶ÇÕjobLv * 0.3 + DEX * 0.1 + LUK * 0.1 + ÉXÉLÉãï‚ê≥ + 15 Ç∆âºíË)
							begin
									if (Random(1000) < (tc.JobLV * 3.5 + tc.Param[4] + tc.Param[5]) + tc.Skill[94].Data.Data1[tc.Skill[94].Lv] + 150) then i := 0;
								end;
							999://ç|ìSêªë¢(ê¨å˜ó¶ÇÕjobLv * 0.3 + DEX * 0.1 + LUK * 0.1 + ÉXÉLÉãï‚ê≥ + 15 Ç∆âºíË)
								begin
									if (Random(1000) < (tc.JobLV * 3.5 + tc.Param[4] + tc.Param[5]) + tc.Skill[95].Data.Data1[tc.Skill[95].Lv] + 150) then i := 0;
								end;
							1000://êØÇÃÇ©ÇØÇÁêªë¢(Ç©Ç»ÇÁÇ∏ê¨å˜Ç∆âºíË)
								begin
									i := 0;
								end;
							else begin//ïêäÌêªë¢(ê¨å˜ó¶ÇÕjobLv * 0.3 + DEX * 0.1 + LUK * 0.1 + ÉXÉLÉãï‚ê≥ + 15 Ç∆âºíË)
                // Colus, 20040224: Updated calculation for Pharmacy.  Not correct, but closer.
                // Like Steal, the exact formula is not known to anybody yet...
                // Some formulas given:
                //
                // LP◊3 + Pha◊2 + JobLv◊0.3 + Dex◊0.1 + Int◊0.05 + 10
                // LP◊1 + Pha◊3 + JobLv◊0.2 + Dex◊0.1 + Luk◊0.1 + 20
                // Pha◊4 + JobLv◊0.3 + Dex◊0.1 + Int◊0.05 + 20
                // LP + Pha * 3 + PP + JovLV * 0.5 + LUK * 0.1 + DEX * 0.1 + 5
                // LP + Pha◊3 + PP + Job◊0.2 + Dex◊0.1 + Luk◊0.05 + 15

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

					//ÉfÉoÉbÉOóp
					//i := 0;

					//äÆê¨ïiÇÃéÊìæèàóù
					//êªë¢Ç≈èdó Ç™ëùÇ¶ÇÈÇ±Ç∆ÇÕÇ†ÇËÇ¶Ç»Ç¢ÇÃÇ≈èdó É`ÉFÉbÉNÇÕÇµÇ»Ç¢
					//ñºëOÇÃï\é¶Ç…ÇÕCard[2]Ç∆Card[3]Ç…ÉLÉÉÉâÉNÉ^Å[å≈óLÇÃIDÇì¸ÇÍÇÈïKóvÇ™Ç†ÇÈÇØÇ«
					//0194ÉpÉPÉbÉgÇÃèàóùÇ™ñ¢é¿ëïÇÃÇΩÇﬂÇ∆ÇËÇ†Ç¶Ç∏ï˙íu

					if (i = 0) then begin

						td := ItemDB.IndexOfObject(m1) as TItemDB;
						k := SearchCInventory(tc, m1, td.IEquip);

						if k <> 0 then begin

							if tc.Item[k].Amount  >= 30000 then continue;

							if (td.IEquip = false) then begin
								//çzêŒóﬁÇÃèÍçá
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
								tc.Item[k].Card[0] := $00FF;//êªë¢ïêäÌÉtÉâÉO($00FFÇÃÇ∆Ç´êªë¢ïêäÌÇ∆îªíË)
								tc.Item[k].Card[1] := w1;//ïêäÌÇÃì¡ê´èÓïÒ($0500 * êØÇÃêî + ëÆê´î‘çÜ)
								tc.Item[k].Card[2] := e;//êªë¢é“èÓïÒ1
								tc.Item[k].Card[3] := e2;//êªë¢é“èÓïÒ2
								tc.Item[k].Data := td;
							end;

							//èdó í«â¡
							tc.Weight := tc.Weight + cardinal(td.Weight);
							WFIFOW( 0, $00b0);
							WFIFOW( 2, $0018);
							WFIFOL( 4, tc.Weight);
							Socket.SendBuf(buf, 8);

							//ÉAÉCÉeÉÄÉQÉbÉgí ím
							SendCGetItem(tc, k, 1);
						end;
					end;

					//êªë¢ÉGÉtÉFÉNÉgÉpÉPÉbÉgëóêM
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
{ÉAÉCÉeÉÄêªë¢í«â¡ÉRÉRÇ‹Ç≈}
		//--------------------------------------------------------------------------
{ÉAÉCÉeÉÄêªë¢í«â¡}
		$0193: //éwíËIDÇÃÉLÉÉÉâÅANPCÇÃñºëOÇóvãÅ
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
{ÉAÉCÉeÉÄêªë¢í«â¡ÉRÉRÇ‹Ç≈}
		//--------------------------------------------------------------------------
		$0197: //GMÉRÉ}ÉìÉh /resetstate /resetskill(è´óàìIÇ…ÇÕGMÉ`ÉFÉbÉNÇì¸ÇÍÇÈ)
			begin
                           {GMÇ©É`ÉFÉbÉN}
                           tp := tc.PData;
      h := IDTableDB.IndexOf(tc.ID);
      if (h <> -1) then begin
      tid := IDTableDB.Objects[h] as TIDTbl;

				RFIFOW(2, w);

				if (w = 0) and (tid.ChangeStatSkill = 1) then begin// Resetstate
					for i := 0 to 5 do begin
						tc.ParamBase[i] := 1;
					end;
					//Lv1éûÇÃäÓñ{É|ÉCÉìÉg48ÇÇ‹Ç∏ó^Ç¶ÇÈ
					tc.StatusPoint := 48;
					//åªç›ÉåÉxÉãÇ‹Ç≈ÇÃÉXÉeÅ[É^ÉXÉ|ÉCÉìÉgåvéZÇíÄàÍçsÇ§
					//Ç±Ç±ÇÕÇ‡Ç¡Ç∆è„éËÇ¢ï˚ñ@Ç™Ç†ÇÈÇ∆évÇ¢Ç‹Ç∑Ç™éÑÇ…ÇÕñ≥óù(;ÅLÑD`)
					for i := 1 to tc.BaseLV - 1 do begin
						tc.StatusPoint := tc.StatusPoint + i div 5 + 3;
				end;
          CalcStat(tc);
          SendCStat(tc);
					end;
					//äeéÌÉXÉeÅ[É^ÉXÇçƒåvéZÇµÅAÉNÉâÉCÉAÉìÉgÇ…ïœçXÇí ím
					CalcStat(tc);

				if (w = 1) and (tid.ChangeStatSkill = 1) then begin // ResetSkill
					for i := 2 to MAX_SKILL_NUMBER do begin
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
					end else if tc.JID < 7 then tc.SkillPoint := tc.JobLV -1
					else tc.SkillPoint := tc.JobLV -1 + 49;
					SendCSkillList(tc);
          CalcStat(tc);
          SendCStat(tc);
				end;
{í«â¡ÉRÉRÇ‹Ç≈}
				//if w = 1 then begin // ResetSkill(ÉXÉLÉãÉ|ÉCÉìÉgçƒï™îz)ÇÃèàóù

				//	//å∏ÇÁÇµÇΩÉ|ÉCÉìÉgãLò^ópÇ…jÇ0Ç…Ç∑ÇÈ
				//	j := 0;
				//	//ÉXÉLÉãÉåÉxÉãÇ0Ç…ÇµÅAå∏ÇÁÇµÇΩÉ|ÉCÉìÉgÇjÇ…â¡Ç¶ÇƒÇ¢Ç≠
				//	for i := 1 to 157 do begin
				//		if (tc.Skill[i].Lv <> 0) then begin
				//			j := j + tc.Skill[i].Lv;
				//			tc.Skill[i].Lv := 0;
				//		end;
				//	end;
				//		tc.SkillPoint := j;

				//	//ÉXÉLÉãëóêM
				//	//ÉXÉLÉãåvéZånÇÃä÷êîÇ™Ç≈Ç´ÇΩÇÁÇªÇ¡ÇøÇ…îÚÇŒÇ∑
				//	//åªç›ÇÕÉXÉLÉãÇëSïîê^Ç¡îíÇ…Ç∑ÇÈÇæÇØ

				//	WFIFOW( 0, $010f);
				//	WFIFOW( 2, 4);
				//	Socket.SendBuf(buf, 4);

				//	//ÉXÉLÉãÉ|ÉCÉìÉgÇÃïœçXÇí ím
				//	SendCStat(tc);
				//end;
                                               //ÉXÉLÉãÉ|ÉCÉìÉgÇÃïœçXÇí ím
						SendCStat(tc);
			end;
								end;
		//--------------------------------------------------------------------------
		$019d: //GMÉnÉCÉhÉRÉ}ÉìÉh
			begin    
                           {GMÇ©É`ÉFÉbÉN}
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
{ÉLÉÖÅ[ÉyÉbÉg}
                $019f: // ÉyÉbÉgÉeÉCÉ~ÉìÉO ÉXÉçÉbÉgí‚é~
                        begin
                                if( tc.UseItemID = 0 ) then continue;
                                
                                b := 0;
                                // l = ÉÇÉìÉXÉ^Å[ ID
                                RFIFOL( 2, l );
                                tm := tc.Mdata;
                                if tm.Mob.IndexOf( l ) <> -1 then begin
                                        ts := tm.Mob.IndexOfObject(l) as TMob;

                                        if PetDB.IndexOf( ts.JID ) <> -1 then begin
                                                tpd := PetDB.IndexOfObject( ts.JID ) as TPetDB;

                                                if( tc.UseItemID = tpd.ItemID ) then begin

                                                        // ïﬂäló¶ÅBLUK Ç∆Ç©Ç‡óçÇﬂÇÈÇ∆äyÇµÇ¢Ç©Ç‡ÅB
                                                        k := tpd.Capture;
                                                        //k := 1000;
                                                        if Random( 1000 ) < k then begin

                                                                b := 1;

                                                                // ÉÇÉìÉXè¡ñ≈
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

                                                                //É^Å[ÉQÉbÉgâèú
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

                                                                // åoå±ínÉäÉZÉbÉg
                                                                for i := 0 to 31 do begin
                                                                        ts.EXPDist[i].CData := nil;
                                                                        ts.EXPDist[i].Dmg := 0;
                                                                end;

                                                                // MVP ÉyÉbÉgÇ»ÇÒÇƒÇ¢Ç»Ç¢Ç∆évÇ§ÇØÇ«àÍâûÉäÉZÉbÉg
                                                                if ts.Data.MEXP <> 0 then begin
		                                                        for j := 0 to 31 do begin
			                                                        ts.MVPDist[j].CData := nil;
			                                                        ts.MVPDist[j].Dmg := 0;
		                                                        end;
	                                                        end;

                                                                //è¢ä“ÉÇÉìÉXÇÕè¡ñ≈
                                                                if ts.isSummon then begin
		                                                        i := tm.Mob.IndexOf(ts.ID);
		                                                        if i <> -1 then begin
		                                                                tm.Mob.Delete(i);
		                                                                ts.Free;
                                                                        end;
                                                                end;

                                                                td := ItemDB.IndexOfObject( tpd.EggID ) as TItemDB;

                                                                // óëälìæÉvÉçÉZÉX
                                                                // èdó îªíË
                                                                if tc.MaxWeight >= tc.Weight + td.Weight then begin
                                                                        j := SearchCInventory(tc, td.ID, td.IEquip );
					                                if j <> 0 then begin
						                                //ÉAÉCÉeÉÄí«â¡

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

						                                //èdó í«â¡
						                                tc.Weight := tc.Weight + td.Weight;
						                                WFIFOW( 0, $00b0);
						                                WFIFOW( 2, $0018);
																						WFIFOL( 4, tc.Weight);
						                                Socket.SendBuf(buf, 8);

						                                //ÉAÉCÉeÉÄÉQÉbÉgí ím
        					                                SendCGetItem(tc, j, 1);
					                                end else begin
                                                                                //Ç±ÇÍà»è„Ç‡ÇƒÇ»Ç¢
						                                WFIFOW( 0, $00a0);
						                                WFIFOB(22, 1);
						                                Socket.SendBuf(buf, 23);
                                                                        end;
                                                                end else begin
					                                //èdó ÉIÅ[ÉoÅ[
					                                WFIFOW( 0, $00a0);
					                                WFIFOB(22, 2);
					                                Socket.SendBuf(buf, 23);
				                                end;
                                                        end;
                                                end;
                                                tc.UseItemID := 0;
                                        end;
                                end;

                                // ê¨î€îªíË
                                WFIFOW( 0, $01a0 );
                                WFIFOB( 2, b );
                                Socket.SendBuf( buf, 3 );
                        end;

                //--------------------------------------------------------------------------
                $01a1: // ÉyÉbÉgÉÅÉjÉÖÅ[
                        begin
                                RFIFOB( 2, b );
                                tm := tc.MData;

                                if ( tc.PetData <> nil ) and ( tc.PetNPC <> nil ) then begin
                                        tpe := tc.PetData;
                                        tn := tc.PetNPC;

                                        case b of
                                                0: // ÉyÉbÉgÉXÉeÅ[É^ÉXï\é¶
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
                                                1: // ÉGÉTÇÇ†Ç∞ÇÈ
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

                                                                // ÉAÉCÉeÉÄå∏è≠
                                                                Dec(tc.Item[w].Amount);
                                                                if tc.Item[w].Amount = 0 then tc.Item[w].ID := 0;
				                                tc.Weight := tc.Weight - tc.Item[w].Data.Weight;

                                                                //ÉAÉCÉeÉÄêîå∏è≠
				                                WFIFOW( 0, $00af);
				                                WFIFOW( 2, w);
				                                WFIFOW( 4, 1);
                                                                Socket.SendBuf( buf, 6 );

				                                //èdó å∏è≠
				                                WFIFOW( 0, $00b0);
				                                WFIFOW( 2, $0018);
				                                WFIFOL( 4, tc.Weight);
				                                Socket.SendBuf(buf, 8);

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
																								2: // ÉpÉtÉHÅ[É}ÉìÉX
                                                begin
                                                        // êeñßìxÇ™çÇÇ¢ÇŸÇ«ÅAëΩÇ≠ÇÃÉAÉNÉVÉáÉìÇå©ÇπÇÈÇÊÇ§Ç…ÇµÇƒÇ›ÇÈ
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
                                                3: // óëÇ…ñﬂÇ∑
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
                                                                        //ÉyÉbÉgçÌèú
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
                                                4: // ÉAÉNÉZÉTÉäâèú
                                                begin
                                                        if tpe.Accessory <> 0 then begin

                                                                if ItemDB.IndexOf( tpe.Accessory ) <> -1 then begin
                                                                        td := ItemDB.IndexOfObject( tpe.Accessory ) as TItemDB;

                                                                        // èdó îªíË
                                                                        if tc.MaxWeight >= tc.Weight + td.Weight then begin
																																								j := SearchCInventory(tc, td.ID, td.IEquip );
                                                                                if j <> 0 then begin
                                                                                        //ÉAÉCÉeÉÄí«â¡
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

                                                                                        //ÉAÉCÉeÉÄÉQÉbÉgí ím
                                                                                        SendCGetItem(tc, j, 1);

                                                                                        //èdó í«â¡
                                                                                        tc.Weight := tc.Weight + td.Weight;
                                                                                        WFIFOW( 0, $00b0);
                                                                                        WFIFOW( 2, $0018);
                                                                                        WFIFOL( 4, tc.Weight);
                                                                                        Socket.SendBuf(buf, 8);
                                                                                end else begin
                                                                                        //Ç±ÇÍà»è„Ç‡ÇƒÇ»Ç¢
                                                                                        WFIFOW( 0, $00a0);
																																												WFIFOB(22, 1);
                                                                                        Socket.SendBuf(buf, 23);
                                                                                end;
                                                                        end else begin
                                                                                //èdó ÉIÅ[ÉoÅ[
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
                $01a5: // ÉyÉbÉgÇÃñºëOïœçX
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
                $01a7: // óëõzâªã@égópéû óëëIë
                        begin
                                // w = óëÇÃ index
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

				        //ÉAÉCÉeÉÄêîå∏è≠
				        WFIFOW( 0, $00af);
				        WFIFOW( 2, tc.UseItemID);
				        WFIFOW( 4, 1);

				        //èdó å∏è≠
				        WFIFOW( 0, $00b0);
				        WFIFOW( 2, $0018);
				        WFIFOL( 4, tc.Weight);
				        Socket.SendBuf(buf, 8);

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
                                                        if i <> -1 then begin
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
                                                WFIFOL( 7, 20 ); // ì‰
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
                $01a9: // ÉGÉÇÅ[ÉVÉáÉì
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
{ÉLÉÖÅ[ÉyÉbÉgÇ±Ç±Ç‹Ç≈}
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
									//ÉAÉCÉeÉÄí«â¡
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
									//èdó í«â¡
									tc.Weight := tc.Weight + cardinal(td.Weight * ma.CNum[i]);
									WFIFOW( 0, $00b0);
									WFIFOW( 2, $0018);
									WFIFOL( 4, tc.Weight);
									Socket.SendBuf(buf, 8);

									//ÉAÉCÉeÉÄÉQÉbÉgí ím
									SendCGetItem(tc, k, ma.CNum[i]);
                end;
								end;
							end else begin
								//èdó ÉIÅ[ÉoÅ[
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

								WFIFOW( 0, $00b0);
								WFIFOW( 2, $0018);
								WFIFOL( 4, tc.Weight);
								Socket.SendBuf(buf, 8);
      end;

		$01af: //ÉJÅ[ÉgÉ`ÉFÉìÉW
			begin
																tm := tc.MData;
				RFIFOW(2, w);
				case w of
					1: tc.Option := (tc.Option and $F877) or $0008; //ÉJÅ[Ég1
					2: tc.Option := (tc.Option and $F877) or $0080; //ÉJÅ[Ég2
					3: tc.Option := (tc.Option and $F877) or $0100; //ÉJÅ[Ég3
					4: tc.Option := (tc.Option and $F877) or $0200; //ÉJÅ[Ég4
					5: tc.Option := (tc.Option and $F877) or $0400; //ÉJÅ[Ég5
				end;
				//å©ÇΩñ⁄ïœçX
				WFIFOW(0, $0119);
				WFIFOL(2, tc.ID);
				WFIFOW(6, 0);
				WFIFOW(8, 0);
				WFIFOW(10, tc.Option);
				WFIFOB(12, 0);
				//SendBCmd(tc.MData, tc.Point, 13);
																SendBCmd(tm, tc.Point, 13);
					SendCStat(tc);

                        end;
		//--------------------------------------------------------------------------
{òIìXÉXÉLÉãí«â¡}
		$01b2: //òIìXäJê›
			begin
				//êEã∆ÅïÉXÉLÉãÉ`ÉFÉbÉN
				if (tc.JID <> 5) and (tc.JID <> 10) and (tc.JID <> 18) then continue;
				if (tc.Skill[41].Lv = 0) then continue;

				//ÉLÉÉÉìÉZÉãîªíË
				RFIFOB(84, b);//0=ÉLÉÉÉìÉZÉã,1=ÉIÅ[ÉvÉì
				if (b = 0) then continue;
				RFIFOW(2, w);
				if (w - 85 < 8) then continue;
				tv := TVender.Create;

				//òIìXèÓïÒê›íË
				tv.Title := RFIFOS(4, 80);//É^ÉCÉgÉã
				for j := 0 to (w - 85) div 8 - 1 do begin
					//IDÉ`ÉFÉbÉN
					RFIFOW(85+j*8, w1);
					if (tc.Cart.Item[w1].ID = 0) then begin
						exit;
					end;
					tv.Idx[j] := w1;
					//êîó É`ÉFÉbÉN
					RFIFOW(87+j*8, w2);
					if (w2 > tc.Cart.Item[w1].Amount) then begin
						w2 := tc.Cart.Item[w1].Amount;
					end;
					tv.Amount[j] := w2;
					//âøäiÉ`ÉFÉbÉN
					RFIFOL(89+j*8, l);//Price
					if (l > 10000000) then l := 10000000;//âøäiè„å¿(10M)
					tv.Price[j] := l;
					//èdó 
					td := tc.Cart.Item[w1].Data;
					tv.Weight[j] := td.Weight;
					tv.Cnt := tv.Cnt + 1;
				end;

				tv.ID := tc.ID;
				tv.CID := tc.CID;
				tc.VenderID := tv.ID;
				tv.MaxCnt := tv.Cnt;
				VenderList.AddObject(tv.ID, tv);

				//ÉJÅ[ÉgÇ©ÇÁÉAÉCÉeÉÄçÌèú
				for j := 0 to (w - 85) div 8 - 1 do begin
					WFIFOW( 0, $0125);
					WFIFOW( 2, tv.Idx[j]);
					WFIFOL( 4, tv.Amount[j]);
					Socket.SendBuf(buf, 8);
				end;

				//òIìXäJéní ím
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

				//é¸àÕÇ…ä≈î¬í ím
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
						//ÉpÅ[ÉeÉBÅ[ñºÇ™èdï°ÇµÇƒÇÕÇ¢ÇØÇ»Ç¢
						tpa := TParty.Create;
						tpa.Name := str;
						tpa.EXPShare := 0;
						tpa.ITEMShare := 1;
						tpa.MemberID[0] := tc.CID; //ÉäÅ[É_:0
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

					//ÉpÅ[ÉeÉBÅ[çÏê¨ê≥î€âûìö
					WFIFOW( 0, $00fa);
					WFIFOB( 2, i);         // 1:ìØñºÅ` 2:ä˘Ç…Å`
					Socket.SendBuf(buf, 3);
				end;
				//DebugOut.Lines.Add(Format('PartyNameList.Count = %d', [PartyNameList.Count]));

			end;
{òIìXÉXÉLÉãí«â¡ÉRÉRÇ‹Ç≈}
		end;
  end;
end;
//==============================================================================
end.
