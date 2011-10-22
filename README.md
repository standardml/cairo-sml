
Cairo bindings for Standard ML -- v0.0.1
---

This provides a fairly one-to-one mapping between the Cairo C
library and Standard ML. This library is similar in structure to
cairo-ocaml. Currently there is a MLton and SML/NJ implementation.


Compilation
---

For MLton compile with `make mlton`.

For SML/NJ compile with `make smlnj`.

For documentation install SMLDoc and then run `make doc`.


Gotchas
---

Lots of paths are hard-coded in the source. You might need to change
things in the make files and in `src/smlnj/cairo-smlnj.make` for
SML/NJ.
