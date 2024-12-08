GO_MODULE := github.com/allapptest/grpctest

.PHONY: tidy
tidy:
	go mod tidy

.PHONY: clean
clean:
ifeq ($(OS), Windows_NT)
	if exist "protogen" rd /s /q protogen
	mkdir protogen\go
else
	rm -fR ./protogen 
	mkdir -p ./protogen/go
endif

.PHONY: protoc-go
protoc-go:
	protoc --go_opt=module=${GO_MODULE} --go_out=. \
	--go-grpc_opt=module=${GO_MODULE} --go-grpc_out=. \
	./proto/hello/*.proto ./proto/payment/*.proto ./proto/transaction/*.proto \

.PHONY: build
build: clean protoc-go



.PHONY: build
build: clean protoc-go tidy

.PHONY: run
run: 
	go run main.go

.PHONY: pipeline-init
pipeline-init:
	sudo apt-get install -y protobuf-compiler golang-goprotobuf-dev
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest


.PHONY: pipeline-build
pipeline-build: pipeline-init build