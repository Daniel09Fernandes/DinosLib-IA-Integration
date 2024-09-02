unit uConexao.Aplicacao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Datasnap.DBClient, Data.FMTBcd, Data.SqlExpr, FireDAC.Stan.StorageBin;

type
  TdmConexao = class(TDataModule)
    mCliente: TFDMemTable;
    mProduto: TFDMemTable;
    mFilial: TFDMemTable;
    mProdutoCodProduto: TStringField;
    mProdutoCodEAN: TStringField;
    mProdutoProduto: TStringField;
    mProdutoNCM: TStringField;
    mProdutoExtIPI: TStringField;
    mProdutoCFOP: TStringField;
    mProdutouCOM: TStringField;
    mProdutoqtdCom: TFloatField;
    mProdutoVlrUnCom: TFloatField;
    mProdutoVlrProduto: TFloatField;
    mProdutoEANTrib: TStringField;
    mProdutoTrib: TStringField;
    mProdutoqtdTrib: TFloatField;
    mProdutoVlrUnTrib: TFloatField;
    mProdutoVlrOutros: TFloatField;
    mProdutoVlrFrete: TFloatField;
    mProdutoVlrSegmento: TFloatField;
    mProdutoVlrDesconto: TFloatField;
    mProdutovFCPST: TFloatField;
    mFilialCNPJCPF: TStringField;
    mFilialIE: TStringField;
    mFilialNome: TStringField;
    mFilialNomeFantasia: TStringField;
    mFilialFone: TStringField;
    mFilialCEP: TIntegerField;
    mFilialLogradouro: TStringField;
    mFilialNumero: TStringField;
    mFilialBairro: TStringField;
    mFilialMunicipio: TStringField;
    mFilialCodigoIBGEMunicipio: TStringField;
    mFilialUF: TStringField;
    mFilialPais: TStringField;
    mFilialCodPais: TIntegerField;
    mClienteCNPJCPF: TStringField;
    mClienteIE: TStringField;
    mClienteISUF: TStringField;
    mClienteNome: TStringField;
    mClienteFone: TStringField;
    mClienteCEP: TIntegerField;
    mClienteLogradouro: TStringField;
    mClienteNumero: TIntegerField;
    mClienteComplemento: TStringField;
    mClienteBairro: TStringField;
    mClienteCodMunicipio: TIntegerField;
    mClienteNomeMunicipio: TStringField;
    mClienteUF: TStringField;
    mClienteCodPais: TIntegerField;
    mClientePais: TStringField;
    mProdNFE: TFDMemTable;
    mProdNFECodProduto: TStringField;
    mProdNFECodEAN: TStringField;
    mProdNFEProduto: TStringField;
    mProdNFENCM: TStringField;
    mProdNFEExtIPI: TStringField;
    mProdNFECFOP: TStringField;
    mProdNFEuCOM: TStringField;
    mProdNFEqtdCom: TFloatField;
    mProdNFEVlrUnCom: TFloatField;
    mProdNFEVlrProduto: TFloatField;
    mProdNFEEANTrib: TStringField;
    mProdNFETrib: TStringField;
    mProdNFEqtdTrib: TFloatField;
    mProdNFEVlrUnTrib: TFloatField;
    mProdNFEVlrOutros: TFloatField;
    mProdNFEVlrFrete: TFloatField;
    mProdNFEVlrSegmento: TFloatField;
    mProdNFEVlrDesconto: TFloatField;
    mProdNFEpRedBC: TFloatField;
    mProdNFEvBC: TFloatField;
    mProdNFEpICMS: TFloatField;
    mProdNFEvICMS: TFloatField;
    mProdNFEvICMSDeson: TFloatField;
    mProdNFEpCredSN: TFloatField;
    mProdNFEvCredICMSSN: TFloatField;
    mProdNFEvBCFCPST: TFloatField;
    mProdNFEpFCPST: TFloatField;
    mProdNFEvFCPST: TFloatField;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure mClienteBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmConexao: TdmConexao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmConexao.DataModuleCreate(Sender: TObject);
begin
  for var i := 0 to ComponentCount -1 do
  begin
    if Components[i] is TFDMemTable then
    begin
      var fileDb := '.\Dbs\database.'+Copy(String(TFDMemTable(Components[i]).Name), 2)+ '.db';
      if FileExists(fileDb) then
         TFDMemTable(Components[i]).LoadFromFile(fileDb);
       sleep(200);
    end;
  end;
end;

procedure TdmConexao.DataModuleDestroy(Sender: TObject);
begin
  for var i := 0 to ComponentCount -1 do
  begin
    if Components[i] is TFDMemTable then
    begin
      var fileDb := '.\Dbs\database.'+Copy(String(TFDMemTable(Components[i]).Name), 2)+ '.db';
      if FileExists(fileDb) then
        TFDMemTable(Components[i]).SaveToFile(fileDb);
      sleep(200);
    end;
  end;
end;

procedure TdmConexao.mClienteBeforePost(DataSet: TDataSet);
begin
  if mClienteCodPais.AsInteger <=0  then
    mClienteCodPais.AsInteger := 1058;

  if mClientePais.AsString.IsEmpty  then
    mClientePais.AsString := 'BRASIL';

end;

end.
