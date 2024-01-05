unit uPedidoController;

interface

uses
  uPedidoModel, uPedido, FireDAC.Comp.Client, FireDAC.Stan.Param, Data.DB;

type
  TPedidoController = class
  public
    class function GravarPedido(NumeroPedido: Integer; Pedido: TPedido; Conexao: TFDConnection): Boolean;
    class function obterProximoNumeroPedidoDoBanco(Conexao: TFDConnection): Integer;
    class procedure CancelarPedido(Pedido: Integer; Conexao: TFDConnection);
    class function CarregarPedido(Pedido: Integer; Conexao: TFDConnection): TFDQuery;
  end;

implementation

{ TPedidoController }

class procedure TPedidoController.CancelarPedido(Pedido: Integer; Conexao: TFDConnection);
begin
  TPedidoModel.CancelarPedido(Pedido, Conexao);
end;

class function TPedidoController.CarregarPedido(Pedido: Integer; Conexao: TFDConnection): TFDQuery;
begin
  Result := TPedidoModel.CarregarPedido(Pedido, Conexao);
end;

class function TPedidoController.GravarPedido(NumeroPedido: Integer; Pedido: TPedido; Conexao: TFDConnection): Boolean;
begin
  if NumeroPedido = 0 then
    Result := TPedidoModel.GravarPedido(Pedido, Conexao)
  else
    Result := TPedidoModel.AlterarPedido(NumeroPedido, Pedido, Conexao);
end;

class function TPedidoController.obterProximoNumeroPedidoDoBanco(Conexao: TFDConnection): Integer;
begin
  Result := TPedidoModel.obterProximoNumeroPedido(Conexao);

end;

end.

