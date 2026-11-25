# Практические примеры по расширенным инструментам IaC (Темы 16–26)

В данном разделе собраны рабочие конфигурации и шаблоны по ключевым инструментам автоматизации инфраструктуры, CI/CD, управления конфигурациями и версионирования баз данных:

1. **16_jenkins:** Declarative `Jenkinsfile` с параметризованным запуском `Terraform` (`plan`, `apply`, `destroy`) и `Ansible`.
2. **17_gitlab_ansible_secrets:** Интеграция `Ansible Vault` в `.gitlab-ci.yml` с безопасной передачей пароля расшифровки через переменные CI/CD.
3. **18_concourse_ci:** Декларативный конвейер `pipeline.yml` для ConcourseCI с изолированными ресурсами и задачами.
4. **GitHub Actions (Тема 19):** Реализован в соседней директории [`../lab_6_gha`](../lab_6_gha) (полный цикл развёртывания WordPress с S3 Remote State).
5. **20_saltstack:** Управление конфигурациями на базе SaltStack (`top.sls` и state-файл `webserver.sls`).
6. **21_puppet:** Декларативный манифест Puppet (`site.pp`) для управления пакетами, файлами и службами.
7. **22_docs_as_code:** Подход Documentation as Code на базе `MkDocs` (`mkdocs.yml` + Markdown-документация).
8. **23_puppet_hiera:** Иерархическая система хранения конфигурационных данных `Hiera` (`hiera.yaml` + YAML-слои окружений).
9. **24_dashboards_as_code:** Автоматический провижининг дашбордов Grafana из Git-репозитория (`dashboards-provider.yml` + JSON).
10. **25_pulumi_yc:** Описание облачной сети и подсети в Yandex Cloud на языке программирования Python с помощью `Pulumi`.
11. **26_db_migrations:** Версионирование схемы базы данных в стиле Flyway (`V1__init_schema.sql`, `V2__seed_admin.sql`).
