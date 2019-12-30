all: clean build

clean:
	@rm -Rf build

build:
	@mkdir build
	@cp -r src/* build/
	@cp -r lib/* build/
	@cd build; zip -r ucg.love *
