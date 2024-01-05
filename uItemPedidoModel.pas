unit uItemPedidoModel;

interface

uses
  uItemPedido, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param;

type
  TItemPedidoModel = class
  public
    class function GravarItemPedido(ItemPedido: TItemPedido; Conexao: TFDConnection): Boolean;
    class function AtualizarItemPedido(ItemPedido: TItemPedido; Conexao: TFDConnection): Boolean;
    class function ExcluirItemPedido(NumeroPedido, ID: Integer; Conexao: TFDConnection): Boolean;
  end;

implementation

{ TItemPedidoModel }

class function TItemPedidoModel.AtualizarItemPedido(ItemPedido: TItemPedido; Conexao: TFDConnection): Boolean;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := Conexao;
    Query.SQL.Text := 'UPDATE item_pedido '+
                      '   SET codigo_produto = :CodigoProduto, '+
                      '       quantidade = :Quantidade, ' +
                      '       valor_unitario = :ValorUnitario, ' +
                      '       valor_total = :ValorTotal ' +
                      ' WHERE numero_pedido = :NumeroPedido' +
                      '   AND ID = :Id ' ;

    Query.ParamByName('NumeroPedido').AsInteger := ItemPedido.NumeroPedido;
    Query.ParamByName('Id').AsInteger := ItemPedido.Id;
    Query.ParamByName('CodigoProduto').AsInteger := ItemPedido.CodigoProduto;
    Query.ParamByName('Quantidade').AsInteger := ItemPedido.Quantidade;
    Query.ParamByName('ValorUnitario').AsCurrency := ItemPedido.ValorUnitario;
    Query.ParamByName('ValorTotal').AsCurrency := ItemPedido.ValorTotal;
    Query.ExecSQL;

    Result := True;
  finally
    Query.Free;
  end;
end;

class function TItemPedidoModel.ExcluirItemPedido(NumeroPedido, ID: Integer;  Conexao: TFDConnection): Boolean;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := Conexao;
    Query.SQL.Text := 'DELETE FROM item_pedido WHERE id = :Id and numero_pedido = :numeropedido';
    Query.ParamByName('NumeroPedido').AsInteger := NumeroPedido;
    Query.ParamByName('ID').AsInteger := ID;
    Query.ExecSQL;

    Result := True;
  finally
    Query.Free;
  end;
end;

class function TItemPedidoModel.GravarItemPedido(ItemPedido: TItemPedido; Conexao: TFDConnection): Boolean;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := Conexao;
    Query.SQL.Text := 'INSERT INTO item_pedido (numero_pedido, codigo_produto, quantidade, ' +
                      'valor_unitario, valor_total) VALUES (:NumeroPedido, :CodigoProduto, ' +
                      ':Quantidade, :ValorUnitario, :ValorTotal)';
    Query.ParamByName('NumeroPedido').AsInteger := ItemPedido.NumeroPedido;
    Query.ParamByName('CodigoProduto').AsInteger := ItemPedido.CodigoProduto;
    Query.ParamByName('Quantidade').AsInteger := ItemPedido.Quantidade;
    Query.ParamByName('ValorUnitario').AsCurrency := ItemPedido.ValorUnitario;
    Query.ParamByName('ValorTotal').AsCurrency := ItemPedido.ValorTotal;
    Query.ExecSQL;

    Result := True;
  finally
    Query.Free;
  end;
end;

end.

