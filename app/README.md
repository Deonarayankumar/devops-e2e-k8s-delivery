```bash
docker build -t order-service:local .
docker run -p 8080:8080 order-service:local
curl localhost:8080/health
```
