object fmOpt: TfmOpt
  Left = 430
  Top = 381
  ActiveControl = edSrc
  BorderStyle = bsDialog
  Caption = 'Speech'
  ClientHeight = 186
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 29
    Height = 13
    Caption = 'Voice:'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 34
    Height = 13
    Caption = 'Speed:'
  end
  object Label3: TLabel
    Left = 8
    Top = 88
    Width = 38
    Height = 13
    Caption = 'Volume:'
  end
  object edSrc: TComboBox
    Left = 8
    Top = 24
    Width = 361
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object bOk: TButton
    Left = 168
    Top = 152
    Width = 97
    Height = 23
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object bCan: TButton
    Left = 272
    Top = 152
    Width = 97
    Height = 23
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object edSpeed: TSpinEdit
    Left = 8
    Top = 64
    Width = 65
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 0
  end
  object edVol: TSpinEdit
    Left = 8
    Top = 104
    Width = 65
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 2
    Value = 0
  end
end
