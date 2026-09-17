# flake operations
.PHONY: build
build:
	nix build .#gdm-tweaks

.PHONY: check
check:
	nix flake check

.PHONY: test
test:
	nix run .#nix-unit -- ./tests/default.nix

.PHONY: update
update:
	nix flake update

# development utilities
.PHONY: clean
clean:
	rm -rf result

.PHONY: fmt
fmt:
	alejandra --exclude ./lib/build.nix .

