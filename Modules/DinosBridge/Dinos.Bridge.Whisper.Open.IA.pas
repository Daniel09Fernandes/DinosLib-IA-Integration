unit Dinos.Bridge.Whisper.Open.IA;

interface
uses
 sysUtils, strUtils;

type
  TDinosWhisper = class
    private
    const
      PATH_ANACONDA = 'D:\Users\daniel\anaconda3';  //Local da instalação do Anaconda
      POWERSHELL    = '%windir%\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy ByPass -NoExit -Command ';
      CALL_ANACONDA = '"& '''+PATH_ANACONDA+'\shell\condabin\conda-hook.ps1'' ; conda activate '''+PATH_ANACONDA+''';';
      WHISPER = 'whisper [PATH_WAV] --language Portuguese"';

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
  FCommandShell := POWERSHELL + CALL_ANACONDA + WHISPER.Replace('[PATH_WAV]',APathWaveFile);
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
