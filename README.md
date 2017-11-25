Docker statsite
===

Dockerfile to build [statsite](https://github.com/statsite/statsite) as a docker container.

USAGE
===

## Build docker image from master

```
docker build --build-arg VERSION=master --no-cache -t statsite:latest .
```

## Build docker image from a tag

```
docker build --build-arg VERSION=v0.8.0 --no-cache -t statsite:latest .
```

## Starting statsite container

You require to have a statsite.conf file on your local FS and mount the directory as a volume on /etc/statsite so we can start statsite

```
docker run -i -v /etc/statsite:/etc/statsite -p 8125:8125 -p 8125:8125/udp statsite:latest
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
