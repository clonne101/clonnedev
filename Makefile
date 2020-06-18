## logs: Tail general logs for all running docker compose containers
logs:
	@echo "=============viewing all logs============="
	docker-compose logs -f

## down: Shutdown docker compose running containers
down:
	@echo "=============shutting down all running containers============="
	docker-compose down

## clean: Clean up after shutdown and remove all dummy images and volumes
clean:
	@echo "=============project cleaning up============="
	docker system prune -f
	docker volume prune -f

## run: Boot up docker compose containers in daemon mode
run:
	@echo "=============run docker compose============="
	docker-compose up -d

## run-dev: Boot up docker compose containers in developer mode
run-dev:
	@echo "=============run docker compose in developer mode============"
	docker-compose up

## run-build: Boot up docker compose containers and build
run-build:
	@echo "=============run docker compose and build============"
	docker-compose up --build

## script: Boot custom script which boots up standalone docker images
script:
	@echo "=============run custom script which boots up standalone docker images============"
	sudo chmod +x docker_run.sh && sudo bash docker_run.sh

## ssh-db-postgres: SSH into container for the db (postgres)
ssh-db-postgres:
	@echo "=============ssh into container for database(postgres)============"
	docker-compose exec db bash

## ssh-adminer: SSH into container for the adminer
ssh-adminer:
	@echo "=============ssh into container for adminer============"
	docker-compose exec adminer bash

## view: Show all running containers
view:
	@echo "=============view all running containers============"
	docker-compose ps

## help: Command to view help
help: Makefile
	@echo
	@echo "Choose a command to run in Clonnedev:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo
