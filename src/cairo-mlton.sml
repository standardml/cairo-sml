structure Cairo :> CAIRO =
struct

    type surface = MLton.Pointer.t
    type t = MLton.Pointer.t

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

val create = _import "cairo_create" public: surface -> t;
val set_source_rgb = _import "cairo_set_source_rgb" public: t * real * real * real -> unit;
val fill = _import "cairo_fill" public: t -> unit;
val fill_preserve = _import "cairo_fill_preserve" public: t -> unit;
val set_line_width = _import "cairo_set_line_width" public: t * real -> unit;
val stroke = _import "cairo_stroke" public: t -> unit;
val move_to = _import "cairo_move_to" public: t * real * real -> unit;
val line_to = _import "cairo_line_to" public: t * real * real -> unit;
val curve_to = _import "cairo_curve_to" public: t * real * real * real * real * real * real -> unit;
val close_path = _import "cairo_close_path" public: t -> unit;
val save = _import "cairo_save" public: t -> unit;
val restore = _import "cairo_restore" public: t -> unit;
val show_page = _import "cairo_show_page" public: t -> unit;
val surface_finish = _import "cairo_surface_finish" public: surface -> unit;

end
