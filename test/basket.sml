(* This file is derived from the cairo-ocaml project *)
(* and is free software, licensed under the terms of *)
(* the GNU Lesser General Public License version 2.1 *)
(* The file is Copyright © 2004-2005 Olivier Andrieu *)

val x_inches = 8.0
val y_inches = 3.0
val width_in_points  = x_inches * 72.0
val height_in_points = y_inches * 72.0

fun draw c =
  (Cairo.move_to (c, 50.0, 50.0) ;
  Cairo.line_to (c, 550.0, 50.0) ;
  Cairo.curve_to (c, 450.0, 240.0, 150.0, 240.0, 50.0, 50.0) ;
  Cairo.close_path c ;
  
  Cairo.save c ;
    Cairo.set_source_rgb (c, 0.8, 0.1, 0.1) ;
    Cairo.fill_preserve c ;
  Cairo.restore c ;

  Cairo.set_line_width (c, 6.0) ;
  Cairo.set_source_rgb (c, 0.0, 0.0, 0.0) ;
  Cairo.stroke c)

val _ =
    (let val s = (Cairo.surface_create_pdf ("basket.pdf", width_in_points, height_in_points))
         val c = (Cairo.create s) in
     (draw c;
      Cairo.show_page c;
      Cairo.surface_finish s)
    end)
