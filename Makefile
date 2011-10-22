.PHONY: mlton doc clean test

mlton:
	mlton -link-opt -lcairo cairo-sml.mlb src/cairo-mlton.c
	make -C test $@

smlnj:
	sml cairo-sml.cm

test: mlton
	./cairo-sml && test -f test.pdf && echo -e "\nPDF successfully generated!"

doc:
	make -C doc $@

clean:
	rm -f cairo-sml
	rm -rf FFI
	rm -rf src/.cm
	make -C doc $@
	make -C test $@
