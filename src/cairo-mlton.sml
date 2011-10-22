structure Cairo :> CAIRO =
struct

val run_time_version = _import "cairo_version" public: unit -> int;
fun run_time_version_string ()
    = let val f = _import "ml_cairo_version_string" public: unit -> CString.p;
      in CString.toString (CString.fromPointer (f ()))
      end

val compile_time_version = _import "ml_CAIRO_VERSION" public: unit -> int;
fun compile_time_version_string ()
    = let val f = _import "ml_CAIRO_VERSION_STRING" public: unit -> CString.p;
      in CString.toString (CString.fromPointer (f ()))
      end

val _ =
    (print ("run: " ^ Int.toString (run_time_version ()) ^ "\n");
     print ("run: " ^ run_time_version_string () ^ "\n");
     print ("comp: " ^ Int.toString (compile_time_version ()) ^ "\n");
     print ("comp: " ^ compile_time_version_string () ^ "\n"))

end
