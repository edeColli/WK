unit uViewPedidoVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, uCliente,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, Vcl.Grids, uConnection, uProduto,
  uClienteController, uProdutoController, Data.DB, Vcl.DBGrids, DBClient, System.Generics.Collections,
  FireDAC.Comp.Client, System.UITypes;

type
  TfrmPedidoVenda = class(TForm)
    edtCodigoCliente: TLabeledEdit;
    edtNomeCliente: TLabeledEdit;
    edtCodigoItem: TLabeledEdit;
    edtDescricaoItem: TLabeledEdit;
    edtQuantidade: TLabeledEdit;
    btnSalvar: TButton;
    edtValorUnitario: TLabeledEdit;
    btnLocalizarCliente: TButton;
    btnLocalizarProduto: TButton;
    btnGerarPedido: TButton;
    edtValorTotalPedido: TLabeledEdit;
    dbGridProdutos: TDBGrid;
    dsProdutos: TDataSource;
    btnCancelarPedido: TButton;
    BtnCarregarPedido: TButton;
    procedure FormCreate(Sender: TObject);
  private
    connectionModule:  TConnectionModule;
    FCliente: TCliente;
    FProduto: TProduto;
    CDSProdutos: TClientDataSet;

    procedure DoOnSaveItem(Sender: TObject);
    procedure DoOnClickSearchCliente(Sender: TObject);
    procedure DoOnClickSearchItem(Sender: TObject);
    procedure DoOnClickGerarPedido(Sender: TObject);
    procedure DoOnClickCancelarPedido(Sender: TObject);
    procedure DoOnClickCarregarPedido(Sender: TObject);
    procedure DoOnKeyPressEdit(Sender: TObject; var Key: Char);
    procedure DoOnKeyPressEditValue(Sender: TObject; var Key: Char);
    procedure DoonKeyPressGrid(Sender: TObject; var Key: Char);
    procedure DoOnKeyDownGrid(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoOnChangeItem(Sender: TObject);
    procedure DoOnChangeCliente(Sender: TObject);
    procedure InitializeForm;
    procedure CreateConnection;
    procedure ConfigurateEdits;
    procedure InitializeGridItems;
    procedure ConfigurateButtons;
    procedure CreateObjects;
    procedure CleanFieldsItem;
    procedure CleanFieldsCliente;
    procedure AddItemToDataSet(AProduto: TProduto);
    procedure InsertItem;
    function inserirItem: Boolean;
    procedure alterarItem;
    procedure ProdutoInvalido;
    procedure GetCliente;
    procedure GetItem;
    procedure GerarPedido;
    procedure CarregarPedido;
    procedure CancelarPedido;
    procedure ConfigurateDatasetProdutos;
    procedure AjustarTamanhoColunasGrid;
    procedure ConfigurarGridSelecaoLinha;
    procedure CriarDataSet;
    procedure LimparTela;
    procedure habilitarBotoesPedido;
    procedure PopularDadosPedido(AQuery: TFDQuery);

    function getNroPedido: Integer;
    function ValidarDados: Boolean;
    function getTotalPedido: Double;
    function InputNumeroPedido: Integer;
  public
    { Public declarations }
  end;

var
  frmPedidoVenda: TfrmPedidoVenda;

CONST
  MSG_INVALIDA = 'Código inválido. Informe um código válido.';

implementation

uses
  uPedido, uItemPedido, uPedidoController, uItemPedidoController;

{$R *.dfm}

procedure TfrmPedidoVenda.AddItemToDataSet(AProduto: TProduto);
begin
  CDSProdutos.Append;
  CDSProdutos.FieldByName('Codigo').AsInteger := AProduto.Codigo;
  CDSProdutos.FieldByName('Descricao').AsString := AProduto.Descricao;
  CDSProdutos.FieldByName('Quantidade').AsInteger := AProduto.Quantidade;
  CDSProdutos.FieldByName('Valor_Unitario').AsFloat := AProduto.PrecoVenda;
  CDSProdutos.FieldByName('Valor_Total').AsFloat := AProduto.getTotalValue;
  CDSProdutos.Post;
end;

procedure TfrmPedidoVenda.AjustarTamanhoColunasGrid;
begin
  dbGridProdutos.Columns[0].Width := 50; // Codigo
  dbGridProdutos.Columns[1].Width := 180; // Descricao
  dbGridProdutos.Columns[2].Width := 80; // Quantidade
  dbGridProdutos.Columns[3].Width := 80; // Valor_Unitario
  dbGridProdutos.Columns[4].Width := 80; // Valor_Total

  dbGridProdutos.Columns[0].Title.Caption := 'Código';
  dbGridProdutos.Columns[1].Title.Caption := 'Descrição';
  dbGridProdutos.Columns[2].Title.Caption := 'Quantidade';
  dbGridProdutos.Columns[3].Title.Caption := 'Valor Unitario';
  dbGridProdutos.Columns[4].Title.Caption := 'Valor Total';

  dbGridProdutos.Columns[5].Visible := False; //ID
  dbGridProdutos.Columns[6].Visible := False; //Numero Pedido
end;

procedure TfrmPedidoVenda.alterarItem;
begin
  CDSProdutos.Edit;
  CDSProdutos.FieldByName('Codigo').AsInteger := StrToIntDef(edtCodigoItem.Text, 0);
  CDSProdutos.FieldByName('Descricao').AsString := edtDescricaoItem.Text;
  CDSProdutos.FieldByName('Quantidade').AsInteger := StrToIntDef(edtQuantidade.Text, 0);
  CDSProdutos.FieldByName('Valor_Unitario').AsFloat := StrToCurrDef(edtValorUnitario.Text, 0);
  CDSProdutos.Post;
end;

procedure TfrmPedidoVenda.ConfigurarGridSelecaoLinha;
begin
  dbGridProdutos.Options := dbGridProdutos.Options + [dgRowSelect, dgConfirmDelete];
end;

procedure TfrmPedidoVenda.CriarDataSet;
begin
  CDSProdutos := TClientDataSet.Create(Self);
  CDSProdutos.FieldDefs.Add('Codigo', ftInteger);
  CDSProdutos.FieldDefs.Add('Descricao', ftString, 150);
  CDSProdutos.FieldDefs.Add('Quantidade', ftInteger);
  CDSProdutos.FieldDefs.Add('Valor_Unitario', ftFloat);
  CDSProdutos.FieldDefs.Add('Valor_Total', ftFloat);
  CDSProdutos.FieldDefs.Add('ID', ftInteger);
  CDSProdutos.FieldDefs.Add('Numero_Pedido', ftInteger);
  CDSProdutos.CreateDataSet;
end;


procedure TfrmPedidoVenda.CancelarPedido;
var
  NumeroPedido: Integer;
  Transaction: TFDTransaction;
begin
  NumeroPedido := InputNumeroPedido;
  if NumeroPedido > 0 then
  begin
    Transaction := TFDTransaction.Create(nil);
    try
      Transaction.Connection := ConnectionModule.Connection;
      Transaction.StartTransaction;
      TPedidoController.CancelarPedido(NumeroPedido, connectionModule.Connection);
      Transaction.Commit;

      ShowMessage('Pedido cancelado com sucesso.');
      LimparTela;
    except
      Transaction.Rollback
    end;
    Transaction.Free;
  end;
end;

procedure TfrmPedidoVenda.CarregarPedido;
var
  NumeroPedido: Integer;
  AQuery: TFDQuery;
begin
  NumeroPedido := InputNumeroPedido;
  if NumeroPedido > 0 then
  begin
    AQuery := TPedidoController.CarregarPedido(NumeroPedido, connectionModule.Connection);
    try
      PopularDadosPedido(AQuery);
      FCliente := TClienteController.getClienteByNumeroPedido(NumeroPedido, ConnectionModule.Connection);
    finally
      AQuery.Free;
    end;
    habilitarBotoesPedido;
  end;
end;

procedure TfrmPedidoVenda.CleanFieldsCliente;
begin
  EdtNomeCliente.Clear;
end;

procedure TfrmPedidoVenda.CleanFieldsItem;
begin
  EdtDescricaoItem.Clear;
  EdtQuantidade.Clear;
  EdtValorUnitario.Clear;
end;

procedure TfrmPedidoVenda.configurateDatasetProdutos;
begin
  CriarDataSet;
  dsProdutos.DataSet := CDSProdutos;
  AjustarTamanhoColunasGrid;
  ConfigurarGridSelecaoLinha;
end;

procedure TfrmPedidoVenda.configurateButtons;
begin
  btnSalvar.OnClick := DoOnSaveItem;
  BtnLocalizarCliente.OnClick := DoOnClickSearchCliente;
  BtnLocalizarProduto.OnClick := DoOnClickSearchItem;
  BtnGerarPedido.OnClick := DoOnClickGerarPedido;
  btnCancelarPedido.OnClick := DoOnClickCancelarPedido;
  BtnCarregarPedido.OnClick := DoOnClickCarregarPedido;
  habilitarBotoesPedido;
end;

procedure TfrmPedidoVenda.configurateEdits;
begin
  EdtCodigoCliente.OnKeyPress := DoOnKeyPressEdit;
  EdtCodigoItem.OnKeyPress := DoOnKeyPressEdit;
  EdtQuantidade.OnKeyPress := DoOnKeyPressEdit;
  EdtValorUnitario.OnKeyPress := DoOnKeyPressEditValue;
  EdtNomeCliente.ReadOnly := True;
  EdtDescricaoItem.ReadOnly := True;
  EdtValorTotalPedido.ReadOnly := True;

  EdtCodigoItem.OnChange := DoOnChangeItem;
  EdtCodigoCliente.OnChange := DoOnChangeCliente;
end;

procedure TfrmPedidoVenda.CreateConnection;
begin
  ConnectionModule := TConnectionModule.Create(Self);
end;

procedure TfrmPedidoVenda.createObjects;
begin
  //FCliente := TCliente.Create;
  //ConfigurarDatasetProdutos;
end;

procedure TfrmPedidoVenda.DoOnChangeCliente(Sender: TObject);
begin
  CleanFieldsCliente;
end;

procedure TfrmPedidoVenda.DoOnChangeItem(Sender: TObject);
begin
  CleanFieldsItem;
end;

procedure TfrmPedidoVenda.DoOnClickCancelarPedido(Sender: TObject);
begin
  cancelarPedido;
end;

procedure TfrmPedidoVenda.DoOnClickCarregarPedido(Sender: TObject);
begin
  carregarPedido;
end;

procedure TfrmPedidoVenda.DoOnClickGerarPedido(Sender: TObject);
begin
  gerarPedido;
end;

procedure TfrmPedidoVenda.DoOnClickSearchCliente(Sender: TObject);
begin
  getCliente;
end;

procedure TfrmPedidoVenda.DoOnClickSearchItem(Sender: TObject);
begin
  getItem;
end;

procedure TfrmPedidoVenda.DoOnKeyDownGrid(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  SelectedRowIndex: Integer;
  NumeroPedido, Id: Integer;
begin
  if (Key = VK_DELETE) then
  begin
    SelectedRowIndex := dbGridProdutos.DataSource.DataSet.RecNo;

    if (SelectedRowIndex > 0) and (SelectedRowIndex <= CDSProdutos.RecordCount) then
    begin
      NumeroPedido := CDSProdutos.FieldByName('Numero_pedido').AsInteger;
      Id := CDSProdutos.FieldByName('ID').AsInteger;

      if MessageDlg('Deseja excluir o item do pedido?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        if not TItemPedidoController.ExcluirItemPedido(NumeroPedido, Id, connectionModule.Connection) then
        begin
          ShowMessage('Erro ao excluir o item do pedido.');
          Exit;
        end;
        CDSProdutos.Delete;
      end;
    end;
  end;
end;


procedure TfrmPedidoVenda.DoOnKeyPressEdit(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TfrmPedidoVenda.DoOnKeyPressEditValue(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8, ',']) then
    Key := #0;
end;

procedure TfrmPedidoVenda.DoonKeyPressGrid(Sender: TObject; var Key: Char);
var
  SelectedRowIndex: Integer;
begin
  if Key = #13 then
  begin
    SelectedRowIndex := dbGridProdutos.DataSource.DataSet.RecNo;

    if (SelectedRowIndex > 0) and (SelectedRowIndex <= CDSProdutos.RecordCount) then
    begin
      EdtCodigoItem.Text := IntToStr(CDSProdutos.FieldByName('Codigo').AsInteger);
      EdtDescricaoItem.Text := CDSProdutos.FieldByName('Descricao').AsString;
      EdtQuantidade.Text := IntToStr(CDSProdutos.FieldByName('Quantidade').AsInteger);
      EdtValorUnitario.Text := CurrToStr(CDSProdutos.FieldByName('Valor_Unitario').AsFloat);

      dbGridProdutos.SelectedRows.Clear;
    end;
  end;
end;


procedure TfrmPedidoVenda.DoOnSaveItem(Sender: TObject);
begin
  insertItem;
end;

procedure TfrmPedidoVenda.FormCreate(Sender: TObject);
begin
  CreateConnection;
  initializeForm;
end;

procedure TfrmPedidoVenda.gerarPedido;
var
  Pedido: TPedido;
  ItemPedido: TItemPedido;
  Transaction: TFDTransaction;
  NumeroPedido: Integer;

  procedure TratarErroGravacao;
  begin
    ShowMessage('Erro ao gravar item do pedido no banco.');
    Exit;
  end;
begin
  if ValidarDados then
  begin
    NumeroPedido := getNroPedido;
    Transaction := TFDTransaction.Create(nil);
    try
      Transaction.Connection := ConnectionModule.Connection;
      Transaction.StartTransaction;

      Pedido := TPedido.Create;
      try
        Pedido.CodigoCliente := FCliente.Codigo;
        Pedido.DataEmissao := Now;
        Pedido.ValorTotal := getTotalPedido;

        if not TPedidoController.GravarPedido(NumeroPedido, Pedido, connectionModule.Connection) then
        begin
          ShowMessage('Erro ao gravar pedido no banco.');
          Exit;
        end;
        if True then

        if NumeroPedido = 0 then
          NumeroPedido := TPedidoController.obterProximoNumeroPedidoDoBanco(connectionModule.Connection);

        CDSProdutos.First;
        while not CDSProdutos.Eof do
        begin
          ItemPedido := TItemPedido.Create;
          try
            ItemPedido.NumeroPedido := NumeroPedido;
            ItemPedido.CodigoProduto := CDSProdutos.FieldByName('Codigo').AsInteger;
            ItemPedido.Quantidade := CDSProdutos.FieldByName('Quantidade').AsInteger;
            ItemPedido.ValorUnitario := CDSProdutos.FieldByName('Valor_Unitario').AsFloat;
            ItemPedido.ValorTotal := CDSProdutos.FieldByName('Valor_Total').AsFloat;

            if CDSProdutos.FieldByName('ID').AsInteger > 0 then
            begin
              ItemPedido.ID := CDSProdutos.FieldByName('ID').AsInteger;
              if not TItemPedidoController.AtualizarItemPedido(ItemPedido, connectionModule.Connection) then
                TratarErroGravacao
            end else
            if not TItemPedidoController.GravarItemPedido(ItemPedido, connectionModule.Connection) then
              TratarErroGravacao;

          finally
            ItemPedido.Free;
          end;
          CDSProdutos.Next;
        end;

        Transaction.Commit;
      finally
        Pedido.Free;
      end;
      ShowMessage('Pedido gravado com sucesso.');
      LimparTela;
    except
      Transaction.Rollback
    end;
    Transaction.Free;
  end
  else
    ShowMessage('Impossível gerar o pedido, informações inválidas. Verique!');
end;

procedure TfrmPedidoVenda.getCliente;
var
  codigoCliente: Integer;
begin
  if (Trim(EdtCodigoCliente.Text) = '') or (StrToIntDef(EdtCodigoCliente.Text, 0) = 0) then
  begin
    ShowMessage(MSG_INVALIDA);
    Exit;
  end;

  codigoCliente := StrToInt(EdtCodigoCliente.Text);

  FCliente := TClienteController.getClienteById(codigoCliente, ConnectionModule.Connection);

  if FCliente.ValidaCliente then
  begin
    EdtNomeCliente.Text := FCliente.Nome;
    habilitarBotoesPedido;
  end;
end;

procedure TfrmPedidoVenda.getItem;
var
  codigoProduto: Integer;
begin
  if (Trim(EdtCodigoItem.Text) = '') or (StrToIntDef(EdtCodigoItem.Text, 0) = 0) then
  begin
    ShowMessage(MSG_INVALIDA);
    Exit;
  end;

  codigoProduto := StrToInt(EdtCodigoItem.Text);

  FProduto := TProdutoController.getProdutoById(codigoProduto, ConnectionModule.Connection);
  if FProduto.validarProdtuto then
  begin
    EdtDescricaoItem.Text := FProduto.Descricao;
    EdtValorUnitario.Text := CurrToStr(FProduto.PrecoVenda);
  end;
end;

function TfrmPedidoVenda.getNroPedido: Integer;
begin
  CDSProdutos.First;
  Result := 0;
  while not CDSProdutos.Eof do
  begin
    if CDSProdutos.FieldByName('Numero_pedido').AsInteger > 0 then
      Exit(CDSProdutos.FieldByName('Numero_pedido').AsInteger);
    CDSProdutos.Next;
  end;
end;

function TfrmPedidoVenda.getTotalPedido: Double;
var
  Total: Double;
begin
  Total := 0;
  CDSProdutos.First;
  while not CDSProdutos.eof do
  begin
    Total := Total + CDSProdutos.FieldByName('valor_total').AsCurrency;
    CDSProdutos.Next
  end;
  Result := Total;
end;

procedure TfrmPedidoVenda.habilitarBotoesPedido;
begin
  btnCancelarPedido.Enabled := StrToIntDef(edtCodigoCliente.Text, 0) = 0;
  BtnCarregarPedido.Enabled := StrToIntDef(edtCodigoCliente.Text, 0) = 0;
end;

procedure TfrmPedidoVenda.initializeForm;
begin
  initializeGridItems;
  ConfigurateDatasetProdutos;
  configurateButtons;
  configurateEdits;
  createObjects;
end;

procedure TfrmPedidoVenda.initializeGridItems;
begin
  dbGridProdutos.OnKeyPress := DoOnKeyPressGrid;
  dbGridProdutos.OnKeyDown := DoOnKeyDownGrid;
end;

procedure TfrmPedidoVenda.insertItem;
begin
  if Assigned(FProduto)then
  begin
    if inserirItem then
      edtCodigoItem.Clear;
  end
  else
    alterarItem;

  edtCodigoItem.SetFocus;
end;

procedure TfrmPedidoVenda.LimparTela;
begin
  edtCodigoCliente.Clear;
  edtCodigoItem.Clear;
  CDSProdutos.EmptyDataSet;
  edtValorTotalPedido.Clear;
  habilitarBotoesPedido;
end;

procedure TfrmPedidoVenda.PopularDadosPedido(AQuery: TFDQuery);
begin
  if not AQuery.IsEmpty then
  begin
    edtCodigoCliente.Text := AQuery.FieldByName('codCli').AsString;
    edtNomeCliente.Text := AQuery.FieldByName('Nome').AsString;
    edtValorTotalPedido.Text := AQuery.FieldByName('totalPedido').AsString;
    while not(AQuery.Eof) do
    begin
      CDSProdutos.Append;
      CDSProdutos.FieldByName('ID').AsInteger := AQuery.FieldByName('ID').AsInteger;
      CDSProdutos.FieldByName('Numero_Pedido').AsInteger := AQuery.FieldByName('Numero_Pedido').AsInteger;
      CDSProdutos.FieldByName('Codigo').AsInteger := AQuery.FieldByName('Codigo').AsInteger;
      CDSProdutos.FieldByName('Descricao').AsString := AQuery.FieldByName('Descricao').AsString;
      CDSProdutos.FieldByName('Quantidade').AsInteger := AQuery.FieldByName('Quantidade').AsInteger;
      CDSProdutos.FieldByName('Valor_Unitario').AsFloat := AQuery.FieldByName('Valor_unitario').AsFloat;
      CDSProdutos.FieldByName('Valor_Total').AsFloat := AQuery.FieldByName('Valor_total').AsCurrency;
      AQuery.Next;
    end;
  end;
end;

procedure TfrmPedidoVenda.ProdutoInvalido;
begin
  ShowMessage('Produto sem preço ou com quantidade zerada. Verifique!');
end;

function TfrmPedidoVenda.InputNumeroPedido: Integer;
var
  NumeroPedidoStr: string;
begin
  NumeroPedidoStr := InputBox('Carregar Pedido', 'Digite o número do pedido:', '');

  if not TryStrToInt(NumeroPedidoStr, Result) then
  begin
    Result := 0;
    ShowMessage('Número de pedido inválido.');
  end;
end;


function TfrmPedidoVenda.inserirItem: Boolean;
begin
  Result := True;
  FProduto.PrecoVenda := StrToCurrDef(edtValorUnitario.Text, 0);
  FProduto.Quantidade := StrToIntDef(edtQuantidade.Text, 0);

  if FProduto.isValid then
  begin
    AddItemToDataSet(FProduto);
    edtValorTotalPedido.Text := CurrToStr(getTotalPedido);
    FProduto := nil;
  end else
  begin
    ProdutoInvalido;
    Result := False;
  end;

end;

function TfrmPedidoVenda.ValidarDados: Boolean;
begin
  Result := False;

  if (CDSProdutos.RecordCount > 0) and (StrToIntDef(edtCodigoCliente.Text, 0) > 0) then
    Result := True;
end;

end.
