SHELL=/bin/sh

.PHONY: help check test

help:
	@printf '%s\n' 'Targets:'
	@printf '%s\n' '  check  Validate the Milestone 1 controller and metadata files'
	@printf '%s\n' '  test   Alias for check'

check:
	@sh -n bin/compatbsd
	@./bin/compatbsd version >/dev/null
	@./bin/compatbsd help >/dev/null
	@grep -q '^id=ubuntu-24.04$$' runtimes/ubuntu-24.04/runtime.conf
	@grep -q '^id=spotify$$' applications/spotify/app.conf
	@printf '%s\n' 'Milestone 1 checks passed.'

test: check
