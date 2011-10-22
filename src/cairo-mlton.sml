structure Cairo :> CAIRO =
struct

    type surface = MLton.Pointer.t
    type canvas = MLton.Pointer.t

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


fun surface_create_pdf filename width_in_points height_in_points
    = let val f = _import "cairo_pdf_surface_create" public: CString.p * real * real -> surface;
      in CString.app (fn p => (f (p, width_in_points, height_in_points))) (CString.fromString filename)
      end

val create = _import "cairo_create" public: surface -> canvas;

val fill = _import "cairo_fill" public: canvas -> unit;

fun set_source_rgb canvas r g b
    = let val f = _import "cairo_set_source_rgb" public: canvas * real * real * real -> unit;
      in f (canvas, r, g, b)
      end

val show_page = _import "cairo_show_page" public: canvas -> unit;

val surface_finish = _import "cairo_surface_finish" public: surface -> unit;

val _ =
    (print ("run: " ^ Int.toString (run_time_version ()) ^ "\n");
     print ("run: " ^ run_time_version_string () ^ "\n");
     print ("comp: " ^ Int.toString (compile_time_version ()) ^ "\n");
     print ("comp: " ^ compile_time_version_string () ^ "\n");
     let val s = (surface_create_pdf "test.pdf" 72.0 72.0)
         val c = (create s) in
     (set_source_rgb c 0.5 0.5 0.5;
      fill c;
      show_page c;
      surface_finish s)
     end)

end
