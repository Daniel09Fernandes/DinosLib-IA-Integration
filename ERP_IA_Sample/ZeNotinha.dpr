program ZeNotinha;

uses
  Vcl.Forms,
  uLogin.View in 'uLogin.View.pas' {frLogin},
  uMain.Menu.View in 'uMain.Menu.View.pas' {frMenu},
  Vcl.Themes,
  Vcl.Styles,
  uFaturamento.NotaFiscal.View in 'Modulos\Faturamento\Nota Fiscal\uFaturamento.NotaFiscal.View.pas' {Form1},
  uFaturamento.NotaFiscal.Model in 'Modulos\Faturamento\Nota Fiscal\uFaturamento.NotaFiscal.Model.pas',
  uFaturamento.NotaFiscal.DTO in 'Modulos\Faturamento\Nota Fiscal\uFaturamento.NotaFiscal.DTO.pas',
  uFaturamento.NotaFiscal.Produto.DTO in 'Modulos\Faturamento\Nota Fiscal\uFaturamento.NotaFiscal.Produto.DTO.pas',
  uCadastros.Produto.View in 'Modulos\Cadastros\Produto\uCadastros.Produto.View.pas' {Form3},
  uConexao.Aplicacao in 'Conexao\Aplicacao\uConexao.Aplicacao.pas' {dmConexao: TDataModule},
  uCadastros.Cliente.View in 'Modulos\Cadastros\Cliente\uCadastros.Cliente.View.pas' {frCadCliente},
  bass in '..\midiawares\Audio-Bass\bass.pas',
  Dinos.Bridge.Bass in '..\midiawares\DinosBridge\Dinos.Bridge.Bass.pas',
  Dinos.Bridge.GPT.Open.IA in '..\midiawares\DinosBridge\Dinos.Bridge.GPT.Open.IA.pas',
  Dinos.Bridge.Whisper.Open.IA in '..\midiawares\DinosBridge\Dinos.Bridge.Whisper.Open.IA.pas',
  uChat.IA.View in '..\midiawares\Frames\ChatIA\uChat.IA.View.pas' {frmChatIA: TFrame},
  Commands.consts in 'IA-Core\Commands.consts.pas',
  uAcoes.Validas in 'IA-Core\uAcoes.Validas.pas',
  uVerifica.Palavras in 'IA-Core\uVerifica.Palavras.pas',
  uChat.Acoes.Controller in 'IA-Core\uChat.Acoes.Controller.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 Dark');
  Application.CreateForm(TfrLogin, frLogin);
  Application.CreateForm(TdmConexao, dmConexao);
  Application.Run;
end.
