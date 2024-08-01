unit ISCS;

interface

uses
    SlyIrc, SysUtils, StrUtils, Common, Globals;

type
    TfrmISCS = class
    private
        procedure iscs_console_create();
        procedure iscs_console_destroy(str : String);
        procedure iscs_console_receive(Sender: TObject; AResponse: String);
    public
end;

var
    frmISCS: TfrmISCS;

    ISCS_CONNECTION : Array of TSlyIrc;
    ISCS_PREVIOUS : String;

    ISCS_ON : Boolean;
    ISCS_SERVER : String;
    ISCS_PORT: String;
    ISCS_CHANNEL : String;
    ISCS_NICK : String;

    procedure iscs_console_connect(tc : TChara = nil);
    procedure iscs_console_disconnect(tc : TChara = nil);
    procedure iscs_console_send(str : String; tc : TChara = nil);
    procedure iscs_console_join(str : String);

implementation

uses
    Main;

    { ---------------------------------------------------------------------- }
    procedure TfrmISCS.iscs_console_create();
    var
        i : Integer;
    begin
        SetLength(ISCS_CONNECTION, Chara.Count + 1);

        for i := 0 to length(ISCS_CONNECTION) - 1 do begin
            if ISCS_CONNECTION[i] = nil then break;
        end;

        ISCS_CONNECTION[i] := TSlyIrc.Create(nil);
        ISCS_CONNECTION[i].OnReceive := iscs_console_receive;

        ISCS_CONNECTION[i].Host := ISCS_SERVER;
        ISCS_CONNECTION[i].Port := ISCS_PORT;
        ISCS_CONNECTION[i].Nick := '['+ StringReplace(ServerName, ' ', '', [rfReplaceAll, rfIgnoreCase]) +']-'+ISCS_NICK;
        ISCS_CONNECTION[i].AltNick := '['+ StringReplace(ServerName, ' ', '', [rfReplaceAll, rfIgnoreCase]) +']-'+ISCS_NICK;
        ISCS_CONNECTION[i].Username := ISCS_NICK;
        ISCS_CONNECTION[i].Connect;
    end;

    procedure TfrmISCS.iscs_console_destroy(str : String);
    var
        i : Integer;
    begin
        for i := 0 to length(ISCS_CONNECTION) - 1 do begin
            if ISCS_CONNECTION[i] = nil then Continue;
            if ISCS_CONNECTION[i].Username = str then begin
                ISCS_CONNECTION[i].Quit('Powered by the Fusion Inter-Server Communication System.');
                ISCS_CONNECTION[i] := nil;
                Break;
            end;
        end;
    end;

    procedure TfrmISCS.iscs_console_receive(Sender: TObject; AResponse: String);
    var
        i : Integer;
        nickname : String;
        body : String;
        tc : TChara;
    begin        

        if AnsiPos('PRIVMSG', AResponse) > 0 then begin
            nickname := Copy(AResponse, 2, AnsiPos('!', AResponse) - 2);
            body := AnsiRightStr(AResponse, length(AResponse) - AnsiPos('PRIVMSG #Fusion :', AResponse) - length('PRIVMSG #Fusion :') + 1 );

            if (ISCS_PREVIOUS = AResponse) then Exit;

            ISCS_PREVIOUS := AResponse;

            for i := 0 to length(ISCS_CONNECTION) - 1 do begin
                if ISCS_CONNECTION[i] = nil then Continue;

                if ISCS_CONNECTION[i].Username = 'Server' then
                    frmMain.txtDebug.Lines.Add('[ISCS] ' + nickname+': '+body);
                
                if CharaName.IndexOf(ISCS_CONNECTION[i].Username) = -1 then Continue;

                tc := CharaName.Objects[CharaName.IndexOf(ISCS_CONNECTION[i].Username)] as TChara;
                message_green(tc, '[ISCS] ' + nickname+' : '+body);
            end;
        end;

        if AnsiPos('MODE ['+StringReplace(ServerName, ' ', '', [rfReplaceAll, rfIgnoreCase])+']-', AResponse) > 0 then begin
            iscs_console_join(ISCS_NICK);
        end;
        
    end;
    { ---------------------------------------------------------------------- }


    { ---------------------------------------------------------------------- }
    procedure iscs_console_connect(tc : TChara = nil);
    begin
        if (tc = nil) then ISCS_ON := True;
        
        ISCS_SERVER := 'irc.z4znet.com';
        ISCS_PORT := '6667';
        ISCS_CHANNEL := '#fusion';

        if (tc = nil) then ISCS_NICK := 'Server'
        else ISCS_NICK := tc.Name;

        frmISCS.iscs_console_create();
    end;

    procedure iscs_console_disconnect(tc : TChara = nil);
    begin
        if (tc = nil) then begin
            ISCS_ON := False;
            frmISCS.iscs_console_destroy('Server');
        end else begin
            frmISCS.iscs_console_destroy(tc.Name);
        end;
    end;

    procedure iscs_console_send(str : String; tc : TChara = nil);
    var
        i : Integer;
        array_length : Integer;
        nick : String;
    begin
        array_length := -1;
        for i := 0 to length(ISCS_CONNECTION) - 1 do begin
            if ISCS_CONNECTION[i] = nil then Continue;
            Inc(array_length);
        end;

        if (tc = nil) then nick := 'Server'
        else nick := tc.Name;

        if Copy(str, 1, 4) <> 'join' then begin
            if array_length = 0 then begin
                if (tc = nil) then frmMain.txtDebug.Lines.Add('[ISCS] ['+ StringReplace(ServerName, ' ', '', [rfReplaceAll, rfIgnoreCase]) +']-'+nick+': '+str)
                else if tc.PData.Login then message_green(tc, '[ISCS] ['+ StringReplace(ServerName, ' ', '', [rfReplaceAll, rfIgnoreCase]) +']-'+nick+' : '+str);
            end;
            str := 'PRIVMSG ' + ISCS_CHANNEL + ' :' + str;
        end;

        for i := 0 to length(ISCS_CONNECTION) - 1 do begin
            if ISCS_CONNECTION[i] = nil then Continue;
            if ISCS_CONNECTION[i].Username = nick then begin
                ISCS_CONNECTION[i].Send(str);
                Break;
            end;
        end;
    end;

    procedure iscs_console_join(str : String);
    var
        tc : TChara;
    begin
        tc := nil;
        
        if (str <> 'Server') then begin
            if CharaName.IndexOf(str) = -1 then Exit;
            tc := CharaName.Objects[CharaName.IndexOf(str)] as TChara;
        end;
        
        iscs_console_send('join ' + ISCS_CHANNEL, tc);
    end;
    { ---------------------------------------------------------------------- }

end.
