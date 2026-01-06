# SeedKey DB Migrations

SeedKey DB Migrations — репозиторий с **Liquibase** миграциями, который является частью Open Source 
экосистемы **SeedKey**.   

## Содержание

- [🚀 Запуск](#-запуск)
- [🤝 Вклад](#-вклад)
- [🔧 Добавление новых миграций](#-добавление-новых-миграций)
- [🔌 Интеграция с CI/CD](#-интеграция-с-cicd)
- [🧩 Связанные репозитории](#-связанные-репозитории)
- [📄 Лицензия](#-лицензия)

## 🚀 Запуск

```bash
# Применить миграции
docker compose run --rm liquibase update

# Откатить на N шагов назад
docker compose run --rm liquibase rollback-count 1
```

## 🤝 Контрибьютинг   

Если у вас есть идеи и желание помочь проекту, смело открывайте issue или pull request.

## 🔧 Добавление новых миграций

Создайте SQL‑файл в директории `liquibase/changelogs/<id>_v<version>/sql/`:

```sql
--liquibase formatted sql

--changeset author:<id>_<version>
--comment: Описание изменения
CREATE TABLE example (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);

--rollback DROP TABLE IF EXISTS example;
```

### Соглашение об именовании файлов

Соблюдайте соглашение об именовании SQL‑файлов: `<FILE_ID>_<METHOD>_<ENTITY_NAME>.sql`

- **`FILE_ID`**: порядковый номер файла в миграции.
- **`METHOD`**: `CREATE` / `UPDATE` / `DELETE` / `INSERT`.
- **`ENTITY_NAME`**: имя сущности (таблицы/view), к которым применяются изменения.

Пример: `3_CREATE_table_name.sql`

Файлы в директории `sql/` подхватываются автоматически через XML‑тег `includeAll`.

### Версионирование 

При добавлении миграций `tag` должен соответствовать актуальной версии протокола **SeedKey**.  
`id` — последовательный номер changeset'а.

После завершения версии добавьте тег в `changelog.xml`:

```xml
<changeSet author="name" id="2">
    <tagDatabase tag="v0.0.2" />
</changeSet>
```

## 🔌 Интеграция с CI/CD

### Kubernetes Job

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: seedkey-migrations
spec:
  template:
    spec:
      containers:
        - name: liquibase
          image: mbessarab/seedkey-migrations:latest
          env:
            - name: LIQUIBASE_COMMAND_URL
              valueFrom:
                secretKeyRef:
                  name: db-credentials
                  key: url
            - name: LIQUIBASE_COMMAND_USERNAME
              valueFrom:
                secretKeyRef:
                  name: db-credentials
                  key: username
            - name: LIQUIBASE_COMMAND_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: db-credentials
                  key: password
      restartPolicy: Never
  backoffLimit: 3
```

### GitHub Actions

```yaml
- name: Run migrations
  run: |
    docker compose run --rm liquibase update
  env:
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
    DATABASE_USER: ${{ secrets.DATABASE_USER }}
    DATABASE_PASSWORD: ${{ secrets.DATABASE_PASSWORD }}
```

## 🧩 Связные проекты

Ознакомьтесь также с другими репозиториями экосистемы:
- [seedkey-browser-extension](https://github.com/mbessarab/seedkey-browser-extension) — браузерное расширение.
- [seedkey-auth-service](https://github.com/mbessarab/seedkey-auth-service) — self-hosted сервис аутентификации.
- [seedkey-server-sdk](https://github.com/mbessarab/seedkey-server-sdk) — серверная библиотека для самостоятельной реализации сервиса.
- [seedkey-client-sdk](https://github.com/mbessarab/seedkey-client-sdk) — клиентская библиотека для работы с расширением.
- [seedkey-auth-service-helm-chart](https://github.com/mbessarab/seedkey-auth-service-helm-chart) — Helm Chart для развёртывания `seedkey-auth-service` + миграций.

## 📄 Лицензия

См. `LICENSE`.
