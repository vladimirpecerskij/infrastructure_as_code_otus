# Проектная работа: Многосредовой инфраструктурный проект (Terraform + Ansible + CI/CD)

## 1. Описание и архитектура проекта

Проект реализует автоматизированное развёртывание и конфигурацию многоуровневого веб-приложения в облаке **Yandex Cloud** с поддержкой изолированных сред (**`stage`** и **`prod`**).

### Состав каждой среды (3 функциональных уровня)
1. **Frontend (`frontend-<env>`):** Виртуальная машина Ubuntu 22.04 с публичным IP-адресом и обратным прокси-сервером **Nginx** (порт `80`).
2. **Backend (`backend-<env>`):** Сервер приложений на базе **Python** (порт `8080`), принимающий запросы от Frontend внутри приватной подсети и взаимодействующий с БД.
3. **Database (`pg-<env>`):** Управляемый кластер **Managed PostgreSQL 15** с изолированной базой данных `appdb` и пользователем `appuser`.

```text
[ Интернет ] ──(HTTP:80)──► [ Frontend (Nginx) ] ──(HTTP:8080)──► [ Backend (Python API) ] ──(TCP:5432)──► [ Managed PostgreSQL ]
```

---

## 2. Структура репозитория

```text
final_project/
├── README.md                          # Документация проектной работы
├── modules/
│   └── three_tier_env/                # Переиспользуемый Terraform-модуль среды
│       ├── main.tf                    # VPC, подсеть, SG, Frontend ВМ, Backend ВМ, Managed PostgreSQL
│       ├── variables.tf               # Параметры среды (CIDR, CPU, RAM, пароль БД)
│       └── outputs.tf                 # Экспорт публичных/приватных IP и FQDN БД
├── environments/
│   ├── stage/main.tf                  # Среда тестирования (192.168.100.0/24, отдельный S3 tfstate)
│   └── prod/main.tf                   # Продакшн-среда (192.168.200.0/24, отдельный S3 tfstate)
├── tests/
│   └── infra.tftest.hcl               # Нативные модульные тесты Terraform
└── ansible/
    ├── ansible.cfg                    # Конфигурация Ansible
    ├── site.yml                       # Главный плейбук настройки слоёв
    └── roles/
        ├── frontend/tasks/main.yml    # Роль установки и настройки Nginx Reverse Proxy
        └── backend/tasks/main.yml     # Роль развёртывания Python-сервиса и systemd-юнита
```

---

## 3. Тестирование и CI/CD (`.github/workflows/final-project.yml`)

Пайплайн состоит из двух последовательных джоб:
1. **`test-iac` (Автоматическое тестирование кода):**
   * Выполняет нативные тесты `terraform test` для проверки корректности конфигурации модуля.
   * Выполняет синтаксическую проверку плейбуков `ansible-playbook --syntax-check`.
2. **`deploy-environment` (Управление средами `stage` и `prod`):**
   * Поддерживает ручной выбор среды (`stage` / `prod`) и действия (`plan` / `apply` / `destroy`) через `workflow_dispatch`.
   * После развёртывания инфраструктуры автоматически формирует динамический `inventory.ini` из `terraform output -json`, настраивает роли `backend` и `frontend` и выполняет сквозной **HTTP Smoke Test** (`curl http://<FRONTEND_IP>`).
