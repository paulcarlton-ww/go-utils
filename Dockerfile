
FROM pcarlton/go-builder:0.0.1 as builder

ARG VERSION
WORKDIR /go/src/github.com/paul-carlton/go-utils
COPY . .
RUN make build

ENV TAG=$TAG \
  GIT_SHA=$GIT_SHA \
  BUILD_DATE=$BUILD_DATE \
  SRC_REPO=$SRC_REPO

LABEL TAG=$TAG \
  GIT_SHA=$GIT_SHA \
  BUILD_DATE=$BUILD_DATE \
  SRC_REPO=$SRC_REPO
