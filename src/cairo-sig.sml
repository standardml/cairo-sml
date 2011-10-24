(**
 * Cairo bindings for Standard ML.
 *
 * Disclaimer: these bindings are under development and do not provide
 * a full or accurate mapping to the Cairo API.
 * 
 * These bindings provide access to the Cairo 2D graphics library.
 * The signature is fairly close to the C API of Cairo. However, the
 * underlying data representations are hidden. Thus manipulating data
 * must take place using utility functions such as `fold_path` etc.
 *
 * Currently there is a MLton backend based on its FFI and an SML/NJ
 * backend based on NLFFI.
 *
 * For more in-depth documentation of the various functions please
 * refer to the Cairo docs.
 *
 * @see <a href="http://cairographics.org/">Cairo</a>
 * @see <a href="http://cairographics.org/manual/">Cairo API Reference</a>
 * @author Mathias Rav <rav@cs.au.dk>
 * @author Ian Zerny <ian@zerny.dk>
 * @version 0.0.1
 *)
signature CAIRO =
sig
    (** Cairo context type (ie, cairo_t). *)
    type t

    (** Cairo surface type (ie, cairo_surface_t). *)
    type surface

    (** Status for error handling (ie, cairo_surface_t). *)
    type status

    (** A type alias for points in the plane. *)
    type point = real * real

    (** The Cairo version at runtime (format XYYZZ) *)
    val run_time_version : unit -> int

    (** The Cairo version at runtime (format X.YY.ZZ) *)
    val run_time_version_string : unit -> string

    (** The Cairo version at the time of compilation / binding generation *)
    val compile_time_version : unit -> int

    (** The Cairo version at the time of compilation / binding generation *)
    val compile_time_version_string : unit -> string

    (* Consult the Cairo docs for the following *)

    (* Error reporting  *)
    val status_to_string : status -> string

    (* Operations on contexts:
       http://cairographics.org/manual/cairo-cairo-t.html *)

    val create : surface -> t
    (*  reference *)
    (*  destroy *)
    val status : t -> status
    val save : t -> unit
    val restore : t -> unit
    (*  get_target *)
    (*  push_group *)
    (*  push_group_with_content *)
    (*  pop_group *)
    (*  pop_group_to_source *)
    (*  get_group_target *)
    val set_source_rgb : t * real * real * real -> unit
    val set_source_rgba : t * real * real * real * real -> unit
    (*  set_source *)
    (*  set_source_surface *)
    (*  get_source *)
    (*  ... *)
    val set_line_width : t * real -> unit
    (*  ... *)
    val fill : t -> unit
    val fill_preserve : t -> unit
    (*  fill_extents *)
    (*  ... *)
    val stroke : t -> unit
    (*  ... *)
    val show_page : t -> unit

    (* Operations on surfaces:
       http://cairographics.org/manual/cairo-cairo-surface-t.html *)

    (* val surface_status : surface -> status *)
    val surface_finish : surface -> unit


    (* Operations on paths:
       http://cairographics.org/manual/cairo-Paths.html *)

    (*  copy_path *)
    (*  copy_path_flat *)
    (*  ... *)
    val new_path : t -> unit
    (*  ... *)
    val close_path : t -> unit
    (*  ... *)
    val curve_to : t * real * real * real * real * real * real -> unit
    val line_to : t * real * real -> unit
    val line_to_point : t * point -> unit
    val move_to : t * real * real -> unit
    val move_to_point : t * point -> unit
    (*  ... *)
    val text_path : t * string -> unit
    (*  ... *)

    (* Path utilities *)

    (**
     * Fold a path.
     *
     * @param curve_to Curve to case
     * @param move_to  Move to case
     * @param line_to  Line to case
     * @param close    Close path case
     * @param init     Initial accumulator value
     * @param context  The context containing the path to fold
     *)
    val fold_path : (real * real * real * real * real * real * 'a -> 'a) ->
                    (real * real * 'a -> 'a) ->
                    (real * real * 'a -> 'a) ->
                    ('a -> 'a) ->
                    'a ->
                    t -> 'a

    (**
     * Fold a flat path (ie, one without curves).
     *
     * @param move_to Move to case
     * @param line_to Line to case
     * @param close   Close path case
     * @param init    Initial accumulator value
     * @param context The context containing the path to fold
     *)
    val fold_path_flat : (real * real * 'a -> 'a) ->
                         (real * real * 'a -> 'a) ->
                         ('a -> 'a) ->
                         'a ->
                         t -> 'a

    (* Transformations:
       http://cairographics.org/manual/cairo-Transformations.html *)
    val translate : t * real * real -> unit
    (*  scale *)
    (*  ... *)

    (* Font, text and patterns ... *)
    (* The structure of the following is pre-alpha... *)

    (** The font slant style. *)
    datatype font_slant
      = FONT_SLANT_NORMAL
      | FONT_SLANT_ITALIC
      | FONT_SLANT_OBLIQUE

    (** The font weight style. *)
    datatype font_weight
      = FONT_WEIGHT_NORMAL
      | FONT_WEIGHT_BOLD

    val select_font_face : t * string * font_slant * font_weight -> unit
    val set_font_size : t * real -> unit

    type text_extents
      = { x_bearing : real,
          y_bearing : real,
          width     : real,
          height    : real,
          x_advance : real,
          y_advance : real }
 
    val text_extents : t * string -> text_extents

    structure Pattern : sig
        type t
        val create_linear : real * real *        real * real        -> t
        val create_radial : real * real * real * real * real * real -> t
        val add_color_stop_rgb  : t * real * real * real * real        -> unit
        val add_color_stop_rgba : t * real * real * real * real * real -> unit
    end

    val set_source : t * Pattern.t -> unit

    (* PDF *)
    (**
     * Create a Cairo surface backed by PDF output to a file.
     *
     * @param filename Output PDF filename.
     * @param width_in_points Page width in points.
     * @param height_in_points Page height in points.
     *)
    val surface_create_pdf : string * real * real -> surface

end
