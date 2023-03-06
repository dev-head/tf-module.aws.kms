init: config
	terraform init

init-upgrade:
	terraform init -upgrade=true

config:
	@if [[ ! -f local.ini ]]; then cp local.ini.dist local.ini; fi

plan: init
	terraform plan -var-file=local.ini

apply:
	terraform apply -var-file=local.ini

destroy-plan:
	terraform plan -destroy -var-file=local.ini

destroy:
	terraform destroy -var-file=local.ini
