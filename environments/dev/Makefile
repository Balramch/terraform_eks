# Run from this directory: make init, make plan, make apply
ENV  := dev
ROOT := ../..

.PHONY: init plan apply destroy validate fmt help

init plan apply destroy validate fmt help:
	@$(MAKE) -C $(ROOT) $@ ENV=$(ENV)
