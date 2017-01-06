all: plan

show:
	terraform show | grep module | sort

fmt:
	terraform fmt

get:
	terraform get

plan: fmt get
	terraform plan -var-file=${env}.tfvars -out proposed.plan

plan-destroy: fmt get
	terraform plan -destroy -var-file=${env}.tfvars

apply: plan
	terraform apply proposed.plan

destroy:
	terraform destroy -var-file=${env}.tfvars
