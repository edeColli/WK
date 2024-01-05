unit uProduto;

interface

uses
  System.Generics.Collections;

type
  TProduto = class
  private
    FCodigo: Integer;
    FDescricao: string;
    FPrecoVenda: Currency;
    FQuantidade: Integer;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Descricao: string read FDescricao write FDescricao;
    property PrecoVenda: Currency read FPrecoVenda write FPrecoVenda;
    property Quantidade: Integer read FQuantidade write FQuantidade;
  
    function validarProdtuto: Boolean;
    function isValid: Boolean;
    function getTotalValue: Double;
  end;

  TProdutoList = class(TObjectList<TProduto>)
  public
    function getTotal: Double;
  end;


implementation

uses
  Vcl.Dialogs;

{ TProduto }

function TProduto.isValid: Boolean;
begin
  Result := False;

  if (Self.Quantidade > 0) and (Self.PrecoVenda > 0) then
    Result := True
end;

function TProduto.getTotalValue: Double;
begin
  Result := Self.Quantidade * Self.PrecoVenda;
end;

function TProduto.validarProdtuto: Boolean;
begin
  Result := True;
  if Self = nil then
  begin
    ShowMessage('Produto não encontrado.');
    Result := False;
  end;
end;

{ TProdutoList }

function TProdutoList.getTotal: Double;
var
  Item: TProduto;
  total: Double;
begin
  total := 0;
  for Item in Self do
    total := total + Item.getTotalValue;

  result := Total;
end;

end.
