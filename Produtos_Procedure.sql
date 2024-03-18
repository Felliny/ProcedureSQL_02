create database Produtos

use Produtos

create table produto (
	codigo			int				not null,
	nome			varchar(100)	not null,
	valor			decimal(7, 2)	not null
	primary key(codigo)
)
go
create table entrada(
	codigo			int				not null,
	codigo_produto	int				not null,
	quantidade		int				not null,
	valor_total		decimal(7, 2)	not null
	primary key (codigo)
	foreign key (codigo_produto) references produto(codigo)
)
go
create table saida(
	codigo			int				not null,
	codigo_produto	int				not null,
	quantidade		int				not null,
	valor_total		decimal(7, 2)	not null
	primary key (codigo)
	foreign key (codigo_produto) references produto(codigo)
)


insert into produto 
values (1, 'placa de video', 1300.20),
	   (2, 'HD', 500.00),
	   (3, 'mouse', 130.20)


create procedure sp_produtos (@opcao char(1), @codigo_tran int, @codigo_prod int, @quantidade int,
								@saida varchar(80) output)
as
	declare @query varchar(200),
			@tabela varchar(10),
			@erro	varchar(100),
			@valor decimal(7, 2)
	set @tabela = ''
	if (@opcao = 'e')
	begin
		set @tabela = 'entrada'
	end
	if (@opcao = 's')
	begin
		set @tabela = 'saida'
	end
	begin try
		select @valor = valor from produto where produto.codigo = @codigo_prod
		set @valor = @valor * @quantidade
		set @saida = 'Produto encontrado com sucesso'
	end try
	begin catch
		set @erro = ERROR_MESSAGE()
		if (@erro like '%primary%')
		begin
			set @erro = 'codigo do produto invalido'
		end
		else
		begin
			SET @erro = 'Erro na leitura de produto'
		END
		raiserror(@erro, 16, 1)
	end catch
		set @query = 'insert into ' + @tabela + ' values (' +
			cast(@codigo_tran as varchar(5))+ ',' + cast(@codigo_prod as varchar(5)) + ',' +
			cast(@quantidade as varchar(10)) + ',' +cast(@valor as varchar(30)) + ')'
	begin try
		exec (@query)
		set @saida = upper(@tabela) + ' inserido com sucesso'
	end try
	begin catch
		set @erro = ERROR_MESSAGE()
		if (@erro like '%primary%')
		begin
			set @erro = 'duplicado!'
		end
		else
		begin
			SET @erro = 'Opcao invalida'
		END
		raiserror(@erro, 16, 1)
	end catch
	

declare @saida1 varchar(80)
exec sp_produtos 's', 3, 1, 15, @saida1 output
print @saida1
