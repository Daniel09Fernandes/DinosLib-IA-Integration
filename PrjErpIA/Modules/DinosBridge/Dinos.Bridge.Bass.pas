unit Dinos.Bridge.Bass;

interface

uses Bass, System.Classes;

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

  TDinosMicRec = class
  private
  const
    MIC_MUTE            = 4294967296;
    MIN_FREQ_OF_SILENCE = 11171220;
    STEP_SILENCE_MAX    = 2;
    function getPathSaveFile: String;
  var
   FChan          : HStream;
   FRChan         : HRecord;
   FWaveStream    : TMemoryStream;
   FWaveHdr       : WAVHDR;
   FPathSaveFile  : String;
   FSilenceCounter: Integer;
   FFreqMic       : Single;
   class var
     FInstance   : TDinosMicRec;

   constructor Create();
   procedure SetWaveStream(const Value: TMemoryStream);
   procedure SetGenerateHeaderForWavFile;
   function  GetWaveStream: TMemoryStream;
  public
    destructor Destroy; override;

    property Channel     : HStream       read FChan;
    property RecChannel  : HRecord       read FRChan;
    property WaveStream  : TMemoryStream read GetWaveStream write SetWaveStream;
    property WaveHdr     : WAVHDR        read FWaveHdr;
    property FreqMic     : Single        read FFreqMic      write FFreqMic;
    property PathSaveFile: String        read getPathSaveFile write FPathSaveFile;

    procedure StartRecord();
    procedure StopRecord();
    procedure PauseForSilence();

    class function GetInstance: TDinosMicRec;
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

constructor TDinosMicRec.Create();
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
destructor TDinosMicRec.Destroy;
begin
  BASS_RecordFree();
  Bass_Free;
  WaveStream.Free;
  inherited;
end;

class function TDinosMicRec.GetInstance: TDinosMicRec;
begin
  if not Assigned(FInstance) then
    FInstance := TDinosMicRec.create;

  Result := FInstance;
end;

function TDinosMicRec.getPathSaveFile: String;
begin
  if FPathSaveFile.trim.isEmpty then
    FPathSaveFile := GetCurrentDir+'\DinosRec.wav';

  Result := FPathSaveFile;
end;

function TDinosMicRec.GetWaveStream: TMemoryStream;
begin
  gWaveStream := FWaveStream;
  Result      := FWaveStream;
end;

procedure TDinosMicRec.PauseForSilence;  //Utilizar em um timer, para monitorar
var
  level: Single;
begin
  level := BASS_ChannelGetLevel(FRChan);
  FreqMic := 0;

  if level = MIC_MUTE then
    exit;

  FreqMic := level;

  if level < MIN_FREQ_OF_SILENCE then
    Inc(FSilenceCounter)
  else
    FSilenceCounter := 0;

  if FSilenceCounter > STEP_SILENCE_MAX then
    StopRecord;
end;

procedure TDinosMicRec.SetGenerateHeaderForWavFile;
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

procedure TDinosMicRec.SetWaveStream(const Value: TMemoryStream);
begin
  FWaveStream := Value;
  gWaveStream := FWaveStream;
end;

procedure TDinosMicRec.StartRecord;
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
  end
end;

procedure TDinosMicRec.StopRecord;
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
end;

end.
