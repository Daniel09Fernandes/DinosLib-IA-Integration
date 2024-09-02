unit uFaturamento.NotaFiscal.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ACBrBase, ACBrDFe, ACBrNFe, Vcl.StdCtrls,
  ACBrNFeDANFeESCPOS, ACBrNFeDANFEClass, ACBrDANFCeFortesFr, ACBrDFeReport,
  ACBrDFeDANFeReport, ACBrNFeDANFeRLClass, System.ImageList, Vcl.ImgList,
  Vcl.Buttons, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.DBCtrls,
  uConexao.Aplicacao;

type
  TFrNotaFiscal = class(TForm)
    BtnEmitirNf: TButton;
    ACBrNFeDANFeRL1: TACBrNFeDANFeRL;
    ACBrNFeDANFCeFortes1: TACBrNFeDANFCeFortes;
    ACBrNFeDANFeESCPOS1: TACBrNFeDANFeESCPOS;
    ACBrNFe1: TACBrNFe;
    edtCliente: TEdit;
    btnPesqCliente: TSpeedButton;
    ImageList1: TImageList;
    DBEdit1: TDBEdit;
    edtCodProd: TEdit;
    btnPesqProduto: TSpeedButton;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    dsProd: TDataSource;
    dsCliente: TDataSource;
    dsProdNF: TDataSource;
    btnAdditem: TButton;
    OpenDialog1: TOpenDialog;
    procedure BtnEmitirNfClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPesqClienteClick(Sender: TObject);
    procedure btnPesqProdutoClick(Sender: TObject);
    procedure btnAdditemClick(Sender: TObject);
  private

  public
    { Public declarations }
  end;

var
  FrNotaFiscal: TFrNotaFiscal;

implementation

{$R *.dfm}
uses
  uFaturamento.NotaFiscal.Model,
  uFaturamento.NotaFiscal.DTO,
  uFaturamento.NotaFiscal.Produto.DTO;

procedure TFrNotaFiscal.BtnEmitirNfClick(Sender: TObject);
begin
  var NotaFiscal   := TNotaFiscalModel.Create(ACBrNFe1);
  var Config       : TConfiguracaoNFe;
  var Filial       := TEmitente.Create; //
  var Destinatario := TClienteDest.Create; //
  var Produtos     : TProdutos;
  try
    dmConexao.mFilial.open;

    {$region 'Emitente'}
    Filial.CNPJCPF := dmConexao.mFilialCNPJCPF.Value;
    Filial.IE      := dmConexao.mFilialIE.Value;
    Filial.Nome    := dmConexao.mFilialNome.Value;
    Filial.Fantasia := dmConexao.mFilialNomeFantasia.Value;

    Filial.Endereco := TEmitenteEndereco.Create;
    Filial.Endereco.Fone := dmConexao.mFilialFone.Value;
    Filial.Endereco.CEP := dmConexao.mFilialCEP.Value;
    Filial.Endereco.Logradouro := dmConexao.mFilialLogradouro.Value;
    Filial.Endereco.Nro := dmConexao.mFilialNumero.Value;
    Filial.Endereco.Complemento := '';
    Filial.Endereco.Bairro := dmConexao.mFilialBairro.Value;
    Filial.Endereco.codMunicipio :=  dmConexao.mFilialCodigoIBGEMunicipio.AsInteger;
    Filial.Endereco.NomeMunicipio := dmConexao.mFilialMunicipio.Value;
    Filial.Endereco.UF := dmConexao.mFilialUF.Value;
    Filial.Endereco.CodPais := dmConexao.mFilialCodPais.asString;
    Filial.Endereco.NomePais := dmConexao.mFilialPais.Value;

    Filial.IEST  := '';
    Filial.IM    := '';
    Filial.CNAE  := '';
    {$endregion}

    {$region 'Destinatario'}
     Destinatario.Sufixo := '';
     Destinatario.CNPJCPF := dmConexao.mClienteCNPJCPF.Value;
     Destinatario.IE := dmConexao.mClienteIE.Value;
     Destinatario.Nome := dmConexao.mClienteNome.Value;
     Destinatario.Fantasia := dmConexao.mClienteNome.Value;
     Destinatario.IEST := '';
     Destinatario.IM := '';
     Destinatario.Endereco := TClienteDestEndereco.Create;
     Destinatario.Endereco.Fone := dmConexao.mClienteFone.Value;
     Destinatario.Endereco.CEP := dmConexao.mClienteCEP.Value;
     Destinatario.Endereco.Logradouro := dmConexao.mClienteLogradouro.Value;
     Destinatario.Endereco.Nro := dmConexao.mClienteNumero.Value.ToString;
     Destinatario.Endereco.Complemento := '';
     Destinatario.Endereco.Bairro := dmConexao.mClienteBairro.Value;
     Destinatario.Endereco.codMunicipio :=  dmConexao.mClienteCodMunicipio.AsInteger;
     Destinatario.Endereco.NomeMunicipio := dmConexao.mClienteNomeMunicipio.Value;
     Destinatario.Endereco.UF := dmConexao.mClienteUF.Value;
     Destinatario.Endereco.CodPais := dmConexao.mClienteCodPais.asString;
     Destinatario.Endereco.NomePais := dmConexao.mClientePais.Value;

    {$endregion}

    {$region 'Produtos'}
    dmConexao.mProdNFE.First;
    var i:= 0;
    SetLength(Produtos,dmConexao.mProdNFE.RecordCount);
    while not dmConexao.mProdNFE.EOF do
    begin
      Produtos[i]        := TProduto.Create;
      Produtos[i].cProd  := dmConexao.mProdNFECodProduto.AsString;

      Produtos[i].cEAN      := dmConexao.mProdNFECodEAN.Value;
      Produtos[i].xProd     := dmConexao.mProdNFEProduto.AsString;
      Produtos[i].NCM       := dmConexao.mProdNFENCM.Value;
      Produtos[i].EXTIPI    := dmConexao.mProdNFEExtIPI.Value;
      Produtos[i].CFOP      := dmConexao.mProdNFECFOP.Value;
      Produtos[i].uCom      := dmConexao.mProdNFEuCOM.Value;
      Produtos[i].qCom      := dmConexao.mProdNFEqtdCom.Value;
      Produtos[i].vUnCom    := dmConexao.mProdNFEVlrUnCom.Value;
      Produtos[i].vProd     := dmConexao.mProdNFEVlrProduto.Value;
      Produtos[i].cEANTrib  := dmConexao.mProdNFEEANTrib.Value;
      Produtos[i].vUnTrib   := dmConexao.mProdNFEVlrUnTrib.Value;
      Produtos[i].vOutro    := dmConexao.mProdNFEVlrOutros.Value;
      Produtos[i].vFrete    := dmConexao.mProdNFEVlrFrete.Value;
      Produtos[i].vSeg      := dmConexao.mProdNFEVlrSegmento.Value;
      Produtos[i].vDesc     := dmConexao.mProdNFEVlrDesconto.Value;
      //Objs  [i]
      Produtos[i].Imposto := TICMSDTO.Create;
      //EndObg[i]s
      Produtos[i].Imposto.pRedBC           := dmConexao.mProdNFEpRedBC.Value;
      Produtos[i].Imposto.vBC              := dmConexao.mProdNFEvBC.Value;
      Produtos[i].Imposto.pICMS            := dmConexao.mProdNFEpICMS.Value;
      Produtos[i].Imposto.vICMS            := dmConexao.mProdNFEvICMS.Value;
      Produtos[i].Imposto.vICMSDeson       := dmConexao.mProdNFEvICMSDeson.Value;
      Produtos[i].Imposto.pCredSN          := dmConexao.mProdNFEpCredSN.Value;
      Produtos[i].Imposto.vCredICMSSN      := dmConexao.mProdNFEvCredICMSSN.Value;
      Produtos[i].Imposto.pRedBCST         := dmConexao.mProdNFEpRedBC.Value;
      Produtos[i].Imposto.pICMSST          := dmConexao.mProdNFEpICMS.Value;
      Produtos[i].Imposto.vBCFCPST         := dmConexao.mProdNFEvBCFCPST.Value;
      Produtos[i].Imposto.pFCPST           := dmConexao.mProdNFEpFCPST.Value;
      Produtos[i].Imposto.vFCPST           := dmConexao.mProdNFEvFCPST.Value;
      Produtos[i].Imposto.vICMSSTDeson     := dmConexao.mProdNFEvICMSDeson.Value;

      Produtos[i].Imposto.COFINSStDTO := TCOFINSStDTO.Create;
      Produtos[i].Imposto.PISSTDTO := TPISSTDTO.Create;
      Produtos[i].Imposto.COFINSDTO := TCOFINSDTO.Create;
      Produtos[i].Imposto.PISDTO := TPISDTO.Create;
      Produtos[i].Imposto.IIDTO :=  TIIDTO.Create;
      Produtos[i].Imposto.ICMSUFDestDTO := TICMSUFDestDTO.Create;

      inc(i);
      dmConexao.mProdNFE.Next;
    end;

    {$endregion}

    Config.URLPFX  := '';

//    OpenDialog1.Title := 'Selecione o Certificado';
//    OpenDialog1.DefaultExt := '*.pfx';
//    OpenDialog1.Filter := 'Arquivos PFX (*.pfx)|*.pfx|Todos os Arquivos (*.*)|*.*';
//
//    OpenDialog1.InitialDir := GetCurrentDir;
//
//    if OpenDialog1.Execute then
    Config.Caminho := '';//OpenDialog1.FileName;

    Config.Senha := '';
   // Config.NumSerie := ACBrNFe1.SSL.SelecionarCertificado;
    Config.Report := ACBrNFeDANFeRL1;

    NotaFiscal.Configuracao := Config;
    NotaFiscal.Emitente := Filial;
    NotaFiscal.Cliente :=  Destinatario;
    NotaFiscal.Produtos := Produtos;
    NotaFiscal.PreencherNotaFiscal;
    NotaFiscal.GerarNotaFiscal;
    NotaFiscal.ImprimirNotaFiscal;
  finally
     Filial.Endereco.Free;
     Filial.Free;

     Destinatario.Endereco.Free;
     Destinatario.Free;

     for var ii := 0 to High(produtos) do
     begin
       Produtos[ii].Imposto.COFINSStDTO.Free;
       Produtos[ii].Imposto.PISSTDTO.Free;
       Produtos[ii].Imposto.COFINSDTO.Free;
       Produtos[ii].Imposto.PISDTO.Free;
       Produtos[ii].Imposto.IIDTO.Free;
       Produtos[ii].Imposto.ICMSUFDestDTO.Free;
       Produtos[ii].Imposto.Free;
       Produtos[ii].Free;
     end;
     SetLength(Produtos, 0);
  end;
end;

procedure TFrNotaFiscal.btnAdditemClick(Sender: TObject);
begin
  with dsProdNF.DataSet do
  begin
    open;
    Append;

    for var I := 0 to FieldCount - 1  do
    begin
       if dsProd.DataSet.FindField(Fields[i].FieldName) <> nil then
         Fields[i].Value := dsProd.DataSet.FindField(Fields[i].FieldName).value;
    end;
    post;
  end;

end;

procedure TFrNotaFiscal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    FreeAndNil(FrNotaFiscal);
end;

procedure TFrNotaFiscal.btnPesqClienteClick(Sender: TObject);
begin
  dsCliente.DataSet.Open;
  dsCliente.DataSet.First;

  while not dsCliente.DataSet.EOF do
  begin
     if  dsCliente.DataSet.FieldByName('Nome').AsString.Contains(edtCliente.Text) then
       Exit;

     dsCliente.DataSet.next;
  end;

end;

procedure TFrNotaFiscal.btnPesqProdutoClick(Sender: TObject);
begin
  dsProd.DataSet.Open;
  dsProd.DataSet.First;

  while not dsProd.DataSet.EOF do
  begin
     if  dsProd.DataSet.FieldByName('CodProduto').AsString.Contains(edtCodProd.Text) then
       Exit;

     dsProd.DataSet.next;
  end;
end;

end.
