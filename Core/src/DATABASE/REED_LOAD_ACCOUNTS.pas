unit REED_LOAD_ACCOUNTS;

interface

uses
    Common, REED_Support, REED_LOAD_CHARACTERS, REED_LOAD_PETS,
    Classes, SysUtils;

    procedure PD_Load_Accounts(UID : String = '*');

    procedure PD_Load_Accounts_Settings(UID : String; path : String);
    procedure PD_Load_Accounts_ActiveCharacters(UID : String; path : String);
    procedure PD_Load_Accounts_Storage(UID : String; path : String);

implementation

    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Accounts ----------------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Accounts(UID : String = '*');
    var
        basepath, path, pfile : String;
        resultlist : TStringList;
        i : Integer;
    begin
        basepath := AppPath + 'gamedata\Accounts\';
        pfile := 'Account.txt';
        resultlist := get_list(basepath, pfile);

        for i := 0 to resultlist.Count - 1 do begin
            if (UID = '*') then path := basepath + resultlist[i] + '\'
            else begin
                path := basepath + UID + '\';
                resultlist[i] := UID;
            end;

            pfile := 'Account.txt';
            PD_Load_Accounts_Settings(resultlist[i], path + pfile);

            pfile := 'ActiveChars.txt';
            PD_Load_Accounts_ActiveCharacters(resultlist[i], path + pfile);

            { Bug Tracing: (01/06/05) }
                // This one is really getting on my nerves. Apparently, Fusion
                // has a stringlist error in the line below me.  However, that
                // is not a string list, and quite frankly I have never heard
                // of any error on a single string type assignment. I have a
                // feeling it is in the line above me in the "resultlist[i]"
                // retrieval, though I don't know why because Fusion says the
                // error is in the line below me.  This could easily be fixed
                // if the people who have this error send me their gamedata, but
                // of course, they're morons.
                // - AlexKreuz (01/06/05)
            pfile := 'Storage.txt';
            PD_Load_Accounts_Storage(resultlist[i], path + pfile);

            PD_Load_Characters_Startup(resultlist[i], path);
            PD_Load_Pets_Startup(resultlist[i], path);

            if (UID <> '*') then Break;
        end;

        FreeAndNil(resultlist);
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Accounts Setting --------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Accounts_Settings(UID : String; path : String);
    var
        datafile : TStringList;
        tp : TPlayer;
    begin
        datafile := TStringList.Create;
        datafile.Clear;
        datafile.LoadFromFile(path);

        if Player.IndexOf(reed_convert_type(UID, 0, -1)) = -1 then tp := TPlayer.Create
        else tp := Player.Objects[Player.IndexOf(reed_convert_type(UID, 0, -1))] as TPlayer;

        tp.ID := retrieve_data(0, datafile, path, 1);
        tp.Name := retrieve_data(1, datafile, path);
        tp.Pass := retrieve_data(2, datafile, path);

        if retrieve_data(3, datafile, path) = 'MALE' then tp.Gender := 1
        else if retrieve_data(3, datafile, path) = 'FEMALE' then tp.Gender := 0;

        tp.Mail := retrieve_data(4, datafile, path);

        if retrieve_data(5, datafile, path) = 'YES' then tp.Banned := True
        else if retrieve_data(5, datafile, path) = 'NO' then tp.Banned := False;

        tp.AccessLevel := retrieve_data(6, datafile, path, 1);

        if Player.IndexOf(reed_convert_type(UID, 0, -1)) = -1 then begin
            PlayerName.AddObject(tp.Name, tp);
            Player.AddObject(tp.ID, tp);
        end;

        datafile.Free;
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Active Characters into Accounts ------------------------------------ }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Accounts_ActiveCharacters(UID : String; path : String);
    var
        datafile : TStringList;
        tp : TPlayer;
        i : Integer;
    begin
        datafile := TStringList.Create;
        datafile.Clear;
        datafile.LoadFromFile(path);

        tp := Player.Objects[Player.IndexOf(reed_convert_type(UID, 0, -1))] as TPlayer;

        for i := 0 to 8 do begin
            tp.CName[i] := retrieve_data(i, datafile, path);
        end;

        datafile.Free;
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Account Storage ---------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Accounts_Storage(UID : String; path : String);
	var
        tp : TPlayer;
    begin
        tp := Player.Objects[Player.IndexOf(reed_convert_type(UID, 0, -1))] as TPlayer;
        retrieve_inventories(path, tp.Kafra.Item);
        CalcInventory(tp.Kafra);
    end;
    { ------------------------------------------------------------------------------------- }

end.
