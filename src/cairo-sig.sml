signature CAIRO =
sig
    (**
     * Cairo surface type.
     *
     * Corresponds to cairo_surface_t.
     *)
    type surface

    (**
     * Cairo type.
     *
     * Corresponds to cairo_t.
     *)
    type canvas

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
     * Create a canvas from a surface.
     *)
    val create : surface -> canvas

    (* Consult Cairo docs for the following *)
    val set_source_rgb : canvas * real * real * real -> unit
    val fill : canvas -> unit
    val fill_preserve : canvas -> unit
    val set_line_width : canvas * real -> unit
    val stroke : canvas -> unit
    val move_to : canvas * real * real -> unit
    val line_to : canvas * real * real -> unit
    val curve_to : canvas * real * real * real * real * real * real -> unit
    val close_path : canvas -> unit
    val save : canvas -> unit
    val restore : canvas -> unit
    val show_page : canvas -> unit
    val surface_finish : surface -> unit
end
