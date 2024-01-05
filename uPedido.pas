unit uPedido;

interface

type
  TPedido = class
  private
    FNumeroPedido: Integer;
    FCodigoCliente: Integer;
    FDataEmissao: TDateTime;
    FValorTotal: Currency;
  public
    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property CodigoCliente: Integer read FCodigoCliente write FCodigoCliente;
    property DataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property ValorTotal: Currency read FValorTotal write FValorTotal;
  end;

implementation

end.

