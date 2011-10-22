.PHONY: clean mlton

TESTBASES=basket.mlb version.mlb
TESTRUNS=$(TESTBASES:.mlb=.mlton.sml)
TESTS=$(TESTBASES:.mlb=)
mlton: $(TESTS)

$(TESTS):
	cp $@.sml $@.mlton.sml
	echo 'val () = Test.run ()' >> $@.mlton.sml
	(echo ../cairo-sml.mlb; echo $@.mlton.sml) > $@.mlb
	mlton -link-opt -lcairo $@.mlb ../src/mlton/cairo-mlton.c

clean:
	rm -f $(TESTS) $(TESTBASES) $(TESTRUNS) basket.pdf
	rm -rf .cm
