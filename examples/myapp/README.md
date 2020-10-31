# myapp example
Build a minimal Node.js app Docker image

---

# Build Image

Package `myapp` into a local Docker image, tagged "latest".

```bash
docker build --tag myapp:latest .
```

# Run Container

Start a `myapp` container, bound to port 3333. Removed the container on exit.

```bash
docker run --init --rm --port 3000:3333 myapp:latest
```
