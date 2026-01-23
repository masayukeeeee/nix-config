.PHONY: install uninstall status status-body apply show-config configure cleanup-safety cleanup-all

# Repo root (directory containing this Makefile)
ROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

# Allow per-machine overrides (useful for people who clone this repo).
-include Makefile.local

# Colors (set NO_COLOR=1 to disable)
NO_COLOR ?= 0
ifeq ($(NO_COLOR),1)
	C_RESET :=
	C_BOLD :=
	C_DIM :=
	C_RED :=
	C_GREEN :=
	C_YELLOW :=
	C_BLUE :=
	C_CYAN :=
else
	C_RESET := \033[0m
	C_BOLD := \033[1m
	C_DIM := \033[2m
	C_RED := \033[31m
	C_GREEN := \033[32m
	C_YELLOW := \033[33m
	C_BLUE := \033[34m
	C_CYAN := \033[36m
endif

# Defaults (override via Makefile.local or command line).
FLAKE_DIR ?= $(ROOT_DIR)
# Do not auto-guess host for safety; require Makefile.local (or explicit override).
DARWIN_HOST ?=

# Require Makefile.local before applying (safer workflow).
REQUIRE_LOCAL ?= 1

# Nix command used for flake subcommands (works even if experimental features are not enabled globally).
# Avoid quoting here so it can be embedded safely in shell strings.
NIX_FLAKE ?= nix --extra-experimental-features nix-command --extra-experimental-features flakes

# Pager for long outputs (colors require -R). Set USE_PAGER=1 to enable.
PAGER ?= less -R
USE_PAGER ?= 0

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

# Status (scrollable wrapper; use `make status-body` for raw output)
status:
	@{ $(MAKE) --no-print-directory status-body; } | { \
		if [ "$(USE_PAGER)" = "1" ] && command -v less >/dev/null 2>&1 && [ -t 1 ]; then \
			$(PAGER); \
		else \
			cat; \
		fi; \
	}

# Status (informational; do not fail if some commands are missing)
status-body:
	@OK="$(C_GREEN)✔$(C_RESET)"; FAIL="$(C_RED)✘$(C_RESET)"; WARN="$(C_YELLOW)!$(C_RESET)"; ARROW="$(C_CYAN)➜$(C_RESET)"; \
	ACTUAL_HOST="$$(scutil --get ComputerName 2>/dev/null || hostname -s)"; \
	LOCAL_OK=0; [ -f "$(ROOT_DIR)/Makefile.local" ] && LOCAL_OK=1; \
	FLAKE_OK=0; [ -d "$(FLAKE_DIR)" ] && [ -f "$(FLAKE_DIR)/flake.nix" ] && FLAKE_OK=1; \
	HOST_OK=0; [ -n "$(DARWIN_HOST)" ] && [ -f "$(FLAKE_DIR)/hosts/$(DARWIN_HOST)/default.nix" ] && HOST_OK=1; \
	NIX_OK=0; command -v nix >/dev/null 2>&1 && NIX_OK=1; \
	INSTALLER_OK=0; [ -x /nix/nix-installer ] && INSTALLER_OK=1; \
	DAEMON_OK=0; pgrep -lf nix-daemon >/dev/null 2>&1 && DAEMON_OK=1; \
	INS_VER="$$(/nix/nix-installer --version 2>/dev/null || true)"; \
	NIX_VER="$$(nix --version 2>/dev/null || true)"; \
	DAEMON_LINE="$$(pgrep -lf nix-daemon 2>/dev/null | head -n 1 || true)"; \
	FLAKE_HOST_OK=0; \
	if [ $$NIX_OK -eq 1 ] && [ $$FLAKE_OK -eq 1 ]; then \
		OUT="$$(mktemp)"; ERR="$$(mktemp)"; \
		if (cd "$(FLAKE_DIR)" && $(NIX_FLAKE) eval ".#darwinConfigurations" --apply 'builtins.attrNames') >"$$OUT" 2>"$$ERR"; then \
			grep -Fq "\"$(DARWIN_HOST)\"" "$$OUT" && FLAKE_HOST_OK=1; \
		fi; \
		rm -f "$$OUT" "$$ERR"; \
	fi; \
	READY=1; \
	if [ "$(REQUIRE_LOCAL)" = "1" ] && [ $$LOCAL_OK -ne 1 ]; then READY=0; fi; \
	if [ $$FLAKE_OK -ne 1 ] || [ $$HOST_OK -ne 1 ] || [ $$NIX_OK -ne 1 ] || [ $$FLAKE_HOST_OK -ne 1 ]; then READY=0; fi; \
	\
	printf '%b\n' "$(C_BOLD)Status$(C_RESET)"; \
	if [ $$READY -eq 1 ]; then \
		printf '  %b  %b\n' "$$OK" "Ready to apply"; \
	else \
		printf '  %b  %b\n' "$$FAIL" "Not ready to apply"; \
		printf '  %b\n' "     $(C_DIM)Next: make configure && make status && make apply$(C_RESET)"; \
	fi; \
	\
	printf '\n%b\n' "$(C_BOLD)Config$(C_RESET)"; \
	printf '  %b  %-13s %b\n' "$$ARROW" "Flake Dir" "$(C_DIM)$(FLAKE_DIR)$(C_RESET)"; \
	printf '  %b  %-13s %b\n' "$$ARROW" "Target Host" "$(C_DIM)$${DARWIN_HOST:-<empty>}$(C_RESET)"; \
	if [ $$LOCAL_OK -eq 1 ]; then \
		printf '  %b  %b\n' "$$OK" "Local override (Makefile.local)"; \
	else \
		printf '  %b  %b\n' "$$FAIL" "Local override (Makefile.local) missing"; \
		printf '  %b\n' "     $(C_BOLD)RUN: make configure$(C_RESET)"; \
		printf '  %b\n' "     $(C_DIM)This is required for the safe workflow (install -> configure -> apply).$(C_RESET)"; \
	fi; \
	\
	printf '\n%b\n' "$(C_BOLD)Checks$(C_RESET)"; \
	if [ -z "$(DARWIN_HOST)" ]; then \
		printf '  %b  %b\n' "$$WARN" "Target host is not set"; \
	elif [ "$(DARWIN_HOST)" = "$$ACTUAL_HOST" ]; then \
		printf '  %b  %b\n' "$$OK" "Hostname matches target ($(DARWIN_HOST))"; \
	else \
		printf '  %b  %b\n' "$$WARN" "Hostname does not match target (actual=$$ACTUAL_HOST)"; \
	fi; \
	if [ $$FLAKE_OK -eq 1 ]; then \
		printf '  %b  %b\n' "$$OK" "Flake configuration found"; \
	else \
		printf '  %b  %b\n' "$$FAIL" "Flake configuration not found"; \
	fi; \
	if [ $$HOST_OK -eq 1 ]; then \
		printf '  %b  %b\n' "$$OK" "Host module defines '$(DARWIN_HOST)'"; \
	else \
		printf '  %b  %b\n' "$$FAIL" "Host module missing (hosts/$(DARWIN_HOST)/default.nix)"; \
	fi; \
	if [ $$FLAKE_HOST_OK -eq 1 ]; then \
		printf '  %b  %b\n' "$$OK" "darwinConfigurations includes '$(DARWIN_HOST)'"; \
	else \
		printf '  %b  %b\n' "$$WARN" "Cannot verify darwinConfigurations (nix eval failed or host missing)"; \
		printf '  %b\n' "     $(C_DIM)hint: (cd \"$(FLAKE_DIR)\" && $(NIX_FLAKE) eval \".#darwinConfigurations\" --apply 'builtins.attrNames')$(C_RESET)"; \
	fi; \
	if [ $$INSTALLER_OK -eq 1 ]; then \
		printf '  %b  %b %b\n' "$$OK" "Nix Installer is present" "$(C_DIM)($$INS_VER)$(C_RESET)"; \
	else \
		printf '  %b  %b\n' "$$WARN" "Nix Installer is not detected (/nix/nix-installer)"; \
	fi; \
	if [ $$NIX_OK -eq 1 ]; then \
		printf '  %b  %b %b\n' "$$OK" "Nix is available" "$(C_DIM)($$NIX_VER)$(C_RESET)"; \
	else \
		printf '  %b  %b\n' "$$FAIL" "Nix is not in PATH"; \
		printf '  %b\n' "     $(C_DIM)hint: . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh$(C_RESET)"; \
	fi; \
	if [ $$DAEMON_OK -eq 1 ]; then \
		printf '  %b  %b\n' "$$OK" "nix-daemon is running"; \
		printf '  %b\n' "     $(C_DIM)$$DAEMON_LINE$(C_RESET)"; \
	else \
		printf '  %b  %b\n' "$$WARN" "nix-daemon not detected"; \
	fi

# Apply nix-darwin configuration
apply:
	@if [ "$(REQUIRE_LOCAL)" = "1" ] && [ ! -f "$(ROOT_DIR)/Makefile.local" ]; then \
		printf '%b\n' "$(C_RED)ERROR$(C_RESET): Makefile.local is required before apply (safer workflow)"; \
		printf '%b\n' "  $(C_DIM)run: make configure$(C_RESET)"; \
		printf '%b\n' "  $(C_DIM)or:  make apply REQUIRE_LOCAL=0 DARWIN_HOST=<host>$(C_RESET)"; \
		exit 2; \
	fi
	@if [ ! -d "$(FLAKE_DIR)" ] || [ ! -f "$(FLAKE_DIR)/flake.nix" ]; then \
		printf '%b\n' "$(C_RED)ERROR$(C_RESET): FLAKE_DIR is invalid (flake.nix not found): $(FLAKE_DIR)"; \
		printf '%b\n' "  $(C_DIM)hint: make apply FLAKE_DIR=/path/to/flake$(C_RESET)"; \
		exit 2; \
	fi
	@if [ -z "$(DARWIN_HOST)" ]; then \
		ACTUAL_HOST="$$(scutil --get ComputerName 2>/dev/null || hostname -s)"; \
		printf '%b\n' "$(C_RED)ERROR$(C_RESET): DARWIN_HOST is empty"; \
		printf '%b\n' "  $(C_DIM)run: make configure$(C_RESET)"; \
		printf '%b\n' "  $(C_DIM)or:  make apply DARWIN_HOST=$$ACTUAL_HOST REQUIRE_LOCAL=0$(C_RESET)"; \
		exit 2; \
	fi
	@if [ ! -f "$(FLAKE_DIR)/hosts/$(DARWIN_HOST)/default.nix" ]; then \
		ACTUAL_HOST="$$(scutil --get ComputerName 2>/dev/null || hostname -s)"; \
		printf '%b\n' "$(C_RED)ERROR$(C_RESET): host module not found: $(FLAKE_DIR)/hosts/$(DARWIN_HOST)/default.nix"; \
		printf '%b\n' "  $(C_DIM)hint: ls \"$(FLAKE_DIR)/hosts\"$(C_RESET)"; \
		printf '%b\n' "  $(C_DIM)hint: make apply DARWIN_HOST=$$ACTUAL_HOST$(C_RESET)"; \
		printf '%b\n' "  $(C_DIM)hint: make configure DARWIN_HOST=$$ACTUAL_HOST$(C_RESET)"; \
		exit 2; \
	fi
	@if command -v nix >/dev/null 2>&1; then \
		if (cd "$(FLAKE_DIR)" && $(NIX_FLAKE) eval ".#darwinConfigurations" --apply 'builtins.attrNames') 2>/dev/null | grep -Fq "\"$(DARWIN_HOST)\""; then \
			:; \
		else \
			printf '%b\n' "$(C_RED)ERROR$(C_RESET): darwinConfigurations does not include $(DARWIN_HOST) (or evaluation failed)"; \
			printf '%b\n' "  $(C_DIM)hint: (cd \"$(FLAKE_DIR)\" && $(NIX_FLAKE) eval \".#darwinConfigurations\" --apply 'builtins.attrNames')$(C_RESET)"; \
			printf '%b\n' "  $(C_DIM)hint: $(NIX_FLAKE) flake show --show-trace -v \"$(FLAKE_DIR)\"$(C_RESET)"; \
			exit 2; \
		fi; \
	else \
		printf '%b\n' "$(C_RED)ERROR$(C_RESET): nix not found in PATH"; \
		exit 2; \
	fi
	sudo darwin-rebuild switch --flake $(FLAKE_DIR)#$(DARWIN_HOST)

show-config:
	@echo "== make config =="
	@echo "FLAKE_DIR=$(FLAKE_DIR)"
	@echo "DARWIN_HOST=$(DARWIN_HOST)"
	@echo "REQUIRE_LOCAL=$(REQUIRE_LOCAL)"
	@echo
	@echo "Override examples:"
	@echo "  make apply DARWIN_HOST=YourHost"
	@echo "  make apply FLAKE_DIR=/path/to/flake"
	@echo "  make configure DARWIN_HOST=YourHost"

configure:
	@echo "Writing Makefile.local (local overrides; not committed)"
	@{ \
	  echo "# Local overrides for this machine"; \
	  echo "FLAKE_DIR := $(FLAKE_DIR)"; \
	  echo "DARWIN_HOST := $$(scutil --get ComputerName 2>/dev/null || hostname -s)"; \
	} > Makefile.local
	@echo "Done. You can edit Makefile.local anytime."
	@echo
	@echo "== Makefile.local =="
	@cat Makefile.local

# Cleanup (safe): GC store paths without deleting generations
cleanup-safety:
	@echo "== cleanup (safe) =="
	@echo "Running: nix store gc"
	@nix store gc
	@echo "Running: nix store optimise"
	@nix store optimise || true

# Cleanup (all): delete old generations (aggressive)
cleanup-all:
	@echo "== cleanup (all) =="
	@echo "Running: nix-collect-garbage -d"
	@nix-collect-garbage -d
	@echo "Running: nix store optimise"
	@nix store optimise || true
