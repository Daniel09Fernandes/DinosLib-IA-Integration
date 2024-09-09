{MIT License

Copyright (c) 2022 Daniel Fernandes

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.}
{ ******************************************************* }

{ Delphi openOffice Library }

{ File     : Dinos.Bridge.GPT.OpenIA.pas }
{ Developer: Daniel Fernandes Rodrigures }
{ Email    : danielfernandesroddrigues@gmail.com }
{ Instagram: @DinosDev }
{ this unit is a part of the Open Source. }
{ licensed under a MIT - see LICENSE.md}

{ ******************************************************* }
unit Dinos.Bridge.GPT.Open.IA;

interface

uses
  sysUtils, strutils, Classes,
  OpenAI,
  OpenAI.Audio,
  OpenAI.Chat;

type
  TypeGPTVoice = (tvOnyx, tvAlloy, tvEcho, tvFable, tvNova, tvShimmer);

  TypeGPTVoiceHelper = record helper for TypeGPTVoice
    function ToString: string;
  end;

  TDinosChatGPT = class(TOpenAI)
  private
   Const
    API_KEY  = 'sk-proj-xxxxxx';
    BASE_URL = 'https://api.openai.com/v1';
    CONNECTION_TIME_OUT = 60000;
   var
    FModelsAvailability: TStringList;
    FVoice: TypeGPTVoice;
  public
    function TextToSpeench(const AText: String): TMemoryStream;
    function SendMessage(const AMessage : string): string;
    function GetModelAvailability : TStringList;
    property Voice : TypeGPTVoice read FVoice  write FVoice;
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
                                            .Voice(FVoice.ToString)
                                            .Input(AText);
                                        end, Result);
end;


{ TypeGPTVoiceHelper }

function TypeGPTVoiceHelper.ToString: string;
begin
   case Self of
    tvOnyx: Result := 'onyx';
    tvAlloy: Result := 'alloy';
    tvEcho: Result := 'echo';
    tvFable: Result := 'fable';
    tvNova: Result := 'nova';
    tvShimmer: Result := 'shimmer';
  else
    Result := 'onyx';
  end;
end;

end.
