object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'PDV Integracao'
  ClientHeight = 628
  ClientWidth = 360
  Color = 15790320
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlHeader: TAdvPanel
    Left = 0
    Top = 0
    Width = 360
    Height = 72
    Align = alTop
    Color = clTeal
    TabOrder = 0
    object shHeaderCircle: TShape
      Left = 252
      Top = -48
      Width = 160
      Height = 160
      Brush.Color = clAqua
      Pen.Style = psClear
      Shape = stCircle
    end
    object lblTitle: TLabel
      Left = 20
      Top = 14
      Width = 160
      Height = 21
      Caption = 'Ativacao do PDV'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -18
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSubtitle: TLabel
      Left = 20
      Top = 38
      Width = 196
      Height = 13
      Caption = 'Conecte seu caixa ao servidor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object shCard: TShape
    Left = 12
    Top = 88
    Width = 336
    Height = 240
    Brush.Color = clWhite
    Pen.Style = psClear
    Shape = stRoundRect
  end
  object shAccentTop: TShape
    Left = 16
    Top = 96
    Width = 4
    Height = 224
    Brush.Color = clTeal
    Pen.Style = psClear
  end
  object shLogCard: TShape
    Left = 12
    Top = 336
    Width = 336
    Height = 272
    Brush.Color = 16316664
    Pen.Style = psClear
    Shape = stRoundRect
  end
  object shAccentLog: TShape
    Left = 16
    Top = 344
    Width = 4
    Height = 256
    Brush.Color = clTeal
    Pen.Style = psClear
  end
  object lblBaseUrl: TLabel
    Left = 28
    Top = 104
    Width = 45
    Height = 13
    Caption = 'Base URL'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblCode: TLabel
    Left = 28
    Top = 180
    Width = 92
    Height = 13
    Caption = 'Codigo de ativacao'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblLabel: TLabel
    Left = 28
    Top = 256
    Width = 63
    Height = 13
    Caption = 'Label (Caixa)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblLog: TLabel
    Left = 28
    Top = 352
    Width = 21
    Height = 13
    Caption = 'Log'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblBaseUrlHelp: TLabel
    Left = 28
    Top = 142
    Width = 154
    Height = 13
    Caption = 'ex: https://meusistema.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblCodeHelp: TLabel
    Left = 28
    Top = 218
    Width = 172
    Height = 13
    Caption = 'Cole o codigo enviado pelo suporte'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblLabelHelp: TLabel
    Left = 28
    Top = 294
    Width = 86
    Height = 13
    Caption = 'ex: Caixa 01'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblStatus: TLabel
    Left = 28
    Top = 316
    Width = 106
    Height = 13
    Caption = 'Pronto para ativar.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object edtBaseUrl: TAdvEdit
    Left = 28
    Top = 120
    Width = 304
    Height = 26
    Anchors = [akLeft, akTop, akRight]
    Color = 16777215
    TabOrder = 1
  end
  object edtCode: TAdvEdit
    Left = 28
    Top = 196
    Width = 304
    Height = 26
    Anchors = [akLeft, akTop, akRight]
    Color = 16777215
    TabOrder = 2
  end
  object edtLabel: TAdvEdit
    Left = 28
    Top = 272
    Width = 304
    Height = 26
    Anchors = [akLeft, akTop, akRight]
    Color = 16777215
    TabOrder = 3
  end
  object btnActivate: TAdvGlowButton
    Left = 28
    Top = 336
    Width = 304
    Height = 36
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Ativar dispositivo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = btnActivateClick
  end
  object memLog: TAdvMemo
    Left = 28
    Top = 372
    Width = 304
    Height = 220
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 5
  end
end
