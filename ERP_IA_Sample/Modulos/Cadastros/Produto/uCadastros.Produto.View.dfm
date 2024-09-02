object FrCadProduto: TFrCadProduto
  Left = 0
  Top = 0
  Caption = 'Cadastro de produtos'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIForm
  Position = poOwnerFormCenter
  Visible = True
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 624
    Height = 406
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Produto'
      object Label1: TLabel
        Left = 24
        Top = 19
        Width = 39
        Height = 15
        Caption = 'C'#243'digo'
      end
      object Label2: TLabel
        Left = 112
        Top = 19
        Width = 51
        Height = 15
        Caption = 'Descri'#231#227'o'
      end
      object Label3: TLabel
        Left = 24
        Top = 75
        Width = 26
        Height = 15
        Caption = 'Valor'
      end
      object Label4: TLabel
        Left = 112
        Top = 75
        Width = 116
        Height = 15
        Caption = 'Desconto - promo'#231#227'o'
      end
      object DBEdit1: TDBEdit
        Left = 24
        Top = 40
        Width = 82
        Height = 23
        DataField = 'CodProduto'
        DataSource = dsProd
        TabOrder = 0
      end
      object DBEdit2: TDBEdit
        Left = 112
        Top = 40
        Width = 489
        Height = 23
        DataField = 'Produto'
        DataSource = dsProd
        TabOrder = 1
      end
      object DBEdit4: TDBEdit
        Left = 24
        Top = 96
        Width = 82
        Height = 23
        DataField = 'VlrProduto'
        DataSource = dsProd
        TabOrder = 2
      end
      object DBEdit5: TDBEdit
        Left = 112
        Top = 96
        Width = 116
        Height = 23
        DataField = 'VlrDesconto'
        DataSource = dsProd
        TabOrder = 3
      end
      object DBGrid1: TDBGrid
        Left = 24
        Top = 168
        Width = 577
        Height = 193
        DataSource = dsProd
        ReadOnly = True
        TabOrder = 4
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Imposto'
      ImageIndex = 1
      object CFOP: TLabel
        Left = 16
        Top = 16
        Width = 30
        Height = 15
        Caption = 'CFOP'
      end
      object Label5: TLabel
        Left = 79
        Top = 16
        Width = 28
        Height = 15
        Caption = 'NCM'
      end
      object Label6: TLabel
        Left = 191
        Top = 14
        Width = 23
        Height = 15
        Caption = 'EAN'
      end
      object Label7: TLabel
        Left = 288
        Top = 14
        Width = 81
        Height = 15
        Caption = 'EAN Tributa'#231#227'o'
      end
      object Label8: TLabel
        Left = 432
        Top = 14
        Width = 32
        Height = 15
        Caption = 'Ext IPI'
      end
      object Label9: TLabel
        Left = 16
        Top = 75
        Width = 44
        Height = 15
        Caption = 'qtdCom'
      end
      object Label10: TLabel
        Left = 300
        Top = 75
        Width = 73
        Height = 15
        Caption = 'Unidade Com'
      end
      object Label11: TLabel
        Left = 143
        Top = 75
        Width = 76
        Height = 15
        Caption = 'Qtd. Tributado'
      end
      object Label12: TLabel
        Left = 228
        Top = 75
        Width = 55
        Height = 15
        Caption = 'Tributa'#231#227'o'
      end
      object Label14: TLabel
        Left = 161
        Top = 128
        Width = 93
        Height = 15
        Caption = 'Valor Seguimento'
      end
      object Label15: TLabel
        Left = 16
        Top = 128
        Width = 55
        Height = 15
        Caption = 'Valor Frete'
      end
      object Label18: TLabel
        Left = 79
        Top = 128
        Width = 76
        Height = 15
        Caption = 'Outros Valores'
      end
      object Label13: TLabel
        Left = 115
        Top = 184
        Width = 99
        Height = 15
        Caption = 'ICMS Desonera'#231#227'o'
      end
      object Label16: TLabel
        Left = 16
        Top = 184
        Width = 57
        Height = 15
        Caption = 'Valor ICMS'
      end
      object Label17: TLabel
        Left = 219
        Top = 184
        Width = 59
        Height = 15
        Caption = '% Cred. SN'
      end
      object Label19: TLabel
        Left = 318
        Top = 184
        Width = 76
        Height = 15
        Caption = 'Val. BC FC CST'
      end
      object Label20: TLabel
        Left = 417
        Top = 184
        Width = 49
        Height = 15
        Caption = '% FCP ST'
      end
      object Label21: TLabel
        Left = 16
        Top = 240
        Width = 54
        Height = 15
        Caption = 'Val FCP ST'
      end
      object Label22: TLabel
        Left = 260
        Top = 128
        Width = 99
        Height = 15
        Caption = 'Reducao Base Calc'
      end
      object Label23: TLabel
        Left = 364
        Top = 128
        Width = 67
        Height = 15
        Caption = 'Base Calculo'
      end
      object Label24: TLabel
        Left = 463
        Top = 128
        Width = 41
        Height = 15
        Caption = '% ICMS'
      end
      object DBEdit7: TDBEdit
        Left = 16
        Top = 35
        Width = 57
        Height = 23
        DataField = 'CFOP'
        DataSource = dsProd
        TabOrder = 0
      end
      object DBEdit10: TDBEdit
        Left = 288
        Top = 35
        Width = 121
        Height = 23
        DataField = 'EANTrib'
        DataSource = dsProd
        TabOrder = 1
      end
      object DBEdit13: TDBEdit
        Left = 16
        Top = 96
        Width = 121
        Height = 23
        DataField = 'qtdCom'
        DataSource = dsProd
        TabOrder = 2
      end
      object DBEdit16: TDBEdit
        Left = 16
        Top = 149
        Width = 57
        Height = 23
        DataField = 'VlrFrete'
        DataSource = dsProd
        TabOrder = 3
      end
      object DBEdit17: TDBEdit
        Left = 79
        Top = 149
        Width = 76
        Height = 23
        DataField = 'VlrOutros'
        DataSource = dsProd
        TabOrder = 4
      end
      object DBEdit14: TDBEdit
        Left = 143
        Top = 96
        Width = 79
        Height = 23
        DataField = 'qtdTrib'
        DataSource = dsProd
        TabOrder = 5
      end
      object DBEdit11: TDBEdit
        Left = 432
        Top = 35
        Width = 121
        Height = 23
        DataField = 'ExtIPI'
        DataSource = dsProd
        TabOrder = 6
      end
      object DBEdit8: TDBEdit
        Left = 79
        Top = 35
        Width = 106
        Height = 23
        DataField = 'NCM'
        DataSource = dsProd
        TabOrder = 7
      end
      object DBEdit9: TDBEdit
        Left = 191
        Top = 35
        Width = 82
        Height = 23
        DataField = 'CodEAN'
        DataSource = dsProd
        TabOrder = 8
      end
      object DBEdit12: TDBEdit
        Left = 228
        Top = 96
        Width = 66
        Height = 23
        DataField = 'Trib'
        DataSource = dsProd
        TabOrder = 9
      end
      object DBEdit15: TDBEdit
        Left = 300
        Top = 96
        Width = 121
        Height = 23
        DataField = 'uCOM'
        DataSource = dsProd
        TabOrder = 10
      end
      object DBEdit18: TDBEdit
        Left = 161
        Top = 149
        Width = 93
        Height = 23
        DataField = 'VlrSegmento'
        DataSource = dsProd
        TabOrder = 11
      end
      object DBEdit3: TDBEdit
        Left = 16
        Top = 205
        Width = 93
        Height = 23
        DataField = 'vICMS'
        DataSource = dsProd
        TabOrder = 12
      end
      object DBEdit6: TDBEdit
        Left = 115
        Top = 205
        Width = 93
        Height = 23
        DataField = 'vICMSDeson'
        DataSource = dsProd
        TabOrder = 13
      end
      object DBEdit19: TDBEdit
        Left = 16
        Top = 261
        Width = 93
        Height = 23
        DataField = 'vFCPST'
        DataSource = dsProd
        TabOrder = 14
      end
      object DBEdit20: TDBEdit
        Left = 417
        Top = 205
        Width = 93
        Height = 23
        DataField = 'pFCPST'
        DataSource = dsProd
        TabOrder = 15
      end
      object DBEdit21: TDBEdit
        Left = 260
        Top = 149
        Width = 93
        Height = 23
        DataField = 'pRedBC'
        DataSource = dsProd
        TabOrder = 16
      end
      object DBEdit22: TDBEdit
        Left = 364
        Top = 149
        Width = 93
        Height = 23
        DataField = 'vBC'
        DataSource = dsProd
        TabOrder = 17
      end
      object DBEdit23: TDBEdit
        Left = 463
        Top = 149
        Width = 93
        Height = 23
        DataField = 'pICMS'
        DataSource = dsProd
        TabOrder = 18
      end
      object DBEdit24: TDBEdit
        Left = 318
        Top = 205
        Width = 93
        Height = 23
        DataField = 'vBCFCPST'
        DataSource = dsProd
        TabOrder = 19
      end
      object DBEdit25: TDBEdit
        Left = 219
        Top = 205
        Width = 93
        Height = 23
        DataField = 'pCredSN'
        DataSource = dsProd
        TabOrder = 20
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 406
    Width = 624
    Height = 35
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      624
      35)
    object DBNavigator1: TDBNavigator
      Left = 185
      Top = 6
      Width = 240
      Height = 25
      DataSource = dsProd
      Anchors = [akLeft, akRight]
      TabOrder = 0
    end
  end
  object dsProd: TDataSource
    DataSet = dmConexao.mProduto
    Left = 484
    Top = 106
  end
end
