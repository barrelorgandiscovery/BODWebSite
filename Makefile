# Barrel Organ Discovery — Zola production build
# Output: public/  (upload to host so it is served at PROD_BASE_URL)
#
# Usage (from this directory):
#   make prod
#
# From repo root:
#   make prod
#
# Override the deploy base (must end with /):
#   make prod PROD_BASE_URL=https://www.barrel-organ-discovery.org/site/

ZOLA         ?= zola
MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ROOT         := $(patsubst %/,%,$(MAKEFILE_DIR))
PUBLIC       := $(ROOT)/public
SYNC_WIKI    := $(ROOT)/scripts/sync-wiki-static-assets.sh

# Published under /site/ on the main domain
PROD_BASE_URL ?= https://www.barrel-organ-discovery.org/site/

.PHONY: default help prod prod-build local clean serve sync-wiki

default: help

help:
	@echo "Barrel Organ Discovery (Zola)"
	@echo ""
	@echo "  make prod     Production build for $(PROD_BASE_URL) → $(PUBLIC)/"
	@echo "  make local    Build using base_url from config.toml (typically /)"
	@echo "  make clean    Remove $(PUBLIC)/"
	@echo "  make serve    Run zola serve (local preview)"
	@echo ""
	@echo "Override base URL: make prod PROD_BASE_URL=https://example.org/site/"

# Same as scripts/build-site-deploy.sh: sync wiki assets, then zola with --base-url
prod: prod-build

prod-build: sync-wiki
	@url="$(PROD_BASE_URL)"; \
	case "$$url" in */) ;; *) url="$$url/";; esac; \
	echo "Building with base_url=$$url"; \
	cd "$(ROOT)" && $(ZOLA) build --base-url "$$url"
	@echo "Output: $(PUBLIC)/"

local: sync-wiki
	cd "$(ROOT)" && $(ZOLA) build
	@echo "Output: $(PUBLIC)/"

sync-wiki:
	@if [ -x "$(SYNC_WIKI)" ]; then "$(SYNC_WIKI)"; fi

clean:
	rm -rf "$(PUBLIC)"

serve:
	cd "$(ROOT)" && $(ZOLA) serve
