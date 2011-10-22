.PHONY: mlton doc clean

mlton:
	mlton -link-opt -lcairo cairo-sml.mlb src/cairo-mlton.c

doc:
	make -C doc $@

clean:
	rm -f cairo-sml
	make -C doc $@
