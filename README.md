# podcast



~/my-function$ go get github.com/aws/aws-lambda-go/lambda
~/my-function$ GOOS=linux go build main.go

mkdir dist | zip dist/lambda.go.zip src/lambda.go

