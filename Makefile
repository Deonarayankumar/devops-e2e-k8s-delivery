.PHONY: test lint helm
test:
	cd apps/backend && python -m pip install -q -r requirements-dev.txt && pytest -q
helm:
	helm lint charts/shop
	helm template shop charts/shop -f charts/shop/values-prod.yaml >/dev/null
