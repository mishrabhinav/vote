HEAD_REV=$(shell git rev-parse HEAD)

all: update build

setup:
	npm install -g pug-cli
	npm install

update:
	npm install
	npm update

build: build/index.html build/images build/css

build/index.html: index.pug
	pug $< -o ./build

build/images: images
	rsync -rupE $< build/

build/css: css
	rsync -rupE $< build/

deploy: build
	rm -rf build/.git
	git -C build init .
	git -C build fetch "git@github.com:mishrabhinav/vote.git" gh-pages
	git -C build reset --soft FETCH_HEAD
	git -C build add .
	if ! git -C build diff-index --quiet HEAD ; then \
		git -C build commit -m "Deploy mishrabhinav/vote@${HEAD_REV}" && \
		git -C build push "git@github.com:mishrabhinav/vote.git" master:gh-pages ; \
		fi
	cd ..

clean:
	rm -rf ./build
