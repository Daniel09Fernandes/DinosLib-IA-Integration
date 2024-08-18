unit Dinos.Bridge.GPT.Open.IA;

interface

uses
  sysUtils, strutils, Classes,
  OpenAI;

type
  TChatGPT = class(TOpenAI)
  private
   Const
    API_KEY = '';
    BASE_URL = 'https://api.openai.com/v1';
   var
    FModelsAvailability: TStringList;
  public
    function GetModelAvailability : TStringList;
    constructor Create();
    destructor Destroy; override;

  end;

implementation

{ TChatGPT }

constructor TChatGPT.Create();
begin
  inherited Create(API_KEY);
  FModelsAvailability := TStringList.Create;
  BaseURL := BASE_URL;
end;

destructor TChatGPT.Destroy;
begin
  FreeAndNil(FModelsAvailability);
  inherited;
end;

function TChatGPT.GetModelAvailability: TStringList;
begin
  var Models := Model.List();
  try
    for var Model in Models.Data do
      FModelsAvailability.Add(Model.Id);
  finally
    Models.Free;
  end;
end;

end.
