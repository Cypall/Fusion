unit WAC;

interface

uses
    StrUtils, SysUtils,
    Common, PlayerData,
    BRSHttpSrv, Globals;

var
    BRSHttpSrv1 : TBRSHttpSrv;

    function parse_wac(URI : String) : String;
    function account_exists(username : String) : Boolean;

    procedure create_wac();
    procedure destroy_wac(forced : Boolean = False);

implementation

uses
    Main;

    {
        Result Types:
        -------------
          0 - Display Basic Index Page.
          1 - Account already exists.
          2 - Passwords do not match.
          3 - Email does not contain '@'.
          4 - Password / Username length too short.
          5 - Success. Account created.
          6 - Missing information.
    }

    function parse_wac(URI : String) : String;
    var
        username : String;
        password1 : String;
        password2 : String;
        email : String;
        sex : String;

        result_type : Integer;
    begin
        if (URI = '/index.html') or (URI = '/') then result_type := 0
        else if AnsiContainsStr(URI, 'action=Create+Account') then begin
            username := AnsiMidStr(URI, AnsiPos('USERNAME=', URI) + 9, AnsiPos('&PASSWORD1=', URI) - AnsiPos('USERNAME=', URI) - 9);
            password1 := AnsiMidStr(URI, AnsiPos('PASSWORD1=', URI) + 10, AnsiPos('&PASSWORD2=', URI) - AnsiPos('PASSWORD1=', URI) - 10);
            password2 := AnsiMidStr(URI, AnsiPos('PASSWORD2=', URI) + 10, AnsiPos('&EMAIL=', URI) - AnsiPos('PASSWORD2=', URI) - 10);
            email := AnsiMidStr(URI, AnsiPos('EMAIL=', URI) + 6, AnsiPos('&SEX=', URI) - AnsiPos('EMAIL=', URI) - 6);
            sex := AnsiMidStr(URI, AnsiPos('SEX=', URI) + 4, AnsiPos('&action=', URI) - AnsiPos('SEX=', URI) - 4);

            if (username = '') or (password1 = '') or (password2 = '') or (email = '') or (sex = '') then result_type := 6
            else if account_exists(username) then result_type := 1
            else if (password1 <> password2) then result_type := 2
            else if (not AnsiContainsStr(email, '@')) and (not AnsiContainsStr(email, '%40')) then result_type := 3
            else if (length(username) < 4) or (length(password1) < 4) then result_type := 4

            else begin
                (* Tsusai: Added conversion of %40 to @ to fix test%40test.org
                bogus email submissions for other browsers like Firefox. *)
                email := AnsiReplaceStr(email, '%40', '@');
                create_account(username, password1, email, sex);
                result_type := 5;
            end;
        end;

        case result_type of
            0: Result := 'WAC/index.html';
            1: Result := 'WAC/account_exists.html';
            2: Result := 'WAC/password_mismatch.html';
            3: Result := 'WAC/check_email.html';
            4: Result := 'WAC/userpass_length.html';
            5: Result := 'WAC/success.html';
            6: Result := 'WAC/missing.html';
        end;
    end;

    function account_exists(username : String) : Boolean;
    var
        tp : TPlayer;
    begin
        if PlayerName.IndexOf(username) = -1 then Result := False
        else Result := True;
    end;

    procedure create_wac();
    begin
        if (Option_Enable_WAC) then begin
            BRSHttpSrv1 := TBRSHttpSrv.Create(frmMain);
            BRSHttpSrv1.Port := wacport;
            try
                BRSHttpSrv1.Start;
            except
                debugout.Lines.add('WAC was unable to use the port ' + IntToStr(wacport));
                destroy_wac(true);
            end;

            if (Option_Use_UPnP) then begin
                create_upnp(wacport, 'Fusion Web Account Creator');
            end;
        end;
    end;

    procedure destroy_wac(forced : Boolean = False);
    begin
        if (not (Option_Enable_WAC) and assigned(BRSHttpSrv1)) or (forced and assigned(BRSHttpSrv1))  then begin
            BRSHttpSrv1.Stop;
            BRSHttpSrv1 := nil;

            if (Option_Use_UPnP) then begin
                destroy_upnp(wacport);
            end;
        end;
    end;

end.
