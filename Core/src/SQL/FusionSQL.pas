unit FusionSQL;

interface

uses
        Windows, MMSystem, Forms, Classes, SysUtils, IniFiles, Common, DBXpress, DB, SqlExpr, StrUtils;

        function MySQL_Query(sqlcmd: String) : Boolean;
        function Assign_AccountID() : cardinal;
        function Load_Accounts(userid: String; AID: cardinal = 0) : Boolean;
        function Call_Characters(AID: cardinal) : Boolean;
        function Load_Characters(GID: cardinal) : Boolean;
        function Load_Parties(GID: cardinal) : Boolean;
        function Load_Pets(AID: cardinal) : Boolean;
        function Load_Guilds(GID: cardinal) : Boolean;
        function Preload_GuildMembers() : Boolean;

implementation

var
        SQLDataSet : TSQLDataSet;
        SQLConnection : TSQLConnection;

function MySQL_Query(sqlcmd: String) : Boolean;
begin
        Result := False;

        if not assigned(SQLConnection) then begin
                SQLConnection := TSQLConnection.Create(nil);
                SQLConnection.ConnectionName := 'MySQLConnection';
                SQLConnection.DriverName := 'MySQL';
                SQLConnection.GetDriverFunc := 'getSQLDriverMYSQL';
                SQLConnection.KeepConnection := True;
                SQLConnection.LibraryName := 'dbexpmysql.dll';
                SQLConnection.LoginPrompt := False;
                SQLConnection.VendorLib := 'libmysql.dll';
                SQLConnection.Params.Values['HostName'] := DbHost;
                SQLConnection.Params.Values['Database'] := DbName;
                SQLConnection.Params.Values['User_Name'] := DbUser;
                SQLConnection.Params.Values['Password'] := DbPass;
        end;

        if not SQLConnection.Connected then begin
                try
                        SQLConnection.Connected := True;
                except
                        DebugOut.Lines.Add('*** Error on MySQL Connect.');
                        Exit;
                end;
        end;

        if not assigned(SQLDataSet) then begin
                SQLDataSet := TSQLDataSet.Create(nil);
                SQLDataSet.SQLConnection := SQLConnection;
        end;

        if SQLDataSet.Active then SQLConnection.Close;

        SQLDataSet.CommandText := sqlcmd;

        if UpperCase(copy(SQLDataSet.CommandText,1,6)) <> 'SELECT' then begin
                try
                        SQLDataSet.ExecSQL;
		except
                        DebugOut.Lines.Add( Format( '*** Execute SQL Error: %s', [sqlcmd] ) );
                        exit;
                end;
                Result := True;
                Exit;
        end;

        try
                SQLDataSet.Open;
        except
                DebugOut.Lines.Add( Format( '*** Open SQL Data Error: %s', [sqlcmd] ) );
                exit;
        end;
        Result := True;
end;

function Assign_AccountID() : cardinal;
var
        query : string;
begin
        Result := 100101;
        query := 'SELECT AID FROM accounts ORDER BY AID DESC LIMIT 1';
        if MySQL_Query (query) then begin
                SQLDataSet.First;
                if SQLDataSet.Eof then exit;
                Result := strtoint(SQLDataSet.FieldValues['AID']) + 1;
        end;
end;

function Load_Accounts(userid: String; AID: cardinal = 0) : Boolean;
var
        tp : TPlayer;
        i : Integer;
        sl : TStringList;
        query : string;
begin
        Result := False;
        sl := TStringList.Create;
        sl.QuoteChar := '"';
        sl.Delimiter := ',';
        tp := TPlayer.Create;

        if AID = 0 then begin
                if (PlayerName.IndexOf(userid) <> -1) then begin
                        tp := PlayerName.Objects[PlayerName.IndexOf(userid)] as TPlayer;
                end else begin
                        tp := TPlayer.Create;
                end;
        end

        else begin
                if (assigned(PlayerName)) then begin
                        if (Player.IndexOf(AID) <> -1) then begin
                                Result := True;
                                Exit;
                        end;
                end;
        end;

        query := 'SELECT A.AID, A.ID, A.passwd, A.Gender, A.Mail, A.Banned, A.regDate, S.storeitem, S.money FROM accounts AS A LEFT JOIN storage AS S ON S.AID=A.AID WHERE A.ID = '+''''+userid+''''+' LIMIT 1';
        if MySQL_Query(query) then begin
                SQLDataSet.First;
                if not SQLDataSet.Eof then begin
                        tp.ID := StrToInt(SQLDataSet.FieldValues['AID']);
                        tp.Name := SQLDataSet.FieldValues['ID'];
                        tp.Pass := SQLDataSet.FieldValues['passwd'];
                        tp.Gender := SQLDataSet.FieldValues['Gender'];
                        tp.Mail := SQLDataSet.FieldValues['Mail'];
                        tp.Banned := StrToInt(SQLDataSet.FieldValues['Banned']);
                        tp.ver2 := 9;
                        if (SQLDataSet.FieldValues['storeitem'] <> '') then begin
                                with SQLDataSet do begin
                                        sl.Clear;
                                        sl.DelimitedText := SQLDataSet.FieldValues['storeitem'];

                                        for i := 0 to ((sl.Count div 10) - 1) do begin
                                                tp.Kafra.Item[i+1].ID := strtoint(sl.Strings[0+i*10]);
                                                tp.Kafra.Item[i+1].Amount := strtoint(sl.Strings[1+i*10]);
                                                tp.Kafra.Item[i+1].Equip := strtoint(sl.Strings[2+i*10]);
                                                tp.Kafra.Item[i+1].Identify := strtoint(sl.Strings[3+i*10]);
                                                tp.Kafra.Item[i+1].Refine := strtoint(sl.Strings[4+i*10]);
                                                tp.Kafra.Item[i+1].Attr := strtoint(sl.Strings[5+i*10]);
                                                tp.Kafra.Item[i+1].Card[0] := strtoint(sl.Strings[6+i*10]);
                                                tp.Kafra.Item[i+1].Card[1] := strtoint(sl.Strings[7+i*10]);
                                                tp.Kafra.Item[i+1].Card[2] := strtoint(sl.Strings[8+i*10]);
                                                tp.Kafra.Item[i+1].Card[3] := strtoint(sl.Strings[9+i*10]);
                                                tp.Kafra.Item[i+1].Data := ItemDB.Objects[ItemDB.IndexOf(tp.Kafra.Item[i+1].ID)] as TItemDB;
                                        end;
                                        sl.Free;
                                        CalcInventory(tp.Kafra);
                                end;
                        end;
                end;

                for i := 0 to 8 do begin
                        tp.CID[i] := 0;
                        tp.CName[i] := '';
                        tp.CData[i] := nil;
                end;

                if (AID = 0) then begin
                        if (PlayerName.IndexOf(userid) <> -1) then begin
                        end else begin
                                PlayerName.AddObject(tp.Name, tp);
                                Player.AddObject(tp.ID, tp);
                        end;
                end;

                Result := True;
        end;
end;

function Call_Characters(AID: cardinal) : Boolean;
var
        i : integer;
        tp : TPlayer;
        query : string;
begin
        Result := False;

        tp := Player.Objects[Player.IndexOf(AID)] as TPlayer;

        query := 'SELECT GID, Name, CharaNumber FROM characters WHERE AID='+''''+inttostr(AID)+''''+' LIMIT 9';
        if MySQL_Query(query) then begin
                while not SQLDataSet.Eof do begin
                        tp.CID[StrToInt(SQLDataSet.FieldValues['CharaNumber'])] := StrToInt(SQLDataSet.FieldValues['GID']);
                        SQLDataSet.Next;
                end;
        end else begin
                Exit;
        end;

        for i := 0 to 8 do begin
                if (tp.CID[i] <> 0) then begin
                        Load_Characters(tp.CID[i]);
                end;
        end;
        Result := True;
end;

function Load_Characters(GID: cardinal) : Boolean;
var
        i : integer;
        tc : TChara;
        ta : TMapList;
        tp  : TPlayer;
        tpa : TParty;
        sl  : TStringList;
        str : string;
        query : string;
        query2 : string;
        addkey : boolean;
begin
        sl := TStringList.Create;
        sl.QuoteChar := '"';
        sl.Delimiter := ',';

        Result := False;
        addkey := True;

        //DebugOut.Lines.Add(format('Load Character Data From MySQL: CharaID = %d', [GID]));

        query := 'SELECT C.*, M.*, S.skillInfo, I.equipItem, T.cartitem, V.flagdata FROM characters AS C LEFT JOIN warpmemo AS M ON (C.GID=M.GID) LEFT JOIN skills AS S ON (C.GID=S.GID) ';
        query2 := 'LEFT JOIN inventory AS I ON (I.GID=C.GID) LEFT JOIN cart AS T ON (T.GID=C.GID) LEFT JOIN character_flags AS V ON (V.GID=C.GID) WHERE C.GID='+''''+inttostr(GID)+''''+' LIMIT 1';

        if MySQL_Query(query+query2) then begin
                SQLDataSet.First;
                if not SQLDataSet.Eof then begin
                        tc := TChara.Create;
                        tc.CID := StrToInt(SQLDataSet.FieldValues['GID']);
                        tc.Name := SQLDataSet.FieldValues['Name'];
                        str := tc.Name;
                        if assigned (CharaName) then begin
                                if (CharaName.IndexOf(tc.Name) <> -1) then begin
                                        tc := CharaName.Objects[CharaName.IndexOf(str)] as TChara;
                                        addkey := False;
                                end;
                        end;
                        tc.JID := StrToInt(SQLDataSet.FieldValues['JID']);
                        if (tc.JID > LOWER_JOB_END) then tc.JID := tc.JID - LOWER_JOB_END + UPPER_JOB_BEGIN;
                        tc.BaseLV := StrToInt(SQLDataSet.FieldValues['BaseLV']);
                        tc.BaseEXP := StrToInt(SQLDataSet.FieldValues['BaseEXP']);
                        tc.StatusPoint := StrToInt(SQLDataSet.FieldValues['StatusPoint']);
                        tc.JobLV := StrToInt(SQLDataSet.FieldValues['JobLV']);
                        tc.JobEXP := StrToInt(SQLDataSet.FieldValues['JobEXP']);
                        tc.SkillPoint := StrToInt(SQLDataSet.FieldValues['SkillPoint']);
                        tc.Zeny := StrToInt(SQLDataSet.FieldValues['Zeny']);
                        tc.Stat1 := StrToInt(SQLDataSet.FieldValues['Stat1']);
                        tc.Stat2 := StrToInt(SQLDataSet.FieldValues['Stat2']);
                        tc.Option := StrToInt(SQLDataSet.FieldValues['Options']);
                        if tc.Option = 4 then tc.Option := 0;
                        tc.Karma := StrToInt(SQLDataSet.FieldValues['Karma']);
                        tc.Manner := StrToInt(SQLDataSet.FieldValues['Manner']);
                        tc.HP := StrToInt(SQLDataSet.FieldValues['HP']);
                        if (tc.HP < 0) then tc.HP := 0;
                        tc.SP := StrToInt(SQLDataSet.FieldValues['SP']);
                        tc.DefaultSpeed := StrToInt(SQLDataSet.FieldValues['DefaultSpeed']);
                        tc.Hair := StrToInt(SQLDataSet.FieldValues['Hair']);
                        tc._2 := StrToInt(SQLDataSet.FieldValues['_2']);
                        tc._3 := StrToInt(SQLDataSet.FieldValues['_3']);
                        tc.Weapon := StrToInt(SQLDataSet.FieldValues['Weapon']);
                        tc.Shield := StrToInt(SQLDataSet.FieldValues['Shield']);
                        tc.Head1 := StrToInt(SQLDataSet.FieldValues['Head1']);
                        tc.Head2 := StrToInt(SQLDataSet.FieldValues['Head2']);
                        tc.Head3 := StrToInt(SQLDataSet.FieldValues['Head3']);
                        tc.HairColor := StrToInt(SQLDataSet.FieldValues['HairColor']);
                        tc.ClothesColor := StrToInt(SQLDataSet.FieldValues['ClothesColor']);
                        tc.ParamBase[0] := StrToInt(SQLDataSet.FieldValues['STR']);
                        tc.ParamBase[1] := StrToInt(SQLDataSet.FieldValues['AGI']);
                        tc.ParamBase[2] := StrToInt(SQLDataSet.FieldValues['VIT']);
                        tc.ParamBase[3] := StrToInt(SQLDataSet.FieldValues['INTS']);
                        tc.ParamBase[4] := StrToInt(SQLDataSet.FieldValues['DEX']);
                        tc.ParamBase[5] := StrToInt(SQLDataSet.FieldValues['LUK']);
                        tc.CharaNumber := StrToInt(SQLDataSet.FieldValues['CharaNumber']);
                        tc.Map := (SQLDataSet.FieldValues['Map']);
                        tc.Point.X := StrToInt(SQLDataSet.FieldValues['X']);
                        tc.Point.Y := StrToInt(SQLDataSet.FieldValues['Y']);
                        tc.SaveMap := (SQLDataSet.FieldValues['SaveMap']);
                        tc.SavePoint.X := StrToInt(SQLDataSet.FieldValues['SX']);
                        tc.SavePoint.Y := StrToInt(SQLDataSet.FieldValues['SY']);
                        tc.Plag := StrToInt(SQLDataSet.FieldValues['Plag']);
                        tc.PLv := StrToInt(SQLDataSet.FieldValues['PLv']);
                        tc.PartyName := '';
                        tc.ID := StrToInt(SQLDataSet.FieldValues['AID']);

                        for i := 0 to 2 do begin
                                if (SQLDataSet.FieldByName('mapName' + inttostr(i)).IsNull) then continue;
                                tc.MemoMap[i] := (SQLDataSet.FieldValues['mapName' + IntToStr(i)]);
                                tc.MemoPoint[i].X := StrToInt(SQLDataSet.FieldValues['xPos' + IntToStr(i)]);
                                tc.MemoPoint[i].Y := StrToInt(SQLDataSet.FieldValues['yPos' + IntToStr(i)]);

                                if (tc.MemoMap[i] <> '') and (MapList.IndexOf(tc.MemoMap[i]) = -1) then begin
                                        DebugOut.Lines.Add(Format('%s : Invalid MemoMap%d "%s"', [tc.Name, i, tc.MemoMap[i]]));
                                        tc.MemoMap[i] := '';
                                        tc.MemoPoint[i].X := 0;
                                        tc.MemoPoint[i].Y := 0;
                                end else if (tc.MemoMap[i] <> '') then begin
                                        ta := MapList.Objects[MapList.IndexOf(tc.MemoMap[i])] as TMapList;
                                        if (tc.MemoPoint[i].X < 0) or (tc.MemoPoint[i].X >= ta.Size.X) or (tc.MemoPoint[i].Y < 0) or (tc.MemoPoint[i].Y >= ta.Size.Y) then begin
                                                DebugOut.Lines.Add(Format('%s : Invalid MemoMap%d Point "%s"[%dx%d] (%d,%d)', [tc.Name, i, tc.MemoMap[i], ta.Size.X, ta.Size.Y, tc.MemoPoint[i].X, tc.MemoPoint[i].Y]));
                                                tc.MemoMap[i] := '';
                                                tc.MemoPoint[i].X := 0;
                                                tc.MemoPoint[i].Y := 0;
                                        end;
                                end;
                        end;
                        if (tc.CID < 100001) then tc.CID := tc.CID + 100001;

                        if MapList.IndexOf(tc.Map) = -1 then begin
                                DebugOut.Lines.Add(Format('%s : Invalid Map "%s"', [tc.Name, tc.Map]));
                                tc.Map := 'prontera';
                                tc.Point.X := 158;
                                tc.Point.Y := 189;
                        end;

                        ta := MapList.Objects[MapList.IndexOf(tc.Map)] as TMapList;
                        if (tc.Point.X < 0) or (tc.Point.X >= ta.Size.X) or (tc.Point.Y < 0) or (tc.Point.Y >= ta.Size.Y) then begin
                                DebugOut.Lines.Add(Format('%s : Invalid Map Point "%s"[%dx%d] (%d,%d)',[tc.Name, tc.Map, ta.Size.X, ta.Size.Y, tc.Point.X, tc.Point.Y]));
                                tc.Map := 'prontera';
                                tc.Point.X := 158;
                                tc.Point.Y := 189;
                        end;

                        if MapList.IndexOf(tc.SaveMap) = -1 then begin
                                DebugOut.Lines.Add(Format('%s : Invalid SaveMap "%s"', [tc.Name, tc.SaveMap]));
                                tc.SaveMap := 'prontera';
                                tc.SavePoint.X := 158;
                                tc.SavePoint.Y := 189;
                        end;

                        ta := MapList.Objects[MapList.IndexOf(tc.SaveMap)] as TMapList;
                        if (tc.SavePoint.X < 0) or (tc.SavePoint.X >= ta.Size.X) or (tc.SavePoint.Y < 0) or (tc.SavePoint.Y >= ta.Size.Y) then begin
                                DebugOut.Lines.Add(Format('%s : Invalid SaveMap Point "%s"[%dx%d] (%d,%d)', [tc.Name, tc.SaveMap, ta.Size.X, ta.Size.Y, tc.SavePoint.X, tc.SavePoint.Y]));
                                tc.SaveMap := 'prontera';
                                tc.SavePoint.X := 158;
                                tc.SavePoint.Y := 189;
                        end;

                        for i := 0 to MAX_SKILL_NUMBER do begin
                                if SkillDB.IndexOf(i) <> -1 then begin
                                        tc.Skill[i].Data := SkillDB.IndexOfObject(i) as TSkillDB;
                                end;
                        end;

                        if (tc.Plag <> 0) then begin
                                tc.Skill[tc.Plag].Plag := true;
                        end;

                        sl.Clear;
                        sl.DelimitedText := SQLDataSet.FieldValues['skillInfo'];

                        for i := 0 to ((sl.Count div 2) - 1) do begin
                                if (SkillDB.IndexOf(strtoint(sl.Strings[0+i*2])) <> -1) then begin
                                        tc.Skill[strtoint(sl.Strings[0+i*2])].Lv := strtoint(sl.Strings[1+i*2]);
                                        tc.Skill[strtoint(sl.Strings[0+i*2])].Card := false;
                                        tc.Skill[strtoint(sl.Strings[0+i*2])].Plag := false;
                                end;
                        end;

                        sl.Clear;
                        sl.DelimitedText := SQLDataSet.FieldValues['equipItem'];

                        for i := 0 to ((sl.Count div 10) - 1) do begin
                                tc.Item[i+1].ID := strtoint(sl.Strings[0+i*10]);
                                tc.Item[i+1].Amount := strtoint(sl.Strings[1+i*10]);
                                tc.Item[i+1].Equip := strtoint(sl.Strings[2+i*10]);
                                tc.Item[i+1].Identify := strtoint(sl.Strings[3+i*10]);
                                tc.Item[i+1].Refine := strtoint(sl.Strings[4+i*10]);
                                tc.Item[i+1].Attr := strtoint(sl.Strings[5+i*10]);
                                tc.Item[i+1].Card[0] := strtoint(sl.Strings[6+i*10]);
                                tc.Item[i+1].Card[1] := strtoint(sl.Strings[7+i*10]);
                                tc.Item[i+1].Card[2] := strtoint(sl.Strings[8+i*10]);
                                tc.Item[i+1].Card[3] := strtoint(sl.Strings[9+i*10]);
                                tc.Item[i+1].Data := ItemDB.Objects[ItemDB.IndexOf(tc.Item[i+1].ID)] as TItemDB;
                        end;

                        sl.Clear;
                        sl.DelimitedText := SQLDataSet.FieldValues['cartitem'];

                        for i := 0 to ((sl.Count div 10) - 1) do begin
                                tc.Cart.Item[i+1].ID := strtoint(sl.Strings[0+i*10]);
                                tc.Cart.Item[i+1].Amount := strtoint(sl.Strings[1+i*10]);
                                tc.Cart.Item[i+1].Equip := strtoint(sl.Strings[2+i*10]);
                                tc.Cart.Item[i+1].Identify := strtoint(sl.Strings[3+i*10]);
                                tc.Cart.Item[i+1].Refine := strtoint(sl.Strings[4+i*10]);
                                tc.Cart.Item[i+1].Attr := strtoint(sl.Strings[5+i*10]);
                                tc.Cart.Item[i+1].Card[0] := strtoint(sl.Strings[6+i*10]);
                                tc.Cart.Item[i+1].Card[1] := strtoint(sl.Strings[7+i*10]);
                                tc.Cart.Item[i+1].Card[2] := strtoint(sl.Strings[8+i*10]);
                                tc.Cart.Item[i+1].Card[3] := strtoint(sl.Strings[9+i*10]);
                                tc.Cart.Item[i+1].Data := ItemDB.Objects[ItemDB.IndexOf(tc.Cart.Item[i+1].ID)] as TItemDB;
                        end;

                        sl.Clear;
                        sl.DelimitedText := SQLDataSet.FieldValues['flagdata'];

                        for i := 0 to (sl.Count - 1) do begin
                                tc.Flag.Add(sl.Strings[i]);
                        end;

                        if (addkey) then begin
                                CharaName.AddObject(tc.Name, tc);
                                Chara.AddObject(tc.CID, tc);
                        end;

                        Load_Accounts('', tc.ID);

                        if (Player.IndexOf(tc.ID) <> -1) then begin
                                tp := Player.Objects[Player.IndexOf(tc.ID)] as TPlayer;
                                tp.CID[tc.CharaNumber] := tc.CID;
                                tp.CName[tc.CharaNumber] := tc.Name;
                                tp.CData[tc.CharaNumber] := tc;
                                tp.CData[tc.CharaNumber].Gender := tp.Gender;
                        end;
                end;
        end;
        sl.Free;
end;

function Load_Parties(GID: cardinal) : Boolean;
var
        i, k : integer;
        query : string;
        tpa : TParty;
        tc : TChara;
        addkey : Boolean;
begin
        Result := False;
        addkey := True;

        query := 'SELECT * FROM party where MemberID0 = '+ '''' + inttostr(GID) + '''' + ' OR MemberID1= '+ '''' + inttostr(GID) + '''' + ' OR MemberID2 = '+ '''' + inttostr(GID) + '''' + ' OR MemberID3 = '+ '''' + inttostr(GID) + '''' + ' OR MemberID4 = '+ '''' + inttostr(GID) + '''' + ' OR MemberID5 = '+ '''' + inttostr(GID) + '''' + ' OR MemberID6 = '+ '''' + inttostr(GID) + '''' + ' OR MemberID7 = '+ '''' + inttostr(GID) + '''' + ' OR MemberID8 = '+ '''' + inttostr(GID) + '''' + ' OR MemberID9 = '+ '''' + inttostr(GID) + '''' + ' OR MemberID10 = '+ '''' + inttostr(GID) + '''' + ' OR MemberID11 = '+ '''' + inttostr(GID) + '''';
        if (MySQL_Query (query)) then begin
                if SQLDataSet.FieldByName('Name').IsNull then begin
                end else begin
                        tpa := TParty.Create;
                        with tpa do begin
                                Name := (SQLDataSet.FieldValues['Name']);
                                if assigned (PartyNameList) then begin
                                        if (PartyNameList.IndexOf(tpa.Name) <> -1) then begin
                                                tpa := PartyNameList.Objects[PartyNameList.IndexOf(tpa.Name)] as TParty;
                                                addkey := False;
                                        end;
                                end;
                                EXPShare := StrToInt(SQLDataSet.FieldValues['EXPShare']);
                                ITEMShare := StrToInt(SQLDataSet.FieldValues['ITEMShare']);
                                MemberID[0] := StrToInt(SQLDataSet.FieldValues['MemberID0']);
                                MemberID[1] := StrToInt(SQLDataSet.FieldValues['MemberID1']);
                                MemberID[2] := StrToInt(SQLDataSet.FieldValues['MemberID2']);
                                MemberID[3] := StrToInt(SQLDataSet.FieldValues['MemberID3']);
                                MemberID[4] := StrToInt(SQLDataSet.FieldValues['MemberID4']);
                                MemberID[5] := StrToInt(SQLDataSet.FieldValues['MemberID5']);
                                MemberID[6] := StrToInt(SQLDataSet.FieldValues['MemberID6']);
                                MemberID[7] := StrToInt(SQLDataSet.FieldValues['MemberID7']);
                                MemberID[8] := StrToInt(SQLDataSet.FieldValues['MemberID8']);
                                MemberID[9] := StrToInt(SQLDataSet.FieldValues['MemberID9']);
                                MemberID[10] := StrToInt(SQLDataSet.FieldValues['MemberID10']);
                                MemberID[11] := StrToInt(SQLDataSet.FieldValues['MemberID11']);
                        end;

                        if (addkey) then begin
                                PartyNameList.AddObject(tpa.Name, tpa);
                                DebugOut.Lines.Add(Format('Add Party Name : %s.', [tpa.Name]));
                        end;

                        tc := Chara.Objects[Chara.IndexOf(GID)] as TChara;
                        for i := 0 to 11 do begin
                                if (tpa.MemberID[i] <> 0) AND (tpa.MemberID[i] = tc.CID) then begin
                                        tpa := PartyNameList.Objects[PartyNameList.IndexOf(tpa.Name)] as TParty;
                                        tc.PartyName := tpa.Name;
                                        tpa.Member[i] := tc;
                                        break;
                                end;
                        end;
                end;
        end;

        Result := True;
end;

function Load_Pets(AID: cardinal) : Boolean;
var
        tpe : TPet;
        tp : TPlayer;
        tc : TChara;
        query : string;
        i : integer;
        addkey : Boolean;
begin
        Result := False;
        addkey := True;

        query := 'SELECT * FROM pet WHERE PlayerID = '' '+inttostr(AID)+'''';
        if (MySQL_Query(query)) then begin
                while not SQLDataSet.Eof do begin
                        i := PetDB.IndexOf(strtoint(SQLDataSet.FieldValues['JID']));
                        if (i <> -1) then begin
                                tpe := TPet.Create;
                                with tpe do begin
                                        if assigned (PetList) then begin
                                                if (PetList.IndexOf(StrToInt(SQLDataSet.FieldValues['PID'])) <> -1) then begin
                                                        tpe := PetList.Objects[PetList.IndexOf(StrToInt(SQLDataSet.FieldValues['PID']))] as TPet;
                                                        addkey := False;
                                                end;
                                        end;
                                        PlayerID := StrToInt(SQLDataSet.FieldValues['PlayerID']);
                                        CharaID := StrToInt(SQLDataSet.FieldValues['CharaID']);
                                        Cart := StrToInt(SQLDataSet.FieldValues['Cart']);
                                        Index := StrToInt(SQLDataSet.FieldValues['PIndex']);
                                        Incubated := StrToInt(SQLDataSet.FieldValues['Incubated']);
                                        PetID := StrToInt(SQLDataSet.FieldValues['PID']);
                                        JID := StrToInt(SQLDataSet.FieldValues['JID']);
                                        Name := (SQLDataSet.FieldValues['Name']);
                                        Renamed := StrToInt(SQLDataSet.FieldValues['Renamed']);
                                        LV := StrToInt(SQLDataSet.FieldValues['LV']);
                                        Relation := StrToInt(SQLDataSet.FieldValues['Relation']);
                                        Fullness := StrToInt(SQLDataSet.FieldValues['Fullness']);
                                        Accessory := StrToInt(SQLDataSet.FieldValues['Accessory']);
                                        Data := PetDB.Objects[i] as TPetDB;
                                end;

                                if (addkey) then begin
                                        PetList.AddObject(tpe.PetID, tpe);
                                end;

                                if (tpe.PlayerID <> 0) then begin
                                        if (tpe.CharaID = 0) then begin
                                                try
                                                        tp := Player.IndexOfObject(tpe.PlayerID) as TPlayer;
                                                        with tp.Kafra.Item[tpe.Index] do begin
                                                                Attr := 0;
                                                                Card[0] := $FF00;
                                                                Card[2] := tpe.PetID mod $10000;
                                                                Card[3] := tpe.PetID div $10000;
                                                        end;
                                                except
                                                end;
                                        end else begin
                                                tc := Chara.IndexOfObject(tpe.CharaID) as TChara;
                                                if tpe.Cart = 0 then begin
                                                        try
                                                                with tc.Item[tpe.Index] do begin
                                                                        Attr := tpe.Incubated;
                                                                        Card[0] := $FF00;
                                                                        Card[2] := tpe.PetID mod $10000;
                                                                        Card[3] := tpe.PetID div $10000;
                                                                end;
                                                        except
                                                        end;
                                                end else begin
                                                        try
                                                                with tc.Cart.Item[tpe.Index] do begin
                                                                        Attr := 0;
                                                                        Card[0] := $FF00;
                                                                        Card[2] := tpe.PetID mod $10000;
                                                                        Card[3] := tpe.PetID div $10000;
                                                                end;
                                                        except
                                                        end;
                                                end;
                                        end;
                                end;

                        end;
                        SQLDataSet.Next;
                end;
        end else begin
                DebugOut.Lines.Add('Pet data loading error...');
                Exit;
        end;

        Result := True;
end;

function Load_Guilds(GID: cardinal) : Boolean;
var
        query : string;
        tc : TChara;
        tg : TGuild;
	tgb : TGBan;
	tgl : TGRel;
        i, j : integer;
        sl : TStringList;
        guildkey : Boolean;
        addkey : Boolean;
begin
	sl := TStringList.Create;
	sl.QuoteChar := '"';
	sl.Delimiter := ',';
        
        Result := False;
        guildkey := False;
        addkey := True;

        query := 'SELECT G.*, M.* FROM guild_info AS G LEFT JOIN guild_members AS M ON (G.GDID=M.GDID) WHERE M.GID = '''+inttostr(GID)+''' LIMIT 1';
        if (MySQL_Query(query)) then begin
                while not SQLDataSet.Eof do begin
                        guildkey := True;
                        tg := TGuild.Create;
                        with tg do begin
                                ID := StrToInt(SQLDataSet.FieldValues['GDID']);
                                if assigned (GuildList) then begin
                                        if (GuildList.IndexOf(tg.ID) <> -1) then begin
                                                tg := GuildList.Objects[GuildList.IndexOf(tg.ID)] as TGuild;
                                                addkey := False;
                                        end;
                                end;
                                if (ID > NowGuildID) then NowGuildID := ID;
                                Name := (SQLDataSet.FieldValues['Name']);
                                LV := StrToInt(SQLDataSet.FieldValues['LV']);
                                EXP := StrToInt(SQLDataSet.FieldValues['EXP']);
                                GSkillPoint := StrToInt(SQLDataSet.FieldValues['GSkillPoint']);
                                Notice[0] := (SQLDataSet.FieldValues['Subject']);
                                Notice[1] := (SQLDataSet.FieldValues['Notice']);
                                Agit := (SQLDataSet.FieldValues['Agit']);
                                Emblem := StrToInt(SQLDataSet.FieldValues['Emblem']);
                                Present := StrToInt(SQLDataSet.FieldValues['Present']);
                                DisposFV := StrToInt(SQLDataSet.FieldValues['DisposFV']);
                                DisposRW := StrToInt(SQLDataSet.FieldValues['DisposRW']);

                                for i := 10000 to 10004 do begin
                                        if (GSkillDB.IndexOf(i) <> -1) then begin
                                                GSkill[i].Data := GSkillDB.IndexOfObject(i) as TSkillDB;
                                        end;
                                end;

                                sl.Clear;
                                sl.DelimitedText := SQLDataSet.FieldValues['skill'];

                                for i := 0 to ((sl.Count div 2) - 1) do begin
                                        if (GSkillDB.IndexOf(strtoint(sl.Strings[0+i*2])) <> -1) then begin
                                                GSkill[strtoint(sl.Strings[0+i*2])].Lv := strtoint(sl.Strings[1+i*2]);
                                                GSkill[strtoint(sl.Strings[0+i*2])].Card := false;
                                        end;
                                end;
                        end;

                        if (addkey) then begin
                                GuildList.AddObject(tg.ID, tg);
                        end;
                        SQLDataSet.Next;
                end;
        end;

        if (guildkey) then begin
        with tg do begin
                query := 'SELECT * FROM guild_members WHERE GDID = '''+inttostr(tg.ID)+'''';
                if (MySQL_Query(query)) then begin
                        i := 0;
                        while not SQLDataSet.Eof do begin
                                if i > 35 then break;
                                MemberID[i] := StrToInt(SQLDataSet.FieldValues['GID']);
                                MemberPos[i] := StrToInt(SQLDataSet.FieldValues['PositionID']);
                                MemberEXP[i] := StrToInt(SQLDataSet.FieldValues['MemberExp']);
                                if (MemberID[i] <> 0) then Inc(RegUsers, 1);
                                inc(i);
                                SQLDataSet.Next;
                        end;
                end;

                query := 'SELECT * FROM guild_positions WHERE GDID = '''+inttostr(tg.ID)+''' LIMIT 20';
                if (MySQL_Query(query)) then begin
                        i := 0;
                        while not SQLDataSet.Eof do begin
                                PosName[i] := (SQLDataSet.FieldValues['PosName']);
                                PosInvite[i] := StrToBool(SQLDataSet.FieldValues['PosInvite']);
                                PosPunish[i] := StrToBool(SQLDataSet.FieldValues['PosPunish']);
                                PosEXP[i] := StrToInt(SQLDataSet.FieldValues['PosEXP']);
                                inc(i);
                                SQLDataSet.Next;
                        end;
                end;

                query := 'SELECT * FROM guild_banish WHERE GDID = '''+inttostr(tg.ID)+'''';
                if (MySQL_Query(query)) then begin
                        i := 0;
                        while not SQLDataSet.Eof do begin
                                tgb := TGBan.Create;
                                tgb.Name := (SQLDataSet.FieldValues['MemberName']);
                                tgb.AccName := (SQLDataSet.FieldValues['MemberAccount']);
                                tgb.Reason := (SQLDataSet.FieldValues['Reason']);
                                GuildBanList.AddObject(tgb.Name, tgb);
                                SQLDataSet.Next;
                        end;
                end;

                query := 'SELECT * FROM guild_allies WHERE GDID = '''+inttostr(tg.ID)+'''';
                if (MySQL_Query(query)) then begin
                        i := 0;
                        while not SQLDataSet.Eof do begin
                                tgl := TGRel.Create;
                                tgl.ID := StrToInt(SQLDataSet.FieldValues['GDID']);
                                tgl.GuildName := (SQLDataSet.FieldValues['GuildName']);
                                if (SQLDataSet.FieldValues['Relation'] = 1) then RelAlliance.AddObject(tgl.GuildName, tgl)
                                else RelHostility.AddObject(tgl.GuildName, tgl);
                                SQLDataSet.Next;
                        end;
                end;

                tc := Chara.Objects[Chara.IndexOf(GID)] as TChara;
                for j := 0 to 35 do begin
                        if MemberID[j] = tc.CID then begin
                                tc.GuildName := Name;
                                tc.GuildID := tg.ID;
                                tc.ClassName := PosName[MemberPos[j]];
                                tc.GuildPos := j;
                                Member[j] := tc;
                                if (j = 0) then MasterName := tc.Name;
                                SLV := SLV + tc.BaseLV;
                                break;
                        end;
                end;

                for j := 0 to 35 do begin
                        if MemberID[j] <> 0 then begin
                                i := Chara.IndexOf(MemberID[j]);

                                if i = -1 then begin
                                        Load_Characters(tg.MemberID[j]);
                                end;

                                if i <> -1 then begin
                                        i := Chara.IndexOf(MemberID[j]);
                                        tc := Chara.Objects[i] as TChara;
                                        tc.GuildName := Name;
                                        tc.GuildID := ID;
                                        tc.ClassName := PosName[MemberPos[j]];
                                        tc.GuildPos := j;
                                        Member[j] := tc;
                                        if (j = 0) then MasterName := tc.Name;
                                        SLV := SLV + tc.BaseLV;
                                end;
                        end;
                end;
        end;
        end;

        Result := True;
        guildkey := False;
        sl.Free;
end;

function Preload_GuildMembers() : Boolean;
var
        query : string;
        tc : TChara;
        addkey : Boolean;
begin
        addkey := True;

        query := 'SELECT C.GID, C.Name, C.BaseLV FROM characters AS C LEFT JOIN guild_members AS G ON (C.GID=G.GID) WHERE C.GID <> 0';
        if MySQL_Query(query) then begin
                debugout.Lines.add('Pre-Loading Character Data for Guilds');
                SQLDataSet.First;
                while not SQLDataSet.Eof do begin
                        tc := TChara.Create;
                        tc.CID := StrToInt(SQLDataSet.FieldValues['GID']);
                        tc.Name := SQLDataSet.FieldValues['Name'];
                        if assigned (CharaName) then begin
                                if (CharaName.IndexOf(tc.Name) <> -1) then begin
                                        tc := CharaName.Objects[CharaName.IndexOf(tc.Name)] as TChara;
                                        addkey := False;
                                end;
                        end;
                        tc.BaseLV := StrToInt(SQLDataSet.FieldValues['BaseLV']);

                        if (addkey) then begin
                                CharaName.AddObject(tc.Name, tc);
                                Chara.AddObject(tc.CID, tc);
                        end;
                        
                        SQLDataSet.Next;
                end;
        end;
        debugout.Lines.add('-- Completed.');

end;

end.
