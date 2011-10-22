.PHONY mlton

mlton:
	mlton -link-opt -lcairo cairo-sml.mlb src/cairo-mlton.c
