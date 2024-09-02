unit Commands.consts;

interface

const
  SEPARADOR = ';';

  // MENUS
  MENU_NF = 'NOTA FISCAL' + SEPARADOR + 'FATURAMENTO' + SEPARADOR + 'NF' + SEPARADOR + 'NFE';
  ACOES_MENU_NF = '';

  MENU_CADASTRO_CLIENTE = 'CLIENTE' + SEPARADOR + 'CLIENTES';
  MENU_CADASTRO_PRODUTO = 'PRODUTO' + SEPARADOR + 'PRODUTOS';

  ACOES_MENUS = 'ABRIR' + SEPARADOR +
                'ABRA'  + SEPARADOR +
                'ABRE'  + SEPARADOR +
                'FECHAR' + SEPARADOR +
                'FECHE' + SEPARADOR +
                'FECHA' + SEPARADOR +
                'CADASTRAR' + SEPARADOR +
                'CADASTRE' + SEPARADOR +
                'CADASTRA' + SEPARADOR +
                'EXCLUIR' + SEPARADOR +
                'EXCLUA' + SEPARADOR +
                'EXCLUE' + SEPARADOR +
                'EDITAR'+ SEPARADOR +
                'EDITE'+ SEPARADOR +
                'EDITA'+ SEPARADOR +
                'INCLUIR '+ SEPARADOR +
                'INCLUA '+ SEPARADOR +
                'INCLUE '+ SEPARADOR +
                'DELETAR'+ SEPARADOR +
                'DELETE'+ SEPARADOR +
                'DELETA'+ SEPARADOR +
                'ALTERE'+ SEPARADOR +
                'ALTERA'+ SEPARADOR +
                'ALTERAR'+ SEPARADOR +
                'EMITA'+ SEPARADOR +
                'EMITE'+ SEPARADOR +
                'EMITIR'+ SEPARADOR +
                'IMITIR'+ SEPARADOR +
                'GERAR'+ SEPARADOR +
                'GERA'+ SEPARADOR;



function GetAllKeywords: TArray<string>;

implementation

uses
  SysUtils, StrUtils, Classes;

function GetAllKeywords: TArray<string>;
var
  Keywords: TStringList;
begin
  Keywords := TStringList.Create;
  try
    Keywords.Delimiter := SEPARADOR;
    Keywords.StrictDelimiter := True;

    // Adiciona palavras-chave compostas
    Keywords.DelimitedText := MENU_NF + SEPARADOR +
                              MENU_CADASTRO_CLIENTE + SEPARADOR +
                              MENU_CADASTRO_PRODUTO + SEPARADOR +
                              ACOES_MENUS;

    Result := Keywords.ToStringArray;
  finally
    Keywords.Free;
  end;
end;

end.

