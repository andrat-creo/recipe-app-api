CURR_PATH = $(shell pwd)
APP_DIR = $(shell echo "app")
APP_NAME = $(shell echo "recipe-app-api")
SERVICE_NAME = $(shell echo "app")

######### Development Environment #########
.PHONY: build-dev-env run-dev-env run-unit-tests run-ut-coverage-report run-ut-coverage-html down-dev-env

# Build dev instance on your local machine
build-dev-env:
	@docker-compose \
 		--file docker-compose.yml \
 		--project-name $(APP_NAME) \
 		build
	@echo "[DEV-INFO] DEV instances were successfully built!"

# Run DEV instance
run-dev-env:
	@docker-compose \
		--file docker-compose.yml run \
		--rm \
		--detach \
		--publish 8082:8000 \
		$(SERVICE_NAME)
	@echo "[DEV-INFO] DEV instances were successfully started!"

# Run DEV instance interactively
run-dev-env-it:
	@docker-compose \
		--file docker-compose.yml run \
		--rm \
		--publish 8082:8000 \
		$(SERVICE_NAME) \
		sh -c '/bin/sh'
	@docker-compose \
		--file docker-compose.yml \
 		down --remove-orphans
	@echo "[DEV-INFO] DEV instances were successfully started!"

# Run unit tests on DEV instance
run-unit-tests:
	@docker-compose \
		--file docker-compose.yml run \
		--rm \
		$(SERVICE_NAME) \
		sh -c "python manage.py wait_for_db && python manage.py test && flake8"
	@docker-compose \
		--file docker-compose.yml \
 		down --remove-orphans
	@echo "[DEV-INFO] Unit Tests on DEV instance(s) were successfully run!"

# Run unit tests with coverage report on DEV instance
run-ut-coverage-report:
	@docker-compose \
		--file docker-compose.yml run \
		--rm \
		$(SERVICE_NAME) \
		sh -c "python manage.py wait_for_db && coverage run --source='.' manage.py test && coverage report > .coverage.report && coverage erase && cat .coverage.report"
	@docker-compose \
		--file docker-compose.yml \
 		down --remove-orphans
	@echo "[DEV-INFO] Unit Tests on DEV instance(s) were successfully run! Coverage report in ./app/.coverage.report"

# Run unit tests with coverage html report on DEV instance
run-ut-coverage-html:
	@docker-compose \
		--file docker-compose.yml run \
		--rm \
		$(SERVICE_NAME) \
		sh -c "python manage.py wait_for_db && coverage run --source='.' manage.py test && coverage html && coverage erase"
	@docker-compose \
		--file docker-compose.yml \
 		down --remove-orphans
	@echo "[DEV-INFO] Unit Tests on DEV instance(s) were successfully run! HTML coverage report in ./app/htmlcov/index.html"

.PHONY:
down-dev-env:  ## Stop and clear DEV instance
	@docker-compose \
		--file docker-compose.yml \
 		down --remove-orphans
	@echo "[DEV-INFO] DEV instances were successfully stopped."
