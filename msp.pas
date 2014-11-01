unit msp;

interface
uses
  SysUtils, Windows, Classes, sapi4, sapi5cut, ActiveX;

const
  NotSelected = -1;
  SAPI4Code = 0;
  SAPI5Code = 1;


  DefaultVolume = 50;
  DefaultSpeed = 10;
  DefaultPitch = 0;

  MaxSpeed = 20;
  MinSpeed = 0;

  MaxVolume = 100;
  MinVolume = 0;

  MaxPitch = 20;
  MinPitch = 0;


type
  TEngineState = set of (esSpeak, esPause, esStop);
  TEngineInfo = record
    Name: string;
    Gender: string;
    Language: string;
    SpInterface: byte;
  end;


  TTTSBufNotifySink = class(TInterfacedObject, ITTSBufNotifySink)
  protected
    Owner: TComponent;
    function TextDataDone(qTimeStamp: QWORD; dwFlags: DWORD): HResult; stdcall;
    function TextDataStarted(qTimeStamp: QWORD): HResult; stdcall;
    function BookMark(qTimeStamp: QWORD; dwMarkNum: DWORD): HResult; stdcall;
    function WordPosition(qTimeStamp: QWORD; dwByteOffset: DWORD): HResult; stdcall;
  public
    constructor Create(AOwner: TComponent);
  end;

  TSelectEngineEvent = procedure(Sender: TObject; Number: integer; const Name: string) of object;
  TPositionEvent = procedure(Sender: TObject; Position: dword) of object;
  TErrorEvent = procedure(Sender: TObject; const Text: Widestring) of object;

  TMultiSpeech = class(TComponent)
  protected
    FOnStart: TNotifyEvent;
    FOnPause: TNotifyEvent;
    FOnResume: TNotifyEvent;
    FOnStop: TNotifyEvent;
    FOnUserStart: TNotifyEvent;
    FOnUserStop: TNotifyEvent;
    FOnPosition: TPositionEvent;
    FOnSpeed: TPositionEvent;
    FOnVolume: TPositionEvent;
    FOnPitch: TPositionEvent;
    FOnSelectEngine: TSelectEngineEvent;
    FOnStatusChange: TNotifyEvent;
    FOnError: TErrorEvent;
    FSpeed: integer;
    FVolume: integer;
    FPitch: integer;
    FEngineState: TEngineState;
    TTSEnum: ITTSEnum;
    TTSCentral: ITTSCentralA;
    TTSAttributes: ITTSAttributesA;
    AudioMultimediaDevice: IAudioMultimediaDevice;
    TTSBufNotifySink: ITTSBufNotifySink;
    SAPI5: TSpVoice;
    UserStop: boolean;
    FEngineInfo: TEngineInfo;


    procedure StartStream(ASender: TObject; StreamNumber: Integer; StreamPosition: OleVariant);
    procedure EndStream(ASender: TObject; StreamNumber: Integer; StreamPosition: OleVariant);
    procedure SpWord(ASender: TObject; StreamNumber: Integer; StreamPosition: OleVariant; CharacterPosition, Length: Integer);

    function GetSpeed: integer;
    procedure SetSpeed(Value: integer);

    function GetVolume: integer;
    procedure SetVolume(Value: integer);

    function GetPitch: integer;
    procedure SetPitch(Value: integer);
    procedure AddError(const Text: Widestring);

    procedure DoStop;
  public
    BufferText: Widestring;
    BufferPosition: dword;
    FLastPosition: longint;
    CurrentInterface: integer;
    ErrorList: TStringList;
    Engines: TStringList;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Speak(const Text: Widestring);
    procedure Stop;
    procedure Pause;
    procedure Resume;
    procedure Select(Number: integer); overload;
    procedure Select(const EngineName: string); overload;


  published
    property Speed: integer read GetSpeed write SetSpeed default 10;
    property Volume: integer read GetVolume write SetVolume default 50;
    property Pitch: integer read GetPitch write SetPitch default 10;
    property EngineState: TEngineState read FEngineState write FEngineState;
    property EngineInfo: TEngineInfo read FEngineInfo write FEngineInfo;
    property OnStart: TNotifyEvent read FOnStart write FOnStart;
    property OnPause: TNotifyEvent read FOnPause write FOnPause;
    property OnResume: TNotifyEvent read FOnResume write FOnResume;    
    property OnStop: TNotifyEvent read FOnStop write FOnStop;
    property OnUserStart: TNotifyEvent read FOnUserStart write FOnUserStart;
    property OnUserStop: TNotifyEvent read FOnUserStop write FOnUserStop;

    property OnPosition: TPositionEvent read FOnPosition write FOnPosition;
    property OnSpeed: TPositionEvent read FOnSpeed write FOnSpeed;
    property OnVolume: TPositionEvent read FOnVolume write FOnVolume;
    property OnPitch: TPositionEvent read FOnPitch write FOnPitch;
    property OnSelectEngine: TSelectEngineEvent read FOnSelectEngine write FOnSelectEngine;
    property OnStatusChange: TNotifyEvent read FOnStatusChange write FOnStatusChange;    
    property OnError: TErrorEvent read FOnError write FOnError;


  end;

var
  Sp: TMultiSpeech;

  procedure Register;
implementation


constructor TTTSBufNotifySink.Create(AOwner: TComponent);
begin
  inherited Create;
  Owner := AOwner;
end;

function TTTSBufNotifySink.TextDataDone(qTimeStamp: QWORD; dwFlags: DWORD): HResult; stdcall;
begin
//  if TMultiSpeech(Owner).EngineState = [esStop] then Exit;
  TMultiSpeech(Owner).EngineState := [esStop];
  if Assigned(TMultiSpeech(Owner).OnStatusChange) then TMultiSpeech(Owner).OnStatusChange(Self);  
  if not TMultiSpeech(Owner).UserStop then
   if Assigned(TMultiSpeech(Owner).OnStop) then TMultiSpeech(Owner).OnStop(Self);
  TMultiSpeech(Owner).UserStop := false;
  result := 0;
end;

function TTTSBufNotifySink.TextDataStarted(qTimeStamp: QWORD): HResult; stdcall;
begin
  TMultiSpeech(Owner).UserStop := false;
  TMultiSpeech(Owner).EngineState := [esSpeak];
  if Assigned(TMultiSpeech(Owner).OnStatusChange) then TMultiSpeech(Owner).OnStatusChange(Self);
  if Assigned(TMultiSpeech(Owner).OnStart) then TMultiSpeech(Owner).OnStart(Self);
  result := 0;
end;

function TTTSBufNotifySink.BookMark(qTimeStamp: QWORD; dwMarkNum: DWORD): HResult; stdcall;
begin
  result := 0;
end;

function TTTSBufNotifySink.WordPosition(qTimeStamp: QWORD; dwByteOffset: DWORD): HResult; stdcall;
begin
  TMultiSpeech(Owner).FLastPosition := dwByteOffset + TMultiSpeech(Owner).BufferPosition;
  if Assigned(TMultiSpeech(Owner).OnPosition) then TMultiSpeech(Owner).OnPosition(Self, TMultiSpeech(Owner).FLastPosition);
  result := 0;
end;


constructor TMultiSpeech.Create(AOwner: TComponent);
var
  result: dword;
  EngineCount: dword;
  Info: TTSMODEINFO;
begin
  inherited Create(AOwner);

  BufferPosition := 0;
  CurrentInterface := NotSelected;
  FVolume := DefaultVolume;
  FSpeed := DefaultSpeed;
  FPitch := DefaultPitch;
  FillChar(FEngineInfo, SizeOf(EngineInfo), #0);

  EngineState := [esStop];
  if Assigned(OnStatusChange) then OnStatusChange(Self);
  ErrorList := TStringList.Create;
  Engines := TStringList.Create;
  try
    SAPI5 := TSpVoice.Create(Self);
    SAPI5.OnStartStream := StartStream;
    SAPI5.OnEndStream := EndStream;
    SAPI5.OnWord := SpWord;
    for EngineCount := 0 to SAPI5.GetVoices('', '').count - 1 do
      Engines.Add(SAPI5.GetVoices('', '').Item(EngineCount).GetDescription(0));
  except
    AddError('SAPI 5 initialization fault');
  end;

  try
    Result := CoCreateInstance(CLSID_TTSEnumerator, nil, CLSCTX_ALL, IID_ITTSEnum, TTSEnum);
    if Result = 0 then
    begin
      TTSBufNotifySink := TTTSBufNotifySink.Create(Self);
      CoCreateInstance(CLSID_MMAudioDest, nil, CLSCTX_ALL, IID_IAudioMultiMediaDevice, AudioMultiMediaDevice);
      TTSEnum.Reset;
      TTSEnum.Next(1, Info, PULONG(@EngineCount));
      while EngineCount > 0 do
      begin
        Engines.Add(string(Info.szModeName));
        TTSEnum.Next(1, Info, @EngineCount);
      end;
    end;
  except
    AddError('SAPI 4 initialization fault');
  end;
end;

destructor TMultiSpeech.Destroy;
begin
  Stop;
  CoDisconnectObject(AudioMultiMediaDevice, 0);
  SAPI5.Destroy;
  Engines.Destroy;
  ErrorList.Destroy;

  inherited Destroy;
end;

procedure TMultiSpeech.AddError(const Text: Widestring);
begin
  ErrorList.Add(Text);
  if Assigned(OnError) then OnError(Self, Text);
end;

procedure TMultiSpeech.DoStop;
begin
  EngineState := [esStop];
  if Assigned(OnStatusChange) then OnStatusChange(Self);
  case CurrentInterface of
    NotSelected: Exit;
    SAPI5Code:
      begin
        SAPI5.Disconnect;
      end;
    SAPI4Code: if TTSCentral <> nil then
      begin
        TTSCentral.AudioReset;
        //Select(EngineInfo.Name);
      end;
  end;
end;

procedure TMultiSpeech.Select(Number: integer);
var
  Info: TTSMODEINFO;
  EngineCount: dword;
  pLanguageName: PChar;
begin
  DoStop;
  ZeroMemory(@EngineInfo, SizeOf(EngineInfo));
  CurrentInterface := NotSelected;
  if Number > Engines.Count - 1 then Exit;
  try
    if Number < SAPI5.GetVoices('', '').Count then
    begin
      CurrentInterface := SAPI5Code;
      SAPI5.Voice := SAPI5.GetVoices('', '').Item(Number);
      FEngineInfo.SpInterface := SAPI5Code;
      FEngineInfo.Gender := AnsiUpperCase(SAPI5.Voice.GetAttribute('GENDER'));
      GetMem(pLanguageName, 80);
      VerLanguageName(cardinal(SAPI5.Voice.GetAttribute('LANGUAGE')), pLanguageName, 80);
      FEngineInfo.Language := string(PLanguageName);
      FreeMem(pLanguageName, 80);
    end
    else
    begin
      if TTSCentral <> nil then TTSCentral.AudioReset;
      CurrentInterface := SAPI4Code;
      CoDisconnectObject(AudioMultiMediaDevice, 0);
      CoCreateInstance(CLSID_MMAudioDest, nil, CLSCTX_ALL, IID_IAudioMultiMediaDevice, AudioMultiMediaDevice);
      CoDisconnectObject(TTSAttributes, 0);
      CoDisconnectObject(TTSCentral, 0);

      TTSEnum.Reset;
      TTSEnum.Skip(Number - SAPI5.GetVoices('', '').Count);
      TTSEnum.Next(1, Info, @EngineCount);
      TTSEnum.Select(Info.gModeID, TTSCentral, AudioMultimediaDevice);
      TTSCentral.QueryInterface(IID_ITTSAttributes, TTSAttributes);
      FEngineInfo.SpInterface := SAPI4Code;
      case info.wGender of
        0: FEngineInfo.Gender := 'NEUTRAL';
        1: FEngineInfo.Gender := 'FEMALE';
        2: FEngineInfo.Gender := 'MALE';
      end;
      GetMem(pLanguageName, 80);
      VerLanguageName(info.Language.LanguageID, pLanguageName, 80);
      FEngineInfo.Language := string(PLanguageName);
      FreeMem(pLanguageName, 80);
    end;

    FEngineInfo.Name := Engines[Number];

    if Assigned(OnSelectEngine) then OnSelectEngine(Self, Number, FEngineInfo.Name);

  except
    AddError('Select ');
  end;
end;

procedure TMultiSpeech.Select(const EngineName: string);
var
  Count: integer;
begin
  for Count := 0 to Engines.Count - 1 do
    if Engines[Count] = EngineName then
    begin
      Select(Count);
      break;
    end;
end;

procedure TMultiSpeech.Speak(const Text: Widestring);
var
  TextA: string;
  SData: TSData;
  Flags: TOleEnum;
begin
  if Text = '' then Exit;
  if Assigned(OnUserStart) then OnUserStart(Self);
  BufferPosition := 0;
  case CurrentInterface of
    NotSelected: Exit;
    SAPI5Code:
      begin
        try
         Flags:= SVSFlagsAsync;
         SAPI5.DefaultInterface.Speak(Text, Flags);
        except
         AddError('SAPI 5 Speak fault: ');
        end;
      end;
    SAPI4Code:
      begin
        TextA:= Text;
        SData.dwSize := Length(TextA) + 1;
        SData.pData := PChar(TextA);
        TTSCentral.TextData(CHARSET_TEXT, 1, SData, Pointer(TTSBufNotifySink), IID_ITTSBufNotifySink);
      end;
  end;
end;

procedure TMultiSpeech.Stop;
begin
  UserStop := true;
  if Assigned(OnUserStop) then OnUserStop(Self);
  DoStop;
end;

procedure TMultiSpeech.Pause;
begin
  EngineState := [esPause];
  if Assigned(OnStatusChange) then OnStatusChange(Self);  
  if Assigned(OnPause) then OnPause(Self);
  case CurrentInterface of
    NotSelected: Exit;
    SAPI5Code: SAPI5.Pause;
    SAPI4Code: TTSCentral.AudioPause;
  end;
end;

procedure TMultiSpeech.Resume;
begin
  EngineState := [esSpeak];
  if Assigned(OnStatusChange) then OnStatusChange(Self);  
  if Assigned(OnResume) then OnResume(Self);  
  case CurrentInterface of
    NotSelected: Exit;
    SAPI5Code: SAPI5.Resume;
    SAPI4Code: TTSCentral.AudioResume;
  end;

  if Assigned(OnStart) then OnStart(nil);

end;

procedure TMultiSpeech.StartStream(ASender: TObject; StreamNumber: Integer; StreamPosition: OleVariant);
begin
  EngineState := [esSpeak];
  if Assigned(OnStatusChange) then OnStatusChange(Self);  
  if Assigned(OnStart) then OnStart(ASender);
end;

procedure TMultiSpeech.EndStream(ASender: TObject; StreamNumber: Integer; StreamPosition: OleVariant);
begin
  EngineState := [esStop];
  if Assigned(OnStatusChange) then OnStatusChange(Self);  
  if Assigned(OnStop) then OnStop(ASender);
end;

procedure TMultiSpeech.SpWord(ASender: TObject; StreamNumber: Integer; StreamPosition: OleVariant; CharacterPosition, Length: Integer);
begin
  FLastPosition := CharacterPosition + BufferPosition;
  if Assigned(OnPosition) then OnPosition(ASender, FLastPosition);
end;


procedure TMultiSpeech.SetSpeed(Value: integer);
var
  Text: Widestring;
  max, min: cardinal;
begin
  if Value < MinSpeed then Value := MinSpeed;
  if Value > MaxSpeed then Value := MaxSpeed;
  FSpeed := Value;
  case CurrentInterface of
    NotSelected: Exit;
    SAPI5Code:
      begin
        {Stop;
        Text := '<RATE ABSSPEED="' + inttostr(Value - 10) + '">' + copy(FText, FLastPosition, length(FText));
        Speak(Text);}
        Stop;
        Text := '<RATE ABSSPEED="' + inttostr(Value - 10) + '">';
        Speak(Text);
      end;
    SAPI4Code:
      begin
        TTSAttributes.SpeedSet(TTSATTR_MAXSPEED);
        TTSAttributes.SpeedGet(max);
        TTSAttributes.SpeedSet(TTSATTR_MINSPEED);
        TTSAttributes.SpeedGet(min);
        max := (max - min) div 20;
        max := value * max + min;
        TTSAttributes.SpeedSet(max);
      end;
  end;
  BufferPosition := length(BufferText) - length(Text);
  if Assigned(OnSpeed) then OnSpeed(Self, value);
end;

function TMultiSpeech.GetSpeed: integer;
begin
  Result := FSpeed;
end;


procedure TMultiSpeech.SetVolume(Value: integer);
var
  max, min: cardinal;
begin
  if Value < MinVolume then Value := MinVolume;
  if Value > MaxVolume then Value := MaxVolume;
  FVolume := Value;
  case CurrentInterface of
    NotSelected: Exit;
    SAPI5Code: SAPI5.Volume := Value;
    SAPI4Code:
      begin
        TTSAttributes.VolumeSet(TTSATTR_MAXVOLUME);
        TTSAttributes.VolumeGet(max);
        TTSAttributes.VolumeSet(TTSATTR_MINVOLUME);
        TTSAttributes.VolumeGet(min);
        {max := (max - min) div 100;
        max := value * max + min;
        max := max shl 16 or (max and $0000FFFF);}
        max := $FFFF * Value div 100;
        max := MakeWParam(max, max);
        TTSAttributes.VolumeSet(max);
      end;
  end;
  if Assigned(OnVolume) then OnVolume(Self, value);
end;

function TMultiSpeech.GetVolume: integer;
begin
  Result := FVolume;
end;

procedure TMultiSpeech.SetPitch(Value: integer);
var
  Text: Widestring;
  max, min: word;
begin
  if Value < 0 then Value := 0;
  if Value > 20 then Value := 20;
  FPitch := Value;
  case CurrentInterface of
    NotSelected: Exit;
    SAPI5Code:
      begin
        Stop;
        Text := '<pitch absmiddle="' + inttostr(Value - 10) + '">';
        Speak(Text);
      end;

    SAPI4Code:
      begin
        TTSAttributes.PitchSet(TTSATTR_MAXPITCH);
        TTSAttributes.PitchGet(max);
        TTSAttributes.PitchSet(TTSATTR_MINPITCH);
        TTSAttributes.PitchGet(min);
        max := (max - min) div 20;
        max := value * max + min;
        TTSAttributes.PitchSet(max);


      end;
  end;
  BufferPosition := length(BufferText) - length(Text);
  if Assigned(OnPitch) then OnPitch(Self, value);
end;

function TMultiSpeech.GetPitch: integer;
begin
  Result := FPitch;
end;

procedure Register;
begin
  RegisterComponents('CD', [TMultiSpeech]);
end;


end.

