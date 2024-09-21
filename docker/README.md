### Docker для сборки apt-пакетов

## Сборка всех пакетов

*Ввод команд выполняется из корня репозитория*

Для сборки всех apt-пакетов выполните следующую команду:

```docker compose --project-directory ./ -f docker/compose.yml --profile all up --build```

Сформированные пакеты располагаются в packages/

## Сборка одного пакета

Для сборки одного пакета, используется профили docker compose, например

```docker compose --project-directory ./ -f docker/compose.yml --profile security up --build```

### Список всех профилей
* all
* security
* pki
