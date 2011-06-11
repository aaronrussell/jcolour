###
jColour JavaScript library
A JavaScript colour manipulation library, inspired by the SASS/Compass colour functions

@version  0.1.0.beta1
@homepage http://github.com/aaronrussell/jcolour/
@author   Aaron Russell (http://www.aaronrussell.co.uk)

Copyright (c) 2010-2011 Aaron Russell (aaron@gc4.co.uk)
Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
###

class window.jColour
  
  constructor: (col) ->
    
    if hex = col.match /^#?([a-f0-9]{2}{3,4})$/i
      @red    = parseInt hex[1].substring(0,2), 16
      @green  = parseInt hex[1].substring(2,4), 16
      @blue   = parseInt hex[1].substring(4,6), 16
      @alpha  = if hex[1].substring(6,8) then parseInt(hex[1].substring(6,8), 16) / 255 else 1
      rgb_to_hsl this
    else if rgb = col.match /^rgba?\(\s*(\d+)[,\s]*(\d+)[,\s]*(\d+)[,\s]*([\.\d]+)?\s*\)$/i
      @red    = Math.min Math.max(rgb[1], 0), 255
      @green  = Math.min Math.max(rgb[2], 0), 255
      @blue   = Math.min Math.max(rgb[3], 0), 255
      @alpha  = if rgb[4] then Math.min(Math.max(rgb[4], 0), 1) else 1
      rgb_to_hsl this
    else if hsl = col.match /^hsla?\(\s*(\d+)[,\s]*(\d+)[,\s]*(\d+)[,\s]*([\.\d]+)?\s*\)$/i
      @hue        = Math.min Math.max(hsl[1], 0), 360
      @saturation = Math.min Math.max(hsl[2], 0), 100
      @lightness  = Math.min Math.max(hsl[3], 0), 100
      @alpha      = if hsl[4] then Math.min(Math.max(hsl[4], 0), 1) else 1
      hsl_to_rgb this
  
  hex: -> "##{hexify @red}#{hexify @green}#{hexify @blue}#{hexify @alpha * 255 unless @alpha == 1}"
  
  rgb: ->
    if @alpha == 1
      return "rgb(#{Math.round @red}, #{Math.round @green}, #{Math.round @blue})"
    else
      return "rgba(#{Math.round @red}, #{Math.round @green}, #{Math.round @blue}, #{@alpha.toPrecision 2})"
  
  hsl: ->
    if @alpha == 1
      return "hsl(#{Math.round @hue}, #{Math.round @saturation}, #{Math.round @lightness})"
    else
      return "hsla(#{Math.round @hue}, #{Math.round @saturation}, #{Math.round @lightness}, #{@alpha.toPrecision 2})"
  
  lighten: (pct) ->
    @lightness += (1 - @lightness) * (pct / 100.0)
    hsl_to_rgb this
  
  darken: (pct) ->
    @lightness *= 1.0 - (pct / 100.0)
    hsl_to_rgb this
  
  saturate: (pct) ->
    @saturation += (1 - @saturation) * (pct / 100.0)
    hsl_to_rgb this
  
  desaturate: (pct) ->
    @saturation *= 1.0 - (pct / 100.0)
    hsl_to_rgb this
  
  adjust_hue: (deg) ->
    @hue += deg
    hsl_to_rgb this
  
  opacify: (amt) ->
    @alpha += amt
    @alpha = Math.min Math.max(@alpha, 0), 1
  
  transparentize: (amt) ->
    @alpha -= amt
    @alpha = Math.min Math.max(@alpha, 0), 1
  
  greyscale: ->
    @saturation = 0
    hsl_to_rgb this
  
  complement: ->
    @hue += 180
    hsl_to_rgb this
  
    


###
The following methods are private helper methods
###
rgb_to_hsl = (c) ->
  r = c.red / 255
  g = c.green / 255
  b = c.blue / 255
  max = Math.max r, g, b
  min = Math.min r, g, b
  h = s = l = (max + min) / 2
  if max == min
    h = s = 0
  else
    d = max - min
    s = if l > 0.5 then d / (2 - max - min) else d / (max + min)
    switch max
      when r then h = (g - b) / d + (g < b ? 6 : 0)
      when g then h = (b - r) / d + 2
      when b then h = (r - g) / d + 4
    h /= 6
  c.hue         = h * 360
  c.saturation  = s * 100
  c.lightness   = l * 100
  c

hsl_to_rgb = (c) ->
  c.hue -= Math.floor(c.hue/360)*360 if c.hue > 360
  c.hue -= Math.ceil(c.hue/360)*360  if c.hue < 0
  h = c.hue / 360
  s = c.saturation / 100
  l = c.lightness / 100
  if s == 0
    r = g = b = l
  else
    q = if l < 0.5 then l * (1 + s) else l + s - l * s
    p = 2 * l - q
    r = hue_to_rgb p, q, h + 1/3
    g = hue_to_rgb p, q, h
    b = hue_to_rgb p, q, h - 1/3
  c.red   = r * 255
  c.green = g * 255
  c.blue  = b * 255
  c

hue_to_rgb = (p, q, t) ->
  t += 1 if t < 0
  t -= 1 if t > 1
  return p + (q - p) * 6 * t if t < 1/6
  return q if t < 1/2
  return p + (q - p) * (2/3 - t) * 6 if t < 2/3
  return p

hexify = (n = '00') ->
  n = parseInt n
  return '00' if n == 0 or isNaN n
  n = Math.max 0, n
  n = Math.min n, 255
  n = Math.round n
  "0123456789ABCDEF".charAt((n-n%16)/16) + "0123456789ABCDEF".charAt(n%16)
