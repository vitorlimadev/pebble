# Pebble

A banking API for the final test of the Elixir's Formation Program at Stone.

## Instalation
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

## Testing

* To run unit testes

```sh
	mix test
```
