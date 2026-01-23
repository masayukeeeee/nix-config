.PHONY: install uninstall status apply show-config configure

# Allow per-machine overrides (useful for people who clone this repo).
-include Makefile.local

# Defaults (override via Makefile.local or command line).
FLAKE_DIR ?= $(CURDIR)
DARWIN_HOST ?= $(shell scutil --get ComputerName 2>/dev/null || hostname -s)

# Install Nix via Determinate Nix Installer
install:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
	@echo
	@echo "NOTE: If 'nix' is not in PATH yet, open a new shell or run:"
	@echo "  - . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
	@echo "  - . /nix/var/nix/profiles/default/etc/profile.d/nix.sh"
	@echo
	@echo "Check: make status"

# Uninstall Nix via Determinate Nix Installer
uninstall:
	@if [ -x /nix/nix-installer ]; then \
		sudo /nix/nix-installer uninstall; \
	else \
		echo "ERROR: /nix/nix-installer not found (Nix may not be installed via Determinate)"; \
		exit 1; \
	fi

# Status (informational; do not fail if some commands are missing)
status:
	@echo "== determinate nix-installer =="
	@if [ -x /nix/nix-installer ]; then \
		echo "/nix/nix-installer: present"; \
		(/nix/nix-installer --version 2>/dev/null || true); \
	else \
		echo "/nix/nix-installer: NOT found"; \
	fi
	@echo
	@echo "== nix =="
	@if command -v nix >/dev/null 2>&1; then \
		echo "nix: $$(command -v nix)"; \
		nix --version; \
		(nix store ping 2>/dev/null || true); \
	else \
		echo "nix: NOT found in PATH"; \
		if [ -x /nix/var/nix/profiles/default/bin/nix ]; then \
			echo "hint: /nix/var/nix/profiles/default/bin/nix exists (PATH may not be set yet)"; \
		fi; \
		if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then \
			echo "hint: . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"; \
		fi; \
		if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix.sh ]; then \
			echo "hint: . /nix/var/nix/profiles/default/etc/profile.d/nix.sh"; \
		fi; \
	fi
	@echo
	@echo "== launchd (nix-daemon) =="
	@((pgrep -lf nix-daemon 2>/dev/null || true) | sed 's/^/process: /')
	@((launchctl print system/org.nixos.nix-daemon >/dev/null 2>&1 && echo "launchd: org.nixos.nix-daemon (loaded)") || true)
	@((launchctl list 2>/dev/null | grep -E "(nix-daemon|determinate)" >/dev/null 2>&1 && echo "launchd: found nix-daemon/determinate in launchctl list") || \
	  echo "launchd: not detected (Determinate may use a different service label than org.nixos.nix-daemon)")

# Apply nix-darwin configuration
apply:
	sudo darwin-rebuild switch --flake $(FLAKE_DIR)#$(DARWIN_HOST)

show-config:
	@echo "== make config =="
	@echo "FLAKE_DIR=$(FLAKE_DIR)"
	@echo "DARWIN_HOST=$(DARWIN_HOST)"
	@echo
	@echo "Override examples:"
	@echo "  make apply DARWIN_HOST=YourHost"
	@echo "  make apply FLAKE_DIR=/path/to/flake"
	@echo "  make configure DARWIN_HOST=YourHost"

configure:
	@echo "Writing Makefile.local (local overrides; not committed)"
	@{ \
	  echo "# Local overrides for this machine"; \
	  echo "FLAKE_DIR ?= $(FLAKE_DIR)"; \
	  echo "DARWIN_HOST ?= $(DARWIN_HOST)"; \
	} > Makefile.local
	@echo "Done. You can edit Makefile.local anytime."
