### Docker для сборки debian-пакетов

## Запуск

Ввод команд выполняется из корня репозитория

```docker build -t debian-package -f docker/Dockerfile . && docker run --rm -v ./packages:/output debian-package```

Сформированный пакет apt располагается в packages/
