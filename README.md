# SeedKey DB Migrations

SeedKey DB Migrations is a repository with **Liquibase** migrations and is part of the Open Source **SeedKey** ecosystem.

## Table of Contents

- [🚀 Run](#-run)
- [🤝 Contributing](#-contributing)
- [🔧 Adding new migrations](#-adding-new-migrations)
- [🔌 CI/CD integration](#-cicd-integration)
- [🧩 Related repositories](#-related-repositories)
- [📄 License](#-license)

## 🚀 Run

```bash
# Apply migrations
docker compose run --rm liquibase update

# Roll back N steps
docker compose run --rm liquibase rollback-count 1
```

## 🤝 Contributing

If you have ideas and want to help the project, feel free to open an issue or a pull request.

## 🔧 Adding new migrations

Create an SQL file in the `liquibase/changelogs/<id>_v<version>/sql/` directory:

```sql
--liquibase formatted sql

--changeset author:<id>_<version>
--comment: Change description
CREATE TABLE example (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);

--rollback DROP TABLE IF EXISTS example;
```

### File naming convention

Follow the SQL file naming convention: `<FILE_ID>_<METHOD>_<ENTITY_NAME>.sql`

- **`FILE_ID`**: sequence number of the file in the migration.
- **`METHOD`**: `CREATE` / `UPDATE` / `DELETE` / `INSERT`.
- **`ENTITY_NAME`**: name of the entity (table/view) the changes apply to.

Example: `3_CREATE_table_name.sql`

Files in the `sql/` directory are automatically picked up via the `includeAll` XML tag.

### Versioning

When adding migrations, `tag` must match the current version of the **SeedKey** protocol.  
`id` is the sequential number of the changeset.

After finishing a version, add a tag in `changelog.xml`:

```xml
<changeSet author="name" id="2">
    <tagDatabase tag="v0.0.2" />
</changeSet>
```

## 🔌 CI/CD integration

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

## 🧩 Related Projects

Also check out other repositories in the ecosystem:
- [seedkey-browser-extension](https://github.com/mbessarab/seedkey-browser-extension) — browser extension.
- [seedkey-auth-service](https://github.com/mbessarab/seedkey-auth-service) — self-hosted authentication service.
- [seedkey-server-sdk](https://github.com/mbessarab/seedkey-server-sdk) — server-side library for implementing the service yourself.
- [seedkey-client-sdk](https://github.com/mbessarab/seedkey-client-sdk) — client library for working with the extension.
- [seedkey-auth-service-helm-chart](https://github.com/mbessarab/seedkey-auth-service-helm-chart) — Helm chart for deploying `seedkey-auth-service` + migrations.

## 📄 License

See `LICENSE`.
