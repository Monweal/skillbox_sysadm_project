# Автоматизация разворачивания, настройки и эксплуатации инфраструры

![GitHub top language](https://img.shields.io/github/languages/top/Monweal/skillbox_sysadm_project)

## Требования к настраиваемым машинам

1. Дистрибутив Linux семейства Debian с установленным пакетным менеджером apt
2. Установленный и настроенный удаленный доступ, например, ssh

## Требования к машине для пересборки apt-пакетов (опционально)

1. Docker >= 20.10.0
2. Docker-compose >= 1.27.0

## Состав серверов проекта

1. Сервер удостоверяющего центра PKI
2. OpenVPN сервер
3. Prometheus сервер
4. Backup сервер

## Apt-пакеты

Собранные пакеты находятся в директории *packages/*

Если есть необходимость в пересборке пакетов, то можно использовать docker. Документацию по сборке можно получить по [этой ссылке](./docker/README.md).

### 1. Сервер удостоверяющего центра PKI

Для настройки требуется поместить пакеты <u>pki-server_0.1-1_all.deb</u> и <u>security-settings_0.1-1_all.deb</u>, а так же скрипт <u>set_pki_server.sh</u> на целевую машину.
*Пакеты и скрипт должны располагаться в одной директории!*

Пример команды для scp:

```scp {pki_server/set_pki_server.sh,packages/{pki-server,security-settings}_0.1-1_all.deb} 192.168.1.100:~```

Далее необходимо запустить скрипт <u>set_pki_server.sh</u>. Скрипт интерактивен, в нем потребуется выбирать настройки сервера.

```./set_pki_server.sh```

По окончанию выполнения скрипта, на вашем сервере будет настроен iptables для безопасного использования, а именно, запрещены все входящие соединения, кроме установленных и ssh. Так же будет добавлено правило для работы с prometheus-сервером.
Будет создан pki по пути *\~/easy-rsa/pki* и сгенерирован корневой сертификат (*\~/easy-rsa/pki/ca.crt*)

### 2. OpenVPN сервер

*Для настройки OpenVPN сервера требуется ssh-доступ к серверу удостоверяющего центра PKI (см. пункт 1)*
Необходимо поместить пакеты <u>openvpn-config_0.1-1_all.deb</u>, <u>pki-server_0.1-1_all.deb</u> и <u>security-settings_0.1-1_all.deb</u>, а так же скрипт <u>set_openvpn_server.sh</u> на целевую машину.

*Пакеты и скрипт должны располагаться в одной директории!*

Пример команды для scp:

```scp {ovpn_server/set_openvpn_server.sh,packages/{openvpn-config,pki-server,security-settings}_0.1-1_all.deb} 192.168.1.100:~```

Далее необходимо запустить скрипт <u>set_openvpn_server.sh</u>. Скрипт интерактивен и требует введения IP-адреса удостоверяющего центра.

```./set_openvpn_server.sh```

#### Необходимые для клиента файлы сервера

1. tls-ключ: ~/easy-rsa/ta.key
2. CA-сертификат: ~/easy-rsa/pki/ca.crt
3. Конфигурация OpenVPN-клиента: /etc/openvpn/server/base.conf
