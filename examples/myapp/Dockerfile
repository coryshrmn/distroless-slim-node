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
  # Compile typescript
  && npm run build \
  # Remove devDependencies
  && npm prune

# Second stage: minimal production image, with only node and myapp
FROM coryshrmn/distroless-slim-node:15.0.1

WORKDIR /opt/myapp

# Load prebuilt app
COPY --from=builder --chown=root:root /home/node/myapp/ ./

USER node
ENV NODE_ENV=production
ENTRYPOINT ["/usr/bin/node", "."]
EXPOSE 3000
