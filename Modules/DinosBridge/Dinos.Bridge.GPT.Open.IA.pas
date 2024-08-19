unit Dinos.Bridge.GPT.Open.IA;

interface

uses
  sysUtils, strutils, Classes,
  OpenAI,
  OpenAI.Audio,
  OpenAI.Chat;

type
  TDinosChatGPT = class(TOpenAI)
  private
   Const
    API_KEY  = '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';
    BASE_URL = 'https://api.openai.com/v1';
    CONNECTION_TIME_OUT = 60000;
   var
    FModelsAvailability: TStringList;
  public
    function TextToSpeench(const AText: String): TMemoryStream;
    function SendMessage(const AMessage : string): string;
    function GetModelAvailability : TStringList;
    constructor Create();
    destructor Destroy; override;
  end;

implementation

{ TChatGPT }

constructor TDinosChatGPT.Create();
begin
  inherited Create(API_KEY);
  FModelsAvailability := TStringList.Create;
  BaseURL := BASE_URL;
end;

destructor TDinosChatGPT.Destroy;
begin
  FreeAndNil(FModelsAvailability);
  inherited;
end;

function TDinosChatGPT.GetModelAvailability: TStringList;
begin
  var Models := Model.List();
  try
    for var Model in Models.Data do
      FModelsAvailability.Add(Model.Id);
  finally
    Models.Free;
  end;
end;

function TDinosChatGPT.SendMessage(const AMessage: string): string;
begin
  var _Chat := Chat.Create(
                            procedure(Params: TChatParams)
                            begin
                              Params.Messages([TChatMessageBuild.Create(TMessageRole.User, AMessage)]);
                              Params.MaxTokens(1024);
                             end);
  try
   Result := _Chat.Choices[0].Message.Content;
  finally
    _Chat.Free;
  end;
end;

function TDinosChatGPT.TextToSpeench(const AText: String): TMemoryStream;
begin
  Result := TMemoryStream.Create;
  Audio.CreateSpeech(procedure(param: TAudioSpeechParams)
                                        begin
                                          param
                                            .Model('tts-1')
                                            .Voice('onyx')
                                            .Input(AText);
                                        end, Result);
end;

end.
