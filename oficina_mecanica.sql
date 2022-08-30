create database oficina_mecanica;
use oficina_mecanica;

create table clientes (
		id_cliente int primary key auto_increment,
        nome_cliente varchar (30),
        CPF char(11) unique,
        modelo_do_veiculo varchar (30),
        Placa_do_veiculo char(7) unique,
        contato_cliete int 
);

insert into clientes (nome_cliente, CPF, modelo_do_veiculo, Placa_do_veiculo,contato_cliete) values
						('Claudio Silva', '44222334785','etios','FLF5j33','960813116'),
                        ('Maria Jose', '38822334785','corsa','ALF5G44','960813469'),
                        ('Silvia maria', '24222334385','Palio','ABF5j21','980813174');

create table equipe_de_mecanicos (
		id_mecaninco int primary key auto_increment,
        nome_mecanico varchar (30),
        endereço varchar (30),
        especialidade_mecanica enum('Funilaria','Eletrica','Arrefecimento','Motor','Cambio')
);

insert into equipe_de_mecanicos (nome_mecanico,endereço,especialidade_mecanica) values
								('Marcio Ribeiro', 'Rua francisco 82','Funilaria'),
                                ('Jose Santos', 'Rua Ribas 63', 'Motor'),
                                ('Elivaldo Sintra','Rua Barão silva 22', 'Eletrica');
                                

create table ordem_de_servico (
		id_os int primary key auto_increment,
        data_os date,
        status_os enum('analisando','em andamento','aguardando aprovação','aguardando peça','concluido'),
        data_conclusao date,
        valor float,
        tipo_os enum ('concerto','revisão'),
        Descricao_serviço varchar (255),
        idCliente_os int,
        idMecanico_os int,
        constraint fk_ordem_de_servico_cliente foreign key (idCliente_os) references clientes(id_cliente),
        constraint fk_ordem_de_servico_mecanico foreign key (idMecanico_os) references equipe_de_mecanicos(id_mecaninco)        
);

insert into ordem_de_servico (data_os, status_os,data_conclusao,valor,tipo_os,Descricao_serviço,idCliente_os,idMecanico_os) values
							 ('2022-08-30', 'analisando','2022-09-05','200','concerto','funilaria na porta','1','1'),
                             ('2022-08-25', 'aguardando aprovação','2022-08-30','500','revisão','motor falhando','2','2'),
                             ('2022-08-27', 'aguardando aprovação','2022-09-02','500','concerto','farol não liga','3','3');
                             
create table mao_de_obra(
		id_mao_de_obra int primary key auto_increment,
        valor_mao_de_obra float,
        idMecanico_resposavel int,
        idOrcamento_mao_de_obra int,
        constraint fk_mao_de_obra_mecanico foreign key (idMecanico_resposavel) references equipe_de_mecanicos(id_mecaninco),
        constraint fk_mao_de_obra_orcamento foreign key (idOrcamento_mao_de_obra) references orcamento(Id_orcamento)
);

insert into mao_de_obra (valor_mao_de_obra,idMecanico_resposavel,idOrcamento_mao_de_obra) values
						('150','1','1'),
                        ('200','2','2'),
                        ('230','3','3');
 
create table orcamento(
		Id_orcamento int primary key auto_increment,
        Numero_os int,
        valor_orcamento float,
        id_cliente_orcamento int,
        constraint fk_orcamento_Numero_os foreign key (Numero_os) references ordem_de_servico(id_os),
		constraint fk_orcamento_id_cliente foreign key (id_cliente_orcamento) references clientes(id_cliente)
);

insert into orcamento (Numero_os ,valor_orcamento, id_cliente_orcamento)values
						('1','200',1),
                        ('2','500',2),
                        ('3','500',3);

create table peca(
		id_peca int primary key auto_increment,
        descricao_peca varchar (255),
        valor_peca float,
        idOrcamento_peca int,
        constraint fk_peca_idOrcamento_peca foreign key (idOrcamento_peca) references orcamento(Id_orcamento)
);

insert into peca (descricao_peca,valor_peca,idOrcamento_peca) values
					('espelho lateral direito','50',1),
                    ('cabeçote do motor','300','2'),
                    ('farol esquerdo','270','3');
 
 -- ordena os clientes pelo nome
select * from clientes
order by nome_cliente;

-- status da ordem de serviço do cliente com o valor do serviço
select clientes.nome_cliente, orcamento.valor_orcamento, ordem_de_servico.status_os from clientes
inner join orcamento
on clientes.id_cliente = orcamento.id_cliente_orcamento
join ordem_de_servico
on ordem_de_servico.id_os = orcamento.id_cliente_orcamento;

-- tipo de serviço solicitado pelo cliente, com o nome do mecanico resposavel
select clientes.nome_cliente, ordem_de_servico.Descricao_serviço, equipe_de_mecanicos.nome_mecanico from clientes
inner join ordem_de_servico
on clientes.id_cliente = ordem_de_servico.idCliente_os
join equipe_de_mecanicos
on equipe_de_mecanicos.id_mecaninco = ordem_de_servico.idMecanico_os;

-- especialidadade de cada mecanico 
select equipe_de_mecanicos.nome_mecanico, equipe_de_mecanicos.especialidade_mecanica from  equipe_de_mecanicos;

-- valor de cada peça para cada solicitação do cliente 
select peca.descricao_peca, peca.valor_peca, orcamento.id_cliente_orcamento from orcamento
inner join peca
on orcamento.Id_orcamento = peca.idOrcamento_peca;