program prjTesteOpenAi.Whisper;

uses
  Vcl.Forms,
  uTesteOpenIA.Whisper in 'uTesteOpenIA.Whisper.pas' {Form2},
  bass in '..\midiawares\Audio-Bass\bass.pas',
  Dinos.Bridge.Bass in '..\midiawares\DinosBridge\Dinos.Bridge.Bass.pas',
  Dinos.Bridge.GPT.Open.IA in '..\midiawares\DinosBridge\Dinos.Bridge.GPT.Open.IA.pas',
  Dinos.Bridge.Whisper.Open.IA in '..\midiawares\DinosBridge\Dinos.Bridge.Whisper.Open.IA.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
