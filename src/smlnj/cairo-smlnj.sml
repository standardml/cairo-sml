structure Cairo : CAIRO =
struct

open Cairo_Common

type 'a ptr = ('a, C.rw) C.su_obj C.ptr'

type t = ST__cairo.tag ptr
type surface = ST__cairo_surface.tag ptr

val run_time_version = Int32.toInt o F_cairo_version.f
val run_time_version_string = ZString.toML o F_cairo_version_string.f

val compile_time_version = Int32.toInt o F_ml_CAIRO_VERSION.f
val compile_time_version_string = ZString.toML o F_ml_CAIRO_VERSION_STRING.f

(* FIXME: are we leaking memory with dupML' *)
fun surface_create_pdf (filename, width, height)
  = F_cairo_pdf_surface_create.f' (ZString.dupML' filename, width, height)

val create = F_cairo_create.f'
val fill = F_cairo_fill.f'
val set_source_rgb = F_cairo_set_source_rgb.f'
val show_page = F_cairo_show_page.f'
val surface_finish = F_cairo_surface_finish.f'
val fill_preserve = F_cairo_fill_preserve.f'
val set_line_width = F_cairo_set_line_width.f'
val stroke = F_cairo_stroke.f'
val move_to = F_cairo_move_to.f'
val line_to = F_cairo_line_to.f'
val curve_to = F_cairo_curve_to.f'
val close_path = F_cairo_close_path.f'
val save = F_cairo_save.f'
val restore = F_cairo_restore.f'

(* FIXME: memory leak? *)
fun select_font_face (ctx, font, slant, weight)
  = F_cairo_select_font_face.f'
        (ctx, ZString.dupML' font, font_slant_to_int slant, font_weight_to_int weight)

end
