# Plurry Websocket Server

## Installation

### Development

```
$ git clone https://github.com/plurryinc/sinatra-server.git
$ cd sinatra-server
$ bundle install
$ rake db:setup
$ thin start
```

### Production

```
$ rake db:setup RACK_ENV=production
$ thin start -e production (-d for daemon mode)
```

## Console

```
$ gem install racksh
$ RACK_ENV={development|production} racksh
```
