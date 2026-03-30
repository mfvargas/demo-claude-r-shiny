.PHONY: dev rebuild deploy

dev:
	docker compose up -d

rebuild:
	docker compose up --build -d

deploy:
	docker compose exec shiny-app Rscript /home/shiny/deploy.R
