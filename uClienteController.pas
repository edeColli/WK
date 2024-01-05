unit uClienteController;

interface

uses
  uClienteModel, uCliente, FireDAC.Comp.Client;

type
  TClienteController = class
  public
    class function getClienteById(Codigo: Integer; Conexao: TFDConnection): TCliente;
    class function getClienteByNumeroPedido(NumeroPedido: Integer; Conexao: TFDConnection): TCliente;
  end;

implementation

{ TClienteController }

class function TClienteController.getClienteById(Codigo: Integer; Conexao: TFDConnection): TCliente;
begin
  Result := TClienteModel.getClienteById(Codigo, Conexao)
end;

class function TClienteController.getClienteByNumeroPedido(NumeroPedido: Integer; Conexao: TFDConnection): TCliente;
begin
  Result := TClienteModel.getClienteByNumeroPedido(NumeroPedido, Conexao);
end;

end.
