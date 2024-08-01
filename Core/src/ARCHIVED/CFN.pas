unit CFN;

interface
uses uMysqlClient, Common, SysUtils, Classes;

    function CFN_Query(query: String) : Boolean;
    //function Call_Characters(AID: cardinal) : Boolean;

implementation

var
    sqlconnection : tmysqlclient;
    sqlresult : tmysqlresult;

function CFN_Query(query: String) : Boolean;
var
    sresult : tresulttype;
    eo : Boolean;
begin
    eo := True;

    sqlconnection := tmysqlclient.create;
    sqlconnection.Host := DbHost;
    sqlconnection.User := DbUser;
    sqlconnection.Password := DbPass;
    sqlconnection.Db := DbName;

    sqlresult := tmysqlresult.create(sqlconnection,  sresult);
    sqlconnection.connect;

    sqlresult := sqlconnection.query(query,true,eo);
    
    sqlconnection.close;
    result := true;
end;

{function Call_Characters(AID: cardinal) : Boolean;
var
        i : integer;
        tp : TPlayer;
        query : string;
begin
        Result := False;

        tp := Player.Objects[Player.IndexOf(AID)] as TPlayer;

        query := 'SELECT GID, Name, CharaNumber FROM characters WHERE AID='+''''+inttostr(AID)+''''+' LIMIT 9';
        if CFN_Query(query) then begin
                while not sqlresult.EOF do begin
                    tp.CID[(strtoint(sqlresult.FieldValueByName('CharaNumber')))] := strtoint(sqlresult.FieldValueByName('GID'));
                    sqlresult.Next;
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
end;}

end.
