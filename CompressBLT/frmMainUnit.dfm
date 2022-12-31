object frmMain: TfrmMain
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Compress Tool'
  ClientHeight = 381
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StatusLabel: TLabel
    Left = 16
    Top = 312
    Width = 657
    Height = 57
    AutoSize = False
    WordWrap = True
  end
  object TreeView: TTreeView
    Left = 8
    Top = 8
    Width = 425
    Height = 273
    Indent = 19
    TabOrder = 0
  end
  object bNewArchive: TButton
    Left = 480
    Top = 24
    Width = 121
    Height = 25
    Caption = 'Nowe archiwum...'
    TabOrder = 1
    OnClick = bNewArchiveClick
  end
  object Button1: TButton
    Left = 480
    Top = 56
    Width = 121
    Height = 25
    Caption = 'Otw'#243'rz archiwum...'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 480
    Top = 104
    Width = 121
    Height = 25
    Caption = 'Kompresuj katalog...'
    TabOrder = 3
    OnClick = Button2Click
  end
  object bDecompressTo: TButton
    Left = 480
    Top = 136
    Width = 121
    Height = 25
    Caption = 'Dekompresuj do...'
    TabOrder = 4
    OnClick = bDecompressToClick
  end
  object DirectoryEdit: TDirectoryEdit
    Left = 504
    Top = 184
    Width = 121
    Height = 21
    DialogKind = dkWin32
    InitialDir = 'E:\Programy\Delphi 2005\Carnet\update\upgradeapp'
    NumGlyphs = 1
    TabOrder = 5
    Text = 'E:\Programy\Delphi 2005\Carnet\update\upgradeapp'
    Visible = False
  end
  object ProgressBar: TProgressBar
    Left = 16
    Top = 288
    Width = 665
    Height = 16
    TabOrder = 6
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '*.inst'
    Filter = 
      'Pliki instalacji (*.inst)|*.inst|Pliki upgrade'#39'u(*.upgr)|*.upgr|' +
      '*sav|*.sav'
    FilterIndex = 3
    InitialDir = 'E:\Programy\Delphi 2005\Carnet\update'
    Left = 616
    Top = 24
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '*.inst'
    Filter = 
      'Pliki instalacji (*.inst)|*.inst|Pliki upgrade'#39'u(*.upgr)|*.upgr|' +
      '*sav|*.sav|*.fwr|*.fwr'
    FilterIndex = 3
    InitialDir = 'E:\Programy\Delphi 2005\Carnet\update'
    Left = 616
    Top = 56
  end
end
