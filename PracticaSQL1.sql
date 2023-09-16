-- Creamos el Esquema

create schema vehiculos;

-- A continuación creamos las tablas correspondientes a nuestro modelo de ER

create table vehiculos.vehiculo(
	matricula VARCHAR(7) primary key,
	color VARCHAR(25) not null,
	num_kms INT not null,
	fecha_compra DATE not null,
	num_poliza VARCHAR(20) not null,
	id_modelo INT not null,
	id_compania INT not null,
	id_revision INT not null
);

create table vehiculos.modelo(
	id_modelo serial primary key,
	nombre_modelo VARCHAR(100) not null,
	id_marca INT not null
);

create table vehiculos.marca(
	id_marca serial primary key,
	nombre_marca VARCHAR(100) not null,
	id_grupo INT not null
);

create table vehiculos.grupoempresarial(
	id_grupo serial primary key,
	nombre_grupo VARCHAR(150) not null
);

create table vehiculos.companiaseguros(
	id_compania serial primary key,
	nombre VARCHAR(100) not null
);

create table vehiculos.revision(
	id_revision serial primary key,
	km_revision INT not null,
	fecha_revision DATE not null,
	importe DECIMAL(10,2) not null,
	id_moneda INT not null
);

create table vehiculos.moneda(
	id_moneda serial primary key,∫
	nombre_moneda VARCHAR(20) not null,
	simbolo VARCHAR(5) not null
);

-- Una vez creadas las tablas, podemos proceder a crear las relaciones

alter table vehiculos.vehiculo  add constraint pk_modelo_vehiculo foreign key (id_modelo) references vehiculos.modelo(id_modelo);
alter table vehiculos.vehiculo add constraint pk_compania_seguro foreign key (id_compania) references vehiculos.companiaseguros(id_compania);
alter table vehiculos.vehiculo add constraint pk_revision_vehiculo foreign key (id_revision) references vehiculos.revision(id_revision);
alter table vehiculos.modelo add constraint pk_marca_modelo foreign key (id_marca) references vehiculos.marca(id_marca);
alter table vehiculos.marca add constraint pk_grupo_empresarial foreign key (id_grupo) references vehiculos.grupoempresarial(id_grupo);
alter table vehiculos.revision add constraint pk_tipo_moneda foreign key (id_moneda) references vehiculos.moneda(id_moneda);


-- Ahora, vamos a insertar datos

insert into vehiculos.grupoempresarial (nombre_grupo) values ('VAG'), ('Mercedes-Benz'), ('BMW'), ('Renault'), ('Nissan') , ('Ford');
insert into vehiculos.marca (nombre_marca, id_grupo) values ('Seat', '1'), ('Smart', '2'), ('Mini', '3'), ('Dacia', '4'), ('Infiniti', '5'), ('Ford', '6');
insert into vehiculos.modelo (nombre_modelo, id_marca) values ('Seat Ateca', '1'), ('Smart #1', '2'), ('Cooper D', '3'), ('Dacia Sandero', '4'), ('Infiniti Q30', '5'), ('Ford Fiesta', '6');
insert into vehiculos.companiaseguros (nombre) values ('mafre'), ('mutuaMadrileña'), ('alianz'), ('pelayo');
insert into vehiculos.moneda (nombre_moneda, simbolo) values ('euro', '€'), ('dolar', '$');
insert into vehiculos.revision (km_revision, fecha_revision, importe, id_moneda) values ('5000', '2020-07-14', '50.09', '1');
insert into vehiculos.vehiculo (matricula, color, num_kms, fecha_compra, num_poliza, id_modelo, id_compania, id_revision) values ('5665kpt', 'Amarillo', '10000', '2017-10-31', '546581', '1', '1', '1' );
insert into vehiculos.revision (km_revision, fecha_revision, importe, id_moneda) values ('2589', '2008-02-28', '60.19', '1');

-- Vamos a editar la tabla vehiculo para poder añadir el atributo activo y poder filtrar por coches activos o no activos
alter table vehiculos.vehiculo add column activo boolean default true;


select 
	m.nombre_modelo as "Nombre del modelo",
	ma.nombre_marca as "Nombre de marca",
	g.nombre_grupo as "Nombre del grupo",
	v.fecha_compra as "Fecha de compra",
	v.matricula as "Matricula",
	v.color as "Color del coche",
	v.num_kms as "Kilómetros totales del coche",
	c.nombre as "Compañia de seguros",
	v.num_poliza as "Número de Póliza"

from
	vehiculos.vehiculo v
join vehiculos.modelo m on v.id_modelo = m.id_modelo
join vehiculos.marca ma on m.id_marca = ma.id_marca 
join vehiculos.grupoempresarial g on ma.id_grupo = g.id_grupo 
join vehiculos.companiaseguros c on v.id_compania = c.id_compania
where v.activo = true
order by m.nombre_modelo, ma.nombre_marca, g.nombre_grupo;


-- Vamos a cambiar un vehiculo a no activo, para comprobar de nuevo si la consulta está bien.
update vehiculos.vehiculo set activo = false where matricula = '5665kpt';


-- Volvemos a hacer la consulta para ver si solo nos muestra el vehículo activo.

select 
	m.nombre_modelo as "Nombre del modelo",
	ma.nombre_marca as "Nombre de marca",
	g.nombre_grupo as "Nombre del grupo",
	v.fecha_compra as "Fecha de compra",
	v.matricula as "Matricula",
	v.color as "Color del coche",
	v.num_kms as "Kilómetros totales del coche",
	c.nombre as "Compañia de seguros",
	v.num_poliza as "Número de Póliza"

from
	vehiculos.vehiculo v
join vehiculos.modelo m on v.id_modelo = m.id_modelo
join vehiculos.marca ma on m.id_marca = ma.id_marca 
join vehiculos.grupoempresarial g on ma.id_grupo = g.id_grupo 
join vehiculos.companiaseguros c on v.id_compania = c.id_compania
where v.activo = true
order by m.nombre_modelo, ma.nombre_marca, g.nombre_grupo;









insert into vehiculos.vehiculo (matricula, color, num_kms, fecha_compra, num_poliza, id_modelo, id_compania, id_revision) values ('1020BMP', 'Blanco', '80000', '2004-05-21', '102059', '2', '3', '2' );