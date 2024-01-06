unit uCliente;

interface

type
  TCliente = class
  private
    FCodigo: Integer;
    FNome: string;
    FCidade: string;
    FUF: string;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Nome: string read FNome write FNome;
    property Cidade: string read FCidade write FCidade;
    property UF: string read FUF write FUF;

    function ValidaCliente: Boolean;
  end;

implementation

uses
  Vcl.Dialogs, WKResourceString;

{ TCliente }

function TCliente.ValidaCliente: Boolean;
begin
  Result := True;
  if Self = nil then
  begin
    ShowMessage(RSClienteNaoEncontrado);
    Result := False;
  end;
end;

end.
