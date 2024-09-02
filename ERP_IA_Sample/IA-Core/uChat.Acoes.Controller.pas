unit uChat.Acoes.Controller;

interface
 Type
   TChatController = class
    private
    public
     class procedure Acoes(AText: string);
   end;

implementation

{ TChatController }
 uses
  uAcoes.Validas;

class procedure TChatController.Acoes(AText: string);
begin
  TActions.Acao(AText);
end;

end.
