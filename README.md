# PROJECT README

## Требования :pizza:
* [git](https://git-scm.com/)
* [make (3.81 or late)](https://savannah.gnu.org/projects/make/)
* [mkcert (latest)](https://github.com/FiloSottile/mkcert)
* [docker (19.03.12 or late)](https://docs.docker.com/engine/install/ubuntu/)
* [docker-compose (1.26.0 or late)](https://docs.docker.com/compose/install/)

### Установка mkcert
_За дополнительной информацией в [репозиторий](https://github.com/FiloSottile/mkcert)_
#### Linux (Ubuntu)
```
> sudo apt install libnss3-tools -y
> wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64
> sudo cp mkcert-v1.4.3-linux-amd64 /usr/local/bin/mkcert
> sudo chmod +x /usr/local/bin/mkcert
```

#### macOS
```
> brew install mkcert
> brew install nss # if you use Firefox
```

#### Windows
Под Windows можно скачать [собранные бинарники](https://github.com/FiloSottile/mkcert/releases) либо воспользоваться одним из пакетных менеджеров: Chocolatey или Scoop.
```
> choco install mkcert
    -или-
> scoop install mkcert
```

## Установка :dancer:

### 1. Клонируем репозиторий
```bash
git clone ...
```

### 1.2 Подготавливаем данные
В корне проекта создаем `.env` файл пример которого можно посмотреть в `.env.example`
При необходимости можно изменить ${PROJECT_NAME}, ${HTTP_PORT} и ${HTTPS_PORT} по которым проект будет доступен в браузере, а так же ${DB_NAME}, ${DB_PORT}, ${DB_USER}, ${DB_PASSWORD} 
```bash
> cp .env.example .env
```

### 2. Собираем образы
_Данный шаг необходим только в случае первоначального запуска, либо при изменении Dockerfile`ов или .env файла
```bash
$PROJECT/make build
```
Эта команда создаст следующие образы (docker image):
+ ${PROJECT_NAME}/nginx
+ ${PROJECT_NAME}/ruby
+ ${PROJECT_NAME}/postgres

### 3 Запускаем контейнеры
```bash
$PROJECT/make start
```
Эта команда создаст и запустит следующие контейнеры:
+ ${PROJECT_NAME}-nginx
+ ${PROJECT_NAME}-ruby
+ ${PROJECT_NAME}-postgres

Также во время запуска будет создан и настроен ssl сертификат (необходим [mkcert](https://github.com/FiloSottile/mkcert))

```
Created a new certificate valid for the following names 📜
 - "${PROJECT_NAME}.localhost"

The certificate is at "./environment/ssl/dev-cert.pem" and the key at "./environment/ssl/dev-key.pem" ✅
```

### 4 Останавливаем контейнеры
```bash
$PROJECT/make stop
```
Рекомендую использовать именно команду, а не `CTRL+C` т.к. помимо остановки контейнеров происходит также удаление ресурсов (артефакты, сертификаты..еtс)

### 5 Остановить и удалить имеджи + volumes
```bash
$PROJECT/make drop
```

## Использование :gun:
По умолчанию команда `$PROJECT/make start` запускает контейнеры и
прокидывает порты на `${PROJECT_NAME}.localhost`:
* 443 + 80        (nginx)

##### SSL
Cоздание сертификатов происходит автоматически, при старте контейнера, удаление — при остановке.  
Для генерации ключей используется [mkcert](https://github.com/FiloSottile/mkcert),

`$PROJECT/environment/ssl`- директория с сертификатами.

##### Артефакты
READ-ONLY mode.  
Используются для шаринга данных (логов) контенейнера на хост машину.

`$PROJECT/environment/artifacts`- директория с артефактами.

##### Make
Чтобы увидеть список доступных команд, выполните `$PROJECT/make`.
