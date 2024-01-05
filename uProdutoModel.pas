unit uProdutoModel;

interface

uses
  uProduto, FireDAC.Comp.Client, Data.DB, FireDAC.Stan.Param;

type

  TProdutoModel = class
  private
    class var FProduto: TProduto;
    class function getProduto: TProduto;
  public
    class function getProdutoById(Codigo: Integer; Conexao: TFDConnection): TProduto;
  end;

implementation

{ TProdutoModel }

class function TProdutoModel.getProduto: TProduto;
begin
  if not(Assigned(FProduto)) then
    FProduto := TProduto.Create();

  Result := FProduto;
end;

class function TProdutoModel.getProdutoById(Codigo: Integer; Conexao: TFDConnection): TProduto;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := Conexao;
    Query.SQL.Text := 'SELECT * FROM produtos WHERE codigo = :codigo';
    Query.ParamByName('codigo').AsInteger := Codigo;
    Query.Open;

    if not Query.IsEmpty then
    begin
      Result := getProduto;
      Result.Codigo := Query.FieldByName('codigo').AsInteger;
      Result.Descricao := Query.FieldByName('descricao').AsString;
      Result.PrecoVenda := Query.FieldByName('preco_venda').AsCurrency;
    end;
  finally
    Query.Free;
  end;
end;


end.
