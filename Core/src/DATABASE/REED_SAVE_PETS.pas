unit REED_SAVE_PETS;

interface

uses
    Common, REED_Support,
    Classes, SysUtils;

    procedure PD_Save_Pets_Parse(forced : Boolean = False);

    procedure PD_Save_Pets_Basic(tpe : TPet; datafile : TStringList);

implementation

    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Pets Parse --------------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Pets_Parse(forced : Boolean = False);
    var
        datafile : TStringList;
        i, j, k, l : Integer;
        tpe : TPet;
        tp : TPlayer;
        tc : TChara;

        path : String;
        pfile : String;
    begin
        datafile := TStringList.Create;

        for i := 0 to PetList.Count - 1 do begin
            tpe := PetList.Objects[i] as TPet;
            tpe.Saved := 0;
        end;

        for i := 0 to Player.Count - 1 do begin
            tp := Player.Objects[i] as TPlayer;

            if (not tp.Login) and (not forced) then Continue;

            for j := 1 to 100 do begin
                for k := 0 to PetList.Count - 1 do begin
                    if (tp.Kafra.Item[j].ID <> 0) and (tp.Kafra.Item[j].Amount > 0) and (tp.Kafra.Item[j].Card[0] = $FF00) then begin
                        tpe := PetList.Objects[k] as TPet;

                        if tp.Kafra.Item[j].Card[1] <> tpe.PetID then Continue;
                        if tpe.PlayerID <> tp.ID then Continue;
                        if tpe.Saved <> 0 then Continue;

                        tpe.Incubated := 0;
                        tpe.CharaID := 0;
                        //tpe.Index := 0;

                        datafile.Clear;
                        path := AppPath + 'gamedata\Accounts\' + IntToStr(tp.ID) + '\Pets';

                        pfile := 'Pet.txt';
                        PD_Save_Pets_Basic(tpe, datafile);
                        reed_savefile(tpe.PetID, datafile, path, pfile);

                        tpe.Saved := 1;
                    end;
                end;
            end;

            for j := 0 to 8 do begin
                tc := tp.CData[j];
                if tc = nil then Continue;

                for k := 1 to 100 do begin
                    for l := 0 to PetList.Count - 1 do begin
                        tpe := PetList.IndexOfObject(l) as TPet;

                        if tc.Item[k].Card[1] <> tpe.PetID then Continue;
                        if not (tpe.PlayerID = tp.ID) then Continue;
                        if not (tpe.Saved = 0) then Continue;

                        if tpe.Saved <> 0 then Continue;

                        datafile.Clear;
                        path := AppPath + 'gamedata\Accounts\' + IntToStr(tp.ID) + '\Pets';

                        pfile := 'Pet.txt';
                        PD_Save_Pets_Basic(tpe, datafile);
                        reed_savefile(tpe.PetID, datafile, path, pfile);

                        tpe.Saved := 1;
                    end;
                end;
            end;            
        end;

        datafile.Clear;
        FreeAndNil(datafile);
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Pets Basic --------------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Pets_Basic(tpe : TPet; datafile : TStringList);
    begin
        datafile.Add('AID : ' + IntToStr(tpe.PlayerID));
        datafile.Add('CID : ' + IntToStr(tpe.CharaID));
        datafile.Add('CRT : ' + IntToStr(tpe.Cart));
        //datafile.Add('IDX : ' + IntToStr(tpe.Index));
        datafile.Add('INC : ' + IntToStr(tpe.Incubated));
        datafile.Add('PID : ' + IntToStr(tpe.PetID));
        datafile.Add('JID : ' + IntToStr(tpe.JID));
        datafile.Add('NAM : ' + tpe.Name);
        datafile.Add('REN : ' + IntToStr(tpe.Renamed));
        datafile.Add('PLV : ' + IntToStr(tpe.LV));
        datafile.Add('REL : ' + IntToStr(tpe.Relation));
        datafile.Add('FUL : ' + IntToStr(tpe.Fullness));
        datafile.Add('ACC : ' + IntToStr(tpe.Accessory));
    end;
    { ------------------------------------------------------------------------------------- }

end.
