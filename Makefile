.PHONY: lint package
lint:
	helm lint ./helm/order-service
package:
	helm package ./helm/order-service -d dist/
