unit REED_SAVE_CASTLES;

interface

uses
    Common, REED_Support,
    Classes, SysUtils;

    procedure PD_Save_Castles_Parse(forced : Boolean = False);

    procedure PD_Save_Castles_Basic(tgc : TCastle; datafile : TStringList);

implementation

    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Castles Parse ------------------------------------------------------ }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Castles_Parse(forced : Boolean = False);
    var
        datafile : TStringList;
        i : Integer;
        tg : TGuild;
        tgc : TCastle;
        path : String;
        pfile : String;
    begin
        datafile := TStringList.Create;

        for i := 0 to CastleList.Count - 1 do begin
            tgc := CastleList.Objects[i] as TCastle;
            if GuildList.IndexOf(tgc.GID) = -1 then Continue;

            tg := GuildList.Objects[GuildList.IndexOf(tgc.GID)] as TGuild;
            if (not guild_is_online(tg)) and (not forced) then Continue;
            datafile.Clear;

            path := AppPath + 'gamedata\Castles';

            pfile := 'Castle.txt';
            PD_Save_Castles_Basic(tgc, datafile);
            reed_savefile(tgc.Name, datafile, path, pfile, 1);
        end;

        FreeAndNil(datafile);
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Castles Basic ------------------------------------------------------ }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Castles_Basic(tgc : TCastle; datafile : TStringList);
    begin
        datafile.Add('MAP : ' + tgc.Name);
        datafile.Add('GID : ' + IntToStr(tgc.GID));
        datafile.Add('GNM : ' + tgc.GName);
        datafile.Add('GMA : ' + tgc.GMName);
        datafile.Add('GKA : ' + IntToStr(tgc.GKafra));
        datafile.Add('EDE : ' + IntToStr(tgc.EDegree));
        datafile.Add('ETR : ' + IntToStr(tgc.ETrigger));
        datafile.Add('DDE : ' + IntToStr(tgc.DDegree));
        datafile.Add('DTR : ' + IntToStr(tgc.DTrigger));
        datafile.Add('GS1 : ' + IntToStr(tgc.GuardStatus[0]));
        datafile.Add('GS2 : ' + IntToStr(tgc.GuardStatus[1]));
        datafile.Add('GS3 : ' + IntToStr(tgc.GuardStatus[2]));
        datafile.Add('GS4 : ' + IntToStr(tgc.GuardStatus[3]));
        datafile.Add('GS5 : ' + IntToStr(tgc.GuardStatus[4]));
        datafile.Add('GS6 : ' + IntToStr(tgc.GuardStatus[5]));
        datafile.Add('GS7 : ' + IntToStr(tgc.GuardStatus[6]));
        datafile.Add('GS8 : ' + IntToStr(tgc.GuardStatus[7]));
    end;
    { ------------------------------------------------------------------------------------- }

end.
