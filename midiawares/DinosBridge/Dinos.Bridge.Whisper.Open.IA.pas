{MIT License

Copyright (c) 2022 Daniel Fernandes - @DinosDev

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

{ File     : Dinos.Bridge.Whisper.Open.IA.pas}
{ Developer: Daniel Fernandes Rodrigures }
{ Email    : danielfernandesroddrigues@gmail.com }
{ Instagram: @DinosDev }
{ this unit is a part of the Open Source. }
{ licensed under a MIT - see LICENSE.md}
{ ******************************************************* }
{
    Modelos disponíveis no Whisper
    Nome do modelo	Tamanho (MB)	Requisitos de GPU	    Velocidade	    Precisão
    tiny             	~39 MB           	Muito leve	     Muito rápida	  Baixa
    base             	~74 MB	          Leve	           Rápida	        Boa
    small            	~244 MB	          Moderada	       Média	        Melhor
    medium           	~769 MB	          Alta	           Mais lenta	    Muito boa
    large            	~1550 MB         	Alta	           Mais lenta	    Excelente
}

unit Dinos.Bridge.Whisper.Open.IA;

interface

uses
  SysUtils, StrUtils, Classes, Winapi.Windows;

type
  TWhisperLanguage = (wlAuto, wlPortuguese, wlEnglish, wlSpanish);
  TWhisperDevice = (wdCPU, wdVRAM_CUDA);
  TWhisperModel = (wmTiny, wmBase, wmSmall, wmMedium, wmLarge);

  TWhisperModelHelper = record helper for TWhisperModel
    function ToString: string;
  end;

  TWhisperDevicelHelper = record helper for TWhisperDevice
    function ToString: string;
  end;

  TDinosWhisper = class
  private
  var
    FPathConda: string;
    FEnvironment: string;
    FAudioFilePath: string;
    FLanguage: TWhisperLanguage;
    FModel: TWhisperModel;
    FDevice: TWhisperDevice;
    FFp16: string;
    FUseFp16: Boolean;

    procedure SetUseFp16(const Value: Boolean);
    function GetLanguageParam: string;
    function SanitizePath(const Path: string): string;
    function BuildWhisperCommand: string;
    function RunCommand(const Command: string): string;
  public
    constructor Create(const AAudioFilePath: string);

    function Execute: string;

    // Propriedades
    property CondaPath: string read FPathConda write FPathConda;
    property Environment: string read FEnvironment write FEnvironment;
    property Language: TWhisperLanguage read FLanguage write FLanguage
      default wlPortuguese;
    property Model: TWhisperModel read FModel write FModel;
    property Device: TWhisperDevice read FDevice write FDevice;
    property UseFp16: Boolean read FUseFp16 write SetUseFp16;
  end;

implementation

{ TDinosWhisper }

constructor TDinosWhisper.Create(const AAudioFilePath: string);
begin
  inherited Create;
  FAudioFilePath := AAudioFilePath;
  FLanguage := wlPortuguese;
  FModel := wmBase;
  FDevice := wdCPU;
end;

function TDinosWhisper.GetLanguageParam: string;
begin
  case FLanguage of
    wlPortuguese:
      Result := ' --language Portuguese';
    wlEnglish:
      Result := ' --language English';
    wlSpanish:
      Result := ' --language Spanish';
  else
    Result := '';
  end;
end;

function TDinosWhisper.SanitizePath(const Path: string): string;
begin
  Result := '"' + Path.Trim + '"';
end;

procedure TDinosWhisper.SetUseFp16(const Value: Boolean);
begin
  FUseFp16 := Value;

  if FUseFp16 then
    FFp16 := ' --fp16 True'
  else
    FFp16 := ' --fp16 False';
end;

function TDinosWhisper.BuildWhisperCommand: string;
var
  lCondaHookPath: string;
  lEnv: string;
begin
  if FPathConda.Trim.IsEmpty then
    raise Exception.Create
      ('Conda path is required. Typically: C:\Users\YourUser\anaconda3');

  lCondaHookPath := IncludeTrailingPathDelimiter(FPathConda) +
    'shell\condabin\conda-hook.ps1';
  lEnv := IfThen(FEnvironment.Trim.IsEmpty, 'base', FEnvironment);

  if FDevice = wdCPU then
    FUseFp16 := False; // Only VRAM use

  Result := Format
    ('powershell.exe -ExecutionPolicy Bypass -NoLogo -NoProfile -Command "& ''%s'';'
    + ' conda activate %s; whisper ''%s'' --model %s --device %s%s %s "',
    [lCondaHookPath, lEnv, FAudioFilePath, FModel.ToString, FDevice.ToString,
    GetLanguageParam, FFp16]);
end;

function TDinosWhisper.RunCommand(const Command: string): string;
var
  SecurityAttributes: TSecurityAttributes;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  Buffer: array [0 .. 255] of AnsiChar;
  BytesRead: DWORD;
  Output: string;
  CmdLine: string;
begin
  Result := '';
  SecurityAttributes.nLength := SizeOf(SecurityAttributes);
  SecurityAttributes.bInheritHandle := TRUE;
  SecurityAttributes.lpSecurityDescriptor := nil;

  if CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SecurityAttributes, 0) then
    try
      ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
      StartupInfo.cb := SizeOf(StartupInfo);
      StartupInfo.hStdOutput := StdOutPipeWrite;
      StartupInfo.hStdError := StdOutPipeWrite;
      StartupInfo.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
      StartupInfo.wShowWindow := SW_HIDE;

      // Executa powershell.exe direto, passando só os parâmetros para o comando
      CmdLine := Command; // Command já inicia com "powershell.exe ..."

      if CreateProcess(nil, PChar(CmdLine), nil, nil, TRUE, 0, nil, nil,
        StartupInfo, ProcessInfo) then
        try
          CloseHandle(StdOutPipeWrite);
          while ReadFile(StdOutPipeRead, Buffer, SizeOf(Buffer) - 1, BytesRead,
            nil) and (BytesRead > 0) do
          begin
            Buffer[BytesRead] := #0;
            Output := Output + string(Buffer);
          end;
          WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
          Result := Output;
        finally
          CloseHandle(ProcessInfo.hProcess);
          CloseHandle(ProcessInfo.hThread);
        end;
    finally
      CloseHandle(StdOutPipeRead);
    end;
end;

function TDinosWhisper.Execute: string;
begin
  if not FileExists(FAudioFilePath) then
    raise Exception.CreateFmt('Audio file not found: %s', [FAudioFilePath]);

  Result := RunCommand(BuildWhisperCommand);
end;

{ TWhisperModelHelper }

function TWhisperModelHelper.ToString: string;
begin
  case self of
    wmTiny:
      Result := 'tiny';
    wmBase:
      Result := 'base';
    wmSmall:
      Result := 'small';
    wmMedium:
      Result := 'medium';
    wmLarge:
      Result := 'large';
  end;
end;

{ TWhisperDevicelHelper }

function TWhisperDevicelHelper.ToString: string;
begin
 case self of
   wdCPU: Result := 'cpu';
   wdVRAM_CUDA: Result := 'cuda';
 end;
end;

end.
