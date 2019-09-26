
include project-name.mk

# Makes a recipe passed to a single invocation of the shell.
.ONESHELL:

MAKE_SOURCES:=makefile.mk project-name.mk Makefile
PROJECT_SOURCES:=$(shell find ./pkg -regex '.*.\.\(go\|json\)$$')

BUILD_DIR:=build/
GOMOD_VENDOR_DIR:=vendor/
export VERSION?=latest

GO_CHECK_PACKAGES:=$(shell [ -d '${CURDIR}/pkg' ] && \
	find '${CURDIR}/pkg' \
	-type f -name '*.go' \
	-printf '%h\n' | sort --uniq)

ALL_SHELL_DIRS:=$(shell [ -d '${CURDIR}' ] && \
	find '${CURDIR}' \
	-type f -name '*.sh' \
	-a -not -path '${CURDIR}/vendor/*' \
	-a -not -path '${CURDIR}/cache/*' \
	-printf '%h\n' | sort --uniq)

BUILDER_ARTIFACT:=${BUILD_DIR}${PROJECT}-builder-${VERSION}-docker.tar

GOMOD_VENDOR_ARTIFACT:=${GOMOD_VENDOR_DIR}._gomod
GO_DOCS_ARTIFACTS:=$(shell echo $(subst $() $(),\\n,$(GO_CHECK_PACKAGES)) | \
	sed 's:\(.*[/\]\)\(.*\):\1\2/\2.md:')

YELLOW:=\033[0;33m
GREEN:=\033[0;32m
NC:=\033[0m

# Targets that do not represent filenames need to be registered as phony or
# Make won't always rebuild them.
.PHONY: all check build clean ci-check clean-godocs _godocs-build godocs \
	clean-gomod gomod gomod-update clean-${PROJECT}-check ${PROJECT}-check \
	clean-shellcheck shellcheck docker-builder
# Stop prints each line of the recipe.
.SILENT:

# Allow secondary expansion of explicit rules.
.SECONDEXPANSION: %.md  %-docker.tar

all: check docker-builder
check: shellcheck
build: gomod ${PROJECT}-check godocs
clean: clean-godocs clean-${PROJECT}-check clean-gomod clean-docker-builder \
    clean-shellcheck clean-${BUILD_DIR}


ci-check: all

clean-${BUILD_DIR}:
	rm -rf ${BUILD_DIR}

${BUILD_DIR}:
	mkdir -p $@


clean-godocs:
	rm -f ${GO_DOCS_ARTIFACTS}

godocs:
	$(MAKE) --no-print-directory _godocs-build
_godocs-build: ${GO_DOCS_ARTIFACTS}
%.md: $$(wildcard $$(dir $$@)*.go)
	echo "${YELLOW}Running godocdown: $@${NC}" && \
	godocdown -output $@ $(shell dirname $@)


clean-gomod:
	rm -rf ${GOMOD_VENDOR_DIR}

go.mod:
	rm -rf ${GOMOD_VENDOR_DIR} && \
	go mod tidy

gomod: go.sum
go.sum:  ${GOMOD_VENDOR_ARTIFACT}
%._gomod: go.mod
	rm -rf ${GOMOD_VENDOR_DIR} && \
	go mod vendor && \
	touch  ${GOMOD_VENDOR_ARTIFACT}

gomod-update: go.mod ${PROJECT_SOURCES}
	rm -rf ${GOMOD_VENDOR_DIR}  && \
	go build ./... && \
	go mod vendor  && \
	touch ${GOMOD_VENDOR_ARTIFACT}


clean-${PROJECT}-check:
	$(foreach target,${GO_CHECK_PACKAGES}, \
		$(MAKE) -C ${target} \
			--makefile=${CURDIR}/makefile.mk clean-coverage clean-lint || exit;)

${PROJECT}-check: go.sum
	$(foreach target,${GO_CHECK_PACKAGES}, \
		$(MAKE) -C ${target} \
			--makefile=${CURDIR}/makefile.mk lint coverage || exit;)


clean-shellcheck:
	$(foreach target,${ALL_SHELL_DIRS}, \
		$(MAKE) -C ${target} \
			--makefile=${CURDIR}/makefile.mk clean-docker-shellcheck || exit;)

shellcheck:
	$(foreach target,${ALL_SHELL_DIRS}, \
		$(MAKE) -C ${target} \
			--makefile=${CURDIR}/makefile.mk docker-shellcheck || exit;)


clean-docker-builder:
	rm -f ${BUILDER_ARTIFACT}

docker-builder: DOCKER_SOURCES=Dockerfile ${MAKE_SOURCES} ${PROJECT_SOURCES}
docker-builder: DOCKER_BUILD_OPTIONS=--target builder --build-arg VERSION
docker-builder: TAG=${ORG}/${PROJECT}-builder:${VERSION}
docker-builder: ${BUILD_DIR} ${BUILDER_ARTIFACT}


%-docker.tar: $${DOCKER_SOURCES}
	docker build --rm --pull=true \
		${DOCKER_BUILD_OPTIONS} \
		--build-arg http_proxy \
		--build-arg https_proxy \
		--build-arg no_proxy \
		--tag ${TAG} \
		--file $< \
		. && \
	docker save --output $@ ${TAG}
