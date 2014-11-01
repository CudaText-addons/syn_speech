{
  Get Access to Speech API from DLL methods [SAPI4, SAPI5 support]
  (c) Kirin Denis 2002-2006.  version 2.0 GNU GPL
  http://wtwsoft.narod.ru
  mailto:wtwsoft@narod.ru
}


{$A+}
unit SAPI4;
interface
uses Windows, SysUtils;
Const
{CLSID_TTSEnumerator
CLSID_AudioDestFile
CLSID_MMAudioDest  used class }

  {$EXTERNALSYM CLSID_TTSEnumerator}
  CLSID_TTSEnumerator: TGUID = '{d67c0280-c743-11cd-80e5-00aa003e4b50}';
  {$EXTERNALSYM CLSID_AudioDestFile}
  CLSID_AudioDestFile: TGUID = '{d4623720-e4b9-11cf-8d56-00a0c9034a7e}';
  {$EXTERNALSYM CLSID_MMAudioDest}
  CLSID_MMAudioDest: TGUID = '{cb96b400-c743-11cd-80e5-00aa003e4b50}';


{
IID_ITTSEnum

IID_IAudioFile
IID_IAudioMultiMediaDevice
IID_ITTSFind
IID_ITTSAttributes
IID_ITTSDialogs
IID_ITTSNotifySink2
IID_ITTSNotifySink
IID_ITTSBufNotifySink used IDD }

  {$EXTERNALSYM IID_ITTSEnum}
  IID_ITTSEnum: TGUID = '{05EB6C6D-DBAB-11CD-B3CA-00AA0047BA4F}';
  {$EXTERNALSYM IID_IAudioFile}
  IID_IAudioFile: TGUID = '{fd7c2320-3d6d-11b9-c000-fed6cba3b1a9}';

 {$EXTERNALSYM IID_ITTSAttributes}
  IID_ITTSAttributes: TGUID = '{0FD6E2A1-E77D-11CD-B3CA-00AA0047BA4F}';


  {$EXTERNALSYM IID_IAudioMultiMediaDevice}
  IID_IAudioMultiMediaDevice: TGUID = '{b68ad320-c743-11cd-80e5-00aa003e4b50}';


  {$EXTERNALSYM IID_ITTSDialogs}
  IID_ITTSDialogs: TGUID = '{05EB6C6B-DBAB-11CD-B3CA-00AA0047BA4F}';

  {$EXTERNALSYM IID_ITTSFind}
  IID_ITTSFind: TGUID = '{05EB6C6E-DBAB-11CD-B3CA-00AA0047BA4F}';

  {$EXTERNALSYM IID_ITTSNotifySink2}
  IID_ITTSNotifySink2: TGUID = '{599f77e2-e42e-11d1-bed8-006008317ce8}';

  {$EXTERNALSYM IID_ITTSNotifySink}
  IID_ITTSNotifySink: TGUID = '{05EB6C6F-DBAB-11CD-B3CA-00AA0047BA4F}';

  {$EXTERNALSYM IID_ITTSBufNotifySink}
  IID_ITTSBufNotifySink: TGUID = '{e4963d40-c743-11cd-80e5-00aa003e4b50}';

//////////////////////////////////////////////////////////////////

  SVFN_LEN     = 262;
  LANG_LEN     = 64;

  TTSI_NAMELEN                 = SVFN_LEN;
  TTSI_STYLELEN                = SVFN_LEN;

  {$EXTERNALSYM TTSATTR_MINPITCH}
  TTSATTR_MINPITCH            = 0;
  {$EXTERNALSYM TTSATTR_MAXPITCH}
  TTSATTR_MAXPITCH            = $ffff;
  {$EXTERNALSYM TTSATTR_MINREALTIME}
  TTSATTR_MINREALTIME         = 0;
  {$EXTERNALSYM TTSATTR_MAXREALTIME}
  TTSATTR_MAXREALTIME         = DWORD($ffffffff);
  {$EXTERNALSYM TTSATTR_MINSPEED}
  TTSATTR_MINSPEED            = 0;
  {$EXTERNALSYM TTSATTR_MAXSPEED}
  TTSATTR_MAXSPEED            = DWORD($ffffffff);
  {$EXTERNALSYM TTSATTR_MINVOLUME}
  TTSATTR_MINVOLUME           = 0;
  {$EXTERNALSYM TTSATTR_MAXVOLUME}
  TTSATTR_MAXVOLUME           = DWORD($ffffffff);

  {$EXTERNALSYM CHARSET_TEXT}
  CHARSET_TEXT = 0;

 SID_ISpchErrorA              = '{9b445336-e39f-11d1-bed7-006008317ce8}'; //SAPI 4
 SID_ITTSFindA                = '{05EB6C6E-DBAB-11CD-B3CA-00AA0047BA4F}';
 SID_ITTSEnumA                = '{05EB6C6D-DBAB-11CD-B3CA-00AA0047BA4F}';
 SID_ITTSDialogsA             = '{05EB6C6B-DBAB-11CD-B3CA-00AA0047BA4F}';
 SID_ITTSCentralA             = '{05EB6C6A-DBAB-11CD-B3CA-00AA0047BA4F}';
 SID_ITTSAttributesA          = '{0FD6E2A1-E77D-11CD-B3CA-00AA0047BA4F}';
 SID_IAudioMultiMediaDevice = '{B68AD320-C743-11cd-80E5-00AA003E4B50}';
 SID_IAudioFileNotifySink   = '{492FE490-51E7-11b9-C000-FED6CBA3B1A9}'; {SAPI 3}
 SID_IAudioFile             = '{FD7C2320-3D6D-11b9-C000-FED6CBA3B1A9}'; {SAPI 3}
 SID_ITTSBufNotifySink      = '{E4963D40-C743-11cd-80E5-00AA003E4B50}';
 SID_ITTSNotifySinkA          = '{05EB6C6F-DBAB-11CD-B3CA-00AA0047BA4F}';


type
  VOICECHARSET = UINT;

  QWORD  = Int64;

  PSpchErrorA = ^TSpchErrorA;
  PSpchError = PSpchErrorA;
  SPCHERROR = record
    hRes: HRESULT;
    szStrings: array[0..511] of AnsiChar;
  end;
  TSpchErrorA = SPCHERROR;
  
  PSData = ^TSData;
  {$EXTERNALSYM SDATA}
  SDATA = record
    pData: pointer;
    dwSize: DWORD;
  end;
  TSData = SDATA;

  PTTSMouth = ^TTTSMouth;
  TTSMOUTH = record
    bMouthHeight:        BYTE;
    bMouthWidth:         BYTE;
    bMouthUpturn:        BYTE;
    bJawOpen:            BYTE;
    bTeethUpperVisible:  BYTE;
    bTeethLowerVisible:  BYTE;
    bTonguePosn:         BYTE;
    bLipTension:         BYTE;
  end;
  TTTSMouth = TTSMOUTH;


  LANGUAGEA = record
    LanguageID: integer;
    szDialect: array[0..LANG_LEN - 1] of AnsiChar;
  end;
  TLanguageA = LANGUAGEA;

  PTTSModeInfo = ^TTTSModeInfo;
  TTSMODEINFO = record
    gEngineID        : TGUID;
    szMfgName        : array [0..TTSI_NAMELEN-1] of AnsiChar;
    szProductName    : array [0..TTSI_NAMELEN-1] of AnsiChar;
    gModeID          : TGUID;
    szModeName       : array [0..TTSI_NAMELEN-1] of AnsiChar;
    Language         : TLanguageA;
    szSpeaker        : array [0..TTSI_NAMELEN-1] of AnsiChar;
    szStyle          : array [0..TTSI_STYLELEN-1] of AnsiChar;
    wGender          : WORD;
    wAge             : WORD;
    dwFeatures       : DWORD;
    dwInterfaces     : DWORD;
    dwEngineFeatures : DWORD;
  end;

  TTTSModeInfo = TTSMODEINFO;

  PTTSModeInfoRank = ^TTTSModeInfoRank;
  {$EXTERNALSYM TTSMODEINFORANK}
  TTSMODEINFORANK = record
    dwEngineID       : DWORD;
    dwMfgName        : DWORD;
    dwProductName    : DWORD;
    dwModeID         : DWORD;
    dwModeName       : DWORD;
    dwLanguage       : DWORD;
    dwDialect        : DWORD;
    dwSpeaker        : DWORD;
    dwStyle          : DWORD;
    dwGender         : DWORD;
    dwAge            : DWORD;
    dwFeatures       : DWORD;
    dwInterfaces     : DWORD;
    dwEngineFeatures : DWORD;
  end;
  TTTSModeInfoRank = TTSMODEINFORANK;




  ISpchError = interface(IUnknown)
    [SID_ISpchErrorA]
    function LastErrorGet(pError: SPCHERROR): HResult; stdcall;
    function ErrorMessageGet(pszMessage: PAnsiChar; dwMessageSize: DWORD;
      var dwNeeded: DWORD): HResult; stdcall;
   end;


  ITTSDialogs = interface(IUnknown)
    [SID_ITTSDialogsA]
    function AboutDlg(hWndParent: HWND; pszTitle: PAnsiChar): HResult; stdcall;
    function LexiconDlg(hWndParent: HWND; pszTitle: PAnsiChar): HResult; stdcall;
    function GeneralDlg(hWndParent: HWND; pszTitle: PAnsiChar): HResult; stdcall;
    function TranslateDlg(hWndParent: HWND; pszTitle: PAnsiChar): HResult; stdcall;
  end;


  ITTSCentralA = interface(IUnknown)
    [SID_ITTSCentralA]
    function Inject(pszTag: PAnsiChar): HResult; stdcall;
    function ModeGet(var ttsInfo: TTTSModeInfo): HResult; stdcall;
    function Phoneme(eCharacterSet: VOICECHARSET; dwFlags: DWORD; dText: SDATA;
      var dPhoneme: SDATA): HResult; stdcall;
    function PosnGet(var qwTimeStamp: QWORD): HResult; stdcall;
    function TextData(eCharacterSet: VOICECHARSET; dwFlags: DWORD; dText: SDATA;
      pNotifyInterface: Pointer; IIDNotifyInterface: TGUID): HResult; stdcall;
    function ToFileTime(var qTimeStamp: QWORD; var FT: TFileTime): HResult; stdcall;
    function AudioPause: HResult; stdcall;
    function AudioResume: HResult; stdcall;
    function AudioReset: HResult; stdcall;
    function Register(pNotifyInterface: Pointer; IIDNotifyInterface: TGUID;
      var dwKey: DWORD): HResult; stdcall;
    function UnRegister(dwKey: DWORD): HResult; stdcall;
  end;

  ITTSEnum = interface(IUnknown)
    [SID_ITTSEnumA]
    function Next(celt: ULONG; var rgelt; pceltFetched: PULONG): HResult; stdcall;
    function Skip(celt: ULONG): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out enum: ITTSEnum): HResult; stdcall;
    function Select(gModeID: TGUID; out ITTSCentral: ITTSCentralA;
      IUnknownForAudio: IUnknown): HResult; stdcall;
  end;

  ITTSFind = interface(IUnknown)
    [SID_ITTSFindA]
    function Find(var ttsInfo: TTTSModeInfo; pttsInfoRank: PTTSModeInfoRank;
      var ttsInfoFound: TTTSModeInfo): HResult; stdcall;
    function Select(gModeID: TGUID; out ITTSCentral: ITTSCentralA;
      IUnknownForAudio: IUnknown): HResult; stdcall;
  end;

  ITTSAttributesA = interface(IUnknown)
    [SID_ITTSAttributesA]
    function PitchGet(var wPitch: WORD): HResult; stdcall;
    function PitchSet(wPitch: WORD): HResult; stdcall;
    function RealTimeGet(var dwRealTime: DWORD): HResult; stdcall;
    function RealTimeSet(dwRealTime: DWORD): HResult; stdcall;
    function SpeedGet(var dwSpeed: DWORD): HResult; stdcall;
    function SpeedSet(dwSpeed: DWORD): HResult; stdcall;
    function VolumeGet(var dwVolume: DWORD): HResult; stdcall;
    function VolumeSet(dwVolume: DWORD): HResult; stdcall;
  end;


  {$EXTERNALSYM IAudioMultiMediaDevice}
  IAudioMultiMediaDevice = interface(IUnknown)
    [SID_IAudioMultiMediaDevice]
    function CustomMessage(uMsg: UINT; dData: SDATA): HResult; stdcall;
    function DeviceNumGet(var dwDeviceID: DWORD): HResult; stdcall;
    function DeviceNumSet(dwDeviceID: DWORD): HResult; stdcall;
  end; // IAudioMultiMediaDevice


  {$EXTERNALSYM IAudioFileNotifySink}
  IAudioFileNotifySink = interface(IUnknown)
    [SID_IAudioFileNotifySink]
    function FileBegin(dwID: DWORD): HResult; stdcall;
    function FileEnd(dwID: DWORD): HResult; stdcall;
    function QueueEmpty: HResult; stdcall;
    function Posn(qwProcessed: QWORD; qwLeft: QWORD): HResult; stdcall;
  end;

  IAudioFile = interface(IUnknown) //Unicode only
    [SID_IAudioFile]
    function Register(NotifyInterface: IAudioFileNotifySink): HResult; stdcall;
    function DoSet(pszFile: LPCWSTR; dwID: DWORD): HResult; stdcall;
    function Add(pszFile: LPCWSTR; dwID: DWORD): HResult; stdcall;
    function Flush: HResult; stdcall;
    function RealTimeSet(wRealTime: WORD): HResult; stdcall;
    function RealTimeGet(var wRealTime: WORD): HResult; stdcall;
  end;

  {$EXTERNALSYM ITTSBufNotifySink}
  ITTSBufNotifySink = interface(IUnknown)
    [SID_ITTSBufNotifySink]
    function TextDataDone(qTimeStamp: QWORD; dwFlags: DWORD): HResult; stdcall;
    function TextDataStarted(qTimeStamp: QWORD): HResult; stdcall;
    function BookMark(qTimeStamp: QWORD; dwMarkNum: DWORD): HResult; stdcall;
    function WordPosition(qTimeStamp: QWORD; dwByteOffset: DWORD): HResult; stdcall;
  end;


  ITTSNotifySinkA = interface(IUnknown)
    [SID_ITTSNotifySinkA]
    function AttribChanged(dwAttribute: DWORD): HResult; stdcall;
    function AudioStart(qTimeStamp: QWORD): HResult; stdcall;
    function AudioStop(qTimeStamp: QWORD): HResult; stdcall;
    function Visual(qTimeStamp: QWORD; cIPAPhoneme: AnsiChar; cEnginePhoneme: AnsiChar;
      dwHints: DWORD; pTTSMouth: PTTSMOUTH): HResult; stdcall;
  end;

  {$EXTERNALSYM ITTSNotifySink2A}
  ITTSNotifySink2A = interface(ITTSNotifySinkA)
    [SID_ITTSNotifySinkA]
    function Error(Error: IUnknown): HResult; stdcall;
    function Warning(Warning: IUnknown): HResult; stdcall;
    function VisualFuture(dwMilliseconds: DWORD; qTimeStamp: QWORD;
      cIPAPhoneme: AnsiChar; cEnginePhoneme: AnsiChar; dwHints: DWORD;
      pTTSMouth: PTTSMouth): HResult; stdcall;
  end;

  {$EXTERNALSYM ITTSNotifySink2}
  ITTSNotifySink2 = ITTSNotifySink2A;

implementation

end.





