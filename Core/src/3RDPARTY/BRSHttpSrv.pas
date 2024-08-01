//////////////////////////////////////////////////////////////////////////
//
//  BRSHttpServer Copyright (C) 1999 Blaine R Southam
//
//  bsoutham@iname.com   http://bsoutham.home.dhs.com
//
//  This programs is free for commercial and non-commercial use as long as
//  the following conditions are aheared to.
//
//  Copyright remains Blaine R Southam, and as such any Copyright notices
//  in the code are not to be removed. If this package is used in a
//  product, Blaine R Southam should be given attribution for the parts of
//  the library used. This can be in the form of a textual message at
//  program startup or in documentation (online or textual) provided with
//  the package.
//
//  Redistribution and use in binary forms, with or without
//  modification, are permitted provided that the following conditions are
//  met:
//
//  1. Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in the
//     documentation and/or other materials provided with the distribution.
//  2. All advertising materials mentioning features or use of this software
//     must display the following acknowledgement:
//     "Based on BRSHttpServer by Blaine R Southam."
//
//  THIS SOFTWARE IS PROVIDED BY BLAINE R SOUTHAM "AS IS" AND ANY EXPRESS
//  OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
//  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
//  IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
//  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The licence and distribution terms for any publically available
//  version or derivative of this code cannot be changed. i.e. this code
//  cannot simply be copied and put under another distribution licence
//  (including the GNU Public Licence).
//
//////////////////////////////////////////////////////////////////////////

unit BRSHttpSrv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WSocket; //WinSock

type

  THttpGetEvent = procedure (Sender: TObject;
    const RemoteAddr, URI: string) of object;


  TBRSHttpSrv = class(TComponent)
  private
    { Private declarations }
    FSocket: TWSocket;
    FClient: TWSocket;
    FPort: integer;
    FOnGetEvent: THttpGetEvent;
    FDocsDir: string;
    FDefaultDoc: string;
  protected
    { Protected declarations }
    procedure SetDocsDir(Value: string);
    procedure SessionAvailable(Sender: TObject; Error: Word);
    procedure DataAvailable(Sender: TObject; Error: Word);
    procedure SendDocument(FileName: string);
    procedure SendFile(FileName: string);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
  published
    { Published declarations }
    property DocDirectory: string read FDocsDir write SetDocsDir;
    property Port: integer read FPort write FPort;
    property OnGetRequest: THttpGetEvent read FOnGetEvent write FOnGetEvent;
    property DefaultDoc: string read FDefaultDoc write FDefaultDoc;
  end;

procedure Register;

implementation

uses
    WAC;

procedure Register;
begin
  RegisterComponents('BRS Stuff', [TBRSHttpSrv]);
end;


constructor TBRSHttpSrv.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPort := 80;
  FSocket := TWSocket.Create(self);
  FSocket.MultiThreaded := False;
  FSocket.Addr := '0.0.0.0';
  FSocket.Port := IntToStr(FPort);
  FSocket.Proto := 'tcp';

  FSocket.OnSessionAvailable := SessionAvailable;

  FClient := TWSocket.Create(self);
  FClient.OnDataAvailable := DataAvailable;

  if (csDesigning in ComponentState) then
    FDocsDir := ExtractFilePath(Application.EXEName)
  else
    if FDocsDir = '' then
      FDocsDir := ExtractFilePath(Application.EXEName);
end;

destructor TBRSHttpSrv.Destroy;
begin
  FSocket.Free;
end;

procedure TBRSHttpSrv.Start;
begin
  FSocket.Port := IntToStr(FPort);
  FSocket.Listen;
end;

procedure TBRSHttpSrv.Stop;
begin
  FSocket.Close;
end;

procedure TBRSHttpSrv.SetDocsDir(Value: string);
begin
  if Value <> FDocsDir then
    if (Length(Value) > 0) and (Value[Length(Value)] = '\') then
      FDocsDir := Copy(Value,1,Length(Value) - 1)
    else
      FDocsDir := Value;
end;



procedure TBRSHttpSrv.SessionAvailable(Sender: TObject; Error: Word);
begin
  FClient.HSocket := FSocket.Accept;
end;



procedure TBRSHttpSrv.DataAvailable(Sender: TObject; Error: Word);
var
  Buffer: array [0..4095] of char;
  URI: string;
  Stream: TStream;
  Line: string;
  Addr: string;
  Doc: string;
begin
  Stream := nil;
  FClient.Receive(@Buffer, SizeOf(Buffer));
  { Pull out first line of request }
  URI := Copy(Buffer,1,Pos(#13#10,Buffer));
  { URI is not something like "GET /sample.html HTTP/1.0" }
  URI := Copy(URI,Pos(' ',URI)+1,Length(URI));
  URI := Copy(URI,1,Pos(' ',URI)-1);
  Addr := FClient.GetPeerAddr;

  Doc := FDocsDir + parse_wac(URI);

  if assigned(FOnGetEvent) then
    FOnGetEvent(Sender,Addr,URI);
  if Stream = nil then
  begin
    if FileExists(Doc) then
      SendDocument(Doc)
    else
    begin
      Doc := FDocsDir + URI + FDefaultDoc;
      if FileExists(Doc) then
        SendDocument(Doc)
      else
      begin
        Line := '<HTML><HEAD><TITLE>404 Not Found</TITLE></HEAD>' +
          '<BODY><H1>404 Not Found</H1>The requested URL ' + URI +
          ' was not found on this server.<P>';
        FClient.SendStr('HTTP/1.0 404 Not Found' + #13#10);
        FClient.SendStr('Content-Type: text/html' + #13#10);
        FClient.SendStr('Content-Length: ' + IntToStr(Length(Line)) + #13#10);
        FClient.SendStr(#13#10);
        FClient.SendStr(Line + #13#10);
      end
    end;
    FClient.Close;
  end;
end;


procedure TBRSHttpSrv.SendDocument(FileName: string);
begin
  FClient.SendStr('HTTP/1.0 200 OK' + #13#10);
  FClient.SendStr('Content-Type: text/html' + #13#10);
  FClient.SendStr(#13#10);
  SendFile(FileName);
end;


procedure TBRSHttpSrv.SendFile(FileName: string);
var
  fIn: file;
  fBuffer: array[0..1030] of Char;
  BytesRead: Integer;
  BytesWritten: integer;
begin
  {We basicly just open the file, read in the bytes and dump them to the
  socket}
{$I-}
  AssignFile(fIn, FileName);
  Reset(fIn, 1);
  while not Eof(fIn) do
  begin
    BlockRead(fIn, fBuffer, 1024, BytesRead);
    repeat
      BytesWritten := FClient.Send(@fBuffer, BytesRead);
    until BytesWritten <> 0;
    if BytesWritten = 0 then // Socket closed
    begin
      FClient.Close;
      Break;
    end;
  end;
  CloseFile(fIn);
  if IoResult = 0 then ;
{$I+}
end;








end.
