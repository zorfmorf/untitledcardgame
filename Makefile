all: clean build

clean:
	@rm -rf build

build:
	@mkdir build
	@cp -r src/* build/
	@cp -r lib/* build/
	@cd build; zip -r ucg.love *
