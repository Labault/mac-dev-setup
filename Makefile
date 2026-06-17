install:
	npm install

lint-commits:
	npx commitlint --from HEAD~1 --to HEAD --verbose

