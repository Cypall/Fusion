unit REED_DELETE;

interface

uses
    Common, Globals,
    REED_Support, REED_SAVE_PETS,
    Classes, SysUtils;

    procedure PD_Delete_Accounts(id_key : Integer);
    procedure PD_Delete_Character(id_key : Integer);
    procedure PD_Delete_Pets(id_key : Integer);
    procedure PD_Delete_Parties(id_key : Integer);
    procedure PD_Delete_Guilds(id_key : Integer);
    procedure PD_Delete_Castles(string_key : String);

    procedure delete_data(path : String; id_key : Variant; vType : Integer = 0; delfile : String = '*');
    procedure delete_folder(path : String; folder_key : String);

implementation

    procedure PD_Delete_Accounts(id_key : Integer);
    var
        tp : TPlayer;
        tpe : TPet;
        i : Integer;
        tc : TChara;
        path : String;
        pfile : String;
        charalist : TStringList;
    begin
        if Player.IndexOf(id_key) = -1 then Exit;
        tp := Player.Objects[Player.IndexOf(id_key)] as TPlayer;

        Player.Delete(Player.IndexOf(tp.ID));
        PlayerName.Delete(PlayerName.IndexOf(tp.Name));

        { -- Accounts can not be deleted while Chars / Pets Exist -- }

        { -- Begin - Delete Characters -- }
        path := AppPath + 'gamedata\Accounts\' + IntToStr(tp.ID) + '\Characters\';
        pfile := 'Character.txt';
        charalist := TStringList.Create;
        charalist := get_list(path, pfile);

        for i := 0 to charalist.Count - 1 do begin
            tc := Chara.Objects[Chara.IndexOf(StrToInt(charalist[i]))] as TChara;
            PD_Delete_Character(tc.CID);
        end;

        charalist.Clear;
        charalist.Free;
        { -- End - Delete Characters -- }

        { -- Begin - Delete Pets -- }
        for i := 0 to PetList.Count - 1 do begin
            tpe := PetList.Objects[0] as TPet;
            if not (tpe.PlayerID = tp.ID) then Continue;
            PD_Delete_Pets(tpe.PetID);
        end;
        { -- End - Delete Pets -- }

        delete_folder(AppPath + 'gamedata\Accounts\' + IntToStr(tp.ID), 'Characters');
        delete_folder(AppPath + 'gamedata\Accounts\' + IntToStr(tp.ID), 'Pets');
        delete_data(AppPath + 'gamedata\Accounts', id_key);
    end;

    procedure PD_Delete_Character(id_key : Integer);
    var
        i : Integer;
        tc : TChara;
        tpe : TPet;
        tp : TPlayer;
    begin
        if Chara.IndexOf(id_key) = -1 then Exit;
        tc := Chara.Objects[Chara.IndexOf(id_key)] as TChara;

        tp := tc.PData;

        { -- Characters can not be deleted while Parties / Guilds / Pets Exist -- }

        leave_party(tc);
        leave_guild(tc);

        for i := 0 to PetList.Count - 1 do begin
            tpe := PetList.Objects[i] as TPet;
            if (tpe.CharaID = tc.CID) then begin
                tpe.Incubated := 0;
                tpe.CharaID := 0;
                PD_Save_Pets_Parse(True);
            end;
        end;
        
        Chara.Delete(Chara.IndexOf(tc.CID));
        CharaName.Delete(CharaName.IndexOf(tc.Name));

        delete_data(AppPath + 'gamedata\Accounts\' + IntToStr(tc.ID) + '\Characters', id_key);
    end;

    procedure PD_Delete_Pets(id_key : Integer);
    var
        tpe : TPet;
    begin
        if PetList.IndexOf(id_key) = -1 then Exit;
        tpe := PetList.Objects[PetList.IndexOf(id_key)] as TPet;

        PetList.Delete(PetList.IndexOf(tpe.PetID));

        delete_data(AppPath + 'gamedata\Accounts\' + IntToStr(tpe.PlayerID) + '\Pets', id_key);
    end;

    procedure PD_Delete_Parties(id_key : Integer);
    var
        tpa : TParty;
    begin
        if PartyList.IndexOf(id_key) = -1 then Exit;
        tpa := PartyList.Objects[PartyList.IndexOf(id_key)] as TParty;

        PartyList.Delete(PartyList.IndexOf(tpa.ID));
        PartyNameList.Delete(PartyNameList.IndexOf(tpa.Name));

        delete_data(AppPath + 'gamedata\Parties', id_key);
    end;

    procedure PD_Delete_Guilds(id_key : Integer);
    var
        tg : TGuild;
    begin
        if GuildList.IndexOf(id_key) = -1 then Exit;
        tg := GuildList.Objects[GuildList.IndexOf(id_key)] as TGuild;

        GuildList.Delete(GuildList.IndexOf(tg.ID));

        delete_data(AppPath + 'gamedata\Guilds', id_key);
    end;

    procedure PD_Delete_Castles(string_key : String);
    var
        tgc : TCastle;
    begin
        if CastleList.IndexOf(string_key) = -1 then Exit;
        tgc := CastleList.Objects[CastleList.IndexOf(string_key)] as TCastle;

        CastleList.Delete(CastleList.IndexOf(tgc.Name));

        delete_data(AppPath + 'gamedata\Castles', string_key, 1);
    end;


    procedure delete_data(path : String; id_key : Variant; vType : Integer = 0; delfile : String = '*');
    var
        searchResult : TSearchRec;
        newFolder : String;
        newPath : String;
    begin
        if vType = 0 then begin
            newFolder := IntToStr(id_key);
            newPath := path + '\' + newFolder + '\';
        end
        else if vType = 1 then begin
            newFolder := id_key;
            newPath := path + '\' + newFolder + '\';
        end;

        SetCurrentDir(newPath);
        if FindFirst(delfile, faAnyFile, searchResult) = 0 then repeat
            if not (searchResult.Name = '.') and not (searchResult.Name = '..') then begin
                DeleteFile(newPath + searchResult.Name);
            end;
        until FindNext(searchResult) <> 0;
        FindClose(searchResult);

        delete_folder(path, newFolder);
    end;

    procedure delete_folder(path : String; folder_key : String);
    begin
        SetCurrentDir(path);
        if (RemoveDir(path + '\' + folder_key + '\')) then Exit;
    end;

end.
