.SILENT :
.PHONY : docker-gen clean fmt

TAG:=`git describe --tags`
LDFLAGS:=-X main.buildVersion=$(TAG)

all: docker-gen

docker-gen:
	echo "Building docker-gen"
	go build -ldflags "$(LDFLAGS)" ./cmd/docker-gen

dist-clean:
	echo "cleaning things"
	rm -rf dist
	rm -f docker-gen-alpine-linux-*.tar.gz
	rm -f docker-gen-linux-*.tar.gz

dist: dist-clean
	echo "Dist alpine arm64"
	mkdir -p dist/alpine-linux/arm64 && GOOS=linux GOARCH=arm64 go build -ldflags "$(LDFLAGS)" -a -tags netgo -installsuffix netgo -o dist/alpine-linux/arm64/docker-gen ./cmd/docker-gen
	echo "Dist linux arm64"
	mkdir -p dist/linux/arm64 && GOOS=linux GOARCH=arm64 go build -ldflags "$(LDFLAGS)" -o dist/linux/arm64/docker-gen ./cmd/docker-gen


release: dist
	echo "Release alpine arm64"
	tar -cvzf docker-gen-alpine-linux-arm64-$(TAG).tar.gz -C dist/alpine-linux/arm64 docker-gen
	echo "Release linux arm64"
	tar -cvzf docker-gen-linux-arm64-$(TAG).tar.gz -C dist/linux/arm64 docker-gen

get-deps:
	echo "Install/Update glock"
	go get github.com/robfig/glock
	echo "Glock Sync"
	glock sync -n < GLOCKFILE

check-gofmt:
	if [ -n "$(shell gofmt -l .)" ]; then \
		echo 1>&2 'The following files need to be formatted:'; \
		gofmt -l .; \
		exit 1; \
	fi

test:
	go test
