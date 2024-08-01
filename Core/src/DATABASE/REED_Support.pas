unit REED_Support;

interface

uses
    Common,
    Classes, SysUtils, Dialogs;

    function retrieve_data(idx : Integer; datafile : TStringList; path : String; rtype : Integer = 0) : Variant;
    function get_list(path : String; pfile : String; UID : String = '*') : TStringList;
    procedure retrieve_inventories(path : String; inventory_item : array of TItem);
    function retrieve_length(datafile : TStringList; path : String) : Integer;
    function retrieve_value(datafile : TStringList; path : String; row : Integer; column : Integer) : Variant;
    procedure reed_shutdown_server(error_message : String);
    function reed_convert_type(in_value : Variant; ctype : Integer; line : Integer; path : String = '') : Variant;
    function stringlist_load(path : String) : TStringList;
    function select_load_guild(UID : String; guildid : Cardinal) : TGuild;
    function guild_is_online(tg : TGuild) : Boolean;
    procedure reed_savefile(folderid : Variant; datafile : TStringList; path : String; pfile : String; vType : Integer = 0);
    procedure compile_inventories(datafile : TStringList; inventory_item : array of TItem);
    function party_is_online(tpa : TParty) : Boolean;
    function reed_column_align(str : String; count : Integer; last : Boolean = True) : String;
    function party_is_current(partyid : Integer) : Boolean;
    function guild_is_current(guildid : Integer) : Boolean;
    function get_pet_index(inventory_item : array of TItem; pet_id : Integer) : Integer;

implementation

uses
    Main;

    { ------------------------------------------------------------------------------------- }
    { R.E.E.D - retrieve_data                                                               }
    { ------------------------------------------------------------------------------------- }
    { Purpose: To retrieve data from the R.E.E.D databases in an efficient manner.          }
    { Parameters:                                                                           }
    {  - idx : Integer, Represents the line from which to retrieve data.                    }
    {  - path : String, Represents the path and file from which to retrieve data.           }
    {  - rtype : Integer, result type designates what type to return. Default String.       }
    {     - Type 0 = String.                                                                }
    {     - Type 1 = Integer.                                                               }
    { ------------------------------------------------------------------------------------- }
    function retrieve_data(idx : Integer; datafile : TStringList; path : String; rtype : Integer = 0) : Variant;
    var
        str : String;
    begin
        if not FileExists(path) then Exit;

        try
            str := Copy(datafile[idx], Pos(' : ', datafile[idx]) + 3, length(datafile[idx]) - Pos(' : ', datafile[idx]) + 3);
        except
            on EStringListError do begin
                reed_shutdown_server('Error in ' + path + ' on line ' + inttostr(idx+1));
            end;
        end;

        if (rtype = 0) then
            Result := str
        else if (rtype = 1) then
            Result := reed_convert_type(str, 0, idx+1, path);

    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { R.E.E.D - get_list                                                                    }
    { ------------------------------------------------------------------------------------- }
    { Purpose: To browse directories and retrieve database files in an efficient manner.    }
    { Parameters:                                                                           }
    {  - path : String, Represents the general directory where to search.                   }
    {  - pfile : String, Represents the file to search for.                                 }
    {  - UID : String, Represents the search mask to use in search. Default * (all).        }
    { ------------------------------------------------------------------------------------- }
    function get_list(path : String; pfile : String; UID : String = '*') : TStringList;
    var
        searchResult : TSearchRec;
        filelist : TStringList;
    begin
        filelist := TStringList.Create;
        filelist.Clear;

        SetCurrentDir(path);
        if FindFirst(UID, faDirectory, searchResult) = 0 then repeat
            if FileExists(path + searchResult.Name + '\' + pfile) then begin
                filelist.add(searchResult.Name);
            end;
        until FindNext(searchResult) <> 0;
        FindClose(searchResult);

        Result := filelist;
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { R.E.E.D - retrieve_inventories                                                        }
    { ------------------------------------------------------------------------------------- }
    { Purpose: To retrieve inventory format databases such as cart/inventory/storage/etc.   }
    { Parameters:                                                                           }
    {  - path : String, Represents file to load up.                                         }
    {  - inventory_item : TItem, Represents the inventory type to clear and reload.         }
    { ------------------------------------------------------------------------------------- }
    procedure retrieve_inventories(path : String; inventory_item : array of TItem);
    var
        datafile : TStringList;
        columns : TStringList;
        i : Integer;
    begin
        if not FileExists(path) then Exit;

        datafile := TStringList.Create;
        columns := TStringList.Create;
        columns.Delimiter := ':';

        datafile.LoadFromFile(path);

        for i := 0 to 99 do begin
            inventory_item[i].ID := 0;
        end;

        for i := 2 to datafile.Count - 1 do begin
            columns.DelimitedText := datafile[i];

            datafile[i] := StringReplace(datafile[i], ' ', '', [rfReplaceAll, rfIgnoreCase]);
            if datafile[i] = '' then Continue;

            if ItemDB.IndexOf(reed_convert_type(columns.Strings[0], 0, i, path)) = -1 then Continue;

            inventory_item[i-2].ID := reed_convert_type(columns.Strings[0], 0, i, path);
            inventory_item[i-2].Amount := reed_convert_type(columns.Strings[1], 0, i, path);
            inventory_item[i-2].Equip := reed_convert_type(columns.Strings[2], 0, i, path);

            { Bug Tracing: 01/06/05 }
                // Apparently the line below me has a "list index out of bounds (3)"
                // type error.  From what I understand, the lines above read the data
                // so its not a indexing error, but mere a "data does not exist" error.
                // This is why it can read the first 3 columns but fails on the 4th.
                // Why does it fail on the fourth? That's a good question.  Most likely,
                // the guy on who it crashed had corrupted/missing gamedata.  Why?
                // Don't know. He either messed with it, or there is an even bigger problem
                // at hand.
                // - AlexKreuz (01/06/05)
            inventory_item[i-2].Identify := reed_convert_type(columns.Strings[3], 0, i, path);
            inventory_item[i-2].Refine := reed_convert_type(columns.Strings[4], 0, i, path);
            inventory_item[i-2].Attr := reed_convert_type(columns.Strings[5], 0, i, path);
            inventory_item[i-2].Card[0] := reed_convert_type(columns.Strings[6], 0, i, path);
            inventory_item[i-2].Card[1] := reed_convert_type(columns.Strings[7], 0, i, path);
            inventory_item[i-2].Card[2] := reed_convert_type(columns.Strings[8], 0, i, path);
            inventory_item[i-2].Card[3] := reed_convert_type(columns.Strings[9], 0, i, path);
            inventory_item[i-2].Data := ItemDB.Objects[ItemDB.IndexOf(inventory_item[i-2].ID)] as TItemDB;
        end;

        FreeAndNil(datafile);
        FreeAndNil(columns);
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { R.E.E.D - retrieve_length                                                             }
    { ------------------------------------------------------------------------------------- }
    { Purpose: To retrieve the length of a file for processing and to strip the header.     }
    { Parameters:                                                                           }
    {  - path : String, Represents file to load up.                                         }
    { ------------------------------------------------------------------------------------- }
    function retrieve_length(datafile : TStringList; path : String) : Integer;
    begin
        Result := datafile.Count - 3;
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { R.E.E.D - retrieve_value                                                              }
    { ------------------------------------------------------------------------------------- }
    { Purpose: To retrieve a value from a REED ':' separated data file.                     }
    { Parameters:                                                                           }
    {  - path : String, Represents file to load up.                                         }
    {  - row : Integer, The row index to look for.                                          }
    {  - column : Integer, The column index to look for.                                    }
    { ------------------------------------------------------------------------------------- }
    function retrieve_value(datafile : TStringList; path : String; row : Integer; column : Integer) : Variant;
    var
        columns : TStringList;
        strbuf : String;
    begin
        columns := TStringList.Create;
        columns.Delimiter := ':';

        if not FileExists(path) then begin
            reed_shutdown_server(path + ' is missing.');
        end;

        strbuf := StringReplace(datafile[row + 2], ' ', '[FSRCALL]', [rfReplaceAll, rfIgnoreCase]);
        columns.DelimitedText := strbuf;

        if columns.Count > column then begin
            Result := Trim(StringReplace(columns.Strings[column], '[FSRCALL]', ' ', [rfReplaceAll, rfIgnoreCase]));
        end else begin
            Result := '';
        end;

        FreeAndNil(columns);
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { R.E.E.D - reed_shutdown_server                                                        }
    { ------------------------------------------------------------------------------------- }
    { Purpose: To shut down the server when the user has a corrupted R.E.E.D database.      }
    { Parameters:                                                                           }
    {  - error_message : String, Represents the message that the user needs.                }
    { ------------------------------------------------------------------------------------- }
    procedure reed_shutdown_server(error_message : String);
    begin
        ShowMessage('R.E.E.D has detected a corrupt database. ' + error_message + '. Your server will now shut down.');
        Halt;
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { R.E.E.D - reed_convert_type                                                           }
    { ------------------------------------------------------------------------------------- }
    { Purpose: To inteligently handle conversions of types and provide proper shutdown.     }
    { Parameters:                                                                           }
    {  - in_value : Variant, Represents the value that must be converted.                   }
    {  - ctype : Integer, Represents the type of conversion.                                }
    {  - line : Integer, Represents the error line or if no line, the correct message.      }
    {  - path : String, Represents the error location.                                      }
    { ------------------------------------------------------------------------------------- }
    function reed_convert_type(in_value : Variant; ctype : Integer; line : Integer; path : String = '') : Variant;
    begin
        try
            case ctype of
                0 : Result := StrToInt(in_value);
                1 : Result := IntToStr(in_value);
            end;
        except
            on EConvertError do begin
                if (line >= 0) then
                    reed_shutdown_server('Error in ' + path + ' on line ' + inttostr(line))
                else
                    reed_shutdown_server('"' + in_value + '" is not a valid database id');
            end;
        end;
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { R.E.E.D - stringlist_load                                                             }
    { ------------------------------------------------------------------------------------- }
    { Purpose: To provide a general way to load data from a file into a stringlist.         }
    { Parameters:                                                                           }
    {  - path : String, Represents the path to the file to be opened.                       }
    { Result:                                                                               }
    {  - Result : TStringList, Represent the stringlist to return.                          }
    { ------------------------------------------------------------------------------------- }
    function stringlist_load(path : String) : TStringList;
    var
        datafile : TStringList;
    begin
        datafile := TStringList.Create;
        datafile.LoadFromFile(path);

        Result := datafile;
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { R.E.E.D - Guild Supplemental Functions                                                }
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { R.E.E.D - select_load_guild                                                           }
    { ------------------------------------------------------------------------------------- }
    { Purpose: To allow guild parsing to create or select the proper guild for loading.     }
    { Parameters:                                                                           }
    {  - UID : String, Represents the account ID to load.                                   }
    {  - tp : TPlayer, Represents the player data.                                          }
    {  - guildid : Cardinal, Represents the guild's ID.                                     }
    { Results:                                                                              }
    {  - Result : TParty, Represents the selected guild.                                    }
    { ------------------------------------------------------------------------------------- }
    function select_load_guild(UID : String; guildid : Cardinal) : TGuild;
    var
        i : Integer;
        tg : TGuild;
        tp : TPlayer;
    begin

        if (UID <> '*') then begin

            if Player.IndexOf(reed_convert_type(UID, 0, -1)) = -1 then Exit;
            tp := Player.Objects[Player.IndexOf(reed_convert_type(UID, 0, -1))] as TPlayer;

            for i := 0 to 8 do begin
                if tp.CName[i] = '' then Continue;
                if tp.CData[i] = nil then Continue;

                if (tp.CData[i].GuildID = guildid) then begin
                    if GuildList.IndexOf(guildid) = -1 then Continue;
                    tg := GuildList.Objects[GuildList.IndexOf(guildid)] as TGuild;
                    Break;
                end;
            end;

        end else begin
            tg := TGuild.Create;
        end;

        Result := tg;
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { R.E.E.D - guild_is_online                                                             }
    { ------------------------------------------------------------------------------------- }
    { Purpose: To see if any guild members are online for loading purposes.                 }
    { Parameters:                                                                           }
    {  - tg : TGuild, Represents the party data to check.                                   }
    { Results:                                                                              }
    {  - Result : Boolean, Represents the return value of whether or not onnline.           }
    { ------------------------------------------------------------------------------------- }
    function guild_is_online(tg : TGuild) : Boolean;
    var
        i : Integer;
    begin
        Result := False;

        for i := 0 to tg.RegUsers - 1 do begin
            if (tg.MemberID[i] <> 0) then begin
                if (tg.Member[i] = nil) then Continue;
                if tg.Member[i].Login <> 0 then begin
                    Result := True;
                    Break;
                end;
            end;
        end;

    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { R.E.E.D - reed_savefile                                                               }
    { ------------------------------------------------------------------------------------- }
    { Purpose: To ensure reed files are properly saved and directories properly created.    }
    { Parameters:                                                                           }
    {  - folderid : Integer, Represents the id value of the data.                           }
    {  - datafile : TStringList, Represents the actual data being saved.                    }
    {  - path : String; Represents the location to save the data.                           }
    {  - pfile : String; Represents the filename of the data.                               }
    { ------------------------------------------------------------------------------------- }
    procedure reed_savefile(folderid : Variant; datafile : TStringList; path : String; pfile : String; vType : Integer = 0);
    begin
        CreateDir(path);
        
        if (vType = 0) then begin
        CreateDir(path + '\' + reed_convert_type(folderid, 1, -1));
        datafile.SaveToFile(path + '\' + reed_convert_type(folderid, 1, -1) + '\' + pfile);
        end else if (vType = 1) then begin
            CreateDir(path + '\' + folderid);
            datafile.SaveToFile(path + '\' + folderid + '\' + pfile);
        end;

        datafile.Clear;
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { R.E.E.D - compile_inventories                                                         }
    { ------------------------------------------------------------------------------------- }
    { Purpose: To ensure that inventory data is properly compiled for reed storage.         }
    { Parameters:                                                                           }
    {  - datafile : TStringList, Represents the actual data being saved.                    }
    {  - inventory_item : array of TItem, Represents the array of items being stored.       }
    { ------------------------------------------------------------------------------------- }
    procedure compile_inventories(datafile : TStringList; inventory_item : array of TItem);
    var
        j, k : Integer;
        len : Integer;
        str : String;
    begin
        datafile.Clear;
        datafile.Add('    ID :   AMT : EQP : I :  R : A : CARD1 : CARD2 : CARD3 : CARD4 : NAME');
        datafile.Add('---------------------------------------------------------------------------------------------------------');

        for j := 0 to 99 do begin
            if inventory_item[j].ID <> 0 then begin

                str := ' ';

                len := length(IntToStr(inventory_item[j].ID));
                for k := 0 to (5 - len) - 1 do begin
                    str := str + ' ';
                end;
                str := str + IntToStr(inventory_item[j].ID);
                str := str + ' : ';

                len := length(IntToStr(inventory_item[j].Amount));
                for k := 0 to (5 - len) - 1 do begin
                    str := str + ' ';
                end;
                str := str + IntToStr(inventory_item[j].Amount);
                str := str + ' : ';

                len := length(IntToStr(inventory_item[j].Equip));
                for k := 0 to (3 - len) - 1 do begin
                    str := str + ' ';
                end;
                str := str + IntToStr(inventory_item[j].Equip);
                str := str + ' : ';

                str := str + IntToStr(inventory_item[j].Identify);
                str := str + ' : ';

                len := length(IntToStr(inventory_item[j].Refine));
                for k := 0 to (2 - len) - 1 do begin
                    str := str + ' ';
                end;
                str := str + IntToStr(inventory_item[j].Refine);
                str := str + ' : ';
                str := str + IntToStr(inventory_item[j].Attr);
                str := str + ' : ';

                len := length(IntToStr(inventory_item[j].Card[0]));
                for k := 0 to (5 - len) - 1 do begin
                    str := str + ' ';
                end;
                str := str + IntToStr(inventory_item[j].Card[0]);
                str := str + ' : ';

                len := length(IntToStr(inventory_item[j].Card[1]));
                for k := 0 to (5 - len) - 1 do begin
                    str := str + ' ';
                end;
                str := str + IntToStr(inventory_item[j].Card[1]);
                str := str + ' : ';

                len := length(IntToStr(inventory_item[j].Card[2]));
                for k := 0 to (5 - len) - 1 do begin
                    str := str + ' ';
                end;
                str := str + IntToStr(inventory_item[j].Card[2]);
                str := str + ' : ';

                len := length(IntToStr(inventory_item[j].Card[3]));
                for k := 0 to (5 - len) - 1 do begin
                    str := str + ' ';
                end;
                str := str + IntToStr(inventory_item[j].Card[3]);
                str := str + ' : ';

                str := str + inventory_item[j].Data.Name;

                datafile.Add(str);
                
            end;
        end;
    end;
    { ------------------------------------------------------------------------------------- }
    

    { ------------------------------------------------------------------------------------- }
    { R.E.E.D - party_is_online                                                             }
    { ------------------------------------------------------------------------------------- }
    { Purpose: To see if any party members are online for loading purposes.                 }
    { Parameters:                                                                           }
    {  - tpa : TParty, Represents the party data to check.                                  }
    { Results:                                                                              }
    {  - Result : Boolean, Represents the return value of whether or not online.           }
    { ------------------------------------------------------------------------------------- }
    function party_is_online(tpa : TParty) : Boolean;
    var
        i : Integer;
    begin
        Result := False;

        for i := 0 to 11 do begin
            if not assigned(tpa.Member[i]) then tpa.MemberID[i] := 0;
            if (tpa.MemberID[i] <> 0) then begin
                if tpa.Member[i].Login <> 0 then begin
                    Result := True;
                    Break;
                end;
            end;
        end;

    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { R.E.E.D - reed_column_align                                                           }
    { ------------------------------------------------------------------------------------- }
    { Purpose: To provide a centralized location for formatting REED format data.           }
    { Parameters:                                                                           }
    {  - str : String, Represents the data to format.                                       }
    {  - count : Integer, Represents number of spaces to put ahead of string.               }
    {  - last : Boolean, Represents switch that determines if its the last column.          }
    { Results:                                                                              }
    {  - Result : String, Represents the fully formatted line to return.                    }
    { ------------------------------------------------------------------------------------- }    
    function reed_column_align(str : String; count : Integer; last : Boolean = True) : String;
    var
        len : Integer;
        result_string : String;
        i : Integer;
    begin
        result_string := '';

        len := length(str);
        for i := 0 to (count - len) - 1 do begin
            result_string := result_string + ' ';
        end;
        result_string := result_string + str;
        if last then result_string := result_string + ' : ';

        Result := result_string;
    end;
    { ------------------------------------------------------------------------------------- }
        

    { ------------------------------------------------------------------------------------- }
    { R.E.E.D - party_is_current                                                            }
    { ------------------------------------------------------------------------------------- }
    { Purpose: ensure that the members within the party still exist and are not dupes.      }
    { Parameters:                                                                           }
    {  - partyid : Integer, Represents the id of the Party.                                 }
    { Results:                                                                              }
    {  - Result : Boolean, Represents the value that determines whether or not to process.  }
    { ------------------------------------------------------------------------------------- }
    function party_is_current(partyid : Integer) : Boolean;
    var
        tpa : TParty;
        i : Integer;
    begin
        tpa := PartyList.Objects[PartyList.IndexOf(partyid)] as TParty;
        Result := False;

        for i := 0 to 11 do begin
            if (tpa.MemberID[i] = 0) or (tpa.Member[i].PData = nil) or (not (tpa.Member[i].PartyName = tpa.Name)) then Continue;
            Result := True;
            Break;
        end;
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { R.E.E.D - guild_is_current                                                            }
    { ------------------------------------------------------------------------------------- }
    { Purpose: ensure that the members within the guild still exist and are not dupes.      }
    { Parameters:                                                                           }
    {  - guildid : Integer, Represents the id of the Guild.                                 }
    { Results:                                                                              }
    {  - Result : Boolean, Represents the value that determines whether or not to process.  }
    { ------------------------------------------------------------------------------------- }
    function guild_is_current(guildid : Integer) : Boolean;
    var
        tg : TGuild;
        i : Integer;
    begin
        tg := GuildList.Objects[GuildList.IndexOf(guildid)] as TGuild;
        Result := False;

        for i := 0 to tg.RegUsers - 1 do begin
            if (tg.MemberID[i] = 0) or (tg.Member[i] = nil) or (not (tg.Member[i].GuildID = tg.ID)) then Continue;
            Result := True;
            Break;
        end;
    end;
    { ------------------------------------------------------------------------------------- }


    function get_pet_index(inventory_item : array of TItem; pet_id : Integer) : Integer;
    var
        i : Integer;
        tpe : TPet;
    begin
        for i := 0 to 99 do begin
            if (inventory_item[i].Card[0] = $FF00) then begin
                if (inventory_item[i].Card[1] = pet_id) then begin
                    Result := i + 1;
                    Break;
                end;
            end;
        end;
    end;

end.

