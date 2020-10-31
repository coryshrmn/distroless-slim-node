ARG NODE_VERSION=15.0.1
FROM mhart/alpine-node:slim-${NODE_VERSION} as builder
RUN adduser --uid 1000 \
  --disabled-password \
  --no-create-home \
  --shell /sbin/nologin \
  node
RUN mkdir -p /newroot/tmp \
  && chmod 1777 /newroot/tmp

FROM scratch
COPY --from=builder \
  /etc/alpine-release \
  /etc/group \
  /etc/passwd \
  /etc/
COPY --from=builder \
  /lib/ld-musl-x86_64.so.1 \
  /lib/
COPY --from=builder \
  /usr/lib/libgcc_s.so.1 \
  /usr/lib/libstdc++.so.6 \
  /usr/lib/
COPY --from=builder \
  /usr/bin/node \
  /usr/bin/
COPY --from=builder \
  /newroot/ \
  /
USER node
ENTRYPOINT ["/usr/bin/node"]
