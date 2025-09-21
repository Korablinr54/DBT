# Настройка подключения 

Создаем виртуальную копию исходной базы данных `demo` внутри хранилища dwh_flight без копирования самих данных.  

1) Прямой доступ "как будто на месте" — сможем запрашивать таблицы из исходной БД `demo` прямо из своей БД `dwh_flight`.  

2) Без перемещения данных — данные физически остаются в исходной БД, но мы можем их читать и использовать.  

3) Для последующей обработки в `dbt` создается "сырой" слой (raw layer). DBT будет не из production-базы `demo` тянуть данные, а из этих виртуальных таблиц, что безопаснее и удобнее.  

```sql
SELECT * FROM pg_catalog.pg_available_extensions;

CREATE extension postgres_fdw;

  DROP SERVER IF EXISTS demo_pg cascade;
CREATE SERVER demo_pg foreign data wrapper postgres_fdw options (
	   host 'localhost',
	   dbname 'demo',
	   port '5432'
);

CREATE USER mapping FROM postgres server demo_pg options (
	   user 'postgres',
	   password 'mysecretpassword'
);

  DROP SCHEMA IF EXISTS demo_src;
CREATE SCHEMA demo_src authorization postgres;
import foreign SCHEMA bookings FROM server demo_pg INTO demo_src;
```

<br>
  
## 1) Просмотреть список доступных расширений в PostgreSQL
```sql
SELECT * FROM pg_catalog.pg_available_extensions;
```  
Чтобы убедиться, что необходимое расширение postgres_fdw присутствует в системе. Это предварительный шаг перед его установкой.

<br>
  
## 2) Активировать расширение postgres_fdw в текущей базе данных (dwh_flight)  
```sql
CREATE EXTENSION postgres_fdw;
```  
Это расширение позволяет PostgreSQL работать как клиент другого сервера PostgreSQL. Вы можете создавать "внешние таблицы" в своей БД, которые на самом деле являются ссылками на таблицы в другой, удаленной БД. Операции SELECT над этими внешними таблицами прозрачно выполняются на удаленном сервере.  

<br>
  
## 3) Создать новое определение внешнего сервера
```sql
  DROP SERVER IF EXISTS demo_pg cascade;
CREATE SERVER demo_pg foreign data wrapper postgres_fdw options (
	   host 'localhost',
	   dbname 'demo',
	   port '5432'
);
```  
Имя сервера (`demo_pg`), используемый враппер (`postgres_fdw`) и параметры подключения: хост, имя базы данных-источника (`demo`) и порт. Это просто "запись о том, как подключиться к другому серверу", без данных для аутентификации.  

<br>
  
## 4) Связать созданный внешний сервер с конкретными учетными данными
```sql
CREATE USER mapping FROM postgres server demo_pg options (
	   user 'postgres',
	   password 'mysecretpassword'
);
```  
Сервер (`demo_pg`) знает, куда подключаться, а сопоставление пользователей говорит ему, под каким логином и паролем это делать. Здесь указываются реальные учетные данные для подключения к исходной БД demo.

<br>
  
## 5) Создать отдельную схему в DWH `dwh_flight` для хранения всех внешних таблиц
```sql
  DROP SCHEMA IF EXISTS demo_src;
CREATE SCHEMA demo_src authorization postgres;
```
Позволяет изолировать внешние объекты от внутренних таблиц хранилища и делает структуру базы данных чище и понятнее.

<br>
  
## 6) Cоздать внешние таблицы в схеме `demo_src`
```sql
import foreign SCHEMA bookings FROM server demo_pg INTO demo_src;
```
PostgreSQL подключается к серверу `demo_pg`, читает метаинформацию (список таблиц, их столбцы, типы данных) из схемы `bookings` исходной базы `demo` и создает в вашей схеме `demo_src` одноименные внешние таблицы. Эти таблицы не содержат своих данных — они являются "окнами" в таблицы исходной БД.  

<br>
  
Это подготовительный этап инфраструктуры, который выполняется до запуска `dbt`. `dbt` не управляет расширениями, серверами или внешними таблицами. Его задача — преобразование данных.  