unit REED_LOAD_CASTLES;

interface

uses
    Common, REED_Support,
    Classes, SysUtils;

    procedure PD_Load_Castles_Pre_Parse(UID : String = '*');
    procedure PD_Load_Castles_Parse(UID : String; resultlist : TStringList; basepath : String);

    procedure PD_Load_Castles_Settings(tgc : TCastle; path : String);

implementation

    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Castles Pre Parse -------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Castles_Pre_Parse(UID : String = '*');
    var
        basepath : String;
        pfile : String;
    begin
        basepath := AppPath + 'gamedata\Castles\';
        pfile := 'Castle.txt';
        PD_Load_Castles_Parse(UID, get_list(basepath, pfile), basepath);
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Castles Parse ------------------------------------------------------ }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Castles_Parse(UID : String; resultlist : TStringList; basepath : String);
    var
        i, GID : Integer;
        pfile : String;
        path : String;
        tp : TPlayer;
        tg : TGuild;
        tgc : TCastle;
        datafile : TStringList;
    begin
        datafile := TStringList.Create;

        for i := 0 to resultlist.Count - 1 do begin
            path := basepath + resultlist[i] + '\';

            if (UID <> '*') then begin

                tgc := CastleList.Objects[CastleList.IndexOf(resultlist[i])] as TCastle;
                pfile := 'Castle.txt';


                datafile.Clear;
                datafile.LoadFromFile(path + pfile);

                tgc.GID := retrieve_data(1, datafile, path + pfile, 1);

                tg := select_load_guild(UID, tgc.GID);
                if not assigned(tg) then Continue;
                if guild_is_online(tg) then Continue;

            end else begin
                tgc := TCastle.Create;
            end;

            pfile := 'Castle.txt';
            PD_Load_Castles_Settings(tgc, path + pfile);

            if (UID = '*') then begin
                CastleList.AddObject(tgc.Name, tgc);
            end;

        end;

        FreeAndNil(datafile);
        FreeAndNil(resultlist);
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Castles Settings --------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Castles_Settings(tgc : TCastle; path : String);
    var
        datafile : TStringList;
    begin
        datafile := TStringList.Create;

        datafile.Clear;
        datafile.LoadFromFile(path);

        tgc.Name := retrieve_data(0, datafile, path);
        tgc.GID := retrieve_data(1, datafile, path, 1);
        tgc.GName := retrieve_data(2, datafile, path);
        tgc.GMName := retrieve_data(3, datafile, path);
        tgc.GKafra := retrieve_data(4, datafile, path, 1);
        tgc.EDegree := retrieve_data(5, datafile, path, 1);
        tgc.ETrigger := retrieve_data(6, datafile, path, 1);
        tgc.DDegree := retrieve_data(7, datafile, path, 1);
        tgc.DTrigger := retrieve_data(8, datafile, path, 1);
        tgc.GuardStatus[0] := retrieve_data(9, datafile, path, 1);
        tgc.GuardStatus[1] := retrieve_data(10, datafile, path, 1);
        tgc.GuardStatus[2] := retrieve_data(11, datafile, path, 1);
        tgc.GuardStatus[3] := retrieve_data(12, datafile, path, 1);
        tgc.GuardStatus[4] := retrieve_data(13, datafile, path, 1);
        tgc.GuardStatus[5] := retrieve_data(14, datafile, path, 1);
        tgc.GuardStatus[6] := retrieve_data(15, datafile, path, 1);
        tgc.GuardStatus[7] := retrieve_data(16, datafile, path, 1);

        FreeAndNil(datafile);
    end;
    { ------------------------------------------------------------------------------------- }

end.
