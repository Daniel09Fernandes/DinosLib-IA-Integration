unit uChat.IA.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Skia, Vcl.Skia,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls,
  Dinos.Bridge.Bass,
  Dinos.Bridge.Whisper.Open.IA,
  Dinos.Bridge.GPT.Open.IA;

Const
  RESP_OBVIA =  'Responda sempre em portugues, Com respostas obvias e genericas apenas para interagir com o usuario do meu sistema, '+
                                        'Leve em consideração que vocês conhece o sistema, caso o usuario peças para abrir algum menu, abra, se pedir para '+
                                        ' preencher, preencha. Comando do usuario é: ';

type
  TControle = (cParado, cGravando);
  TfrmChatIA = class(TFrame)
    Panel2: TPanel;
    mIA: TMemo;
    Panel3: TPanel;
    SkAnimatedImage1: TSkAnimatedImage;
    imgStopRec: TSkAnimatedImage;
    mUser: TMemo;
    Panel1: TPanel;
    imgRec: TSkAnimatedImage;
    tmrPausaPorSilencio: TTimer;
    procedure mUserKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure imgStopRecClick(Sender: TObject);
    procedure imgRecClick(Sender: TObject);
    procedure tmrPausaPorSilencioTimer(Sender: TObject);
  private
    { Private declarations }
    FControle : TControle;
    FInteragirComGPTAoSilenciar: boolean;
  public
    procedure GptInteraction(AText: string; APassarTextoDiretoSemInteracaoGPT: boolean = false);
    procedure ControleVisibilidadeMicGravando(AValue: boolean);
    property InteragirComGPTAoSilenciar: Boolean read FInteragirComGPTAoSilenciar write FInteragirComGPTAoSilenciar;
    property Controle: TControle read FControle;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

  var FrmChat : TfrmChatIA;
implementation

{$R *.dfm}
uses uChat.Acoes.Controller, math;

procedure TfrmChatIA.ControleVisibilidadeMicGravando(AValue: boolean);
begin
  imgRec.Visible := not AValue;
  imgStopRec.Visible :=   AValue;
  FControle := TControle(ifthen(AValue, 1, 0));

end;

constructor TfrmChatIA.Create(AOwner: TComponent);
begin
  inherited;
  var Path := GetCurrentDir+'\Interactions';
  if not DirectoryExists(Path) then
    ForceDirectories(Path);

  TDinosMediaPlayer.GetInstance.PathSaveFile :=Path+'\Interactions.wav';
  FInteragirComGPTAoSilenciar := true;
end;

destructor TfrmChatIA.Destroy;
begin
  TDinosMediaPlayer.FreeInstance; // free on Singleton
  inherited;
end;

procedure TfrmChatIA.GptInteraction(AText: string; APassarTextoDiretoSemInteracaoGPT: boolean = false);
begin
  TDinosMediaPlayer.GetInstance.FreeSongOfMemory;
  Var DinosGpt := TDinosChatGPT.Create;
  DinosGpt.Voice := tvNova;

  var Response := '';
  if not APassarTextoDiretoSemInteracaoGPT then
    Response := DinosGpt.SendMessage(AText)
  else
    Response := AText;

  DinosGpt.TextToSpeench(Response).SaveToFile(TDinosMediaPlayer.GetInstance.PathSaveFile);

  TDinosMediaPlayer.GetInstance.PlaySong(TDinosMediaPlayer.GetInstance.PathSaveFile);
end;

procedure TfrmChatIA.imgRecClick(Sender: TObject);
begin
   ControleVisibilidadeMicGravando(true);

  TDinosMediaPlayer.GetInstance.FreeSongOfMemory;
  TDinosMediaPlayer.GetInstance.StartRecord;
end;

procedure TfrmChatIA.imgStopRecClick(Sender: TObject);
begin
  ControleVisibilidadeMicGravando(false);
  TDinosMediaPlayer.GetInstance.StopRecord;

  TThread.CreateAnonymousThread( procedure
                                 begin
                                   var DinosWhisper := TDinosWhisper.Create(TDinosMediaPlayer.GetInstance.PathSaveFile);
                                   var resp := '';
                                   try
                                      resp := DinosWhisper.GetTextFromWav;
                                   finally
                                     DinosWhisper.Free;
                                   end;

                                    TThread.Synchronize(nil, procedure
                                                              begin
                                                                mIA.Lines.Text := 'Comando: '+ resp;
                                                                TChatController.Acoes(resp);
                                                                if FInteragirComGPTAoSilenciar then
                                                                  GptInteraction(RESP_OBVIA + resp);
                                                              end)
                                 end).Start;
end;

procedure TfrmChatIA.mUserKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (key = VK_RETURN) and (not mUser.Lines.IsEmpty) then
  begin
    GptInteraction(mUser.Lines.Text);
    mUser.Lines.Clear;
  end;
end;

procedure TfrmChatIA.tmrPausaPorSilencioTimer(Sender: TObject);
begin
  TDinosMediaPlayer.GetInstance.PauseForSilence;

  if TDinosMediaPlayer.GetInstance.FreqMic <= 0 then
    ControleVisibilidadeMicGravando(false);

end;

end.
