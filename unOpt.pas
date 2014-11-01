unit unOpt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
  TfmOpt = class(TForm)
    edSrc: TComboBox;
    Label1: TLabel;
    bOk: TButton;
    bCan: TButton;
    Label2: TLabel;
    edSpeed: TSpinEdit;
    edVol: TSpinEdit;
    Label3: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function DoOpt(var OpVoice: string; var OpSpeed, OpVol: Integer): boolean;

implementation

uses SpeechUnit;

{$R *.dfm}

function DoOpt(var OpVoice: string; var OpSpeed, OpVol: Integer): boolean;
var
  i: Integer;
  Eng: TStrings;
begin
  SpeechInit;
  Eng:= GetEngines;

  with TfmOpt.Create(nil) do
  try
    if Eng<>nil then
      for i:= 0 to Eng.Count-1 do
        edSrc.Items.Add(Eng[i]);
    edSrc.ItemIndex:= edSrc.Items.IndexOf(OpVoice);

    edSpeed.MinValue:= GetMinSpeed;
    edSpeed.MaxValue:= GetMaxSpeed;
    edVol.MinValue:= GetMinVolume;
    edVol.MaxValue:= GetMaxVolume;
    edSpeed.Value:= OpSpeed;
    edVol.Value:= OpVol;

    Result:= ShowModal=mrOk;
    if Result then
    begin
      OpVoice:= edSrc.Text;
      OpSpeed:= edSpeed.Value;
      OpVol:= edVol.Value;
    end;
  finally
    Free
  end;
end;

end.
