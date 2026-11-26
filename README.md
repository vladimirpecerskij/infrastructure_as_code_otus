# Infrastructure as Code (OTUS) — Практические работы и Проектный стенд

Репозиторий содержит выполненные лабораторные работы, практические примеры по инструментам автоматизации и итоговый проектный стенд по курсу **«Инфраструктура как код» (IaC)**.

---

## Оглавление репозитория

| Директория | Тема / Описание | Ключевые технологии |
| :--- | :--- | :--- |
| **[`final_project/`](./final_project)** | **Итоговая проектная работа:** многосредовой трёхзвенный проект (`stage` / `prod`) с функциональным разделением хостов (Frontend, Backend, Database), модульными тестами и CI/CD | Terraform Modules, `tftest`, Ansible Roles, S3 Remote State, GitHub Actions |
| **[`lab_6_gha/`](./lab_6_gha)** | **Инфраструктурный CI/CD пайплайн:** автоматизированное развёртывание и конфигурация кластера WordPress в облаке с хранением состояния в Object Storage | GitHub Actions, Terraform, Yandex Managed MySQL, NLB, Ansible |
| **[`lab_5/`](./lab_5)** | **Динамические инвентори и облачные плагины Ansible:** программный скрипт, парсер `terraform.tfstate` и кастомный плагин интеграции с API Yandex Cloud | Python, Ansible Inventory Plugins, Yandex Cloud SDK |
| **[`advanced_iac_topics/`](./advanced_iac_topics)** | **Расширенный стек IaC (Темы 16–26):** практические конфигурации и примеры по ключевым инструментам автоматизации | Jenkins, GitLab CI + Ansible Vault, ConcourseCI, SaltStack, Puppet + Hiera, MkDocs, Grafana, Pulumi, Flyway |

---

## Быстрый старт и проверка

1. **Проектная работа (`final_project`):**
   * Нативные тесты инфраструктуры: `terraform test` (проверка модулей `frontend`, `backend`, `pg-db`).
   * Автоматический линтинг ролей: `ansible-playbook site.yml --syntax-check`.
   * Управление средами через GitHub Actions (`workflow_dispatch`): выбор среды (`stage` / `prod`) и действия (`plan` / `apply` / `destroy`).
2. **Расширенные инструменты (`advanced_iac_topics`):**
   * **CI/CD:** `16_jenkins`, `17_gitlab_ansible_secrets`, `18_concourse_ci`.
   * **Configuration Management:** `20_saltstack`, `21_puppet`, `23_puppet_hiera`.
   * **Docs, Monitoring, Code & DB:** `22_docs_as_code`, `24_dashboards_as_code`, `25_pulumi_yc`, `26_db_migrations`.
