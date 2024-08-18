unit uTesteOpenIA.Whisper;

interface

uses
  Dinos.Bridge.Bass,
  Dinos.Bridge.Whisper.Open.IA,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ShellApi, Vcl.MPlayer,
  Vcl.ExtCtrls;

type
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
    DinosMic : TDinosMicRec;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
const
  TesteAudio = 'D:\Fontes\PalestraIA\ProjetoTeste\Win32\Debug\teste.wav';
begin
  Memo1.Lines.Clear;
  var DinosWhisper := TDinosWhisper.Create(DinosMic.PathSaveFile);
  try
    Memo1.Lines.Text := DinosWhisper.GetTextFromWav;
  finally
    DinosWhisper.Free;
  end;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  memo2.Lines.Clear;
  DinosMic.StartRecord;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  DinosMic.StopRecord;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 FreeAndNil(DinosMic);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  DinosMic := TDinosMicRec.GetInstance;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
var
  level: Single;
begin
   DinosMic.PauseForSilence;

   if DinosMic.FreqMic > 0 then
     Memo2.Lines.Add(DinosMic.FreqMic.ToString);
end;


end.
