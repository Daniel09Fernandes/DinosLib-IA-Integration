unit uMain.Menu.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.ComCtrls, Vcl.ToolWin, Vcl.ExtCtrls, Vcl.Menus, System.Skia, Vcl.Skia,
  Vcl.Imaging.jpeg, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.Buttons,
  uCadastros.Cliente.View,
  uCadastros.Produto.View,
  uFaturamento.NotaFiscal.View,
  uChat.IA.View;

 type
   TfrMenu = class(TForm)
    MainMenu1: TMainMenu;
    Cadastros1: TMenuItem;
    Faturamento1: TMenuItem;
    Produto1: TMenuItem;
    NotaFiscal1: TMenuItem;
    StatusBar1: TStatusBar;
    Image1: TImage;
    Cliente1: TMenuItem;
    pnlMain: TPanel;
    pnlIA: TPanel;
    btnIAControl: TSpeedButton;
    Splitter1: TSplitter;
    procedure Produto1Click(Sender: TObject);
    procedure Cliente1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NotaFiscal1Click(Sender: TObject);
    procedure btnIAControlClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private

  public
    { Public declarations }
  end;

var
  frMenu: TfrMenu;

implementation

{$R *.dfm}
 uses strUtils;

procedure TfrMenu.Cliente1Click(Sender: TObject);
begin
  if not Assigned(FrCadCliente) then
  begin
     FrCadCliente := TFrCadCliente.Create(pnlMain);
     FrCadCliente.Parent  := pnlMain;
  end;

  FrCadCliente.Show;
end;

procedure TfrMenu.FormCreate(Sender: TObject);
begin
  FrmChat := TfrmChatIA.Create(self);
  FrmChat.Parent := pnlIA;
  FrmChat.Align := alClient;
end;

procedure TfrMenu.FormDestroy(Sender: TObject);
begin
  if Assigned(FrCadCliente) then
    FreeAndNil(FrCadCliente);

  if Assigned(FrCadProduto) then
    FreeAndNil(FrCadProduto);

  if Assigned(FrNotaFiscal) then
    FreeAndNil(FrNotaFiscal);

  FreeAndNil(FrmChat);
end;

procedure TfrMenu.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if ((Key = ord('M')) or (Key = ord('m'))) and (Shift = [ssShift])  then
   begin
     if FrmChat.Controle = cParado then
       FrmChat.imgRecClick(sender)
     else
       FrmChat.imgStopRecClick(sender);
   end;
end;

procedure TfrMenu.FormResize(Sender: TObject);
begin
  if Assigned(FrmChat) then
  begin
    FrmChat.clientHeight := pnlIA.Height;
    FrmChat.ClientWidth  := pnlIA.Width;
  end;
end;

procedure TfrMenu.NotaFiscal1Click(Sender: TObject);
begin
   if not Assigned(FrNotaFiscal) then
   begin
     FrNotaFiscal := TFrNotaFiscal.Create(pnlMain);
     FrNotaFiscal.Parent  := pnlMain;
   end;

   FrNotaFiscal.Show;
end;

procedure TfrMenu.Produto1Click(Sender: TObject);
begin
   if not Assigned(FrCadProduto) then
   begin
     FrCadProduto := TFrCadProduto.Create(pnlMain);
     FrCadProduto.Parent  := pnlMain;
   end;

   FrCadProduto.Show;
end;

procedure TfrMenu.btnIAControlClick(Sender: TObject);
begin
  pnlIA.Visible := not pnlIA.Visible;
  btnIAControl.Caption := ifthen(btnIAControl.Caption = '>','<','>');

end;

end.
