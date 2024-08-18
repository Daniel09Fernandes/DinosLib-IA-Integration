unit uTesteOpenIA.Whisper;

interface

uses
  Dinos.Bridge.Bass,
  Dinos.Bridge.Whisper.Open.IA,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ShellApi, Vcl.MPlayer,
  Vcl.ExtCtrls;

type
//  WAVHDR = packed record
//    riff: array [0 .. 3] of AnsiChar;
//    len: DWord;
//    cWavFmt: array [0 .. 7] of AnsiChar;
//    dwHdrLen: DWord;
//    wFormat: Word;
//    wNumChannels: Word;
//    dwSampleRate: DWord;
//    dwBytesPerSec: DWord;
//    wBlockAlign: Word;
//    wBitsPerSample: Word;
//    cData: array [0 .. 3] of AnsiChar;
//    dwDataLen: DWord;
//  end;

  TForm2 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    Timer1: TTimer;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
//    SilenceCounter: integer;
    DinosMic : TDinosMicRec;
    procedure CaptureConsoleOutput(const ACommand, AParameters: String;
      AMemo: TMemo);
    function GetDosOutput(CommandLine, Work: string): string;
    function GetPowerShellOutput(CommandLine, Work: string): string;
    function RunCommandAndGetOutput(const Command: string): string;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
//  WaveStream: TMemoryStream;
//  WaveHdr: WAVHDR;
//  Chan:  HStream = 0;
//  rchan: HRecord = 0;
implementation

{$R *.dfm}

//function RecordingCallback(Handle: HRecord; buffer: Pointer; length: DWord; user: Pointer): boolean; stdcall;
//begin
//  // Copy new buffer contents to the memory buffer
//  WaveStream.Write(buffer^, length);
//  {
//    in the C Example
//    if ((reclen mod BUFSTEP) + length >= BUFSTEP) ....
//		recbuf = realloc(recbuf, ((reclen + length) / BUFSTEP + 1) * BUFSTEP);
//    this is in Delphi not Needed TMemorystream will (if needed ) increase the size of the memory buffer self
//  }
//  // Allow recording to continue
//  Result := True;
//end;



procedure TForm2.Button1Click(Sender: TObject);
const
  TesteAudio = 'D:\Fontes\PalestraIA\ProjetoTeste\Win32\Debug\teste.wav';
//  C:\Users\danie\OneDrive\Documents\Audios\teste.wav
begin
  Memo1.Lines.Clear;
//  GetPowerShellOutput('whisper C:\Users\danie\OneDrive\Documents\Audios\teste.wav --language Portuguese','');
//  var Output := RunCommandAndGetOutput('%windir%\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy ByPass -NoExit -Command "& ''D:\Users\daniel\anaconda3\shell\condabin\conda-hook.ps1'' ; conda activate ''D:\Users\daniel\anaconda3'';'+ 'whisper '+TesteAudio+' --language Portuguese"');
  var DinosWhisper := TDinosWhisper.Create(DinosMic.PathSaveFile);
  try
    Memo1.Lines.Text := DinosWhisper.GetTextFromWav;
  finally
    DinosWhisper.Free;
  end;
//  GetDosOutput('whisper C:\Users\danie\OneDrive\Documents\Audios\teste.wav --language Portuguese','');
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  memo2.Lines.Clear;
  DinosMic.StartRecord;

//  if WaveStream.Size > 0 then
//  begin
//    // free old recording
//    BASS_StreamFree(rchan);
//    WaveStream.Clear;
//  end;
//
//  // generate header for WAV file
//  with WaveHdr do
//  begin
//    riff := 'RIFF';
//    len := 36;
//    cWavFmt := 'WAVEfmt ';
//    dwHdrLen := 16;
//    wFormat := 1;
//    wNumChannels := 2;
//    dwSampleRate := 44100;
//    wBlockAlign := 4;
//    dwBytesPerSec := 176400;
//    wBitsPerSample := 16;
//    cData := 'data';
//    dwDataLen := 0;
//  end;
//  WaveStream.Write(WaveHdr, SizeOf(WAVHDR));
//
//  // start recording @ 44100hz 16-bit stereo
//  rchan := BASS_RecordStart(44100, 2, 0, @RecordingCallback, nil);
//
//  if rchan = 0 then
//  begin
//    MessageDlg('Couldn''t start recording!' + 'ErrorCode ' + inttostr(BASS_ErrorGetCode()), mtError, [mbOk], 0);
//    WaveStream.Clear;
//  end
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  DinosMic.StopRecord;
//  BASS_ChannelStop(rchan);
//  rchan := 0;
//
//  // complete the WAV header
//  WaveStream.Position := 4;
//  var i := WaveStream.Size - 8;
//  WaveStream.Write(i, 4);
//  i := i - $24;
//  WaveStream.Position := 40;
//  WaveStream.Write(i, 4);
//  WaveStream.Position := 0;
//  // create a stream from the recorded data
//  chan := BASS_StreamCreateFile(True, WaveStream.Memory, 0, WaveStream.Size, 0);
//  WaveStream.SaveToFile(GetCurrentDir+'/teste.wav');
end;

procedure TForm2.CaptureConsoleOutput(const ACommand, AParameters: String; AMemo: TMemo);
 const
   CReadBuffer = 2400;
 var
   saSecurity: TSecurityAttributes;
   hRead: THandle;
   hWrite: THandle;
   suiStartup: TStartupInfo;
   piProcess: TProcessInformation;
   pBuffer: array[0..CReadBuffer] of AnsiChar;
   dRead: DWord;
   dRunning: DWord;
 begin
   saSecurity.nLength := SizeOf(TSecurityAttributes);
   saSecurity.bInheritHandle := True;
   saSecurity.lpSecurityDescriptor := nil;

   if CreatePipe(hRead, hWrite, @saSecurity, 0) then
   begin
     FillChar(suiStartup, SizeOf(TStartupInfo), #0);
     suiStartup.cb := SizeOf(TStartupInfo);
     suiStartup.hStdInput := hRead;
     suiStartup.hStdOutput := hWrite;
     suiStartup.hStdError := hWrite;
     suiStartup.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
     suiStartup.wShowWindow := SW_HIDE;

     if CreateProcess(nil, PChar(ACommand + ' ' + AParameters), @saSecurity,
       @saSecurity, True, NORMAL_PRIORITY_CLASS, nil, nil, suiStartup, piProcess)
       then
     begin
       repeat
         dRunning  := WaitForSingleObject(piProcess.hProcess, 100);
         Application.ProcessMessages();
         repeat
           dRead := 0;
           ReadFile(hRead, pBuffer[0], CReadBuffer, dRead, nil);
           pBuffer[dRead] := #0;

           OemToAnsi(pBuffer, pBuffer);
           AMemo.Lines.Add(String(pBuffer));
         until (dRead < CReadBuffer);
       until (dRunning <> WAIT_TIMEOUT);
       CloseHandle(piProcess.hProcess);
       CloseHandle(piProcess.hThread);
     end;

     CloseHandle(hRead);
     CloseHandle(hWrite);
   end;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  BASS_RecordFree();
//  Bass_Free;
//  WaveStream.Free;

 FreeAndNil(DinosMic);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
//   BASS_Init(-1, 44100, 0, Application.Handle, nil);
//  SilenceCounter:= 0;
//  WaveStream := TMemoryStream.Create;
//  if (not BASS_RecordInit(0)) or (not BASS_Init(1, 44100, 0, Application.Handle, Nil)) then
//  begin
//    ShowMessage('Não foi possível iniciar o dispositivo');
//    Close();
//  end;
//
//  BASS_RecordInit(0);
//
// // rchan := BASS_RecordStart(44100, BASS_RECORD_PAUSE, nil, 0);
  DinosMic := TDinosMicRec.GetInstance;
end;

function TForm2.GetDosOutput(CommandLine, Work: string): string;  { Run a DOS program and retrieve its output dynamically while it is running. }
var
  SecAtrrs: TSecurityAttributes;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  WasOK: Boolean;
  pCommandLine: array[0..255] of AnsiChar;
  BytesRead: Cardinal;
  WorkDir: string;
  Handle: Boolean;
begin
  Result := '';
  with SecAtrrs do begin
    nLength := SizeOf(SecAtrrs);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SecAtrrs, 0);
  try
    with StartupInfo do
    begin
      FillChar(StartupInfo, SizeOf(StartupInfo), 0);
      cb := SizeOf(StartupInfo);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdin
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;

    if work = '' then
      Work := GetCurrentDir;

    WorkDir := Work;
    Handle := CreateProcess(nil, PChar('cmd.exe /C ' + CommandLine),
                            nil, nil, True, 0, nil,
                            PChar(WorkDir), StartupInfo, ProcessInfo);
    CloseHandle(StdOutPipeWrite);
    if Handle then
      try
        repeat
          WasOK := ReadFile(StdOutPipeRead, pCommandLine, 255, BytesRead, nil);
          if BytesRead > 0 then
          begin
            pCommandLine[BytesRead] := #0;
            Result := Result + pCommandLine;
          end;
        until not WasOK or (BytesRead = 0);
        WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
      finally
        CloseHandle(ProcessInfo.hThread);
        CloseHandle(ProcessInfo.hProcess);
      end;
  finally
    CloseHandle(StdOutPipeRead);
  end;
end;


function TForm2.GetPowerShellOutput(CommandLine, Work: string): string;
var
  SecAtrrs: TSecurityAttributes;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  WasOK: Boolean;
  pCommandLine: array[0..255] of AnsiChar;
  BytesRead: Cardinal;
  WorkDir: string;
  Handle: Boolean;
begin
  Result := '';
  with SecAtrrs do begin
    nLength := SizeOf(SecAtrrs);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SecAtrrs, 0);
  try
    with StartupInfo do
    begin
      FillChar(StartupInfo, SizeOf(StartupInfo), 0);
      cb := SizeOf(StartupInfo);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdin
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;

    if work = '' then
      Work := GetCurrentDir;

    WorkDir := Work;
    Handle := CreateProcess(nil, PChar('%windir%\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy ByPass -NoExit -Command "& ''D:\Users\daniel\anaconda3\shell\condabin\conda-hook.ps1'' ; conda activate ''D:\Users\daniel\anaconda3''; ' + CommandLine + '"'),
                            nil, nil, True, 0, nil,
                            PChar(WorkDir), StartupInfo, ProcessInfo);
    CloseHandle(StdOutPipeWrite);
    if Handle then
      try
        repeat
          WasOK := ReadFile(StdOutPipeRead, pCommandLine, 255, BytesRead, nil);
          if BytesRead > 0 then
          begin
            pCommandLine[BytesRead] := #0;
            Result := Result + pCommandLine;
          end;
        until not WasOK or (BytesRead = 0);
        WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
      finally
        CloseHandle(ProcessInfo.hThread);
        CloseHandle(ProcessInfo.hProcess);
      end;
  finally
    CloseHandle(StdOutPipeRead);
  end;
end;


function TForm2.RunCommandAndGetOutput(const Command: string): string;
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
        Memo1.Lines.Text := Output;
        Application.ProcessMessages;
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

procedure TForm2.Timer1Timer(Sender: TObject);
var
  level: Single;
begin
   DinosMic.PauseForSilence;

   if DinosMic.FreqMic > 0 then
     Memo2.Lines.Add(DinosMic.FreqMic.ToString);
//  level := BASS_ChannelGetLevel(rchan);
//  //7471218
//  if level <> 4294967296 then //valor padrão mutado
//    memo2.Lines.Add(level.ToString);
//
//  if level < 11171220 then // Ajuste o nível de silêncio conforme necessário
//    Inc(SilenceCounter)
//  else
//    SilenceCounter := 0;
//
//  if SilenceCounter > 2 then // Ajuste o número de verificações de silêncio conforme necessário
//  begin
//    //Timer1.Enabled := False;
//    Button3Click(sender);
//    ShowMessage('Gravação parada devido ao silêncio');
//  end;
end;


end.
