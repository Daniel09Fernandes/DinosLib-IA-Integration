program prjTesteOpenAi.Whisper;

uses
  Vcl.Forms,
  bass in 'bass.pas',
  uTesteOpenIA.Whisper in 'uTesteOpenIA.Whisper.pas' {Form2},
  Dinos.Bridge.Bass in '..\PrjErpIA\Modules\DinosBridge\Dinos.Bridge.Bass.pas',
  Dinos.Bridge.Whisper.Open.IA in '..\PrjErpIA\Modules\DinosBridge\Dinos.Bridge.Whisper.Open.IA.pas',
  Dinos.Bridge.GPT.Open.IA in '..\PrjErpIA\Modules\DinosBridge\Dinos.Bridge.GPT.Open.IA.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
