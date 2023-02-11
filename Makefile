APP_FOLDER=--prefix application

prepare:
	npm install $(APP_FOLDER)
	npm run build $(APP_FOLDER)

install:
	npm install $(APP_FOLDER)

run:
	npm run dev $(APP_FOLDER)

test:
	npm run test $(APP_FOLDER)

build:
	npm run build $(APP_FOLDER)
