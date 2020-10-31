# distroless-slim-node
Isolated Node.js runtime Docker image

---

Built on Alpine Linux using musl.
Restricted to `/usr/bin/node` and its library dependencies.

## Benefits

* small image (70.8MB unpacked)

* reduced exposure (no other binaries, even shells)

## Caveats

* Alpine Linux uses musl instead of glibc. This may cause compatibility issues with other precompiled binaries.

* There are no shells. Commands must use _exec_ form (`ENTRYPOINT ["/usr/bin/node", "/path/to/myapp"]`), and CANNOT use _shell_ form (`ENTRYPOINT /usr/bin/node /path/to/myapp`).

* Node.js doesn't handle SIGINT nor SIGTERM. Make sure you enable `init`:
  * Docker CLI: [`docker run --init`](https://docs.docker.com/engine/reference/run/#specify-an-init-process)
  * Docker Compose: [`init: true`](https://docs.docker.com/compose/compose-file/#init)
  * Amazon ECS: [`initProcessEnabled`](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html)

## Example

`myapp.dockerfile`

```Dockerfile
# First stage: app builder, using npm or yarn
FROM node:15.0.1-alpine3.12 AS builder

USER node
RUN mkdir /home/node/myapp
WORKDIR /home/node/myapp

# Load app sources
COPY --chown=node:node ./ ./

# Build app
ENV NODE_ENV=production
RUN npm ci \
  # Run webpack, typescript, etc.
  && npm run build \
  # Remove devDependencies
  && npm prune

# Second stage: minimal production image, with only node and myapp
FROM coryshrmn/distroless-slim-node:15.0.1

WORKDIR /opt/myapp

# Load prebuilt app
COPY --from=builder --chown=root:root /home/node/myapp/ ./

# Load anything else required for your app / scripts
# COPY --from=builder /usr/bin/env /usr/bin/

USER node
ENV NODE_ENV=production
ENTRYPOINT ["/usr/bin/node", "."]
EXPOSE 3000
```

`.dockerignore`

```gitignore
# ignore everything
*
# allow source files
!package.json
!package-lock.json
!src
!tsconfig.json
```

Build and run

```bash
docker build --tag myapp:latest -f myapp.dockerfile .
docker run --init --rm myapp:latest
```

See [complete example](examples/myapp)

## Inspired by

* https://github.com/mhart/alpine-node

* https://github.com/GoogleContainerTools/distroless
