module Rgb = {
  type t = (float, float, float)

  let fromInt = (~r, ~g, ~b): t => (r->Float.fromInt, g->Float.fromInt, b->Float.fromInt)

  let white = (255.0, 255.0, 255.0)
  let black = (0.0, 0.0, 0.0)
}

module SolidPaint: {
  type t
  let fromRgb: Rgb.t => t
} = {
  type rgbColor = {r: float, g: float, b: float}

  type t = {
    @as("type") _type: [#SOLID],
    color: rgbColor,
  }

  let fromRgb = ((r, g, b)) => {
    _type: #SOLID,
    color: {
      r: r /. 255.0,
      g: g /. 255.0,
      b: b /. 255.0,
    },
  }
}
