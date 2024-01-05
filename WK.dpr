program WK;

uses
  Vcl.Forms,
  uViewPedidoVenda in 'uViewPedidoVenda.pas' {frmPedidoVenda},
  uProduto in 'uProduto.pas',
  uCliente in 'uCliente.pas',
  uConnection in 'uConnection.pas' {ConnectionModule: TDataModule},
  uClienteModel in 'uClienteModel.pas',
  uClienteController in 'uClienteController.pas',
  uProdutoController in 'uProdutoController.pas',
  uProdutoModel in 'uProdutoModel.pas',
  uItemPedido in 'uItemPedido.pas',
  uItemPedidoController in 'uItemPedidoController.pas',
  uItemPedidoModel in 'uItemPedidoModel.pas',
  uPedido in 'uPedido.pas',
  uPedidoController in 'uPedidoController.pas',
  uPedidoModel in 'uPedidoModel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPedidoVenda, frmPedidoVenda);
  Application.CreateForm(TConnectionModule, ConnectionModule);
  Application.Run;
end.
