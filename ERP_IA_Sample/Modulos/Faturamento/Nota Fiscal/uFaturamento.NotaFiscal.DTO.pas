unit uFaturamento.NotaFiscal.DTO;

interface
type
  TEmitenteEndereco = class
  private
    FFone: string;
    FCEP: integer;
    FLogradouro: string;
    FNro: string;
    FComplemento: string;
    FxBairro: string;
    FcodMunicipio: integer;
    FNomeMunicipio: string;
    FUF: string;
    FCodPais: string;
    FNomePais: string;
  public
    property Fone: string read FFone write FFone;
    property CEP: integer read FCEP write FCEP;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Nro: string read FNro write FNro;
    property Complemento: string read FComplemento write FComplemento;
    property Bairro: string read FxBairro write FxBairro;
    property codMunicipio: integer read FcodMunicipio write FcodMunicipio;
    property NomeMunicipio: string read FNomeMunicipio write FNomeMunicipio;
    property UF: string read FUF write FUF;
    property CodPais: string read FCodPais write FCodPais;
    property NomePais: string read FNomePais write FNomePais;
  end;

  TEmitente = class
  private
    FCNPJCPF: string;
    FIE: string;
    FNome: string;
    FFantasia: string;
    FEndereco: TEmitenteEndereco;
    FIEST: string;
    FIM: string;
    FCNAE: string;
  public
    property CNPJCPF: string read FCNPJCPF write FCNPJCPF;
    property IE: string read FIE write FIE;
    property Nome: string read FNome write FNome;
    property Fantasia: string read FFantasia write FFantasia;
    property Endereco: TEmitenteEndereco read FEndereco write FEndereco;
    property IEST: string read FIEST write FIEST;
    property IM: string read FIM write FIM;
    property CNAE: string read FCNAE write FCNAE;
  end;

  TClienteDestEndereco = class(TEmitenteEndereco)

  end;

  TClienteDest = class(TEmitente)
    private
      FSufixo: String;
      FEndereco : TClienteDestEndereco;
    public
      property Endereco: TClienteDestEndereco read FEndereco write FEndereco;
      property Sufixo: String read FSufixo write FSufixo;
  end;

implementation

end.
