brew:
	brew bundle --file=brew/Brewfile

install:
	npm install

lint-commits:
	npx commitlint --from HEAD~1 --to HEAD --verbose

setup:
	bash scripts/setup.sh
