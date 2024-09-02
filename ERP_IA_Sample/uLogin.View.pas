unit uLogin.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask,
  Vcl.Imaging.jpeg, Vcl.Buttons, uMain.Menu.View;

type
  TfrLogin = class(TForm)
    Panel1: TPanel;
    Bevel1: TBevel;
    Button1: TButton;
    Image1: TImage;
    EdtUser: TLabeledEdit;
    EdtSenha: TLabeledEdit;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frLogin: TfrLogin;

implementation

{$R *.dfm}

procedure TfrLogin.Button1Click(Sender: TObject);
begin
  If {(EdtUser.Text = 'admin') and (EdtSenha.Text = 'Dinos') } true then
  begin
      FrMenu := TfrMenu.Create(Application);
    try
      self.Hide;
      FrMenu.ShowModal;
    finally
      FreeAndNil(FrMenu);
      Application.Terminate;
    end;
  end
  else
    ShowMessage('Os dados informados, estão errados, por favor, revisar e tentar novamente.');
end;

procedure TfrLogin.Button2Click(Sender: TObject);
begin
  Application.Terminate;
end;

end.
