{
  Get Access to Speech API from DLL methods
  (c) Kirin Denis 2002-2003.  version 1.1 FREEWARE
  http://wtwsoft.narod.ru
  mailto:wtwsoft@narod.ru
}

unit SAPIInterface;
interface
uses Classes;
type
   DWORD = longint;
   LPCTSTR = PAnsiChar;
  TSpeechEvent = procedure;
  TPositionEvent = procedure(Position: dword);
  TEngineEvent = procedure(Number: integer; Name: string);
  TErrorEvent = procedure(Text: string);


  TEngineInfo = record
    Name: string;
    SpInterface: byte;
    Gender: string[10];
    Language: string[25];
  end;

function  CreateSpeech:HResult;stdcall;external 'SAPIDLL.DLL' name 'CreateSpeech';
procedure DestroySpeech;stdcall;external 'SAPIDLL.DLL';
procedure Speak( Text : string);stdcall;external 'SAPIDLL.DLL';
procedure SelectEngine(EngineName: String);stdcall;external 'SAPIDLL.DLL' name 'SelectEngine';
function  GetEngineInfo(EngineName: String; var Info: TEngineInfo):byte;stdcall;external 'SAPIDLL.DLL';
function  GetEngines:TStrings;stdcall;external 'SAPIDLL.DLL' name 'GetEngines';
function  GetEnginesCount:word;stdcall;external 'SAPIDLL.DLL';
function  GetPitch: Word;stdcall;external 'SAPIDLL.DLL';
function  GetSpeed: dword;stdcall;external 'SAPIDLL.DLL';
function  GetVolume: dword;stdcall;external 'SAPIDLL.DLL';
procedure SetPitch(const Value: Word);stdcall;external 'SAPIDLL.DLL';
procedure SetSpeed(const Value: dword);stdcall;external 'SAPIDLL.DLL';
procedure SetVolume(const Value: dword);stdcall;external 'SAPIDLL.DLL';
function  GetMaxPitch: Word;stdcall;external 'SAPIDLL.DLL';
function  GetMaxSpeed: dword;stdcall;external 'SAPIDLL.DLL';
function  GetMaxVolume: dword;stdcall;external 'SAPIDLL.DLL';
function  GetMinPitch: Word;stdcall;external 'SAPIDLL.DLL';
function  GetMinSpeed: dword;stdcall;external 'SAPIDLL.DLL';
function  GetMinVolume: dword;stdcall;external 'SAPIDLL.DLL';
Procedure Pause;stdcall;external 'SAPIDLL.DLL';
Procedure Resume;stdcall;external 'SAPIDLL.DLL';
Procedure Stop;stdcall;external 'SAPIDLL.DLL';
//
procedure PSpeak( Text: LPCTSTR );stdcall;external 'SAPIDLL.DLL';
procedure PSelectEngine(EngineName: LPCTSTR);stdcall;external 'SAPIDLL.DLL';
procedure PSelectEngineNumber(EngineNumber: word);stdcall;external 'SAPIDLL.DLL';
function  PGetEngines( number : word):LPCTSTR;stdcall;external 'SAPIDLL.DLL';

procedure RegistOnStart(CallbackAddr: TSpeechEvent);stdcall;external 'SAPIDLL.DLL';
procedure RegistOnPause(CallbackAddr: TSpeechEvent);stdcall;external 'SAPIDLL.DLL';
procedure RegistOnResume(CallbackAddr: TSpeechEvent);stdcall;external 'SAPIDLL.DLL';
procedure RegistOnStop(CallbackAddr: TSpeechEvent);stdcall;external 'SAPIDLL.DLL';
procedure RegistOnUserStart(CallbackAddr: TSpeechEvent);stdcall;external 'SAPIDLL.DLL';
procedure RegistOnUserStop(CallbackAddr: TSpeechEvent);stdcall;external 'SAPIDLL.DLL';
procedure RegistOnPosition(CallbackAddr: TPositionEvent);stdcall;external 'SAPIDLL.DLL';
procedure RegistOnSpeed(CallbackAddr: TPositionEvent);stdcall;external 'SAPIDLL.DLL';
procedure RegistOnVolume(CallbackAddr: TPositionEvent);stdcall;external 'SAPIDLL.DLL';
procedure RegistOnPitch(CallbackAddr: TPositionEvent);stdcall;external 'SAPIDLL.DLL';
procedure RegistOnSelectEngine(CallbackAddr: TEngineEvent);stdcall;external 'SAPIDLL.DLL';
procedure RegistOnStatusChange(CallbackAddr: TSpeechEvent);stdcall;external 'SAPIDLL.DLL';
procedure RegistOnError(CallbackAddr: TErrorEvent);stdcall;external 'SAPIDLL.DLL';



implementation

end.
