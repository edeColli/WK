unit uPedidoModel;

interface

uses
  uPedido, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param;

type
  TPedidoModel = class
  private
    class procedure cancelarItems(NumeroPedido: Integer; Conexao: TFDConnection);
    class procedure cancelarCabecalho(NumeroPedido: Integer; Conexao: TFDConnection);
  public
    class procedure CancelarPedido(Pedido: Integer; Conexao: TFDConnection);

    class function GravarPedido(Pedido: TPedido; Conexao: TFDConnection): Boolean;
    class function AlterarPedido(NumeroPedido: Integer; Pedido: TPedido; Conexao: TFDConnection): Boolean;
    class function CarregarPedido(NumeroPedido: Integer; Conexao: TFDConnection): TFDQuery;
    class function obterProximoNumeroPedido(Conexao: TFDConnection): Integer;
  end;

implementation

{ TPedidoModel }

class function TPedidoModel.AlterarPedido(NumeroPedido: Integer; Pedido: TPedido; Conexao: TFDConnection): Boolean;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := Conexao;
    Query.SQL.Text := 'UPDATE pedido ' +
                      '   SET codigo_cliente = :CodigoCliente, '+
                      '       valor_total = :ValorTotal ' +
                      ' WHERE Numero_Pedido = :NumeroPedido';
    Query.ParamByName('NumeroPedido').AsInteger := NumeroPedido;
    Query.ParamByName('CodigoCliente').AsInteger := Pedido.CodigoCliente;
    Query.ParamByName('ValorTotal').AsCurrency := Pedido.ValorTotal;
    Query.ExecSQL;

    Result := True;
  finally
    Query.Free;
  end;
end;

class procedure TPedidoModel.cancelarCabecalho(NumeroPedido: Integer; Conexao: TFDConnection);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := Conexao;
    Query.SQL.Text := 'DELETE FROM pedido WHERE numero_pedido = :numero_pedido ';
    Query.ParamByName('numero_pedido').AsInteger := NumeroPedido;
    Query.ExecSQL;
  finally
    Query.Free;
  end;

end;

class procedure TPedidoModel.cancelarItems(NumeroPedido: Integer; Conexao: TFDConnection);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := Conexao;
    Query.SQL.Text := 'DELETE FROM item_pedido WHERE numero_pedido = :numero_pedido ';
    Query.ParamByName('numero_pedido').AsInteger := NumeroPedido;
    Query.ExecSQL;
  finally
    Query.Free;
  end;


end;

class procedure TPedidoModel.CancelarPedido(Pedido: Integer; Conexao: TFDConnection);
begin
  cancelarItems(Pedido, Conexao);
  cancelarCabecalho(Pedido, Conexao);
end;

class function TPedidoModel.CarregarPedido(NumeroPedido: Integer; Conexao: TFDConnection): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := Conexao;
  Result.SQL.Text := 'SELECT c.codigo as codCli, c.nome, p.numero_pedido, p.valor_total as totalPedido, ' +
                     '       i.codigo, i.descricao, ip.id, ip.quantidade, ip.valor_unitario, ip.valor_total' +
                     '  FROM pedido p ' +
                     '  JOIN item_pedido ip ON p.numero_pedido = ip.numero_pedido ' +
                     '  JOIN clientes c ON p.codigo_cliente = c.codigo ' +
                     '  JOIN produtos i ON ip.codigo_produto = i.codigo ' +
                     ' WHERE p.numero_pedido = :Numero_Pedido';
  Result.ParamByName('numero_pedido').AsInteger := NumeroPedido;
  Result.Open;
end;

class function TPedidoModel.GravarPedido(Pedido: TPedido; Conexao: TFDConnection): Boolean;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := Conexao;
    Query.SQL.Text := 'INSERT INTO pedido (numero_pedido, codigo_cliente, data_emissao, valor_total) ' +
                      'VALUES (:NumeroPedido, :CodigoCliente, :DataEmissao, :ValorTotal)';
    Query.ParamByName('NumeroPedido').AsInteger := Pedido.NumeroPedido;
    Query.ParamByName('CodigoCliente').AsInteger := Pedido.CodigoCliente;
    Query.ParamByName('DataEmissao').AsDateTime := Pedido.DataEmissao;
    Query.ParamByName('ValorTotal').AsCurrency := Pedido.ValorTotal;
    Query.ExecSQL;

    Result := True;
  finally
    Query.Free;
  end;
end;

class function TPedidoModel.obterProximoNumeroPedido(Conexao: TFDConnection): Integer;
var
  Query: TFDQuery;
begin
  Result := 0;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := Conexao;
    Query.SQL.Text := 'SELECT LAST_INSERT_ID() AS ProximoNumero';
    Query.Open;

    if not Query.IsEmpty then
      Result := Query.FieldByName('ProximoNumero').AsInteger;
  finally
    Query.Free;
  end;
end;

end.

