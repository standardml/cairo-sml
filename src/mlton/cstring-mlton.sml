structure Fail :> sig
        val outOfMemory: unit -> 'a
        val unsupportedSize: unit -> 'a
end = struct
        fun die message = (
                TextIO.output (
                        TextIO.stdErr
                        , message ^ "\n"
                ); OS.Process.exit OS.Process.failure
        )
        fun outOfMemory () = die "out of memory"
        fun unsupportedSize () = die "unsupported type size"
end
 
structure Malloc :> sig
        val f: int -> MLton.Pointer.t
end = struct
        val malloc32 = _import "malloc": Word32.word -> MLton.Pointer.t;
        val malloc64 = _import "malloc": Word64.word -> MLton.Pointer.t;
        val f = case MLton.Pointer.sizeofPointer of
                0w4 => malloc32 o Word32.fromInt
                | 0w8 => malloc64 o Word64.fromInt
                | _ => Fail.unsupportedSize ()
end
 
structure Strlen :> sig
        val f: MLton.Pointer.t -> int
end = struct
        val strlen32 = _import "strlen": MLton.Pointer.t -> Word32.word;
        val strlen64 = _import "strlen": MLton.Pointer.t -> Word64.word;
        val f = case MLton.Pointer.sizeofPointer of
                0w4 => Word32.toInt o strlen32
                | 0w8 => Word64.toInt o strlen64
                | _ => Fail.unsupportedSize ()
end

structure CString :> sig
    type p
    type t
    val app: (p -> 'a) -> t -> 'a
    val fromString: string -> t
    val fromPointer: p -> t
    val toString: t -> string
    val size: t -> int
    val sub: t * int -> char
end = struct
    type p = MLton.Pointer.t
    type t = p MLton.Finalizable.t
    fun app f t = MLton.Finalizable.withValue (t, f)
    fun fromPointer pointer = MLton.Finalizable.new pointer
    local
        val malloc = Malloc.f
        val free = _import "free": MLton.Pointer.t -> unit;
    in
        fun fromString string =
    	let val length = String.size string
    	    val pointer = malloc (length + 1)
    	    val () = if pointer = MLton.Pointer.null
                         then (TextIO.output (TextIO.stdErr, "out of memory\n");
                               OS.Process.exit OS.Process.failure)
                         else ()
    	    val t = MLton.Finalizable.new pointer
    	in
    	    MLton.Finalizable.addFinalizer (t, free);
                app (fn pointer =>
                        (CharVector.appi (fn (index, character) =>
    					 MLton.Pointer.setWord8
                                                 ( pointer
    				             , index
    				             , Byte.charToByte character
    					     ))
                                         string;
                         MLton.Pointer.setWord8 (pointer, length, 0w0)))
                    t;
                t
    	end
    end
    fun sub (t, index) =
    	app (fn pointer => Byte.byteToChar (MLton.Pointer.getWord8 (pointer, index))) t
    fun size t = app Strlen.f t
    fun toVector t = CharVector.tabulate (size t, fn index => sub (t, index))
    val toString = toVector
end
