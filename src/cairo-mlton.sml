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


fun surface_create_pdf (filename, width_in_points, height_in_points)
    = let val f = _import "cairo_pdf_surface_create" public: CString.p * real * real -> surface;
      in CString.app (fn p => (f (p, width_in_points, height_in_points))) (CString.fromString filename)
      end

val create = _import "cairo_create" public: surface -> canvas;
val set_source_rgb = _import "cairo_set_source_rgb" public: canvas * real * real * real -> unit;
val fill = _import "cairo_fill" public: canvas -> unit;
val fill_preserve = _import "cairo_fill_preserve" public: canvas -> unit;
val set_line_width = _import "cairo_set_line_width" public: canvas * real -> unit;
val stroke = _import "cairo_stroke" public: canvas -> unit;
val move_to = _import "cairo_move_to" public: canvas * real * real -> unit;
val line_to = _import "cairo_line_to" public: canvas * real * real -> unit;
val curve_to = _import "cairo_curve_to" public: canvas * real * real * real * real * real * real -> unit;
val close_path = _import "cairo_close_path" public: canvas -> unit;
val save = _import "cairo_save" public: canvas -> unit;
val restore = _import "cairo_restore" public: canvas -> unit;
val show_page = _import "cairo_show_page" public: canvas -> unit;
val surface_finish = _import "cairo_surface_finish" public: surface -> unit;

end
