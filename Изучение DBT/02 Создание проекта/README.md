# Создание проекта

1) Необходимо определить директорию нашего проекта. В нашем случае директорией проекта будет путь `D:\GIT\DBT`.  
```bash
# 1. Вы находитесь в PowerShell в каталоге 'D:\GIT\DBT\'
PS D:\GIT\DBT> pwd

Path      
----      
D:\GIT\DBT
```

2) Определяем репозиторий dbt проекта командой:  
```bash
# 1. Вы находитесь в PowerShell в каталоге 'D:\GIT\DBT\'
PS D:\GIT\DBT> 

# 2. Выполняется команда инициализации нового dbt-проекта с именем 'dbt_course_pratice'
dbt init dbt_course_pratice

# 3. Вывод: dbt сообщает, какая версия используется для выполнения команды (1.10.10)
16:12:24  Running with dbt=1.10.10

# 4. Подтверждение успешного создания проекта с указанным именем
Your new dbt project "dbt_course_pratice" was created!

# 5. Информационное сообщение с ссылкой на документацию по настройке профилей
For more information on how to configure the profiles.yml file,
please consult the dbt documentation here:

  https://docs.getdbt.com/docs/configure-your-profile

# 6. Приветственное сообщение от сообщества dbt с ссылками на каналы поддержки
One more thing:

Need help? Dont hesitate to reach out to us via GitHub issues or on Slack:

  https://community.getdbt.com/

Happy modeling!

# 7. Начало процесса настройки профиля для подключения к БД
16:12:24  Setting up your profile.

# 8. Запрос на выбор типа базы данных (в данном случае был только один вариант - postgres)
Which database would you like to use?
[1] postgres

# 9. Ссылка на документацию по другим доступным адаптерам (поддерживаемым БД)
(Dont see the one you want? https://docs.getdbt.com/docs/available-adapters)

# 10. Приглашение ввести номер выбранной БД (вы ввели 1 для postgres)
Enter a number: 1

# 11. Запрос на ввод hostname (вы указали localhost, так как БД запущена на вашей машине)
host (hostname for the instance): localhost

# 12. Запрос на ввод порта. В квадратных скобках указано значение по умолчанию (5432). Вы указали порт 4001.
port [5432]: 4001

# 13. Запрос на ввод имени пользователя для подключения к БД (вы указали 'postgres')
user (dev username): postgres

# 14. Запрос на ввод пароля. При вводе пароль не отображается на экране (вы ввели пароль и нажали Enter)
pass (dev password):

# 15. Запрос на ввод имени базы данных, в которой dbt будет создавать объекты (вы указали 'dwh_flights')
dbname (default database that dbt will build objects in): dwh_flights

# 16. Запрос на ввод схемы по умолчанию, в которой dbt будет создавать объекты (вы указали 'intermediate')
schema (default schema that dbt will build objects in): intermediate

# 17. Запрос на указание количества потоков (threads) для выполнения моделей. Вы указали 4, что позволит выполнять до 4 моделей параллельно.
threads (1 or more) [1]: 4

# 18. Подтверждение, что профиль с именем 'dbt_course_pratice' был записан в файл profiles.yml в вашей домашней директории.
#     Файл был создан на основе шаблона и предоставленных вами значений.
#     Команда также предлагает выполнить 'dbt debug' для проверки подключения к БД.
16:18:11  Profile dbt_course_pratice written to C:\Users\user\.dbt\profiles.yml using target's profile_template.yml and your supplied values. Run 'dbt debug\' to validate the connection.

# 19. Возврат в командную строку PowerShell, указывающий, что процесс завершен.
PS D:\GIT\DBT>
```

3) Проваерим, что все указали верно:  
```bash
# открываем для чтения профиль profiles.yml в вашей домашней директории.  
D:\GIT\DBT> cat ~/.dbt/profiles.yml  

dbt_course_pratice:    # Имя профиля (совпадает с именем проекта)
  outputs:
    dev:               # Цель (target) подключения с именем "dev" (разработка)
      type: postgres   # Тип базы данных: PostgreSQL
      host: localhost  # Сервер БД запущен на вашем локальном компьютере
      user: postgres   # Имя пользователя для подключения к БД
      port: 4001       # Порт, на котором слушает PostgreSQL (нестандартный, не 5432)
      dbname: dwh_flights     # Имя базы данных, к которой подключаться
      schema: intermediate    # Схема по умолчанию для создания моделей
      threads: 4              # Количество одновременных подключений к БД
  target: dev          # Какая цель подключения используется по умолчанию
```

4) Когда папка проекта создана пришло время познакомиться с ее содержимым:  
```bash
# 1. Команда смены текущей директории на папку проекта dbt_course_pratice
PS D:\GIT\DBT> cd dbt_course_pratice

# 2. Приглашение командной строки показывает, что теперь вы находитесь в папке проекта
PS D:\GIT\DBT\dbt_course_pratice>

# 3. Команда ls для просмотра содержимого текущей директории
PS D:\GIT\DBT\dbt_course_pratice> ls

# 4. Заголовок, показывающий путь к текущему каталогу
    Каталог: D:\GIT\DBT\dbt_course_pratice

# 5. Заголовки столбцов: Mode (права/тип), LastWriteTime (время изменения), Length (размер), Name (имя)
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----

# 6. Папка "analyses" - для хранения аналитических запросов, которые не являются моделями
d-----        01.09.2025     21:56                analyses

# 7. Папка "macros" - для макросов (повторно используемых SQL-фрагментов и функций на Jinja)
d-----        01.09.2025     21:56                macros

# 8. Папка "models" - ОСНОВНАЯ папка! Здесь вы будете создавать свои SQL-модели
d-----        01.09.2025     21:56                models

# 9. Папка "seeds" - для CSV-файлов с данными, которые можно загрузить в базу через dbt
d-----        01.09.2025     21:56                seeds

# 10. Папка "snapshots" - для реализации медленно меняющихся измерений (Type 2 SCD)
d-----        01.09.2025     21:56                snapshots

# 11. Папка "tests" - для кастомных тестов (помимо встроенных тестов dbt)
d-----        01.09.2025     21:56                tests

# 12. Файл ".gitignore" - указывает Git, какие файлы не нужно отслеживать (например, папка target/)
-a----        01.09.2025     21:56             29 .gitignore

# 13. Файл "dbt_project.yml" - ГЛАВНЫЙ конфигурационный файл вашего dbt-проекта
#     Здесь настраиваются пути, модели, переменные и многое другое
-a----        05.09.2025     23:12           1304 dbt_project.yml

# 14. Файл "README.md" - документация к вашему проекту в формате Markdown
-a----        01.09.2025     21:56            571 README.md
```