  
init.go:
	cd app;go mod init somosmastl.com/main

clean.go:
	rm app/app-lambda;rm app/go.mod;rm app/go.sum

build.go:
	cd app;GOOS=linux GOARCH=amd64 go build -o app-lambda
init:
	cd terraform;rm -rf .terraform;terraform init

plan:
	rm -rf build; mkdir build;cd terraform;terraform plan

apply:
	cd terraform;terraform apply --auto-approve

destroy:
	cd terraform;terraform destroy --auto-approve
