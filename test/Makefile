TESTBASES=basket.mlb version.mlb
TESTS=$(TESTBASES:.mlb=)
mlton: $(TESTS)

$(TESTS):
	(echo ../cairo-sml.mlb; echo $@.sml) > $@.mlb
	mlton -link-opt -lcairo $@.mlb ../src/cairo-mlton.c

clean:
	rm -f $(TESTS) $(TESTBASES) basket.pdf
