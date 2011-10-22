structure Cairo_Common =
struct

datatype font_slant
  = FONT_SLANT_NORMAL
  | FONT_SLANT_ITALIC
  | FONT_SLANT_OBLIQUE
    
datatype font_weight
  = FONT_WEIGHT_NORMAL
  | FONT_WEIGHT_BOLD

exception Invalid_font_slant
exception Invalid_font_weight

fun font_slant_to_int slant
  = Int32.fromInt
        (case slant
          of FONT_SLANT_NORMAL => 0
           | FONT_SLANT_OBLIQUE => 1
           | FONT_SLANT_ITALIC => 2)

fun int_to_font_slant i
  = (case Int32.toInt i
      of 0 => FONT_SLANT_NORMAL
       | 1 => FONT_SLANT_OBLIQUE
       | 2 => FONT_SLANT_ITALIC
       | _ => raise Invalid_font_slant)

fun font_weight_to_int weight
  = Int32.fromInt 
        (case weight
          of FONT_WEIGHT_NORMAL => 400
           | FONT_WEIGHT_BOLD   => 700)

fun int_to_font_weight i
  = (case Int32.toInt i
      of 400 => FONT_WEIGHT_NORMAL
       | 700 => FONT_WEIGHT_BOLD
       | _   => raise Invalid_font_weight)

end
