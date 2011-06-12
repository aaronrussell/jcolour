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
  
  ###
  Creates a new jColour object
  
  @constructor
  @this {jColour}
  @param {string} col The colour reference - either in hexidecimal format, rgb or hsl
  ###
  constructor: (col) ->
    
    if hex = col.match /^#?([a-f0-9]{6,8})$/i
      @red    = parseInt hex[1].substring(0,2), 16
      @green  = parseInt hex[1].substring(2,4), 16
      @blue   = parseInt hex[1].substring(4,6), 16
      @alpha  = if hex[1].substring(6,8) then parseInt(hex[1].substring(6,8), 16) / 255 else 1
      rgb_to_hsl this
    else if rgb = col.match /^rgba?\(\s*(\d+)[,\s]*(\d+)[,\s]*(\d+)[,\s]*([\.\d]+)?\s*\)$/i
      @red    = rgb[1]
      @green  = rgb[2]
      @blue   = rgb[3]
      @alpha  = if rgb[4] then rgb[4] else 1
      rgb_to_hsl this
    else if hsl = col.match /^hsla?\(\s*(\d+)[,\s]*(\d+)[,\s]*(\d+)[,\s]*([\.\d]+)?\s*\)$/i
      @hue        = hsl[1]
      @saturation = hsl[2]
      @lightness  = hsl[3]
      @alpha      = if hsl[4] then hsl[4] else 1
      hsl_to_rgb this
  
  
  ###
  Returns the hexidecimal value of the colour
  
  @return {string} Hexidecimal value of colour
  ###
  hex: ->
    if @alpha == 1
      "##{hexify @red}#{hexify @green}#{hexify @blue}"
    else
      "##{hexify @red}#{hexify @green}#{hexify @blue}#{hexify @alpha * 255}"
  
  
  ###
  Returns the RGB value of the colour
  
  @return {string} RGB value of colour
  ###
  rgb: ->
    if @alpha == 1
      return "rgb(#{Math.round @red}, #{Math.round @green}, #{Math.round @blue})"
    else
      return "rgba(#{Math.round @red}, #{Math.round @green}, #{Math.round @blue}, #{@alpha.toPrecision 2})"
  
  
  ###
  Returns the HSL value of the colour
  
  @return {string}
  ###
  hsl: ->
    if @alpha == 1
      return "hsl(#{Math.round @hue}, #{Math.round @saturation}, #{Math.round @lightness})"
    else
      return "hsla(#{Math.round @hue}, #{Math.round @saturation}, #{Math.round @lightness}, #{@alpha.toPrecision 2})"
  
  
  ###
  Makes the colour lighter by an absolute amount
  Takes an amount between 0 and 100 and returns the new colour
  
  @param {number} amount
  @return {jColour}
  ###
  lighten: (amount) ->
    @lightness += amount
    hsl_to_rgb this
  
  
  ###
  Makes the colour lighter by a percentage of it's current lightness
  Takes an amount between 0 and 100 and returns the new colour
  
  @param {number} percent
  @return {jColour}
  ###
  lighten_percent: (percent) ->
    @lightness += (@lightness / 100) * percent
    hsl_to_rgb this
  
  
  ###
  Makes the colour darker by an absolute amount
  Takes an amount between 0 and 100 and returns the new colour
  
  @param {number} amount
  @return {jColour}
  ###
  darken: (amount) ->
    @lightness -= amount
    hsl_to_rgb this
  
  
  ###
  Makes the colour darker by a percentage of it's current lightness
  Takes an amount between 0 and 100 and returns the new colour
  
  @param {number} percent
  @return {jColour}
  ###
  darken_percent: (percent) ->
    @lightness -= (@lightness / 100) * percent
    hsl_to_rgb this
  
  
  ###
  Makes the colour more saturated by an absolute amount
  Takes an amount between 0 and 100 and returns the new colour
  
  @param {number} amount
  @return {jColour}
  ###
  saturate: (amount) ->
    @saturation += amount
    hsl_to_rgb this
  
  
  ###
  Makes the colour more saturated by a percentage of it's current saturation
  Takes an amount between 0 and 100 and returns the new colour
  
  @param {number} percent
  @return {jColour}
  ###
  saturate_percent: (percent) ->
    @saturation += (@saturation / 100) * percent
    hsl_to_rgb this
  
  
  ###
  Makes the colour less saturated by an absolute amount
  Takes an amount between 0 and 100 and returns the new colour
  
  @param {number} amount
  @return {jColour}
  ###
  desaturate: (amount) ->
    @saturation -= amount
    hsl_to_rgb this
  
  
  ###
  Makes the colour less saturated by a percentage of it's current saturation
  Takes an amount between 0 and 100 and returns the new colour
  
  @param {number} percent
  @return {jColour}
  ###
  desaturate_percent: (percent) ->
    @saturation -= (@saturation / 100) * percent
    hsl_to_rgb this
  
  
  ###
  Changes the hue of the colour whilst retaining the lightness and saturation
  Takes a number of degrees (usually between -360 and 360) and returns the new colour
  
  @param {number} degrees
  @return {jColour}
  ###
  adjust_hue: (degrees) ->
    @hue += degrees
    hsl_to_rgb this
  
  
  ###
  Makes the colour more opaque
  Takes an amount between 0 and 1
  and returns the colour with its opacity increased 
  
  @param {number} amount
  @return {jColour}
  ###
  opacify: (amount) ->
    @alpha += amount
    @alpha = min_max @alpha, 0, 1
    this
  
  
  ###
  Makes the colour more transparent
  Takes an amount between 0 and 1
  and returns the colour with its opacity decreased 

  @param {number} amount
  @return {jColour}
  ###
  transparentize: (amount) ->
    @alpha -= amount
    @alpha = min_max @alpha, 0, 1
    this
  
  
  ###
  Converts the color to grayscale
  
  @return {jColour}
  ###
  grayscale: ->
    @saturation = 0
    hsl_to_rgb this
  
  
  ###
  Returns the complement of the colour
  This is identical to adjust_hue(180)
  
  @return {jColour}
  ###
  complement: ->
    @hue += 180
    hsl_to_rgb this
  
  
  ###
  Mixes the colour with another 'mix' colour. The mix colour can be
  passed as either a jColour instance or a string.
  Each of the RGB components are averaged, optionally weighted with
  a given percentage. The opacity of the colours is also considered
  when weighting the components.
  
  The weight specifies the weight of the mix.
  The default, 50%, means half the original colour and half the mix
  colour will be used. A weight of 25% means the a quarter of the
  mix colour will be mixed with three quarters of the original colour.
  
  @param {jColour|string} colour
  @param {number} [weight=50]
  @return {jColour}
  ###
  mix_with: (colour, weight = 50) ->
    colour = new jColour(colour) unless colour instanceof jColour
    
    p = weight/100
    w = p * 2 - 1
    a = colour.alpha - this.alpha
    
    w1 = ((if w * a == -1 then w else (w + a) / (1 + w * a)) + 1) / 2
    w2 = 1 - w1
    
    rgb =
      red:    (colour.red * w1)   + (this.red * w2)
      green:  (colour.green * w1) + (this.green * w2)
      blue:   (colour.blue * w1)  + (this.blue * w2)
    alpha =   (colour.alpha * p)  + (this.alpha * (1-p))
    
    new jColour "rgba(#{Math.round rgb.red}, #{Math.round rgb.green}, #{Math.round rgb.blue})"
    
  
    


###
The following methods are private helper methods
###
rgb_to_hsl = (c) ->
  c.red   = min_max c.red, 0, 255
  c.green = min_max c.green, 0, 255
  c.blue  = min_max c.blue, 0, 255
  c.alpha = min_max c.alpha, 0, 1
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
  c.saturation  = min_max c.saturation, 0, 100
  c.lightness   = min_max c.lightness, 0, 100
  c.alpha       = min_max c.alpha, 0, 1
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

min_max = (i, min, max) ->
  Math.min Math.max(i, min), max

