(**
 * Cairo bindings for Standard ML.
 * 
 * This provides a fairly one-to-one mapping between the Cairo C
 * library and Standard ML. This library is similar in structure to
 * cairo-ocaml. Currently there is a MLton and SML/NJ implementation.
 *
 * @see <a href="http://cairographics.org/">Cairo</a>
 * @see <a href="http://cairographics.org/cairo-ocaml/">cairo-ocaml</a>
 * @author Mathias Rav <rav@cs.au.dk>
 * @author Ian Zerny <ian@zerny.dk>
 * @version 0.0.1
 *)
signature CAIRO =
sig
    (**
     * Cairo type.
     *
     * Corresponds to cairo_t.
     *)
    type t

    (**
     * Cairo surface type.
     *
     * Corresponds to cairo_surface_t.
     *)
    type surface

    (**
     * Get the Cairo runtime version as an integer
     *)
    val run_time_version : unit -> int

    (**
     * Get the Cairo runtime version as a string
     *)
    val run_time_version_string : unit -> string

    (**
     * Get the Cairo compile time version as an integer
     *)
    val compile_time_version : unit -> int

    (**
     * Get the Cairo compile time version as a string
     *)
    val compile_time_version_string : unit -> string

    (**
     * Create a Cairo surface backed by PDF output to a file.
     *
     * @param filename Output PDF filename.
     * @param width_in_points Page width in points.
     * @param height_in_points Page height in points.
     *)
    val surface_create_pdf : string * real * real -> surface

    (**
     * Create a t from a surface.
     *)
    val create : surface -> t

    (* Consult Cairo docs for the following *)
    val set_source_rgb : t * real * real * real -> unit
    val fill : t -> unit
    val fill_preserve : t -> unit
    val set_line_width : t * real -> unit
    val stroke : t -> unit
    val move_to : t * real * real -> unit
    val line_to : t * real * real -> unit
    val curve_to : t * real * real * real * real * real * real -> unit
    val close_path : t -> unit
    val save : t -> unit
    val restore : t -> unit
    val show_page : t -> unit
    val surface_finish : surface -> unit

    datatype font_slant
      = FONT_SLANT_NORMAL
      | FONT_SLANT_ITALIC
      | FONT_SLANT_OBLIQUE

    datatype font_weight
      = FONT_WEIGHT_NORMAL
      | FONT_WEIGHT_BOLD

    val select_font_face : t * string * font_slant * font_weight -> unit

end
