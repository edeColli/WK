unit uProdutoController;

interface

uses
  uProdutoModel, uProduto, FireDAC.Comp.Client;

type
  TProdutoController = class
  public
    class function getProdutoById(Codigo: Integer; Conexao: TFDConnection): TProduto;
  end;

implementation

{ TProdutoController }

class function TProdutoController.getProdutoById(Codigo: Integer; Conexao: TFDConnection): TProduto;
begin
  Result := TProdutoModel.getProdutoById(Codigo, Conexao)
end;

end.
