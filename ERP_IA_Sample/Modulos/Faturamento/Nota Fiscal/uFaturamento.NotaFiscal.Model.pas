unit uFaturamento.NotaFiscal.Model;

interface

uses
  ACBrMail,
  ACBrPosPrinter, ACBrNFeDANFeESCPOS, ACBrNFeDANFEClass, ACBrDANFCeFortesFr,
  ACBrDFeReport, ACBrDFeDANFeReport, ACBrNFeDANFeRLClass, ACBrBase, ACBrDFe,
  ACBrNFe, ShellAPI, XMLIntf, XMLDoc, zlib, blcksock, ACBrIntegrador,ACBrNFeNotasFiscais,
  ACBrDANFCeFortesFrA4,
  uFaturamento.NotaFiscal.DTO,
  uFaturamento.NotaFiscal.Produto.DTO;

Type
  TConfiguracaoNFe = record
   URLPFX  :String;
   Caminho :String;
   Senha   :String;
   NumSerie:String;
   Report: TACBrNFeDANFeRL;
  end;

  TNotaFiscalModel = class
  private
    FACBrNfe :TACBrNFe;
    FEmitente : TEmitente;
    FCliente: TClienteDest;
    FProduto: TProdutos;
    FTotalizadorProduto : Double;
    FConfiguracao: TConfiguracaoNFe;
    procedure GerarCabecalhoNF(var NotaF: NotaFiscal);
    procedure GerarDadosEmitente(var NotaF: NotaFiscal);
    procedure GerarDadosCliente(var NotaF: NotaFiscal);
    procedure AdicionarProdutos(var NotaF: NotaFiscal);
    procedure Configurar;
  public
    procedure PreencherNotaFiscal;
    procedure GerarNotaFiscal;
    procedure ImprimirNotaFiscal;
    property Emitente: TEmitente read FEmitente write FEmitente;
    property Cliente: TClienteDest read FCliente write FCliente;
    property Produtos: TProdutos read FProduto write FProduto;
    property Configuracao: TConfiguracaoNFe read FConfiguracao write FConfiguracao;
    constructor Create(var ACBrNfe: TACBrNFe);
  end;

implementation

{ TNotaFiscalModel }
uses
  sysutils, strutils,
  ACBrUtil.Base, ACBrUtil.FilesIO, ACBrUtil.DateTime, ACBrUtil.Strings,
  ACBrUtil.XMLHTML,
  pcnAuxiliar, pcnNFe, pcnConversao, pcnConversaoNFe, pcnNFeRTXT, pcnRetConsReciDFe,
  ACBrDFeConfiguracoes, ACBrDFeSSL, ACBrDFeOpenSSL, ACBrDFeUtil,
  ACBrNFeConfiguracoes;

constructor TNotaFiscalModel.Create(var ACBrNfe: TACBrNFe);
begin
  FACBrNfe := ACBrNfe;
  FACBrNFe.NotasFiscais.Clear;
end;

procedure TNotaFiscalModel.GerarDadosCliente(var NotaF: NotaFiscal);
begin
  NotaF.NFe.Dest.CNPJCPF := Cliente.CNPJCPF;
  NotaF.NFe.Dest.IE := Cliente.IE;
  NotaF.NFe.Dest.ISUF := Cliente.Sufixo;
  NotaF.NFe.Dest.xNome := Cliente.Nome;
  NotaF.NFe.Dest.EnderDest.Fone := Cliente.Endereco.Fone;
  NotaF.NFe.Dest.EnderDest.CEP := Cliente.Endereco.CEP;
  NotaF.NFe.Dest.EnderDest.xLgr := Cliente.Endereco.Logradouro;
  NotaF.NFe.Dest.EnderDest.nro := Cliente.Endereco.Nro;
  NotaF.NFe.Dest.EnderDest.xCpl := Cliente.Endereco.Complemento;
  NotaF.NFe.Dest.EnderDest.xBairro := Cliente.Endereco.Bairro;
  NotaF.NFe.Dest.EnderDest.cMun := Cliente.Endereco.codMunicipio;
  NotaF.NFe.Dest.EnderDest.xMun := Cliente.Endereco.NomeMunicipio;
  NotaF.NFe.Dest.EnderDest.UF := Cliente.Endereco.UF;
  NotaF.NFe.Dest.EnderDest.cPais := 1058;
  NotaF.NFe.Dest.EnderDest.xPais := 'BRASIL';
end;

procedure TNotaFiscalModel.GerarDadosEmitente(var NotaF: NotaFiscal);
begin
  NotaF.NFe.Emit.CNPJCPF := Emitente.CNPJCPF;
  NotaF.NFe.Emit.IE := Emitente.IE;
  NotaF.NFe.Emit.xNome := Emitente.Nome;
  NotaF.NFe.Emit.xFant := Emitente.Fantasia;
  NotaF.NFe.Emit.EnderEmit.fone := Emitente.Endereco.Fone;
  NotaF.NFe.Emit.EnderEmit.CEP := Emitente.Endereco.CEP;
  NotaF.NFe.Emit.EnderEmit.xLgr := Emitente.Endereco.Logradouro;
  NotaF.NFe.Emit.EnderEmit.nro := Emitente.Endereco.Nro;
  NotaF.NFe.Emit.EnderEmit.xCpl := Emitente.Endereco.Complemento;
  NotaF.NFe.Emit.EnderEmit.xBairro := Emitente.Endereco.Bairro;
  NotaF.NFe.Emit.EnderEmit.cMun := Emitente.Endereco.codMunicipio;
  NotaF.NFe.Emit.EnderEmit.xMun := Emitente.Endereco.NomeMunicipio;
  NotaF.NFe.Emit.EnderEmit.UF := Emitente.Endereco.UF;
  NotaF.NFe.Emit.enderEmit.cPais := 1058;
  NotaF.NFe.Emit.enderEmit.xPais := 'BRASIL';
  NotaF.NFe.Emit.IEST              := '';
  NotaF.NFe.Emit.IM                := '';
  NotaF.NFe.Emit.CNAE              := '6201500';
  NotaF.NFe.Emit.CRT  := TpcnCRT.crtRegimeNormal;
end;

procedure TNotaFiscalModel.GerarNotaFiscal;
begin
  FACBrNfe.NotasFiscais.GerarNFe;
  FACBrNFe.NotasFiscais.Assinar;
  FACBrNFe.NotasFiscais.Items[0].GravarXML();
end;

procedure TNotaFiscalModel.Configurar;
var
  Ok: Boolean;
  PathMensal: string;
begin

  with FACBrNfe.Configuracoes.Geral do
  begin
    SSLLib        := TSSLLib(4);
    SSLCryptLib   := TSSLCryptLib(3);
    SSLHttpLib    := TSSLHttpLib(2);
    SSLXmlSignLib := TSSLXmlSignLib(4);

    FACBrNfe.Configuracoes.Certificados.URLPFX      := Configuracao.URLPFX;
    FACBrNfe.Configuracoes.Certificados.ArquivoPFX  := Configuracao.Caminho;
    FACBrNfe.Configuracoes.Certificados.Senha       := Configuracao.Senha;
    FACBrNfe.Configuracoes.Certificados.NumeroSerie := 'CF41825BE7AED1253F9DE366205246385470CA55';//FACBrNFe.SSL.SelecionarCertificado;

    FACBrNfe.DANFE := Configuracao.Report;
    FACBrNfe.SSL.DescarregarCertificado;

    Salvar           := false;
    ExibirErroSchema := false;
    RetirarAcentos   := false;
    FormatoAlerta    := 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.';
    FormaEmissao     := TpcnTipoEmissao(0);
    ModeloDF         := TpcnModeloDF(0);
    VersaoDF         := TpcnVersaoDF(0);

    IdCSC            := '';
    CSC              := '';
    VersaoQRCode     := veqr200;
  end;

  with FACBrNfe.Configuracoes.WebServices do
  begin
    UF         := 'SP';
    Ambiente   := taHomologacao;
    Visualizar := false;
    Salvar     := false;

    AjustaAguardaConsultaRet := false;
    AguardarConsultaRet := 1000;
    Tentativas := 3;
    IntervaloTentativas := 1000;

    TimeOut   := 6000;
    ProxyHost := '';
    ProxyPort := '';
    ProxyUser := '';
    ProxyPass := '';
  end;

  FACBrNfe.SSL.SSLType := TSSLType.LT_TLSv1_2;

  with FACBrNfe.Configuracoes.Arquivos do
  begin
//    Salvar           := cbxSalvarArqs.Checked;
//    SepararPorMes    := cbxPastaMensal.Checked;
//    AdicionarLiteral := cbxAdicionaLiteral.Checked;
//    EmissaoPathNFe   := cbxEmissaoPathNFe.Checked;
//    SalvarEvento     := cbxSalvaPathEvento.Checked;
//    SepararPorCNPJ   := cbxSepararPorCNPJ.Checked;
//    SepararPorModelo := cbxSepararPorModelo.Checked;
//    PathSchemas      := edtPathSchemas.Text;
//    PathNFe          := edtPathNFe.Text;
//    PathInu          := edtPathInu.Text;
//    PathEvento       := edtPathEvento.Text;
//    PathMensal       := GetPathNFe(0);
//    PathSalvar       := PathMensal;
  end;

  if FACBrNfe.DANFE <> nil then
  begin
    FACBrNfe.DANFE.TipoDANFE := StrToTpImp(OK, IntToStr(0));

    {
      A Configuração abaixo utilizanda em conjunto com o TipoDANFE = tiSimplificado
      para impressão do DANFE Simplificado - Etiqueta (Fortes Report)

    ACBrNFeDANFeRL1.Etiqueta := True;
    }

    FACBrNfe.DANFE.Logo    := GetCurrentDir+'\..\assets\img\Dino.jpeg';
    FACBrNfe.DANFE.PathPDF := GetCurrentDir+'\..\assets\pdf';

    FACBrNfe.DANFE.MargemDireita  := 7;
    FACBrNfe.DANFE.MargemEsquerda := 7;
    FACBrNfe.DANFE.MargemSuperior := 5;
    FACBrNfe.DANFE.MargemInferior := 5;
  end;
end;

procedure TNotaFiscalModel.ImprimirNotaFiscal;
begin
  FACBrNFe.NotasFiscais.Imprimir;
end;

procedure TNotaFiscalModel.GerarCabecalhoNF(var NotaF: NotaFiscal);
begin
  NotaF := FACBrNfe.NotasFiscais.Add;
  NotaF.NFe.Ide.natOp := 'VENDA PRODUCAO DO ESTAB.';
  NotaF.NFe.Ide.indPag := ipVista;
  NotaF.NFe.Ide.modelo := 55;
  NotaF.NFe.Ide.serie := 1;
  NotaF.NFe.Ide.nNF := 1;
  NotaF.NFe.Ide.cNF := GerarCodigoDFe(NotaF.NFe.Ide.nNF);
  NotaF.NFe.Ide.dEmi := Date;
  NotaF.NFe.Ide.dSaiEnt := Date;
  NotaF.NFe.Ide.hSaiEnt := Now;
  NotaF.NFe.Ide.tpNF := tnSaida;
  NotaF.NFe.Ide.tpEmis := teNormal;
  NotaF.NFe.Ide.tpAmb := taHomologacao;
  NotaF.NFe.Ide.verProc := '0.0.0.1';
  NotaF.NFe.Ide.cUF := UFtoCUF('SP');
  NotaF.NFe.Ide.cMunFG := StrToInt('3507605');
  NotaF.NFe.Ide.finNFe := fnNormal;
end;

procedure TNotaFiscalModel.AdicionarProdutos(var NotaF: NotaFiscal);
var
 Prod: TDetCollectionItem;
begin
  FTotalizadorProduto := 0;
  for var I := 0 to High(Produtos) do
  begin
    Prod := NotaF.NFe.Det.New;
    Prod.Prod.nItem     := I+1;
    Prod.Prod.cProd     := Produtos[i].cProd;
    Prod.Prod.cEAN      := Produtos[i].cEAN;
    Prod.Prod.xProd     := Produtos[i].xProd;
    Prod.Prod.NCM       := Produtos[i].NCM;
    Prod.Prod.EXTIPI    := Produtos[i].EXTIPI;
    Prod.Prod.CFOP      := Produtos[i].CFOP;
    Prod.Prod.uCom      := Produtos[i].uCom;
    Prod.Prod.qCom      := Produtos[i].qCom;
    Prod.Prod.vUnCom    := Produtos[i].vUnCom;
    Prod.Prod.vProd     := Produtos[i].vProd;
    Prod.Prod.cEANTrib  := Produtos[i].cEANTrib;
    Prod.Prod.uTrib     := Produtos[i].uTrib;
    Prod.Prod.qTrib     := Produtos[i].qTrib;
    Prod.Prod.vUnTrib   := Produtos[i].vUnTrib;
    Prod.Prod.vOutro    := Produtos[i].vOutro;
    Prod.Prod.vFrete    := Produtos[i].vFrete;
    Prod.Prod.vSeg      := Produtos[i].vSeg;
    Prod.Prod.vDesc     := Produtos[i].vDesc;

    FTotalizadorProduto := FTotalizadorProduto + Produtos[i].vProd;
    with Prod.Imposto do
    begin
      // lei da transparencia nos impostos
      vTotTrib := 0;

    with ICMS do
    begin
      orig := oeNacional;
      if NotaF.NFe.Emit.CRT in [crtSimplesExcessoReceita, crtRegimeNormal] then
      begin
        CST := cst20;
        modBC := dbiMargemValorAgregado;
        pRedBC := Produtos[i].Imposto.pRedBC;
        vBC := Produtos[i].Imposto.vBC;
        pICMS := Produtos[i].Imposto.pICMS;
        vICMS := Produtos[i].Imposto.vICMS;
        vICMSDeson := Produtos[i].Imposto.vICMS;
        motDesICMS := mdiOutros;
        indDeduzDeson := tieSim;
      end
      else
      begin
        CSOSN   := csosn101;
        modBC   := dbiValorOperacao;
        pCredSN := Produtos[i].Imposto.pCredSN;
        vCredICMSSN := Prod.Prod.vProd * Produtos[i].Imposto.pCredSN / Prod.Prod.vProd;
        vBC     := Produtos[i].Imposto.vBC;
        pICMS   := Produtos[i].Imposto.pICMS;
        vICMS   := Produtos[i].Imposto.vICMS;
        modBCST := dbisListaNeutra;
        pMVAST  := Produtos[i].Imposto.pMVAST;
        pRedBCST:= Produtos[i].Imposto.pRedBCST;
        vBCST   := Produtos[i].Imposto.vBCST;
        pICMSST := Produtos[i].Imposto.pICMSST;
        vICMSST := Produtos[i].Imposto.vICMSST;
      end;

      vBCFCPST := Produtos[i].Imposto.vBCFCPST;
      pFCPST   := Produtos[i].Imposto.pFCPST;
      vFCPST   := Produtos[i].Imposto.vFCPST;
      vBCSTRet := Produtos[i].Imposto.vBCSTRet;
      pST := Produtos[i].Imposto.pST;
      vICMSSubstituto := Produtos[i].Imposto.vICMSSubstituto;
      vICMSSTRet  := Produtos[i].Imposto.vICMSSTRet;
      vBCFCPSTRet := Produtos[i].Imposto.vBCFCPSTRet;
      pFCPSTRet   := Produtos[i].Imposto.pFCPSTRet;
      vFCPSTRet   := Produtos[i].Imposto.vFCPSTRet;
      pRedBCEfet  := Produtos[i].Imposto.pRedBCEfet;
      vBCEfet     := Produtos[i].Imposto.vBCEfet;
      pICMSEfet   := Produtos[i].Imposto.pICMSEfet;
      vICMSEfet   := Produtos[i].Imposto.vICMSEfet;

      vICMSSTDeson := Produtos[i].Imposto.vICMSSTDeson;
      motDesICMSST := mdiOutros;

      pFCPDif := Produtos[i].Imposto.pFCPDif;
      vFCPDif := Produtos[i].Imposto.vFCPDif;
      vFCPEfet := Produtos[i].Imposto.vFCPEfet;
    end;

    if Assigned(Produtos[i].Imposto.ICMSUFDestDTO) then
    begin
      with ICMSUFDest do
      begin
        // partilha do ICMS e fundo de probreza
        vBCUFDest      := Produtos[i].Imposto.ICMSUFDestDTO.vBCUFDest;
        pFCPUFDest     := Produtos[i].Imposto.ICMSUFDestDTO.pFCPUFDest;
        pICMSUFDest    := Produtos[i].Imposto.ICMSUFDestDTO.pICMSUFDest;
        pICMSInter     := Produtos[i].Imposto.ICMSUFDestDTO.pICMSInter;
        pICMSInterPart := Produtos[i].Imposto.ICMSUFDestDTO.pICMSInterPart;
        vFCPUFDest     := Produtos[i].Imposto.ICMSUFDestDTO.vFCPUFDest;
        vICMSUFDest    := Produtos[i].Imposto.ICMSUFDestDTO.vICMSUFDest;
        vICMSUFRemet   := Produtos[i].Imposto.ICMSUFDestDTO.vICMSUFRemet;
      end;
    end;

    if Assigned(Produtos[i].Imposto.IIDTO) then
    begin
      with II do
      begin
        II.vBc      := Produtos[i].Imposto.IIDTO.vBc;
        II.vDespAdu := Produtos[i].Imposto.IIDTO.vDespAdu;
        II.vII      := Produtos[i].Imposto.IIDTO.vII;
        II.vIOF     := Produtos[i].Imposto.IIDTO.vIOF;
      end;
    end;

    if Assigned(Produtos[i].Imposto.PISDTO) then
    begin
      with PIS do
      begin
        CST  := pis99;
        vBC  := Produtos[i].Imposto.PISDTO.vBC;
        pPIS := Produtos[i].Imposto.PISDTO.pPIS;
        vPIS := Produtos[i].Imposto.PISDTO.vPIS;

        qBCProd   := Produtos[i].Imposto.PISDTO.qBCProd;
        vAliqProd := Produtos[i].Imposto.PISDTO.vAliqProd;
        vPIS      := Produtos[i].Imposto.PISDTO.vPIS;
      end;
    end;

    if Assigned(Produtos[i].Imposto.PISSTDTO) then
    begin
      with PISST do
      begin
        vBc       := Produtos[i].Imposto.PISSTDTO.vBC;
        pPis      := Produtos[i].Imposto.PISSTDTO.pPis;
        qBCProd   := Produtos[i].Imposto.PISSTDTO.qBCProd;
        vAliqProd := Produtos[i].Imposto.PISSTDTO.vAliqProd;
        vPIS      := Produtos[i].Imposto.PISSTDTO.vPIS;
        IndSomaPISST :=  ispNenhum;
      end;
    end;

    if Assigned(Produtos[i].Imposto.COFINSDTO) then
    begin
      with COFINS do
      begin
        CST     := cof99;
        vBC     := Produtos[i].Imposto.COFINSDTO.vBC;
        pCOFINS := Produtos[i].Imposto.COFINSDTO.pCOFINS;
        vCOFINS := Produtos[i].Imposto.COFINSDTO.vCOFINS;
        qBCProd   := Produtos[i].Imposto.COFINSDTO.QbCProd;
        vAliqProd := Produtos[i].Imposto.COFINSDTO.VAliqProd;
      end;
    end;

    if Assigned(Produtos[i].Imposto.COFINSStDTO) then
    begin
      with COFINSST do
      begin
        vBC     := Produtos[i].Imposto.COFINSDTO.vBC;
        pCOFINS := Produtos[i].Imposto.COFINSDTO.pCOFINS;
        vCOFINS := Produtos[i].Imposto.COFINSDTO.vCOFINS;
        qBCProd   := Produtos[i].Imposto.COFINSDTO.QbCProd;
        vAliqProd := Produtos[i].Imposto.COFINSDTO.VAliqProd;
        indSomaCOFINSST :=  iscNenhum;
      end;
    end;
   end;
  end;
end;

procedure TNotaFiscalModel.PreencherNotaFiscal;
var
  NotaF: NotaFiscal;
  Ok: Boolean;

  Volume: TVolCollectionItem;
  Duplicata: TDupCollectionItem;
  ObsComplementar: TobsContCollectionItem;
  ObsFisco: TobsFiscoCollectionItem;
  InfoPgto: TpagCollectionItem;
begin
  GerarCabecalhoNF(NotaF);
  Configurar;
  if  Assigned( FACBrNfe.DANFE ) then
    NotaF.NFe.Ide.tpImp     := FACBrNfe.DANFE.TipoDANFE;

  NotaF.NFe.Ide.indIntermed := iiSemOperacao;
  GerarDadosEmitente(NotaF);
  GerarDadosCliente(NotaF);
  AdicionarProdutos(NotaF);

  if NotaF.NFe.Emit.CRT in [crtSimplesExcessoReceita, crtRegimeNormal] then
  begin
    NotaF.NFe.Total.ICMSTot.vBC := FTotalizadorProduto;
    NotaF.NFe.Total.ICMSTot.vICMS := 18;
  end
  else
  begin
    NotaF.NFe.Total.ICMSTot.vBC := 0;
    NotaF.NFe.Total.ICMSTot.vICMS := 0;
  end;

  NotaF.NFe.Total.ICMSTot.vBCST   := 0;
  NotaF.NFe.Total.ICMSTot.vST     := 0;
  NotaF.NFe.Total.ICMSTot.vProd   := FTotalizadorProduto;
  NotaF.NFe.Total.ICMSTot.vFrete  := 0;
  NotaF.NFe.Total.ICMSTot.vSeg    := 0;
  NotaF.NFe.Total.ICMSTot.vDesc   := 0;
  NotaF.NFe.Total.ICMSTot.vII     := 0;
  NotaF.NFe.Total.ICMSTot.vIPI    := 0;
  NotaF.NFe.Total.ICMSTot.vPIS    := 0;
  NotaF.NFe.Total.ICMSTot.vCOFINS := 0;
  NotaF.NFe.Total.ICMSTot.vOutro  := 0;
  NotaF.NFe.Total.ICMSTot.vNF     := FTotalizadorProduto +
                                      NotaF.NFe.Total.ICMSTot.vFrete +
                                      NotaF.NFe.Total.ICMSTot.vSeg   +
                                      NotaF.NFe.Total.ICMSTot.vDesc +
                                      NotaF.NFe.Total.ICMSTot.vII     +
                                      NotaF.NFe.Total.ICMSTot.vIPI  +
                                      NotaF.NFe.Total.ICMSTot.vPIS   +
                                      NotaF.NFe.Total.ICMSTot.vCOFINS +
                                      NotaF.NFe.Total.ICMSTot.vOutro;




  ;

  // lei da transparencia de impostos
  NotaF.NFe.Total.ICMSTot.vTotTrib := 0;

  // partilha do icms e fundo de probreza
  NotaF.NFe.Total.ICMSTot.vFCPUFDest   := 0.00;
  NotaF.NFe.Total.ICMSTot.vICMSUFDest  := 0.00;
  NotaF.NFe.Total.ICMSTot.vICMSUFRemet := 0.00;

  NotaF.NFe.Total.ICMSTot.vFCPST     := 0;
  NotaF.NFe.Total.ICMSTot.vFCPSTRet  := 0;

  NotaF.NFe.Total.retTrib.vRetPIS    := 0;
  NotaF.NFe.Total.retTrib.vRetCOFINS := 0;
  NotaF.NFe.Total.retTrib.vRetCSLL   := 0;
  NotaF.NFe.Total.retTrib.vBCIRRF    := 0;
  NotaF.NFe.Total.retTrib.vIRRF      := 0;
  NotaF.NFe.Total.retTrib.vBCRetPrev := 0;
  NotaF.NFe.Total.retTrib.vRetPrev   := 0;

  NotaF.NFe.Transp.modFrete := mfContaEmitente;
  NotaF.NFe.Transp.Transporta.CNPJCPF  := '';
  NotaF.NFe.Transp.Transporta.xNome    := '';
  NotaF.NFe.Transp.Transporta.IE       := '';
  NotaF.NFe.Transp.Transporta.xEnder   := '';
  NotaF.NFe.Transp.Transporta.xMun     := '';
  NotaF.NFe.Transp.Transporta.UF       := '';

  NotaF.NFe.Transp.retTransp.vServ    := 0;
  NotaF.NFe.Transp.retTransp.vBCRet   := 0;
  NotaF.NFe.Transp.retTransp.pICMSRet := 0;
  NotaF.NFe.Transp.retTransp.vICMSRet := 0;
  NotaF.NFe.Transp.retTransp.CFOP     := '';
  NotaF.NFe.Transp.retTransp.cMunFG   := 0;

  Volume := NotaF.NFe.Transp.Vol.New;
  Volume.qVol  := 1;
  Volume.esp   := 'Especie';
  Volume.marca := 'Marca';
  Volume.nVol  := 'Numero';
  Volume.pesoL := FTotalizadorProduto;
  Volume.pesoB := 110;


  NotaF.NFe.Cobr.Fat.nFat  := '1001';
  NotaF.NFe.Cobr.Fat.vOrig := NotaF.NFe.Total.ICMSTot.vNF;
  NotaF.NFe.Cobr.Fat.vDesc := 0;
  NotaF.NFe.Cobr.Fat.vLiq  := NotaF.NFe.Cobr.Fat.vOrig - NotaF.NFe.Cobr.Fat.vDesc;

  Duplicata := NotaF.NFe.Cobr.Dup.New;
  Duplicata.nDup  := '001';
  Duplicata.dVenc := now+10;
  Duplicata.vDup  := 50;

  Duplicata := NotaF.NFe.Cobr.Dup.New;
  Duplicata.nDup  := '002';
  Duplicata.dVenc := now+20;
  Duplicata.vDup  := 50;

  NotaF.NFe.InfAdic.infCpl     :=  '';
  NotaF.NFe.InfAdic.infAdFisco :=  '';

  ObsComplementar := NotaF.NFe.InfAdic.obsCont.New;
  ObsComplementar.xCampo := 'ObsCont';
  ObsComplementar.xTexto := 'Texto';

  ObsFisco := NotaF.NFe.InfAdic.obsFisco.New;
  ObsFisco.xCampo := 'ObsFisco';
  ObsFisco.xTexto := 'Texto';

// YA. Informações de pagamento

  InfoPgto := NotaF.NFe.pag.New;
  InfoPgto.indPag := ipVista;
  InfoPgto.tPag   := fpDinheiro;
  InfoPgto.vPag   := NotaF.NFe.Total.ICMSTot.vNF;

end;

end.
