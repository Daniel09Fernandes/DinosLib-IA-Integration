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

Type
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
    function getPathSaveFile: String;
    procedure SetPathSaveFile(const Value: String);
  var
   FChan          : HStream;
   FRChan         : HRecord;
   FWaveStream    : TMemoryStream;
   FWaveHdr       : WAVHDR;
   FPathSaveFile  : String;
   FSilenceCounter: Integer;
   FFreqMic       : Single;
   FSong          : Cardinal;
   class var
     FInstance   : TDinosMediaPlayer;

   constructor Create();
   destructor Destroy; override;
   procedure SetWaveStream(const Value: TMemoryStream);
   procedure SetGenerateHeaderForWavFile;
   function  GetWaveStream: TMemoryStream;
  public
    property Channel     : HStream       read FChan;
    property RecChannel  : HRecord       read FRChan;
    property WaveStream  : TMemoryStream read GetWaveStream write SetWaveStream;
    property WaveHdr     : WAVHDR        read FWaveHdr;
    property FreqMic     : Single        read FFreqMic      write FFreqMic;
    property PathSaveFile: String        read getPathSaveFile write SetPathSaveFile;

    function  StartRecord(): TDinosMediaPlayer;
    function  StopRecord(): TDinosMediaPlayer;
    function  PlaySong(AFile : String): TDinosMediaPlayer;
    function  PauseForSilence(): TDinosMediaPlayer;
    function  FreeSongOfMemory: TDinosMediaPlayer;

    class function GetInstance: TDinosMediaPlayer;
    class function FreeInstance: TDinosMediaPlayer;
  end;
   var
     gWaveStream: TMemoryStream; //Copia global para o callback do audio

implementation

uses
  Vcl.Dialogs, System.SysUtils, Vcl.Forms;

function RecordingCallback(Handle: HRecord; buffer: Pointer; length: DWord; user: Pointer): boolean; stdcall;
begin
  // Copy new buffer contents to the memory buffer
  gWaveStream.Write(buffer^, length);
  {
    in the C Example
    if ((reclen mod BUFSTEP) + length >= BUFSTEP) ....
		recbuf = realloc(recbuf, ((reclen + length) / BUFSTEP + 1) * BUFSTEP);
    this is in Delphi not Needed TMemorystream will (if needed ) increase the size of the memory buffer self
  }
  // Allow recording to continue
  Result := True;
end;


{ TDinosMicRec }

constructor TDinosMediaPlayer.Create();
begin
  FSilenceCounter := 0;
  FChan  := 0;
  FRChan := 0;
  FWaveStream := TMemoryStream.Create;
  gWaveStream := FWaveStream;

  if (not BASS_RecordInit(0)) or (not BASS_Init(1, 44100, 0, Application.Handle, Nil)) then
  begin
    ShowMessage('Não foi possível iniciar o dispositivo');
    Exit;
  end;

  BASS_RecordInit(0);
end;

//Singleton
destructor TDinosMediaPlayer.Destroy;
begin
  BASS_RecordFree();
  Bass_Free;

  If Assigned(WaveStream) then
     FreeAndNil(WaveStream);

  FreeSongOfMemory;
  inherited;
end;

class function TDinosMediaPlayer.FreeInstance: TDinosMediaPlayer;
begin
  if assigned(FInstance) then
   FreeAndNil(FInstance);
end;

function TDinosMediaPlayer.FreeSongOfMemory: TDinosMediaPlayer;
begin
 if FSong > 0 then
   BASS_StreamFree(FSong);

 Result  := Self;
end;

class function TDinosMediaPlayer.GetInstance: TDinosMediaPlayer;
begin
  if not Assigned(FInstance) then
    FInstance := TDinosMediaPlayer.create;

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
    dwSampleRate := 44100;
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

function TDinosMediaPlayer.StartRecord: TDinosMediaPlayer;
begin
  if WaveStream.Size > 0 then
  begin
    BASS_StreamFree(FRChan);
    WaveStream.Clear;
  end;

  SetGenerateHeaderForWavFile;

  // start recording @ 44100hz 16-bit stereo
  FRChan := BASS_RecordStart(44100, 2, 0, @RecordingCallback, nil);

  if FRChan = 0 then
  begin
    MessageDlg('Não foi possivel inicar a gravção!' + 'ErrorCode ' + inttostr(BASS_ErrorGetCode()), mtError, [mbOk], 0);
    WaveStream.Clear;
  end;

  Result := self;
end;

function TDinosMediaPlayer.StopRecord: TDinosMediaPlayer;
begin
  BASS_ChannelStop(FRChan);
  FRChan := 0;

  WaveStream.Position := 4;
  var i := WaveStream.Size - 8;
  WaveStream.Write(i, 4);
  i := i - $24;
  WaveStream.Position := 40;
  WaveStream.Write(i, 4);
  WaveStream.Position := 0;

  FChan := BASS_StreamCreateFile(True, WaveStream.Memory, 0, WaveStream.Size, 0);

  WaveStream.SaveToFile(PathSaveFile);

  Result := self;
end;

end.
