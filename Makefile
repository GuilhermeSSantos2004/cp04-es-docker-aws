.PHONY: build run stop terraform-init terraform-validate plan deploy destroy

build:
	docker build -t cp04-site:local .

run:
	docker compose up --build -d

stop:
	docker compose down

terraform-init:
	terraform -chdir=terraform init

terraform-validate:
	terraform -chdir=terraform fmt -check -recursive
	terraform -chdir=terraform validate

plan:
	terraform -chdir=terraform plan -var-file=terraform.tfvars

deploy:
	terraform -chdir=terraform apply -var-file=terraform.tfvars

destroy:
	terraform -chdir=terraform destroy -var-file=terraform.tfvars
