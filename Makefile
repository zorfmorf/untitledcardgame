all: clean build

clean:
	@rm -rf build

build:
	@mkdir build
	@mkdir build/res
	@cp -r assets/* build/res/
	@cp -r src/* build/
	@cp -r lib/* build/
	@cd build; zip -r ucg.love *
