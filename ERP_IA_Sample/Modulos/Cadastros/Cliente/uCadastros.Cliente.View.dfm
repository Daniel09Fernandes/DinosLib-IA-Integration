object frCadCliente: TfrCadCliente
  Left = 0
  Top = 0
  Caption = 'Cadastro de clientes'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIForm
  Position = poMainFormCenter
  Visible = True
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object Label1: TLabel
    Left = 24
    Top = 8
    Width = 33
    Height = 15
    Caption = 'Nome'
  end
  object Label2: TLabel
    Left = 24
    Top = 166
    Width = 31
    Height = 15
    Caption = 'Bairro'
  end
  object Label3: TLabel
    Left = 24
    Top = 59
    Width = 9
    Height = 15
    Caption = 'IE'
  end
  object Label4: TLabel
    Left = 153
    Top = 59
    Width = 33
    Height = 15
    Caption = 'Sufixo'
  end
  object Label5: TLabel
    Left = 26
    Top = 221
    Width = 21
    Height = 15
    Caption = 'CEP'
  end
  object Label6: TLabel
    Left = 207
    Top = 57
    Width = 44
    Height = 15
    Caption = 'Telefone'
  end
  object Label7: TLabel
    Left = 409
    Top = 8
    Width = 49
    Height = 15
    Caption = 'Cpf/Cnpj'
  end
  object Label8: TLabel
    Left = 488
    Top = 113
    Width = 44
    Height = 15
    Caption = 'Numero'
  end
  object Label9: TLabel
    Left = 24
    Top = 113
    Width = 20
    Height = 15
    Caption = 'Rua'
  end
  object Label10: TLabel
    Left = 269
    Top = 221
    Width = 82
    Height = 15
    Caption = 'Cod. Munic'#237'pio'
  end
  object Label11: TLabel
    Left = 465
    Top = 220
    Width = 21
    Height = 15
    Caption = 'Pais'
  end
  object Label12: TLabel
    Left = 358
    Top = 221
    Width = 14
    Height = 15
    Caption = 'UF'
  end
  object Label13: TLabel
    Left = 101
    Top = 221
    Width = 37
    Height = 15
    Caption = 'Cidade'
  end
  object Label14: TLabel
    Left = 398
    Top = 221
    Width = 49
    Height = 15
    Caption = 'Cod. Pais'
  end
  object Label15: TLabel
    Left = 279
    Top = 166
    Width = 77
    Height = 15
    Caption = 'Complemento'
  end
  object DBEdit1: TDBEdit
    Left = 26
    Top = 28
    Width = 375
    Height = 23
    DataField = 'Nome'
    DataSource = dtsCliente
    TabOrder = 0
  end
  object DBEdit2: TDBEdit
    Left = 26
    Top = 134
    Width = 456
    Height = 23
    DataField = 'Logradouro'
    DataSource = dtsCliente
    TabOrder = 1
  end
  object DBEdit3: TDBEdit
    Left = 398
    Top = 241
    Width = 61
    Height = 23
    DataField = 'CodPais'
    DataSource = dtsCliente
    TabOrder = 2
  end
  object DBEdit4: TDBEdit
    Left = 359
    Top = 242
    Width = 33
    Height = 23
    DataField = 'UF'
    DataSource = dtsCliente
    MaxLength = 2
    TabOrder = 3
  end
  object DBEdit5: TDBEdit
    Left = 269
    Top = 241
    Width = 82
    Height = 23
    DataField = 'CodMunicipio'
    DataSource = dtsCliente
    TabOrder = 4
  end
  object DBEdit6: TDBEdit
    Left = 26
    Top = 187
    Width = 247
    Height = 23
    DataField = 'Bairro'
    DataSource = dtsCliente
    TabOrder = 5
  end
  object DBEdit7: TDBEdit
    Left = 207
    Top = 78
    Width = 121
    Height = 23
    DataField = 'Fone'
    DataSource = dtsCliente
    TabOrder = 6
  end
  object DBEdit8: TDBEdit
    Left = 26
    Top = 241
    Width = 66
    Height = 23
    DataField = 'CEP'
    DataSource = dtsCliente
    TabOrder = 7
  end
  object DBEdit9: TDBEdit
    Left = 101
    Top = 241
    Width = 161
    Height = 23
    DataField = 'NomeMunicipio'
    DataSource = dtsCliente
    TabOrder = 8
  end
  object DBEdit10: TDBEdit
    Left = 279
    Top = 187
    Width = 282
    Height = 23
    DataField = 'Complemento'
    DataSource = dtsCliente
    TabOrder = 9
  end
  object DBEdit11: TDBEdit
    Left = 488
    Top = 134
    Width = 73
    Height = 23
    DataField = 'Numero'
    DataSource = dtsCliente
    TabOrder = 10
  end
  object DBEdit12: TDBEdit
    Left = 153
    Top = 78
    Width = 48
    Height = 23
    DataField = 'ISUF'
    DataSource = dtsCliente
    TabOrder = 11
  end
  object DBEdit13: TDBEdit
    Left = 407
    Top = 28
    Width = 154
    Height = 23
    DataField = 'CNPJCPF'
    DataSource = dtsCliente
    TabOrder = 12
  end
  object DBEdit14: TDBEdit
    Left = 26
    Top = 78
    Width = 121
    Height = 23
    DataField = 'IE'
    DataSource = dtsCliente
    TabOrder = 13
  end
  object DBEdit15: TDBEdit
    Left = 465
    Top = 241
    Width = 96
    Height = 23
    DataField = 'Pais'
    DataSource = dtsCliente
    TabOrder = 14
  end
  object Panel1: TPanel
    Left = 0
    Top = 400
    Width = 624
    Height = 41
    Align = alBottom
    TabOrder = 15
    DesignSize = (
      624
      41)
    object DBNavigator1: TDBNavigator
      Left = 176
      Top = 8
      Width = 240
      Height = 25
      DataSource = dtsCliente
      Anchors = [akLeft, akRight]
      TabOrder = 0
    end
  end
  object DBGrid1: TDBGrid
    Left = 26
    Top = 282
    Width = 569
    Height = 103
    DataSource = dtsCliente
    ReadOnly = True
    TabOrder = 16
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object dtsCliente: TDataSource
    DataSet = dmConexao.mCliente
    Left = 400
    Top = 72
  end
end
