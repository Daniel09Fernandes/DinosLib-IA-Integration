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

{ File     : Dinos.Bridge.Bass.pas }
{ Developer: Daniel Fernandes Rodrigures }
{ Email    : danielfernandesroddrigues@gmail.com }
{ Instagram: @DinosDev }
{ this unit is a part of the Open Source. }
{ licensed under a MIT - see LICENSE.md}

{ ******************************************************* }
unit Dinos.Bridge.Bass;

interface

uses Bass, System.Classes;

 const
    MIC_MUTE            = 4294967296;
    MIN_FREQ_OF_SILENCE = 11171220;
    STEP_SILENCE_MAX    = 3;
    MIC_DEVICE = 0;
    SAMPLE_RATES: array[0..3] of Integer = (44100, 48000, 22050, 96000);

Type

  TSampleRates = (sr44100, sr48000, sr22050, sr96000);

  WAVHDR = packed record
    riff: array [0 .. 3] of AnsiChar;
    len: DWord;
    cWavFmt: array [0 .. 7] of AnsiChar;
    dwHdrLen: DWord;
    wFormat: Word;
    wNumChannels: Word;
    dwSampleRate: DWord;
    dwBytesPerSec: DWord;
    wBlockAlign: Word;
    wBitsPerSample: Word;
    cData: array [0 .. 3] of AnsiChar;
    dwDataLen: DWord;
  end;

  TDinosMediaPlayer = class
  private
   FChan              : HStream;
   FRChan             : HRecord;
   FWaveStream        : TMemoryStream;
   FWaveHdr           : WAVHDR;
   FPathSaveFile      : String;
   FSilenceCounter    : Integer;
   FFreqMic           : Single;
   FSong              : Cardinal;
   FDeviceMicName     : String;
   FRating            : integer;
   FDeviceMicAvaliable: TStringList;

   function getPathSaveFile: String;
   procedure SetPathSaveFile(const Value: String);
   constructor Create(AInxMicDevice: integer = -1; ASampleRate: TSampleRates = sr44100);
   destructor Destroy; override;
   procedure SetWaveStream(const Value: TMemoryStream);
   procedure SetGenerateHeaderForWavFile;
   function  GetWaveStream: TMemoryStream;

   class var
     FInstance   : TDinosMediaPlayer;
    procedure ForceCloseFile(const AFileName: string);
    function IsFileLocked(const AFileName: string): Boolean;
  public
    property Channel          : HStream       read FChan;
    property RecChannel       : HRecord       read FRChan;
    property WaveStream       : TMemoryStream read GetWaveStream   write SetWaveStream;
    property WaveHdr          : WAVHDR        read FWaveHdr;
    property FreqMic          : Single        read FFreqMic        write FFreqMic;
    property PathSaveFile     : String        read getPathSaveFile write SetPathSaveFile;
    property DeviceMicName    : String        read FDeviceMicName;
    property DeviceMicAvaliabe: TStringList   read FDeviceMicAvaliable;

    function  StartRecord(): TDinosMediaPlayer;
    function  StopRecord(): TDinosMediaPlayer;
    function  PlaySong(AFile : String): TDinosMediaPlayer;
    function  PauseForSilence(): TDinosMediaPlayer;
    function  FreeSongOfMemory: TDinosMediaPlayer;
    function  StopSong(): TDinosMediaPlayer;
    function  SongIsFinished: Boolean;

    class function GetInstance(AInxMicDevice: integer = -1; ASampleRate: TSampleRates = sr44100): TDinosMediaPlayer;
    class function FreeInstance: TDinosMediaPlayer;
  end;
   var
     gWaveStream: TMemoryStream; //Copia global para o callback do audio

implementation

uses
  Vcl.Dialogs, System.SysUtils, Vcl.Forms;

function RecordingCallback(Handle: HRecord; buffer: Pointer; length: DWord; user: Pointer): boolean; stdcall;
var
  lPos: Int64;
begin
  if not Assigned(gWaveStream) then
    Exit(False);

  try
    lPos := gWaveStream.Position;
    gWaveStream.Position := gWaveStream.Size;
    gWaveStream.WriteBuffer(buffer^, length);
    gWaveStream.Position := lPos;
  except
    on E: Exception do
    begin
      //OutputDebugString(PChar('Erro no callback: ' + E.Message));
      Exit(False);
    end;
  end;

  Result := True;
end;


{ TDinosMicRec }

constructor TDinosMediaPlayer.Create(AInxMicDevice: integer = -1; ASampleRate: TSampleRates = sr44100);
var lMic: integer;
    lDeviceInfo: BASS_DEVICEINFO;
    MicIdx: integer;
begin
  FSilenceCounter := 0;
  FChan  := 0;
  FRChan := 0;
  FWaveStream := TMemoryStream.Create;
  gWaveStream := FWaveStream;
  FDeviceMicAvaliable := TStringList.Create;
  FRating := SAMPLE_RATES[Integer(ASampleRate)];

  if AInxMicDevice > 0 then
    lMic := AInxMicDevice
  else
    lMic := MIC_DEVICE;

   for MicIdx := 0 to 10 do
   begin
     if not BASS_RecordGetDeviceInfo(MicIdx, lDeviceInfo) then
       Break;

     FDeviceMicAvaliable.Add(MicIdx.ToString + ' - '+ lDeviceInfo.name);
   end;

   if not BASS_RecordGetDeviceInfo(lMic, lDeviceInfo) then
    raise Exception.Create('Não foi possível obter informações do dispositivo de gravação');

   FDeviceMicName := lDeviceInfo.name;

  if not BASS_Init(-1, FRating, 0, Application.Handle, nil) then
    raise Exception.Create('Não foi possível inicializar BASS: ' + IntToStr(BASS_ErrorGetCode()));

  if not BASS_RecordInit(lMic) then
    raise Exception.Create('Não foi possível inicializar dispositivo de gravação: ' + IntToStr(BASS_ErrorGetCode()));

  BASS_SetConfig(BASS_CONFIG_REC_BUFFER, 1024);
end;

//Singleton
destructor TDinosMediaPlayer.Destroy;
begin
  FreeSongOfMemory;

  if FRChan <> 0 then
    BASS_ChannelStop(FRChan);

  BASS_RecordFree;
  BASS_Free;

  FreeAndNil(FDeviceMicAvaliable);

  if Assigned(FWaveStream) then
    FreeAndNil(FWaveStream);

  inherited;
end;

function TDinosMediaPlayer.IsFileLocked(const AFileName: string): Boolean;
var
  lFileHandle: THandle;
begin
  Result := False;
  if FileExists(AFileName) then
  begin
    lFileHandle := FileOpen(AFileName, fmOpenRead or fmShareExclusive);
    if lFileHandle = INVALID_HANDLE_VALUE then
      Result := True // Arquivo está bloqueado
    else
      FileClose(lFileHandle); // Fecha o handle se conseguiu abrir
  end;
end;

procedure TDinosMediaPlayer.ForceCloseFile(const AFileName: string);
var
  lAttempt: Integer;
begin
  for lAttempt := 1 to 3 do // Tenta 3 vezes
  begin
    if not IsFileLocked(AFileName) then
      Break;

    Sleep(100); // Espera 100ms entre tentativas
    if lAttempt = 3 then
      raise Exception.Create('Não foi possível liberar o arquivo: ' + AFileName);
  end;
end;

class function TDinosMediaPlayer.FreeInstance: TDinosMediaPlayer;
begin
  if Assigned(FInstance) then
  begin
   FreeAndNil(FInstance);
  end;
end;

function TDinosMediaPlayer.FreeSongOfMemory: TDinosMediaPlayer;
begin
 if FSong > 0 then
   BASS_StreamFree(FSong);

 Result  := Self;
end;

class function TDinosMediaPlayer.GetInstance(AInxMicDevice: integer = -1; ASampleRate: TSampleRates = sr44100): TDinosMediaPlayer;
begin
  if not Assigned(FInstance) then
    FInstance := TDinosMediaPlayer.create(AInxMicDevice, ASampleRate);

  Result := FInstance;
end;

function TDinosMediaPlayer.getPathSaveFile: String;
begin
  if FPathSaveFile.trim.isEmpty then
    FPathSaveFile := GetCurrentDir+'\DinosRec.wav';

  Result := FPathSaveFile;
end;

function TDinosMediaPlayer.GetWaveStream: TMemoryStream;
begin
  gWaveStream := FWaveStream;
  Result      := FWaveStream;
end;

function TDinosMediaPlayer.PauseForSilence : TDinosMediaPlayer;  //Utilizar em um timer, para monitorar
var
  level: Single;
begin
  level := BASS_ChannelGetLevel(FRChan);

  if level = MIC_MUTE then
  begin
    FreqMic := 0;
    exit;
  end;

  FreqMic := level;

  if level < MIN_FREQ_OF_SILENCE then
    Inc(FSilenceCounter)
  else
    FSilenceCounter := 0;

  if FSilenceCounter > STEP_SILENCE_MAX then
    //StopRecord;

  Result := self;
end;

function TDinosMediaPlayer.PlaySong(AFile: String): TDinosMediaPlayer;
begin
  FSong := BASS_StreamCreateFile(False, PChar(AFile), 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
  BASS_ChannelPlay(FSong, False);
  Result := self;
end;

function TDinosMediaPlayer.StopSong(): TDinosMediaPlayer;
begin
  BASS_ChannelStop(FSong);
  Result := self;
end;

procedure TDinosMediaPlayer.SetGenerateHeaderForWavFile;
begin
  with FWaveHdr do
  begin
    riff := 'RIFF';
    len := 36;
    cWavFmt := 'WAVEfmt ';
    dwHdrLen := 16;
    wFormat := 1;
    wNumChannels := 2;
    dwSampleRate := FRating;
    wBlockAlign := 4;
    dwBytesPerSec := 176400;
    wBitsPerSample := 16;
    cData := 'data';
    dwDataLen := 0;
  end;
  WaveStream.Write(WaveHdr, SizeOf(WAVHDR));
end;

procedure TDinosMediaPlayer.SetPathSaveFile(const Value: String);
begin
  FPathSaveFile := value;
end;

procedure TDinosMediaPlayer.SetWaveStream(const Value: TMemoryStream);
begin
  FWaveStream := Value;
  gWaveStream := FWaveStream;
end;

function TDinosMediaPlayer.SongIsFinished: Boolean;
begin
  // Verifica o estado do canal
  case BASS_ChannelIsActive(FSong) of
    BASS_ACTIVE_STOPPED:
      Result := True; // O áudio terminou de tocar
    BASS_ACTIVE_PAUSED, BASS_ACTIVE_PLAYING:
      Result := False; // Ainda está tocando ou pausado
    else
      Result := True; // Em caso de erro, considera como terminado
  end;
end;

function TDinosMediaPlayer.StartRecord: TDinosMediaPlayer;
var
  lFlags: DWORD;
begin
  if WaveStream.Size > 0 then
  begin
    BASS_StreamFree(FRChan);
    WaveStream.Clear;
  end;

  SetGenerateHeaderForWavFile;

  lFlags := BASS_RECORD_PAUSE;
  FRChan := BASS_RecordStart(FRating, 2, lFlags, @RecordingCallback, nil);

  if FRChan = 0 then
    raise Exception.Create('Não foi possível iniciar a gravação! ErrorCode: ' + IntToStr(BASS_ErrorGetCode()));

  BASS_ChannelSetAttribute(FRChan, BASS_ATTRIB_BUFFER, 0);
  BASS_ChannelSetAttribute(FRChan, BASS_ATTRIB_GRANULE, 0);

  BASS_ChannelPlay(FRChan, False);

  Result := self;
end;

function TDinosMediaPlayer.StopRecord: TDinosMediaPlayer;
var
  i: DWord;
begin
  if FRChan <> 0 then
  begin
    BASS_ChannelStop(FRChan);
    FRChan := 0;

    if WaveStream.Size > 0 then
    begin
      WaveStream.Position := 4;
      i := WaveStream.Size - 8;
      WaveStream.Write(i, 4);

      i := WaveStream.Size - SizeOf(WAVHDR) + 8;
      WaveStream.Position := 40;
      WaveStream.Write(i, 4);

      WaveStream.Position := 0;

      FChan := BASS_StreamCreateFile(True, WaveStream.Memory, 0, WaveStream.Size, 0);
      if FChan = 0 then
        raise Exception.Create('Erro ao criar stream: ' + IntToStr(BASS_ErrorGetCode()));

      WaveStream.SaveToFile(getPathSaveFile);
      ForceCloseFile(getPathSaveFile);
    end;
  end;

  Result := self;
end;

end.
