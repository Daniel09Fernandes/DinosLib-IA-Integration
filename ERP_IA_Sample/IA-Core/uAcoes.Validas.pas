unit uAcoes.Validas;

interface
uses
 system.Classes, strUtils, sysUtils, System.Generics.Collections, Vcl.Forms, Data.DB,
 System.Threading,
 uCadastros.Cliente.View,
 uCadastros.Produto.View,
 uFaturamento.NotaFiscal.View,
 uConexao.Aplicacao,
 uChat.IA.View,
 Dinos.Bridge.Bass,
 uVerifica.Palavras,
 Commands.consts,
 Dinos.Bridge.Whisper.Open.IA;

 Type
   TDinosProc = TProc<string>;
   TActionsMenus = (taNFe, taProduto, taClientes);
   TAction=(taAbrir, taFechar, taEmitir, taGerar, taAlterar, taEditar, taCadastrar, taIncluir, taExcluir, taDeletar);

   TActionsHelper = record helper for  TAction
     function ToString: string;
   end;
   
   TActionsMenusHelper = record helper for  TActionsMenus
     function ToString: string;
   end;
   TActions = class
   private
     FMsgRetorno: string;
     FAcao : TAction;
     FMenu: TActionsMenus;
     function ValidaMenuAberto(AMenu: TActionsMenus): boolean;
     function ValidaMenuCriado(AMenu: TActionsMenus): boolean;
     procedure AguardarResposta(indexField: integer);
     function TratarValor(AValor: string; ADataType: TFieldType = ftString): string;
     procedure InteragirComUsuario(AText: string;  AProc: TDinosProc);
     Procedure AbrirMenuCliente;
     Procedure FecharMenuCliente;
     Procedure AbrirMenuProdutos;
     Procedure FecharMenuProdutos;
     Procedure AbrirMenuNF;
     Procedure FecharMenuNF;
     Procedure CadastrarNovoCliente;
    procedure ExecutarAcoesMenuCliente;
    procedure EmitirUmaNotaFisacal;
    procedure DesejaIncluirItem;
    procedure IncluirItem;
    procedure ExecutarAcoesProdutos;
    procedure ExecutarAcoesMenuNotaFiscal;
   public
     class procedure Acao(AText: string);
   end;

implementation

{ TActions }
uses uMain.Menu.View, System.SyncObjs;

procedure TActions.AbrirMenuCliente;
begin
  if not ValidaMenuCriado(taClientes) then
  begin
    FrCadCliente := TFrCadCliente.Create(frMenu.pnlMain);
    frCadCliente.Parent := frMenu.pnlMain;
  end;

  if not ValidaMenuAberto(taClientes) then
    FrCadCliente.Show
  else
    FMsgRetorno := 'O menu para cadastrar cliente, já se encontra aberto.';  
end;

procedure TActions.DesejaIncluirItem;
begin
  InteragirComUsuario('Deseja incluir mais um item? ',procedure(resp: string)
                                                      begin
                                                        if TratarValor(resp).ToLower.Contains('sim') then
                                                        begin
                                                          IncluirItem;
                                                        end;
                                                      end);
end;

procedure TActions.IncluirItem;
begin
   InteragirComUsuario('Qual o codigo do produto que iremos incluir na NF? ',procedure(resp: string)
                                                                                 begin
                                                                                    FrNotaFiscal.edtCodProd.Text := TratarValor(resp);
                                                                                    FrNotaFiscal.btnPesqProdutoClick(nil);
                                                                                    FrNotaFiscal.btnAdditemClick(nil);
                                                                                    DesejaIncluirItem;
                                                                                  end);
end;

procedure TActions.EmitirUmaNotaFisacal;
begin
   AbrirMenuNF;
   FrmChat.InteragirComGPTAoSilenciar := false; //Estou fazendo o controle local
   FrmChat.tmrPausaPorSilencio.Enabled := false;
   try
     with dmConexao do
     begin
       FrmChat.GptInteraction('Ok, vamos emitir uma Nota Fiscal. Siga as etapas', true);
       sleep(4000);
       InteragirComUsuario('Para qual cliente, iremos emitir a Nota Fiscal? ', procedure(resp: string)
                                                                               begin
                                                                                  FrNotaFiscal.edtCliente.Text := TratarValor(resp);
                                                                                  FrNotaFiscal.btnPesqClienteClick(nil);
                                                                               end);

       IncluirItem;
       InteragirComUsuario('Todos os dados estão corretos? Posso emitir a Nota? ', procedure(resp: string)
                                                                                   begin
                                                                                      if TratarValor(resp).ToLower.Contains('sim') then
                                                                                      FrNotaFiscal.BtnEmitirNfClick(nil);
                                                                                   end);
     end;
   finally
     FrmChat.InteragirComGPTAoSilenciar := true; //Retorna o padrao do chat
     FrmChat.tmrPausaPorSilencio.Enabled := True;
   end;
end;

procedure TActions.CadastrarNovoCliente;
begin
   AbrirMenuCliente;
   FrmChat.InteragirComGPTAoSilenciar := false; //Estou fazendo o controle local
   FrmChat.tmrPausaPorSilencio.Enabled := false;
   try
     with dmConexao.mCliente do
     begin
       FrmChat.GptInteraction('Ok, vamos começar a cadastrar o novo cliente, vou te pedir algumas informações. Siga as etapas', true);
       sleep(6000);
       Append;

       InteragirComUsuario('Qual o nome do cliente? ',    procedure(resp: string)
                                                          begin
                                                            dmConexao.mCliente.Fields[dmConexao.mClienteNome.Index].AsString :=
                                                                               TratarValor(resp, dmConexao.mCliente.Fields[dmConexao.mClienteNome.Index].DataType);
                                                          end);
       InteragirComUsuario('Agora, preciso saber qual é a inscrição estadual? ',
                                                          procedure(resp: string)
                                                          begin
                                                            dmConexao.mCliente.Fields[dmConexao.mClienteIE.Index].AsString :=
                                                                               TratarValor(resp, dmConexao.mCliente.Fields[dmConexao.mClienteIE.Index].DataType);
                                                          end);
       InteragirComUsuario('E qual é o, CNPJ ou CPF? ',   procedure(resp: string)
                                                          begin
                                                            dmConexao.mCliente.Fields[dmConexao.mClienteCNPJCPF.Index].AsString :=
                                                                               TratarValor(resp, dmConexao.mCliente.Fields[dmConexao.mClienteCNPJCPF.Index].DataType);
                                                          end );
       InteragirComUsuario('Me informa o Telefone de contato? ',
                                                          procedure(resp: string)
                                                          begin
                                                            dmConexao.mCliente.Fields[dmConexao.mClienteFone.Index].AsString :=
                                                                               TratarValor(resp, dmConexao.mCliente.Fields[dmConexao.mClienteFone.Index].DataType);
                                                          end);
       InteragirComUsuario('Me informa o CEP, por favor? ',
                                                          procedure(resp: string)
                                                          begin
                                                            dmConexao.mCliente.Fields[dmConexao.mClienteCEP.Index].AsString :=
                                                                               TratarValor(resp, dmConexao.mCliente.Fields[dmConexao.mClienteCEP.Index].DataType);
                                                          end);
       InteragirComUsuario('Qual seria a rua? ',          procedure(resp: string)
                                                          begin
                                                            dmConexao.mCliente.Fields[dmConexao.mClienteLogradouro.Index].AsString :=
                                                                               TratarValor(resp, dmConexao.mCliente.Fields[dmConexao.mClienteLogradouro.Index].DataType);
                                                          end);
       InteragirComUsuario('O Numero da residencia? ',    procedure(resp: string)
                                                          begin
                                                            dmConexao.mCliente.Fields[dmConexao.mClienteNumero.Index].AsString :=
                                                                               TratarValor(resp, dmConexao.mCliente.Fields[dmConexao.mClienteNumero.Index].DataType);
                                                          end );
       InteragirComUsuario('Tem algum complemento no endereço? ',
                                                          procedure(resp: string)
                                                          begin
                                                            dmConexao.mCliente.Fields[dmConexao.mClienteComplemento.Index].AsString :=
                                                                               TratarValor(resp, dmConexao.mCliente.Fields[dmConexao.mClienteComplemento.Index].DataType);
                                                          end);
       InteragirComUsuario('Preciso saber, qual é o bairro? ',
                                                          procedure(resp: string)
                                                          begin
                                                            dmConexao.mCliente.Fields[dmConexao.mClienteBairro.Index].AsString :=
                                                                               TratarValor(resp, dmConexao.mCliente.Fields[dmConexao.mClienteBairro.Index].DataType);
                                                          end);
       InteragirComUsuario('Me informa o codigo do municipio? ',
                                                          procedure(resp: string)
                                                          begin
                                                            dmConexao.mCliente.Fields[dmConexao.mClienteCodMunicipio.Index].AsString :=
                                                                               TratarValor(resp, dmConexao.mCliente.Fields[dmConexao.mClienteCodMunicipio.Index].DataType);
                                                          end);
       InteragirComUsuario('Qual o nome do municipio? ',
                                                         procedure(resp: string)
                                                         begin
                                                            dmConexao.mCliente.Fields[dmConexao.mClienteNomeMunicipio.Index].AsString :=
                                                                               TratarValor(resp, dmConexao.mCliente.Fields[dmConexao.mClienteNomeMunicipio.Index].DataType);
                                                          end);
       InteragirComUsuario('Para finalizar, me informa a UF? ',
                                                        procedure(resp: string)
                                                         begin
                                                            dmConexao.mCliente.Fields[dmConexao.mClienteUF.Index].AsString :=
                                                                               TratarValor(resp, dmConexao.mCliente.Fields[dmConexao.mClienteUF.Index].DataType);
                                                          end);
       post;
     end;
   finally
     FrmChat.InteragirComGPTAoSilenciar := true; //Retorna o padrao do chat
     FrmChat.tmrPausaPorSilencio.Enabled := True;
   end;
end;

procedure TActions.FecharMenuCliente;
begin
   if ValidaMenuCriado(taClientes) and (ValidaMenuAberto(taClientes)) then
    FreeAndNil(FrCadCliente)
  else
    FMsgRetorno := 'O Menu de Produtos, não está aberto.';
end;

procedure TActions.FecharMenuNF;
begin
  if ValidaMenuCriado(taNFe) and (ValidaMenuAberto(taNFe)) then
    FreeAndNil(FrNotaFiscal)
  else
    FMsgRetorno := 'O Menu de NF, não está aberto.';
end;

procedure TActions.FecharMenuProdutos;
begin
  if ValidaMenuCriado(taProduto) and (ValidaMenuAberto(taProduto)) then
    FreeAndNil(FrCadProduto)
  else
    FMsgRetorno := 'O Menu de clientes, não está aberto.';
end;

procedure TActions.InteragirComUsuario(AText: string; AProc: TDinosProc);
begin
  FrmChat.GptInteraction(AText, true);
  sleep(4000);
  FrmChat.imgRecClick(nil);
  Application.ProcessMessages;
  var ThreadFinished := false;
  TThread.CreateAnonymousThread(
                             procedure
                             begin
                                TDinosMediaPlayer.GetInstance.PauseForSilence;
                                while TDinosMediaPlayer.GetInstance.FreqMic <> 0 do
                                begin
                                  TDinosMediaPlayer.GetInstance.PauseForSilence; //Atualiza a Frequencia
                                end;

                                var DinosWhisper := TDinosWhisper.Create(TDinosMediaPlayer.GetInstance.PathSaveFile);
                                var resp := '';
                                try
                                  resp := DinosWhisper.GetTextFromWav;
                                finally
                                  DinosWhisper.Free;
                                end;

                                TThread.Synchronize(nil, procedure
                                begin
                                    FrmChat.ControleVisibilidadeMicGravando(false);
                                    AProc(resp);
                                    ThreadFinished := true;
                                end);
                             end).Start;
   while not ThreadFinished do
  begin
    Application.ProcessMessages; // Permite que a interface continue respondendo
    Sleep(100); // Evita uso excessivo de CPU
  end;
end;

function TActions.TratarValor(AValor: string; ADataType: TFieldType = ftString):string;
begin
  Result := Copy(
                  AValor
                   .replace('(base)', '')
                   .replace(',', '')
                ,26).trim;

   if ADataType = ftFloat then
   begin
     Result := Result.Replace(',','.');
     var outFl: double;
     if not TryStrToFloat(Result,outFl) then
       Result := '0';
   end
   else if ADataType = ftInteger then
         begin
           Result := Result
                         .Replace(',','')
                         .Replace('.','');
           var outInt: integer;
           if not TryStrToInt(Result,outInt) then
             Result := '0';
         end;
end;

procedure TActions.AbrirMenuNF;
begin
  if not ValidaMenuCriado(taNFe) then
  begin
    FrNotaFiscal := TFrNotaFiscal.Create(frMenu.pnlMain);
    FrNotaFiscal.Parent := frMenu.pnlMain;
  end;

  if not ValidaMenuAberto(taNFe) then
    FrNotaFiscal.Show
  else
    FMsgRetorno := 'O menu para cadastrar produtos, já se encontra aberto.';
end;

procedure TActions.AbrirMenuProdutos;
begin
  if not ValidaMenuCriado(taProduto) then
  begin
    FrCadProduto := TFrCadProduto.Create(frMenu.pnlMain);
    FrCadProduto.Parent := frMenu.pnlMain;
  end;

  if not ValidaMenuAberto(taProduto) then
    FrCadProduto.Show
  else
    FMsgRetorno := 'O menu para cadastrar produtos, já se encontra aberto.';
end;

class procedure TActions.Acao(AText: string);
begin
 var  Validador := TValidador.Create; 
 var  Action := TActions.Create;
 var  palavrasEncontradas: TList<string>;
 var  Palavra: string;     
 try 
    Atext := AText.replace('(base)','');
    palavrasEncontradas := Validador.Validate(AText.ToUpper);    
    for Palavra in palavrasEncontradas do
    begin
        if Palavra.Contains(taAbrir.ToString.ToLower) then
          Action.FAcao := taAbrir
        else if Palavra.Contains(taFechar.ToString.ToLower) then
            Action.FAcao := taFechar
          else if (Palavra.Contains(taIncluir.ToString.ToLower) or ( Palavra.Contains(taCadastrar.ToString.ToLower))) then
             Action.FAcao := taCadastrar
           else if (Palavra.Contains(taExcluir.ToString.ToLower) or ( Palavra.Contains(taDeletar.ToString.ToLower))) then
               Action.FAcao := taDeletar
             else if (Palavra.Contains(taEmitir.ToString.ToLower) or ( Palavra.Contains(taGerar.ToString.ToLower))) then
               Action.FAcao := taEmitir;

        if MENU_NF.ToLower.Contains(Palavra) then
          Action.FMenu := taNFe
        else if MENU_CADASTRO_CLIENTE.ToLower.Contains(Palavra) then
              Action.FMenu := taClientes
          else if MENU_CADASTRO_PRODUTO.ToLower.Contains(Palavra) then
                Action.FMenu := taProduto                         
    end;  
      Action.ExecutarAcoesMenuCliente;
      Action.ExecutarAcoesProdutos;
      Action.ExecutarAcoesMenuNotaFiscal;
 finally
   Validador.free;
   palavrasEncontradas.Free;
   Action.Free;
 end;
end;

Procedure TActions.ExecutarAcoesMenuCliente;
begin
  if (FAcao = taAbrir) and (FMenu = taClientes) then
    AbrirMenuCliente
  else
  if (FAcao = taFechar) and (FMenu = taClientes) then
    FecharMenuCliente
  else
  if (FAcao = taCadastrar) and (FMenu = taClientes) then
     CadastrarNovoCliente;
end;

Procedure TActions.ExecutarAcoesProdutos;
begin
  if (FAcao = taAbrir) and (FMenu = taProduto) then
    AbrirMenuProdutos
  else
  if (FAcao = taFechar) and (FMenu = taProduto) then
    FecharMenuProdutos
  else
//  if (FAcao = taCadastrar) and (FMenu = taProduto) then // Nao implementado ainda
//     CadastrarNovoProduto;
end;

Procedure TActions.ExecutarAcoesMenuNotaFiscal;
begin
  if (FAcao = taAbrir) and (FMenu = taNFe) then
    AbrirMenuNF
  else
  if (FAcao = taFechar) and (FMenu = taNFe) then
    FecharMenuNF
  else
  if (FAcao = taEmitir) and (FMenu = taNFe) then
     EmitirUmaNotaFisacal;
end;

procedure TActions.AguardarResposta(indexField: integer);
begin

end;

function TActions.ValidaMenuAberto(AMenu: TActionsMenus): boolean;
begin
  Result := false;
  case AMenu of
    taNFe: Result      := FrNotaFiscal.Showing;
    taProduto: Result  := FrCadProduto.Showing;
    taClientes: Result := FrCadCliente.Showing;
  end;
end;

function TActions.ValidaMenuCriado(AMenu: TActionsMenus): boolean;
begin
   case AMenu of
    taNFe: Result := Assigned(FrNotaFiscal);           
    taProduto: Result := Assigned(FrCadProduto);
    taClientes: Result := Assigned(FrCadCliente);
  end;
end;

{ TActionsMenusHelper }

function TActionsMenusHelper.ToString: string;
begin
  case self of
    taNFe: Result := 'Nota Fiscal';
    taProduto: Result := 'Produto';
    taClientes: Result := 'Clientes' ;
  end;
end;

{ TActionsHelper }

function TActionsHelper.ToString: string;
begin
  case Self of  //Sem conjulgar fica mais abrangente na hora de fazer o match de palavras
    taAbrir:     Result := 'Abr';
    taFechar:    Result := 'Fech';
    taEmitir:    Result := 'mit' ;
    taAlterar:   Result := 'Alter' ;
    taEditar:    Result := 'Edit';
    taCadastrar: Result := 'Cadastr';
    taIncluir:   Result := 'Inclu';
    taExcluir:   Result := 'Exclu';
    taDeletar:   Result := 'Delet';
    taGerar  :   Result := 'Gera';
  end;
end;

end.
