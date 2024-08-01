unit REED_SAVE_PARTIES;

interface

uses
    Common, REED_Support,
    Classes, SysUtils;

    procedure PD_Save_Parties_Parse(forced : Boolean = False);

    procedure PD_Save_Parties_Settings(tpa : TParty; datafile : TStringList);
    procedure PD_Save_Parties_Members(tpa : TParty; datafile : TStringList);

implementation

    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Parties Parse ------------------------------------------------------ }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Parties_Parse(forced : Boolean = False);
    var
        datafile : TStringList;
        i : Integer;
        tpa : TParty;
        path : String;
        pfile : String;
    begin
        datafile := TStringList.Create;

        for i := 0 to PartyList.Count - 1 do begin
            tpa := PartyList.Objects[i] as TParty;
            if (not party_is_online(tpa)) and (not forced) then Continue;
            if not party_is_current(tpa.ID) then Continue;

            datafile.Clear;

            path := AppPath + 'gamedata\Parties';

            pfile := 'Settings.txt';
            PD_Save_Parties_Settings(tpa, datafile);
            reed_savefile(tpa.ID, datafile, path, pfile);

            pfile := 'Members.txt';
            PD_Save_Parties_Members(tpa, datafile);
            reed_savefile(tpa.ID, datafile, path, pfile);
        end;

        FreeAndNil(datafile);
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Parties Settings --------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Parties_Settings(tpa : TParty; datafile : TStringList);
    begin
        datafile.Add('NAM : ' + tpa.Name);
        datafile.Add('PID : ' + IntToStr(tpa.ID));
    end;
    { ------------------------------------------------------------------------------------- }
    

    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Parties Members ---------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Parties_Members(tpa : TParty; datafile : TStringList);
    var
        i : Integer;
    begin
        datafile.Add(' CID    : NAME');
        datafile.Add('-------------------------------------------------');

        for i := 0 to 11 do begin
            if tpa.MemberID[i] = 0 then Continue;
            if not assigned(tpa.Member[i]) then Continue;
            if tpa.Member[i].PartyName <> tpa.Name then Continue;
            datafile.Add(' ' + IntToStr(tpa.MemberID[i]) + ' : ' + tpa.Member[i].Name);
        end;
    end;
    { ------------------------------------------------------------------------------------- }

end.
