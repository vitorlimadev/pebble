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

## Usage
---
### Create account
* POST http://localhost:4000/api/accounts

Body
```json
{
	"name": "Your name",
	"email": "youremail@outlook.com",
	"email_confirmation": "youremail@outlook.com",
	"password": "12345678",
	"cpf": "123.456.789-01"
}
```

Your initial balance is R$ 1000,00.

---
### Get account info
* GET http://localhost:4000/api/accounts/:id

---

### Delete an account
* DELETE http://localhost:4000/api/accounts/:id

---


### Make a transaction
* POST http://localhost:4000/api/transactions

*IMPORTANT*: R$ 1,00 is 100 on the value key. So if you want to send R$ 10,00, use value = 1000

Body
```json
{
	"value": 15000,
	"sender_id": "f6198ce2-1e2e-4031-92cf-be6f04d55374",
	"receiver_id": "5a50266f-3762-447a-b3cd-9f8e807a988a"
}
```
---

### Get a transaction info
* GET http://localhost:4000/api/transactions/:id

---

## Testing

* To run unit testes

```sh
	mix test --trace
```
