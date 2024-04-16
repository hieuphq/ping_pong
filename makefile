.PHONY: build

build: build-ping build-pong

deploy:
	@echo "Deploying ping"
	cd ping && kubectl apply -f k8s
	@echo "Deploying pong"
	cd pong && kubectl apply -f k8s

deploy-down:
	@echo "Undeploying ping"
	cd ping && kubectl delete -f k8s
	@echo "Undeploying pong"
	cd pong && kubectl delete -f k8s

build-ping:
	@echo "Building ping"
	cd ping && make build

build-pong:
	@echo "Building pong"
	cd pong && make build