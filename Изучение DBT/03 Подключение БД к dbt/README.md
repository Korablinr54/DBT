# Настройка подключения 
```sql
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
  