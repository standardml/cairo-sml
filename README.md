
Cairo bindings for Standard ML -- v0.0.1
---

Disclaimer: these bindings are under development and do not provide
a full or accurate mapping to the Cairo API.

These bindings provide access to the Cairo 2D graphics library.
The signature is fairly close to the C API of Cairo. However, the
underlying data representations are hidden. Thus manipulating data
must take place using utility functions such as `fold_path` etc.

Currently there is a MLton backend based on its FFI and an SML/NJ
backend based on NLFFI.

For more in-depth documentation of the various functions please
refer to the Cairo docs.


Compilation
---

For MLton compile with `make mlton`.

For SML/NJ compile with `make smlnj`.

For documentation install SMLDoc and then run `make doc`.


Test
---

For MLton compile with `make mlton`, cd to the test directory and run
the test executables.

For SML/NJ run `sml test/<test>.cm` and then at the prompt type:

    - Test.run ();


Gotchas
---

Lots of paths are hard-coded in the source. You might need to change
things in the make files and in `src/smlnj/cairo-smlnj.make` for
SML/NJ.
