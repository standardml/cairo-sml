FILES = /usr/include/cairo/cairo.h /usr/include/cairo/cairo-pdf.h src/cairo-smlnj.h
H = LibH.libh
D = FFI
HF = ../src/cairo-smlnj-libh.sml
CF = cairo-sml.cm

$(D)/$(CF): $(D)/cairo.so $(FILES)
	$(SMLNJ_BINDIR)/ml-nlffigen -include $(HF) -libhandle $(H) -dir $(D) -cmfile $(CF) $(FILES)

$(D)/cairo-smlnj.o: src/cairo-smlnj.c
	mkdir -p $(D)
	cc -o $(D)/cairo-smlnj.o -c src/cairo-smlnj.c

$(D)/cairo.so: $(D)/cairo-smlnj.o
	ld -shared -o $(D)/cairo.so -lcairo $(D)/cairo-smlnj.o
