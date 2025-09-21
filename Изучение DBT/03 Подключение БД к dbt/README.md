# Настройка подключения 
```sql
SELECT * FROM pg_catalog.pg_available_extensions;

CREATE extension postgres_fdw;

  DROP SERVER IF EXISTS demo_pg cascade;
CREATE SERVER demo_pg foreign data wrapper postgres_fdw options (
	   host 'localhost',
	   dbname 'demo',
	   port '5432'
);

CREATE USER mapping FRO postgres server demo_pg options (
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
  
