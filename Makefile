brew:
	PROFILE=full bash scripts/brew.sh

install:
	npm install

lint-commits:
	npx commitlint --from HEAD~1 --to HEAD --verbose

setup:
	bash scripts/cli.sh setup --profile=full

setup-dev:
	bash scripts/cli.sh setup --profile=minimal

dry-run:
	bash scripts/cli.sh setup --dry-run

completion:
	bash scripts/generate-zsh-completion.sh
