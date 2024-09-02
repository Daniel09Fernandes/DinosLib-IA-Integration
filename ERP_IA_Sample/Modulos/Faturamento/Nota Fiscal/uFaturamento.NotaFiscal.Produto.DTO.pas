unit uFaturamento.NotaFiscal.Produto.DTO;

interface
type
  TICMSUFDestDTO = class
  private
    FvBCUFDest: Double;
    FpFCPUFDest: Double;
    FpICMSUFDest: Double;
    FpICMSInter: Double;
    FpICMSInterPart: Double;
    FvFCPUFDest: Double;
    FvICMSUFDest: Double;
    FvICMSUFRemet: Double;
  public
    property vBCUFDest: Double read FvBCUFDest write FvBCUFDest;
    property pFCPUFDest: Double read FpFCPUFDest write FpFCPUFDest;
    property pICMSUFDest: Double read FpICMSUFDest write FpICMSUFDest;
    property pICMSInter: Double read FpICMSInter write FpICMSInter;
    property pICMSInterPart: Double read FpICMSInterPart write FpICMSInterPart;
    property vFCPUFDest: Double read FvFCPUFDest write FvFCPUFDest;
    property vICMSUFDest: Double read FvICMSUFDest write FvICMSUFDest;
    property vICMSUFRemet: Double read FvICMSUFRemet write FvICMSUFRemet;
  end;

  TIIDTO = class
  private
    FvBc: Double;
    FvDespAdu: Double;
    FvII: Double;
    FvIOF: Double;
  public
    property vBc: Double read FvBc write FvBc;
    property vDespAdu: Double read FvDespAdu write FvDespAdu;
    property vII: Double read FvII write FvII;
    property vIOF: Double read FvIOF write FvIOF;
  end;

  TPISDTO = class
  private
    FCST: Integer;
    FvBC: Double;
    FpPIS: Double;
    FvPIS: Double;
    FqBCProd: Double;
    FvAliqProd: Double;
  public
    property CST: Integer read FCST write FCST;
    property vBC: Double read FvBC write FvBC;
    property pPIS: Double read FpPIS write FpPIS;
    property vPIS: Double read FvPIS write FvPIS;
    property qBCProd: Double read FqBCProd write FqBCProd;
    property vAliqProd: Double read FvAliqProd write FvAliqProd;
  end;

  TPISSTDTO = class
  private
    FvBc: Double;
    FpPis: Double;
    FqBCProd: Double;
    FvAliqProd: Double;
    FvPIS: Double;
    FIndSomaPISST: Integer;
  public
    property vBc: Double read FvBc write FvBc;
    property pPis: Double read FpPis write FpPis;
    property qBCProd: Double read FqBCProd write FqBCProd;
    property vAliqProd: Double read FvAliqProd write FvAliqProd;
    property vPIS: Double read FvPIS write FvPIS;
    property IndSomaPISST: Integer read FIndSomaPISST write FIndSomaPISST;
  end;

  TCOFINSDTO = class
  private
    FCST: Integer;
    FvBC: Double;
    FpCOFINS: Double;
    FvCOFINS: Double;
    FqBCProd: Double;
    FvAliqProd: Double;
  public
    property CST: Integer read FCST write FCST;
    property vBC: Double read FvBC write FvBC;
    property pCOFINS: Double read FpCOFINS write FpCOFINS;
    property vCOFINS: Double read FvCOFINS write FvCOFINS;
    property QbCProd: Double read FqBCProd write FqBCProd;
    property VAliqProd: Double read FvAliqProd write FvAliqProd;
  end;

  TCOFINSStDTO = class(TCOFINSDTO)

  end;

  TICMSDTO = class
  private
    Forig: Integer;
    FCST: Integer;
    FmodBC: Integer;
    FpRedBC: Double;
    FvBC: Double;
    FpICMS: Double;
    FvICMS: Double;
    FvICMSDeson: Double;
    FmotDesICMS: Integer;
    FindDeduzDeson: Integer;
    FCSOSN: Integer;
    FmodBCST: Integer;
    FpCredSN: Double;
    FvCredICMSSN: Double;
    FpMVAST: Double;
    FpRedBCST: Double;
    FvBCST: Double;
    FpICMSST: Double;
    FvICMSST: Double;
    FvBCFCPST: Double;
    FpFCPST: Double;
    FvFCPST: Double;
    FvBCSTRet: Double;
    FpST: Double;
    FvICMSSubstituto: Double;
    FvICMSSTRet: Double;
    FvBCFCPSTRet: Double;
    FpFCPSTRet: Double;
    FvFCPSTRet: Double;
    FpRedBCEfet: Double;
    FvBCEfet: Double;
    FpICMSEfet: Double;
    FvICMSEfet: Double;
    FvICMSSTDeson: Double;
    FmotDesICMSST: Integer;
    FpFCPDif: Double;
    FvFCPDif: Double;
    FvFCPEfet: Double;
    FICMSUFDestDTO: TICMSUFDestDTO;
    FIIDTO: TIIDTO;
    FPISDTO: TPISDTO;
    FPISSTDTO: TPISSTDTO;
    FCOFINSDTO: TCOFINSDTO;
    FCOFINSStDTO: TCOFINSStDTO;
  public
    property COFINSStDTO: TCOFINSStDTO read FCOFINSStDTO write FCOFINSStDTO;
    property PISSTDTO: TPISSTDTO read FPISSTDTO write FPISSTDTO;
    property COFINSDTO: TCOFINSDTO read FCOFINSDTO write FCOFINSDTO;
    property PISDTO: TPISDTO read FPISDTO write FPISDTO;
    property IIDTO: TIIDTO read FIIDTO write FIIDTO;
    property ICMSUFDestDTO: TICMSUFDestDTO read FICMSUFDestDTO write FICMSUFDestDTO;
    property orig: Integer read Forig write Forig;
    property CST: Integer read FCST write FCST;
    property modBC: Integer read FmodBC write FmodBC;
    property pRedBC: Double read FpRedBC write FpRedBC;
    property vBC: Double read FvBC write FvBC;
    property pICMS: Double read FpICMS write FpICMS;
    property vICMS: Double read FvICMS write FvICMS;
    property vICMSDeson: Double read FvICMSDeson write FvICMSDeson;
    property motDesICMS: Integer read FmotDesICMS write FmotDesICMS;
    property indDeduzDeson: Integer read FindDeduzDeson write FindDeduzDeson;
    property CSOSN: Integer read FCSOSN write FCSOSN;
    property modBCST: Integer read FmodBCST write FmodBCST;
    property pCredSN: Double read FpCredSN write FpCredSN;
    property vCredICMSSN: Double read FvCredICMSSN write FvCredICMSSN;
    property pMVAST: Double read FpMVAST write FpMVAST;
    property pRedBCST: Double read FpRedBCST write FpRedBCST;
    property vBCST: Double read FvBCST write FvBCST;
    property pICMSST: Double read FpICMSST write FpICMSST;
    property vICMSST: Double read FvICMSST write FvICMSST;
    property vBCFCPST: Double read FvBCFCPST write FvBCFCPST;
    property pFCPST: Double read FpFCPST write FpFCPST;
    property vFCPST: Double read FvFCPST write FvFCPST;
    property vBCSTRet: Double read FvBCSTRet write FvBCSTRet;
    property pST: Double read FpST write FpST;
    property vICMSSubstituto: Double read FvICMSSubstituto write FvICMSSubstituto;
    property vICMSSTRet: Double read FvICMSSTRet write FvICMSSTRet;
    property vBCFCPSTRet: Double read FvBCFCPSTRet write FvBCFCPSTRet;
    property pFCPSTRet: Double read FpFCPSTRet write FpFCPSTRet;
    property vFCPSTRet: Double read FvFCPSTRet write FvFCPSTRet;
    property pRedBCEfet: Double read FpRedBCEfet write FpRedBCEfet;
    property vBCEfet: Double read FvBCEfet write FvBCEfet;
    property pICMSEfet: Double read FpICMSEfet write FpICMSEfet;
    property vICMSEfet: Double read FvICMSEfet write FvICMSEfet;
    property vICMSSTDeson: Double read FvICMSSTDeson write FvICMSSTDeson;
    property motDesICMSST: Integer read FmotDesICMSST write FmotDesICMSST;
    property pFCPDif: Double read FpFCPDif write FpFCPDif;
    property vFCPDif: Double read FvFCPDif write FvFCPDif;
    property vFCPEfet: Double read FvFCPEfet write FvFCPEfet;
  end;

  TProduto = class
  private
    FnItem: Integer;
    FcProd: string;
    FcEAN: string;
    FxProd: string;
    FNCM: string;
    FEXTIPI: string;
    FCFOP: string;
    FuCom: string;
    FqCom: Double;
    FvUnCom: Double;
    FvProd: Double;
    FcEANTrib: string;
    FuTrib: string;
    FqTrib: Double;
    FvUnTrib: Double;
    FvOutro: Double;
    FvFrete: Double;
    FvSeg: Double;
    FvDesc: Double;
    FImposto: TICMSDTO;
  public
    property nItem: Integer read FnItem write FnItem;
    property cProd: string read FcProd write FcProd;
    property cEAN: string read FcEAN write FcEAN;
    property xProd: string read FxProd write FxProd;
    property NCM: string read FNCM write FNCM;
    property EXTIPI: string read FEXTIPI write FEXTIPI;
    property CFOP: string read FCFOP write FCFOP;
    property uCom: string read FuCom write FuCom;
    property qCom: Double read FqCom write FqCom;
    property vUnCom: Double read FvUnCom write FvUnCom;
    property vProd: Double read FvProd write FvProd;
    property cEANTrib: string read FcEANTrib write FcEANTrib;
    property uTrib: string read FuTrib write FuTrib;
    property qTrib: Double read FqTrib write FqTrib;
    property vUnTrib: Double read FvUnTrib write FvUnTrib;
    property vOutro: Double read FvOutro write FvOutro;
    property vFrete: Double read FvFrete write FvFrete;
    property vSeg: Double read FvSeg write FvSeg;
    property vDesc: Double read FvDesc write FvDesc;
    property Imposto: TICMSDTO read FImposto write FImposto;
  end;
  TProdutos =  Array of TProduto;

implementation

end.
