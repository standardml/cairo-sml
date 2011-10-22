.PHONY: mlton smlnj doc clean test

mlton:
	mlton -link-opt -lcairo cairo-sml.mlb src/mlton/cairo-mlton.c
	make -C test $@

smlnj:
	sml cairo-sml.cm

test: mlton
	make -C test $@

doc:
	make -C doc $@

clean:
	rm -f cairo-sml
	rm -rf FFI
	rm -rf src/smlnj/.cm
	make -C doc $@
	make -C test $@
