FROM postgres:17.2

COPY dump-dbt_course-202412081856.sql.tar /docker-entrypoint-initdb.d/dump-dbt_course-202412081856.sql.tar
RUN tar xzvf /docker-entrypoint-initdb.d/dump-dbt_course-202412081856.sql.tar -C /docker-entrypoint-initdb.d
RUN rm -rf /docker-entrypoint-initdb.d/dump-dbt_course-202412081856.sql.tar
EXPOSE 5432