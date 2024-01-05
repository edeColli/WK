unit uItemPedidoController;

interface

uses
  uItemPedidoModel, uItemPedido, FireDAC.Comp.Client;

type
  TItemPedidoController = class
  public
    class function GravarItemPedido(ItemPedido: TItemPedido; Conexao: TFDConnection): Boolean;
    class function AtualizarItemPedido(ItemPedido: TItemPedido; Conexao: TFDConnection): Boolean;
    class function ExcluirItemPedido(NumeroPedido, ID: Integer; Conexao: TFDConnection): Boolean;
  end;

implementation

{ TItemPedidoController }

class function TItemPedidoController.AtualizarItemPedido(ItemPedido: TItemPedido; Conexao: TFDConnection): Boolean;
begin
  Result := TItemPedidoModel.AtualizarItemPedido(ItemPedido, Conexao);
end;

class function TItemPedidoController.ExcluirItemPedido(NumeroPedido, ID: Integer;  Conexao: TFDConnection): Boolean;
begin
  Result := TItemPedidoModel.ExcluirItemPedido(NumeroPedido, ID, Conexao);
end;

class function TItemPedidoController.GravarItemPedido(ItemPedido: TItemPedido; Conexao: TFDConnection): Boolean;
begin
  Result := TItemPedidoModel.GravarItemPedido(ItemPedido, Conexao);
end;

end.

