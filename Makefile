all: clean build

clean:
	@rm -rf build

build:
	@mkdir build
	@mkdir build/img
	@cp -r assets/* build/img/
	@cp -r src/* build/
	@cp -r lib/* build/
	@cd build; zip -r ucg.love *
