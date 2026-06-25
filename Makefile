.PHONY: brew install lint-commits setup setup-dev dry-run completion

brew:
	PROFILE=full bash scripts/brew.sh

install:
	npm install

lint-commits:
	bash scripts/lint-commit-msg.sh --range HEAD~1 HEAD

setup:
	bash scripts/cli.sh setup --profile=full

setup-dev:
	bash scripts/cli.sh setup --profile=minimal

dry-run:
	bash scripts/cli.sh setup --dry-run

completion:
	bash scripts/generate-zsh-completion.sh
