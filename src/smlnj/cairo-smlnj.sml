structure Cairo :> CAIRO =
struct

open Cairo_Common

type 'a ptr = ('a, C.rw) C.su_obj C.ptr'

type t = ST__cairo.tag ptr
type surface = ST__cairo_surface.tag ptr

type status = Int32.int

exception Internal_Error
exception Status_Exception of int

val status = F_cairo_status.f'

fun status_to_string status
    = ZString.toML' (F_cairo_status_to_string.f' status)

fun treat_status status
    = if status = E__cairo_status.e_CAIRO_STATUS_SUCCESS
      then ()
      else let val str = F_cairo_status_to_string.f' status
           in (* print ("Cairo error: " ^ ZString.toML' str); *)
              raise (Status_Exception (Int32.toInt status))
           end

fun check_status ctx
    = treat_status (status ctx)

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
val set_source_rgba = F_cairo_set_source_rgba.f'
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
val translate = F_cairo_translate.f'


fun font_slant_to_int slant
  = (case slant
      of FONT_SLANT_NORMAL  => E__cairo_font_slant.e_CAIRO_FONT_SLANT_NORMAL
       | FONT_SLANT_ITALIC  => E__cairo_font_slant.e_CAIRO_FONT_SLANT_ITALIC
       | FONT_SLANT_OBLIQUE => E__cairo_font_slant.e_CAIRO_FONT_SLANT_OBLIQUE)

fun font_weight_to_int weight
  = (case weight
      of FONT_WEIGHT_NORMAL => E__cairo_font_weight.e_CAIRO_FONT_WEIGHT_NORMAL
       | FONT_WEIGHT_BOLD   => E__cairo_font_weight.e_CAIRO_FONT_WEIGHT_BOLD)

fun select_font_face (ctx, font, slant, weight)
  = let val font' = ZString.dupML' font (* FIXME: memory leak? *)
        val slant' = font_slant_to_int slant
        val weight' = font_weight_to_int weight
    in F_cairo_select_font_face.f' (ctx, font', slant', weight');
       check_status ctx
    end

val set_font_size = F_cairo_set_font_size.f'

type path_ptr = S_cairo_path.tag ptr

fun move_to_point (ctx, (x, y)) = move_to (ctx, x, y)
fun line_to_point (ctx, (x, y)) = line_to (ctx, x, y)

val new_path = F_cairo_new_path.f'
fun text_path (ctx, txt)
    = let val txt' = ZString.dupML' txt (* FIXME: what about utf8? *)
      in F_cairo_text_path.f' (ctx, txt')
      end

fun internal_fold_path (cpath, curve, move, line, close, init)
  = let val enum = C.Get.enum'
        val sint = Int32.toInt o C.Get.sint'
        val dbl = C.Get.double'
        val dsub = C.Ptr.sub' U__cairo_path_data_t.size
        val cpath' = C.Ptr.|*! cpath
        val num = sint (S_cairo_path.f_num_data' cpath')
        fun go (i, acc)
          = if i < num
            then let val data = C.Get.ptr' (S_cairo_path.f_data' cpath')
                     val datai = dsub (data, i)
                     val head = U__cairo_path_data_t.f_header' datai
                     val typ = enum (S__cairo_path_data_t'0.f_type' head)
                     val len = sint (S__cairo_path_data_t'0.f_length' head)
                     val i' = i + len
                 in if typ = E__cairo_path_data_type.e_CAIRO_PATH_MOVE_TO
                    then let val point = U__cairo_path_data_t.f_point'
                                             (dsub (C.Ptr.|&! datai, 1))
                             val x = dbl (S__cairo_path_data_t'1.f_x' point)
                             val y = dbl (S__cairo_path_data_t'1.f_y' point)
                         in go (i', move (x, y, acc))
                         end
                    else if typ = E__cairo_path_data_type.e_CAIRO_PATH_LINE_TO
                    then let val point = U__cairo_path_data_t.f_point'
                                             (dsub (C.Ptr.|&! datai, 1))
                             val x = dbl (S__cairo_path_data_t'1.f_x' point)
                             val y = dbl (S__cairo_path_data_t'1.f_y' point)
                         in go (i', line (x, y, acc))
                         end
                    else if typ = E__cairo_path_data_type.e_CAIRO_PATH_CLOSE_PATH
                    then go (i', close acc)
                    else
                        (* Cairo allows user defined path data *)
                        (* We just skip over any such entries  *)
                        go (i', acc)
                 end
            else acc
    in treat_status (enum (S_cairo_path.f_status' cpath'));
       go (0, init) before F_cairo_path_destroy.f' cpath
    end

fun fold_path curve move line close init ctx
  = internal_fold_path (F_cairo_copy_path.f' ctx, curve, move, line, close, init)

fun fold_path_flat move line close init ctx
  = let fun curve _ = raise Internal_Error
    in internal_fold_path (F_cairo_copy_path_flat.f' ctx, curve, move, line, close, init)
    end


structure Pattern = struct
type t = ST__cairo_pattern.tag ptr
val create_radial = F_cairo_pattern_create_radial.f'
val create_linear = F_cairo_pattern_create_linear.f'
val add_color_stop_rgb = F_cairo_pattern_add_color_stop_rgb.f'
val add_color_stop_rgba = F_cairo_pattern_add_color_stop_rgba.f'
end

val set_source = F_cairo_set_source.f'

type text_extents
  = { x_bearing : real,
      y_bearing : real,
      width     : real,
      height    : real,
      x_advance : real,
      y_advance : real }

fun text_extents (ctx, txt)
  = let val txt' = ZString.dupML' txt (* FIXME: utf8? *)
        val ext = C.new' S_'cairo_text_extents_t.size
    in F_cairo_text_extents.f' (ctx, txt', C.Ptr.|&! ext);
       check_status ctx;
       { x_bearing = C.Get.double' (S_'cairo_text_extents_t.f_x_bearing' ext)
       , y_bearing = C.Get.double' (S_'cairo_text_extents_t.f_y_bearing' ext)
       , width     = C.Get.double' (S_'cairo_text_extents_t.f_width'     ext)
       , height    = C.Get.double' (S_'cairo_text_extents_t.f_height'    ext)
       , x_advance = C.Get.double' (S_'cairo_text_extents_t.f_x_advance' ext)
       , y_advance = C.Get.double' (S_'cairo_text_extents_t.f_y_advance' ext)
       }
       before C.discard' ext
    end

end
