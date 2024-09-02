unit uVerifica.Palavras;

interface
uses Commands.consts, System.SysUtils, System.StrUtils, System.Generics.Collections;

Type
  TValidador = class
  private
    FKeywords: TList<string>;
    procedure AddKeyword(const AKeyword: string);
  public
    constructor Create;
    destructor Destroy; override;
    function Validate(const AText: string): TList<string>;
  end;

implementation

{ TValidador }

procedure TValidador.AddKeyword(const AKeyword: string);
begin
  FKeywords.Add(AKeyword.ToUpper);
end;

constructor TValidador.Create;
var
  Keyword: string;
  KeywordsArray: TArray<string>;
begin
  FKeywords := TList<string>.Create;
  KeywordsArray := GetAllKeywords;

  for Keyword in KeywordsArray do
    FKeywords.Add(Keyword.ToLower);
end;

destructor TValidador.Destroy;
begin
  FKeywords := TList<string>.Create;
  inherited;
end;

function TValidador.Validate(const AText: string): TList<string>;
var
  Keyword: string;
  FoundKeywords: TList<string>;
begin
  FoundKeywords := TList<string>.Create;
  for Keyword in FKeywords do
  begin
    if ContainsText(AText.ToLower, Keyword) then
      FoundKeywords.Add(Keyword);
  end;
  Result := FoundKeywords;
end;

end.
