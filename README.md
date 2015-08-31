# Plurry Websocket Server

## Installation

### Run on development

```
$ git clone https://github.com/plurryinc/sinatra-server.git
$ cd sinatra-server
$ bundle install
$ rake db:setup
$ thin start
```

### Run on production

```
$ rake db:setup RACK_ENV=production
$ thin start -e production (-d for daemon mode)
```

## Console

```
$ gem install racksh
$ RACK_ENV={development|production} racksh
```

## Deploy

- Deploy from master branch of Github

```
$ cap staging deploy
```

- DB migrate & seed & drop

```
$ cap staging deploy:db_migrate
$ cap staging deploy:db_seed
$ cap staging deploy:db_drop
```

## Thin server commands

- Start & Stop & Restart

```
$ cap staging deploy:start
$ cap staging deploy:stop
$ cap staging deploy:restart
```


## SSH key setting

```
eval 'ssh-agent'
ssh-add ~/.ssh/id_rsa
```
