-- wk.clientes definition

CREATE TABLE `clientes` (
  `codigo` int(11) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `cidade` varchar(255) DEFAULT NULL,
  `uf` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- wk.produtos definition

CREATE TABLE `produtos` (
  `codigo` int(11) NOT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `preco_venda` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- wk.pedido definition

CREATE TABLE `pedido` (
  `numero_pedido` int(11) NOT NULL AUTO_INCREMENT,
  `data_emissao` date DEFAULT NULL,
  `codigo_cliente` int(11) DEFAULT NULL,
  `valor_total` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`numero_pedido`),
  KEY `codigo_cliente` (`codigo_cliente`),
  CONSTRAINT `pedido_ibfk_1` FOREIGN KEY (`codigo_cliente`) REFERENCES `clientes` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- wk.item_pedido definition

CREATE TABLE `item_pedido` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero_pedido` int(11) DEFAULT NULL,
  `codigo_produto` int(11) DEFAULT NULL,
  `quantidade` int(11) DEFAULT NULL,
  `valor_unitario` decimal(10,2) DEFAULT NULL,
  `valor_total` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `numero_pedido` (`numero_pedido`),
  KEY `codigo_produto` (`codigo_produto`),
  CONSTRAINT `item_pedido_ibfk_1` FOREIGN KEY (`numero_pedido`) REFERENCES `pedido` (`numero_pedido`),
  CONSTRAINT `item_pedido_ibfk_2` FOREIGN KEY (`codigo_produto`) REFERENCES `produtos` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;