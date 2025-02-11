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

{ File     : Dinos.Bridge.Whisper.OpenIA.pas }
{ Developer: Daniel Fernandes Rodrigures }
{ Email    : danielfernandesroddrigues@gmail.com }
{ Instagram: @DinosDev }
{ this unit is a part of the Open Source. }
{ licensed under a MIT - see LICENSE.md}

{ ******************************************************* }

unit Dinos.Bridge.Whisper.Open.IA;

interface
uses
 sysUtils, strUtils;

type
  TDinosWhisper = class
    private
    const
      PATH_ANACONDA  = 'D:\Users\daniel\anaconda3';  // Anaconda intalled loacation
      POWERSHELL     = '%windir%\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy ByPass -NoExit -Command ';
      CALL_ANACONDA  = '"& '''+PATH_ANACONDA+'\shell\condabin\conda-hook.ps1'' ; conda activate '''+PATH_ANACONDA+''';';
      WHISPER        = ' whisper [PATH_WAV]  ';
      MODEL_TYNY     = ' --model tiny '; // for performace use tyny BUT is not good model
      MODEL_BASE     = ' --model base '; // for performace use base, i think, bette than tyny
      FPS_16         = ' --fp16 False ';
      TEMP_05        = '--temperature 0.5 ';
      BEAM_SIZE_1    = ' --beam_size 1 ';
      LANGUAGE_PT_BR = ' --language Portuguese ';
      LANGUAGE_EN    = ' --language English ';
    function RunCommandAndGetOutput(const Command: string): string;
    var
      FCommandShell: String;
    public
     function GetTextFromWav:string;
     constructor Create(APathWaveFile: String);
  end;

implementation

uses
  Winapi.Windows;

{ TDinosWhisper }

constructor TDinosWhisper.Create(APathWaveFile: String);
begin
  FCommandShell := POWERSHELL +
                   CALL_ANACONDA +
                   WHISPER.Replace('[PATH_WAV]',APathWaveFile)+
                   MODEL_BASE     +
                   FPS_16         +
                   TEMP_05        +
                 //BEAM_SIZE_1    +
                 //LANGUAGE_PT_BR +'"'; // to Brazilian, descomented this line and comment the LANGUAGE_EN
                   LANGUAGE_EN +'"';
end;

function TDinosWhisper.GetTextFromWav: string;
begin
  Result := RunCommandAndGetOutput(FCommandShell);
end;

function TDinosWhisper.RunCommandAndGetOutput(const Command: string): string;
var
  SecurityAttributes: TSecurityAttributes;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  Buffer: array[0..255] of AnsiChar;
  BytesRead: DWORD;
  Output: string;
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

    if CreateProcess(nil, PChar('cmd.exe /C ' + Command), nil, nil, TRUE, 0, nil, nil, StartupInfo, ProcessInfo) then
    try
      CloseHandle(StdOutPipeWrite);
      while ReadFile(StdOutPipeRead, Buffer, SizeOf(Buffer) - 1, BytesRead, nil) do
      begin
        Buffer[BytesRead] := #0;
        Output := Output + string(Buffer);
        if pos('(base)',Output) > 0 then Break;
      end;
      WaitForSingleObject(ProcessInfo.hProcess, 50);
      Result := Output;
    finally
      CloseHandle(ProcessInfo.hProcess);
      CloseHandle(ProcessInfo.hThread);
    end;
  finally
    CloseHandle(StdOutPipeRead);
  end;
end;

end.
