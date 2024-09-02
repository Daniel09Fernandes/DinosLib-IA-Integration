unit uCadastros.Cliente.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.DBCtrls, uConexao.Aplicacao, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids;

type
  TfrCadCliente = class(TForm)
    DBEdit1: TDBEdit;
    dtsCliente: TDataSource;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    DBEdit15: TDBEdit;
    Label14: TLabel;
    Panel1: TPanel;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    Label15: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frCadCliente: TfrCadCliente;

implementation

{$R *.dfm}

procedure TfrCadCliente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dtsCliente.DataSet.Close;
  FreeAndNil(frCadCliente);
end;

procedure TfrCadCliente.FormShow(Sender: TObject);
begin
  dtsCliente.DataSet.Open;
end;

end.
