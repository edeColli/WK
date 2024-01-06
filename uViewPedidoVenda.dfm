object frmPedidoVenda: TfrmPedidoVenda
  Left = 0
  Top = 0
  Caption = 'Pedido de Venda'
  ClientHeight = 493
  ClientWidth = 573
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object EdtCodigoCliente: TLabeledEdit
    Left = 5
    Top = 89
    Width = 57
    Height = 23
    EditLabel.Width = 37
    EditLabel.Height = 15
    EditLabel.Caption = 'Cliente'
    TabOrder = 0
    Text = ''
  end
  object EdtNomeCliente: TLabeledEdit
    Left = 88
    Top = 89
    Width = 177
    Height = 23
    EditLabel.Width = 33
    EditLabel.Height = 15
    EditLabel.Caption = 'Nome'
    TabOrder = 8
    Text = ''
  end
  object EdtCodigoItem: TLabeledEdit
    Left = 5
    Top = 134
    Width = 57
    Height = 23
    EditLabel.Width = 43
    EditLabel.Height = 15
    EditLabel.Caption = 'Produto'
    TabOrder = 2
    Text = ''
  end
  object EdtDescricaoItem: TLabeledEdit
    Left = 88
    Top = 134
    Width = 177
    Height = 23
    EditLabel.Width = 51
    EditLabel.Height = 15
    EditLabel.Caption = 'Descri'#231#227'o'
    TabOrder = 9
    Text = ''
  end
  object EdtQuantidade: TLabeledEdit
    Left = 280
    Top = 134
    Width = 73
    Height = 23
    EditLabel.Width = 62
    EditLabel.Height = 15
    EditLabel.Caption = 'Quantidade'
    TabOrder = 4
    Text = ''
  end
  object BtnSalvar: TButton
    Left = 457
    Top = 132
    Width = 96
    Height = 25
    Caption = 'Inserir/Alterar'
    TabOrder = 6
  end
  object EdtValorUnitario: TLabeledEdit
    Left = 368
    Top = 134
    Width = 73
    Height = 23
    EditLabel.Width = 71
    EditLabel.Height = 15
    EditLabel.Caption = 'Valor Unit'#225'rio'
    TabOrder = 5
    Text = ''
  end
  object BtnLocalizarCliente: TButton
    Left = 63
    Top = 89
    Width = 23
    Height = 23
    Hint = 'Clique para cliente o produto pelo c'#243'digo'
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object BtnLocalizarProduto: TButton
    Left = 63
    Top = 134
    Width = 23
    Height = 23
    Hint = 'Clique para consultar o produto pelo c'#243'digo'
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object BtnGerarPedido: TButton
    Left = 457
    Top = 431
    Width = 96
    Height = 25
    Caption = 'Gerar Pedido'
    TabOrder = 7
  end
  object EdtValorTotalPedido: TLabeledEdit
    Left = 345
    Top = 433
    Width = 97
    Height = 23
    EditLabel.Width = 81
    EditLabel.Height = 15
    EditLabel.Caption = 'Vl. Total Pedido'
    TabOrder = 10
    Text = ''
  end
  object dbGridProdutos: TDBGrid
    Left = 5
    Top = 177
    Width = 548
    Height = 225
    DataSource = dsProdutos
    TabOrder = 11
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object btnCancelarPedido: TButton
    Left = 8
    Top = 431
    Width = 113
    Height = 25
    Caption = 'Cancelar Pedido'
    TabOrder = 12
  end
  object BtnCarregarPedido: TButton
    Left = 8
    Top = 8
    Width = 113
    Height = 25
    Caption = 'Carregar Pedido'
    TabOrder = 13
  end
  object btnLimparTela: TButton
    Left = 440
    Top = 8
    Width = 113
    Height = 25
    Caption = 'Limpar Tela'
    TabOrder = 14
  end
  object dsProdutos: TDataSource
    Left = 472
    Top = 297
  end
end
