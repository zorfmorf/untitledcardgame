all: clean build

clean:
	@rm -rf build

build:
	@mkdir build
	@cp -r src/* build/
	@cp -r lib/* build/
	@cp -r assets/* build/res/
	@cd build; zip -r ucg.love *
