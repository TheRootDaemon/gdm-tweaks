.PHONY: build
build:
	nix build .#gdm-tweaks

.PHONY: check
check:
	nix flake check

.PHONY: fmt
fmt:
	alejandra --exclude ./lib/build.nix .

.PHONY: update
update:
	nix flake update

.PHONY: clean
clean:
	rm -rf result
