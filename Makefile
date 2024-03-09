postgres:
	docker run --name postgres16 -p 5433:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:alpine

createdb:
	docker exec -it postgres16 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres16 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/simple_bank?sslmode=disable" -verbose up

migratedown: 
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

server:
	go run main.go

test:
	go test -v -cover ./...

mock:
	mockgen -package mockdb -destination db/mock/store.go example/simplebank/db/sqlc Store

.PHONY: createdb dropdb postgres migrateup migratedown sqlc test server mock