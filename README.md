# Pebble

Aplicação para o teste final do Programa de Formação Elixir.

## Instalação
You will need to have docker, docker_compose, erlang and elixir installed in your machine.

* To start the postgres image, run: 

```sh
	docker_compose up -d
```

* Setup database migrations.

```sh
	mix setup
```

* Then, start the server by running: 

```sh
	mix phx.server
```

* To run unit testes

```sh
	mix test
```
