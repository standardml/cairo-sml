structure Cairo_Common =
struct

type point = real * real

datatype path
  = MOVE_TO of point
  | LINE_TO of point
  | CLOSE

datatype font_slant
  = FONT_SLANT_NORMAL
  | FONT_SLANT_ITALIC
  | FONT_SLANT_OBLIQUE
    
datatype font_weight
  = FONT_WEIGHT_NORMAL
  | FONT_WEIGHT_BOLD

type text_extents
  = { x_bearing : real,
      y_bearing : real,
      width     : real,
      height    : real,
      x_advance : real,
      y_advance : real }

end
