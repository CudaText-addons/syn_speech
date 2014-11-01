library Speech;

uses
  Windows,
  SpeechUnit,
  Classes,
  IniFiles,
  ATSynPlugins in 'ATSynPlugins.pas',
  unOpt in 'unOpt.pas' {fmOpt};

var
  _ActionProc: TSynAction = nil;
  _DefaultIni: string = '';
  OpVoice: string;
  OpSpeed, OpVol: Integer;

const
  cCaption = 'Speech';
  cSec = 'Speech';

procedure LoadOpt;
begin
  with TIniFile.Create(_DefaultIni) do
  try
    OpVoice:= ReadString(cSec, 'Voice', '');
    OpSpeed:= ReadInteger(cSec, 'Speed', 0);
    OpVol:= ReadInteger(cSec, 'Vol', 100);
  finally
    Free
  end;
end;

procedure SaveOpt;
begin
  with TIniFile.Create(_DefaultIni) do
  try
    WriteString(cSec, 'Voice', OpVoice);
    WriteInteger(cSec, 'Speed', OpSpeed);
    WriteInteger(cSec, 'Vol', OpVol);
  finally
    Free
  end;
end;

procedure DoSay(const S: Widestring);
const
  cMinLen = 2;
  cMaxShow = 1500;
var
  L: TStrings;
  Eng: string;
begin
  if Length(S)<cMinLen then
  begin
    MessageBoxW(0, 'Text not selected', cCaption, mb_taskmodal or mb_ok or mb_iconwarning);
    Exit
  end;

  SpeechInit;
  L:= GetEngines;
  if (L=nil) or (L.Count<1) then Exit;
  if OpVoice='' then
    Eng:= L[0]
  else
    Eng:= OpVoice;
  SpeechSelectEngine(Eng);

  if OpSpeed>0 then
    SetSpeed(OpSpeed);
  if OpVol>0 then
    SetVolume(OpVol);

  SpeechSpeak(S);
  MessageBoxW(0, PWChar(Copy(S, 1, cMaxShow)), cCaption, mb_taskmodal or mb_ok {or mb_iconinformation});
  SpeechStop; //dll unloads after this, so stop
end;

function EdText: Widestring;
const
  cSize = 100*1024;
var
  buf: array[0..cSize-1] of WideChar;
  bufSize: Integer;
  r: Integer;
begin
  Result:= '';

  FillChar(buf, SizeOf(buf), 0);
  bufSize:= cSize;
  r:= _ActionProc(nil, cActionGetText, Pointer(cSynIdSelectedText), @buf, @bufSize, nil);
  if r=cSynOk then
    Result:= buf;
end;

function SynAction(AHandle: Pointer; AName: PWideChar; A1, A2, A3, A4: Pointer): Integer; stdcall;
var
  SCmd, SId: Widestring;
begin
  Result:= cSynBadCmd;
  SCmd:= PWideChar(AName);

  if SCmd=cActionMenuCommand then
  begin
    SId:= PWideChar(A1);

    if SId='say' then
    begin
      LoadOpt;
      DoSay(EdText);
    end;

    if SId='options' then
    begin
      LoadOpt;
      if DoOpt(OpVoice, OpSpeed, OpVol) then
        SaveOpt;
    end;

    Result:= cSynOK;
    Exit
  end;
end;

procedure SynInit(ADefaultIni: PWideChar; AActionProc: Pointer); stdcall;
begin
  _ActionProc:= AActionProc;
  _DefaultIni:= Widestring(PWChar(ADefaultIni));
end;


exports
  SynAction,
  SynInit;

//following is to check types
var
  _Action: TSynAction;
  _Init: TSynInit;
begin
  _Action:= SynAction;
  _Init:= SynInit;
  if @_Action<>nil then begin end;
  if @_Init<>nil then begin end;

end.
