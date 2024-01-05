unit uClienteModel;

interface

uses
  uCliente, FireDAC.Comp.Client, uConnection, Data.DB, FireDAC.Stan.Param;

type

  TClienteModel = class
  private
    class var FCliente: TCliente;
    class function getCliente: TCliente;
  public
    class function getClienteById(Codigo: Integer; Conexao: TFDConnection): TCliente;
    class function getClienteByNumeroPedido(NumeroPedido: Integer; Conexao: TFDConnection): TCliente;
  end;

implementation

{ TClienteModel }

class function TClienteModel.getCliente: TCliente;
begin
  if not Assigned(FCliente) then
    FCliente := TCliente.Create;
  result := FCliente;
end;

class function TClienteModel.getClienteById(Codigo: Integer; Conexao: TFDConnection): TCliente;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := Conexao;
    Query.SQL.Text := 'SELECT * FROM clientes WHERE codigo = :codigo';
    Query.ParamByName('codigo').AsInteger := Codigo;
    Query.Open;

    if not Query.IsEmpty then
    begin
      Result := getCliente;
      Result.Codigo := Query.FieldByName('codigo').AsInteger;
      Result.Nome := Query.FieldByName('nome').AsString;
      Result.Cidade := Query.FieldByName('cidade').AsString;
      Result.UF := Query.FieldByName('uf').AsString;
    end;
  finally
    Query.Free;
  end;
end;

class function TClienteModel.getClienteByNumeroPedido(NumeroPedido: Integer; Conexao: TFDConnection): TCliente;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := Conexao;
    Query.SQL.Text := 'SELECT c.* ' +
                      '  FROM clientes c ' +
                      '  JOIN pedido p ON c.codigo = p.codigo_cliente ' +
                      ' WHERE p.numero_pedido = :NumeroPedido';
    Query.ParamByName('NumeroPedido').AsInteger := NumeroPedido;
    Query.Open;

    if not Query.IsEmpty then
    begin
      Result := getCliente;
      Result.Codigo := Query.FieldByName('codigo').AsInteger;
      Result.Nome := Query.FieldByName('nome').AsString;
      Result.Cidade := Query.FieldByName('cidade').AsString;
      Result.UF := Query.FieldByName('uf').AsString;
    end;
  finally
    Query.Free;
  end;

end;

end.

