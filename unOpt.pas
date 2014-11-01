unit unOpt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
  TfmOpt = class(TForm)
    edVo: TComboBox;
    Label1: TLabel;
    bOk: TButton;
    bCan: TButton;
    Label2: TLabel;
    edSpeed: TSpinEdit;
    edVol: TSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    edPitch: TSpinEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function DoOpt(var OpVoice: string; var OpSpeed, OpPitch, OpVol: Integer): boolean;

implementation

uses
  SpeechApi, SpeechMulti;

{$R *.dfm}

function DoOpt(var OpVoice: string; var OpSpeed, OpPitch, OpVol: Integer): boolean;
var
  Eng: TStrings;
begin
  SpeechInit;
  Eng:= GetEngines;

  with TfmOpt.Create(nil) do
  try
    if Eng<>nil then
      edVo.Items.AddStrings(Eng);
    if OpVoice<>'' then
      edVo.ItemIndex:= edVo.Items.IndexOf(OpVoice)
    else
      if edVo.Items.Count>0 then
        edVo.ItemIndex:= 0;

    edSpeed.MinValue:= MinSpeed;
    edSpeed.MaxValue:= MaxSpeed;
    edPitch.MinValue:= MinPitch;
    edPitch.MaxValue:= MaxPitch;
    edVol.MinValue:= MinVolume;
    edVol.MaxValue:= MaxVolume;
    edSpeed.Value:= OpSpeed;
    edPitch.Value:= OpPitch;
    edVol.Value:= OpVol;

    Result:= ShowModal=mrOk;
    if Result then
    begin
      OpVoice:= edVo.Text;
      OpSpeed:= edSpeed.Value;
      OpPitch:= edPitch.Value;
      OpVol:= edVol.Value;
    end;
  finally
    Free
  end;
end;

end.
