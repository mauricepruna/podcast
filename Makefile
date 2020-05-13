  
build:
	# mkdir build
	GOOS=linux GOARCH=amd64 go build -o build/app src/main.go
	# GOOS=linux GOARCH=amd64 go build -ldflags '-extldflags "-static"'-o build/app.go src/main.go
	# GOOS=linux GOARCH=amd64 go build -v -ldflags '-d -s -w' -a -o build/bin/app ./src/lambda.go

init:
	terraform init terraform/

plan:
	terraform plan terraform/

apply:
	terraform apply --auto-approve terraform/

destroy:
	terraform destroy --auto-approve terraform/

clean:
	rm -Rf ./build/