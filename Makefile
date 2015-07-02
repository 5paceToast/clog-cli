THIS_MAKEFILE_PATH:=$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
THIS_DIR:=$(shell cd $(dir $(THIS_MAKEFILE_PATH));pwd)

test:
	cargo test

build:
	cargo build

doc:
	cd "$(THIS_DIR)"
	cp src/lib.rs code.bak
	cat README.md | sed -e 's/^/\/\/! /g' > readme.bak
	sed -i '/\/\/ DOCS/r readme.bak' src/lib.rs
	sed -i '/```rust/```ignore/r readme.bak' src/lib.rs
	sed -i '/```toml/```ignore/r readme.bak' src/lib.rs
	sed -i '/```sh/```ignore/r readme.bak' src/lib.rs
	rm -rf docs/*
	(cargo doc --no-deps && make clean) || (make clean && false)

clean:
	cp -r target/doc/* docs/
	cd "$(THIS_DIR)"
	mv code.bak src/lib.rs || true
	rm *.bak || true
