.PHONY: mlton doc clean test

mlton:
	mlton -link-opt -lcairo cairo-sml.mlb src/cairo-mlton.c
	make -C test $@

test: mlton
	./cairo-sml && test -f test.pdf && echo -e "\nPDF successfully generated!"

doc:
	make -C doc $@

clean:
	rm -f cairo-sml
	make -C doc $@
	make -C test $@
