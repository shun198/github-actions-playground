ROOT_FOLDER=--prefix application

install:
	npm install $(ROOT_FOLDER)

run:
	npm run dev $(ROOT_FOLDER)

test:
	npm run test $(ROOT_FOLDER)
