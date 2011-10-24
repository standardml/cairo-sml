(**************************************************************************)
(*  Transliterated from cairo-ocaml to SML.                               *)
(*                                                                        *)
(*  cairo-ocaml -- Objective Caml bindings for Cairo                      *)
(*  Copyright © 2004-2005 Olivier Andrieu                                 *)
(*                                                                        *)
(*  This code is free software and is licensed under the terms of the     *)
(*  GNU Lesser General Public License version 2.1 (the "LGPL").           *)
(**************************************************************************)

structure Test =
struct

local open Math in

val filename = "smack.pdf"
val fontname = "Sans"
val default_text = "SMACK"

val width = 384.0
val height = 256.0

val spikes = 10
val shadow_offset = 10.0

val x_fuzz = 16.0
val y_fuzz = 16.0

val x_outer_radius = width  / 2.0 - x_fuzz - shadow_offset
val y_outer_radius = height / 2.0 - y_fuzz - shadow_offset

val x_inner_radius = x_outer_radius * 0.7
val y_inner_radius = y_outer_radius * 0.7

val pi = 4.0 * atan 1.0

fun do_times n f
    = let fun go i
              = if i = n
                then ()
                else (f i; go (i+1))
      in go 0
      end

fun make_star_path cr
    = let val r = Random.rand (42, 1)
          fun rand up = up * Random.randReal r
      in do_times
           (spikes - 1)
           (fn i =>
               (let val x = width / 2.0 +
                            cos (pi * Real.fromInt (2 * i) / Real.fromInt spikes) *
                            x_inner_radius +
	                    rand x_fuzz
                    val y = height / 2.0 +
                            sin (pi * Real.fromInt (2 * i) / Real.fromInt spikes) *
                            y_inner_radius +
	                    rand y_fuzz
                in if i = 0
                   then Cairo.move_to (cr, x, y)
                   else Cairo.line_to (cr, x, y)
                end;
                let val x = width / 2.0 +
                            cos (pi * Real.fromInt (2 * i + 1) / Real.fromInt spikes) *
                            x_outer_radius +
	                    rand x_fuzz
                    val y = height / 2.0 +
                            sin (pi * Real.fromInt (2 * i + 1) / Real.fromInt spikes) *
                            y_outer_radius +
	                    rand y_fuzz
                in Cairo.line_to (cr, x, y)
                end));
         Cairo.close_path cr
      end

fun bend_it (x, y)
  = let val cx = width / 2.0
        val cy = 500.0
        val angle = pi / 2.0 - (x - cx) / width
        val t = 3.0 * pi / 4.0 - angle + 0.05
        val angle = 3.0 * pi / 4.0 - (pow (t, 1.8))
        val radius = cy - (height / 2.0 + (y - height / 2.0) * t * 2.0)
    in (cx + cos angle * radius, cy - sin angle * radius)
    end


fun make_text_path (cr, x, y, text)
  = (Cairo.move_to (cr, x, y);
     Cairo.text_path (cr, text);
     ignore 
         (Cairo.fold_path_flat
              (fn (x, y, first) =>
	          (if first then Cairo.new_path cr else ();
	           Cairo.move_to_point (cr, bend_it (x,y)); false))
              (fn (x, y, _) =>
	          (Cairo.line_to_point (cr, bend_it (x,y)); false))
	      (fn _ =>
	          (Cairo.close_path cr ; false))
              true cr))

fun draw text =
    let val surface = Cairo.surface_create_pdf ("smack.pdf", width, height)
        (* (Cairo.image_surface_create  *)
        (*    Cairo.FORMAT_ARGB32  *)
        (*    (int_of_float width) (int_of_float height)) *)
        val cr = Cairo.create surface
    in
        Cairo.set_line_width (cr, 2.0) ;

        Cairo.save cr ;
        Cairo.translate (cr, shadow_offset, shadow_offset) ;
        make_star_path cr ;
        Cairo.set_source_rgba (cr, 0.0, 0.0, 0.0, 0.5) ;
        Cairo.fill cr ;
        Cairo.restore cr ;

        make_star_path cr ;
        let val pattern = Cairo.Pattern.create_radial 
                              (width / 2.0, height / 2.0, 10.0,
                               width / 2.0, height / 2.0, 230.0)
        in
            Cairo.Pattern.add_color_stop_rgba (pattern, 0.0, 1.0, 1.0, 0.2, 1.0);
            Cairo.Pattern.add_color_stop_rgba (pattern, 1.0, 1.0, 0.0, 0.0, 1.0);
            Cairo.set_source (cr, pattern);
            Cairo.fill cr;

            make_star_path cr ;
            Cairo.set_source_rgb (cr, 0.0, 0.0, 0.0) ;
            Cairo.stroke cr ;

            Cairo.select_font_face (cr, fontname,
                                    Cairo.FONT_SLANT_NORMAL,
                                    Cairo.FONT_WEIGHT_BOLD) ;
            Cairo.set_font_size (cr, 50.0) ;
            let val extents = Cairo.text_extents (cr, text)
                val x = width / 2.0 - (#width extents / 2.0 +
                                       #x_bearing extents)
                val y = height / 2.0 - (#height extents / 2.0 +
                                        #y_bearing extents)
            in
                make_text_path (cr, x, y, text);
  
                let val pattern = Cairo.Pattern.create_linear 
                                      (width / 2.0 - 10.0, height / 4.0,
                                       width / 2.0 + 10.0, 3.0 * height / 4.0)
                in
                    Cairo.Pattern.add_color_stop_rgba (pattern, 0.0, 1.0, 1.0, 1.0, 1.0) ;
                    Cairo.Pattern.add_color_stop_rgba (pattern, 1.0, 0.0, 0.0, 0.4, 1.0) ;
                    Cairo.set_source (cr, pattern) ;
                    Cairo.fill cr ;

                    make_text_path (cr, x, y, text) ;
                    Cairo.set_source_rgb (cr, 0.0, 0.0, 0.0) ;
                    Cairo.stroke cr ;

                    (* Cairo_png.surface_write_to_file (Cairo.get_target cr, filename) *)
                    Cairo.show_page cr;
                    Cairo.surface_finish surface
                end
            end
        end
    end

fun run ()
  = draw default_text


end
end
