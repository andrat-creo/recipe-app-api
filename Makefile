CURR_PATH := $(shell pwd)
APP_DIR = $(shell echo "app")
APP_NAME = $(shell echo "recipe-app-api")

.PHONY: prep-dev-env-win
prep-dev-env-win:  ## Prepares dev environment for windows os
	@powershell Set-ExecutionPolicy RemoteSigned && [Environment]::Is64BitProcess

.PHONY: build-dev-env
build-dev-env:  ## Build dev instance on your local machine
	@docker-compose \
 		--file docker-compose.yml \
 		--project-name $(APP_NAME) \
 		build
	@echo "[DEV-INFO] DEV instances were successfully built!"

.PHONY: run-dev-env
run-dev-env:  ## Run DEV instance
	@docker-compose \
		--file docker-compose.yml run \
		--publish 8000:8000 \
		--rm \
		--detach \
		app
	@echo "[DEV-INFO] DEV instances were successfully started!"

.PHONY: run-unit-tests
run-unit-tests:  ## Run unit tests on DEV instance
	@docker-compose \
		--file docker-compose.yml run \
		--rm \
		app \
		sh -c "python manage.py wait_for_db && python manage.py test && flake8"
	@docker-compose \
		--file docker-compose.yml \
 		down --remove-orphans
	@echo "[DEV-INFO] Unit Tests on DEV instance(s) were successfully run!"

.PHONY: run-ut-with-coverage
run-ut-with-coverage:  ## Run unit tests with coverage on DEV instance
	@docker-compose \
		--file docker-compose.yml run \
		--rm \
		app \
		sh -c "python manage.py wait_for_db && coverage run --source='.' manage.py test && coverage report > .coverage.report && coverage erase && cat .coverage.report"
	@docker-compose \
		--file docker-compose.yml \
 		down --remove-orphans
	@echo "[DEV-INFO] Unit Tests on DEV instance(s) were successfully run! Coverage report in ./app/.coverage.report"

.PHONY: down-dev-env
down-dev-env:  ## Stop and clear DEV instance
	@docker-compose \
		--file docker-compose.yml \
 		down --remove-orphans
	@echo "[DEV-INFO] DEV instances were successfully stopped."
