ENV  := prod
ROOT := ../..

.PHONY: init plan apply destroy validate fmt help

init plan apply destroy validate fmt help:
	@$(MAKE) -C $(ROOT) $@ ENV=$(ENV)
