# **jColour** is a JavaScript colour manipulation library written in [CoffeeScript](http://coffeescript.org).
# jColour is inspired heavily by the [SASS](http://sass-lang.com)/[Compass](http://compass-style.org)
# colour manipulation functions.
#
# jColour is also the first ever colour library to spell the word "colour" correctly.
#
# jColour is written by [Aaron Russell](http://aaronrussell.co.uk),
# the [source code for jColour](http://github.com/aaronrussell/jcolour) is available on Github and
# is released under the [MIT license](http://www.opensource.org/licenses/mit-license.php).

#### Download jColour

# * [Download the minified version](https://raw.github.com/aaronrussell/jcolour/master/build/jColour.min.js) (8kb)
# * [Download the fatter version](https://raw.github.com/aaronrussell/jcolour/master/build/jColour.js) (14kb)

#### Creating a jColour object

# The jColour class can be used in the browser or in your CommonJS projects.
#
root = exports ? this

class root.jColour
  
  # Create a new jColour object by passing a colour string. jColour will parse a string in any of
  # the following formats: [recognised colour name](http://www.w3.org/TR/SVG/types.html#ColorKeywords),
  # hexidecimal, rgb/a, hsl/a. For example, all the following statements work:
  #
  #     c = new jColour('red');
  #     c = new jColour('#f00');
  #     c = new jColour('#ff0000');
  #     c = new jColour('rgb(255,0,0)');
  #     c = new jColour('rgba(255,0,0,1)');
  #     c = new jColour('hsl(0,100,100)');
  #     c = new jColour('hsla(0,100,100,1)');
  #
  # Internally, colours are represented in both RGB and HSL. Any colour adjustments result in
  # both representaions being recalculated. The alpha channel of a colour is stored independent
  # it's RGB or HSL representation. If no alpha value is supplied, it defaults to 1.
  #
  constructor: (col = '#ffffff') ->
    
    col = colourNames[col] if col.toLowerCase() of colourNames
    if hex = col.match /^#?([a-f0-9]{3})$/i
      h1 = hex[1].substring(0,1)
      h2 = hex[1].substring(1,2)
      h3 = hex[1].substring(2,3)
      col = "##{h1+h1+h2+h2+h3+h3}"
    
    if hex = col.match /^#?([a-f0-9]{6,8})$/i
      @red    = parseInt hex[1].substring(0,2), 16
      @green  = parseInt hex[1].substring(2,4), 16
      @blue   = parseInt hex[1].substring(4,6), 16
      @alpha  = if hex[1].substring(6,8) then parseInt(hex[1].substring(6,8), 16) / 255 else 1
      rgbToHsl this
    else if rgb = col.match /^rgba?\(\s*(\d+)[,\s]*(\d+)[,\s]*(\d+)[,\s]*([\.\d]+)?\s*\)$/i
      @red    = parseInt rgb[1]
      @green  = parseInt rgb[2]
      @blue   = parseInt rgb[3]
      @alpha  = if rgb[4] then rgb[4] else 1
      rgbToHsl this
    else if hsl = col.match /^hsla?\(\s*(\d+)[,\s]*(\d+)[,\s]*(\d+)[,\s]*([\.\d]+)?\s*\)$/i
      @hue        = parseInt hsl[1]
      @saturation = parseInt hsl[2]
      @lightness  = parseInt hsl[3]
      @alpha      = if hsl[4] then hsl[4] else 1
      hslToRgb this
    else
      throw 'Invalid colour string.'
  
  
  #### Accessing colour representations
  
  # At any time, a jColour object can return a string of any of it's colour represenations.
  
  ##### `hex(show_alpha = false)`
  #
  # To return the hexidecimal value of the colour use the `hex()` method. By default, any alpha
  # value of the jColour object will be ignored. However, in specialist cases you may want a
  # hexdecimal representation of the alpha channel, in which case pass `true` to the method.
  #
  #     c.hex();  # -> '#ff0000'
  #
  hex: (showAlpha = false) ->
    hex = if showAlpha && @alpha < 1
      "##{hexify @red}#{hexify @green}#{hexify @blue}#{hexify @alpha * 255}"
    else
      "##{hexify @red}#{hexify @green}#{hexify @blue}"
    hex.toLowerCase()
  
  
  ##### `rgb()`
  #
  # Returns the RGB value of the colour. If the jColour object's alpha channel is anything but 1,
  # the returned representation will be RGBA.
  #
  #     c.rgb();  # -> 'rgb(255,0,0)'
  #
  rgb: ->
    if @alpha == 1
      "rgb(#{Math.round @red}, #{Math.round @green}, #{Math.round @blue})"
    else
      "rgba(#{Math.round @red}, #{Math.round @green}, #{Math.round @blue}, #{Math.round(@alpha * 100) / 100})"
  
  
  ##### `hsl()`
  #
  # Returns the HSL value of the colour. If the jColour object's alpha channel is anything but 1,
  # the returned representation will be HSLA.
  #
  #     c.hsl();  # -> 'hsl(0,100,100)'
  #
  hsl: ->
    if @alpha == 1
      "hsl(#{Math.round @hue}, #{Math.round @saturation}, #{Math.round @lightness})"
    else
      "hsla(#{Math.round @hue}, #{Math.round @saturation}, #{Math.round @lightness}, #{Math.round(@alpha * 100) / 100})"
  
  
  ##### `toS()`
  #
  # Returns the name of the colour if it is a recognised colour keyworld. Alternatively, the hex
  # code will be returned.
  #
  toS: ->
    for key, value of colourNames
      return key if @hex() == value.toLowerCase()
    @hex()
  
  
  #### Manipulating colours
  
  # A jColour object can be manipulated using a range of colour manipulation methods. Each method
  # makes the required adjustment to the colour representations and updates the jColour object.
  # This allows the "chaining" of methods, for example:
  #
  #     c = new jColour('#ff0000');
  #     c.adjustHue(20).darken(10).transparentize(25).rgb();  # -> 'rgba(204, 68, 0, 0.75)'
  #
  # Most of the colour manipulation methods allow colour values to be manipulated relatively
  # (eg. 50 + 10 = 60) or scaled by a percentage (eg. 50 + 10% = 55). The name of the method should
  # make it obvious as to what calculation you should expect.
  
  ##### `lighten(amount)`
  #
  # Makes the colour lighter. Takes an amount between 0 and 100 which makes a relative adjustment
  # (increase) to the current lightness.
  #
  #     c.lighten(25);
  #
  lighten: (amount) ->
    @lightness += amount
    hslToRgb this
  
  
  ##### `lightenPercent(percent)`
  #
  # Also makes the colour lighter. This method should also be passed a value between 0 and 100, but
  # in this case the lightness is *scaled* up relative to it's current value.
  #
  #     c.lightenPercent(25);
  #
  lightenPercent: (percent) ->
    @lightness += (@lightness / 100) * percent
    hslToRgb this
  
  
  ##### `darken(amount)`
  #
  # Makes the colour darker. Takes an amount between 0 and 100 which makes a relative adjustment
  # (decrease) to the current lightness.
  #
  #     c.darken(25);
  #
  darken: (amount) ->
    @lightness -= amount
    hslToRgb this
  
  
  ##### `darkenPercent(percent)`
  #
  # Also makes the colour darker. This method should also be passed a value between 0 and 100, but
  # in this case the lightness is *scaled* down relative to it's current value.
  #
  #     c.darkenPercent(25);
  #
  darkenPercent: (percent) ->
    @lightness -= (@lightness / 100) * percent
    hslToRgb this
  
  
  ##### `saturate(amount)`
  #
  # Makes the colour more saturated. Takes an amount between 0 and 100 which makes a relative
  # adjustment (increase) to the current saturation.
  #
  #     c.saturate(25);
  #
  saturate: (amount) ->
    @saturation += amount
    hslToRgb this
  
  
  ##### `saturatePercent(percent)`
  #
  # Also makes the colour more saturated. This method should also be passed a value between 0 and
  # 100, but in this case the saturation is *scaled* up relative to it's current value.
  #
  #     c.saturatePercent(25);
  #
  saturatePercent: (percent) ->
    @saturation += (@saturation / 100) * percent
    hslToRgb this
  
  
  ##### `desaturate(amount)`
  #
  # Makes the colour less saturated. Takes an amount between 0 and 100 which makes a relative
  # adjustment (decrease) to the current saturation.
  #
  #     c.desaturate(25);
  #
  desaturate: (amount) ->
    @saturation -= amount
    hslToRgb this
  
  
  ##### `desaturatePercent(percent)`
  #
  # Also makes the colour less saturated. This method should also be passed a value between 0 and
  # 100, but in this case the saturation is *scaled* down relative to it's current value.
  #
  #     c.desaturatePercent(25);
  #
  desaturatePercent: (percent) ->
    @saturation -= (@saturation / 100) * percent
    hslToRgb this
  
  
  ##### `greyscale()`
  #
  # Converts the color to greyscale. This is identical to `desaturate(100)`. Can also use the alias, `grayscale()`.
  #
  #     c.greyscale();
  #
  greyscale: ->
    @saturation = 0
    hslToRgb this
  grayscale: -> @greyscale()
  
  
  ##### `adjustHue(degrees)`
  #
  # Changes the hue of the colour whilst retaining the lightness and saturation. This method should
  # be passed a number of degrees (usually between -360 and 360) and makes a relative adjustment to
  # the current hue.
  #
  #     c.adjustHue(45);
  #
  adjustHue: (degrees) ->
    @hue += degrees
    hslToRgb this
  
  
  ##### `complement()`
  #
  # Returns the complement of the current colour. This is identical to `adjustHue(180)`.
  #
  #     c.complement();
  #
  complement: ->
    @hue += 180
    hslToRgb this
  
  
  ##### `opacify(amount)`
  #
  # Makes the colour more opaque. Takes an amount between 0 and 1 which makes a relative
  # adjustment (increase) to the current alpha channel.
  #
  #     c.opacify(0.25);
  #
  opacify: (amount) ->
    @alpha += amount
    @alpha = minMax @alpha, 0, 1
    this
  
  
  ##### `transparentize(amount)`
  #
  # Makes the colour more transparent. Takes an amount between 0 and 100 which makes a relative
  # adjustment (decrease) to the current alpha channel.
  #
  #     c.transparentize(0.25);
  #
  transparentize: (amount) ->
    @alpha -= amount
    @alpha = minMax @alpha, 0, 1
    this
  
  
  ##### `invert()`
  #
  # Returns the inverse (negative) of the color. The red, green, and blue values are inverted, while
  # the opacity is left alone.
  #
  #     c.invert();
  #
  invert: ->
    for color in ['red', 'green', 'blue']
      @[color] = 255 - @[color]
    rgbToHsl this
  
  
  ##### `adjustColour(params = {})`
  #
  # Makes a relative adjustment to one or more properties of the colour. Takes an object with the
  # properties of red, green, blue, hue, saturation, lightness and alpha. All properties are
  # optional and you can't specify both RGB and HSL properties at the same time.
  #
  # Red, green and blue propeties should have a value between -255 and 255. The hue property should
  # have a value between -360 and 360. The saturation and lightness properties should have a value
  # between -100 and 100. The alpha property should have a value between 0 and 1. All values will
  # make a relative adjustment to their current value.
  #
  #     c.adjustColour({
  #       red:        25,
  #       green:      -30,
  #       alpha:      -0.25
  #     })
  #     c.adjustColour({
  #       hue:        120,
  #       lightness:  25,
  #       saturation: -10
  #     })
  #
  adjustColour: (params = {}) ->
    kind = throwIfIncompatible params
    for key of params
      @[key] += params[key] if key in properties
    if kind[0] then rgbToHsl this else hslToRgb this
  
  
  ##### `scaleColour(params = {})`
  #
  # Makes a scaled adjustment to one or more properties of the colour. Takes an object with the
  # properties of red, green, blue, saturation, lightness and alpha. Note that you can't scale the
  # hue value. All properties are optional and you can't specify both RGB and HSL properties at the
  # same time.
  #
  # All properties should have a value between -100 and 100. The property will be scaled up or down
  # relative to it's current value.
  #
  #     c.scaleColour({
  #       red:        25,
  #       green:      -15
  #     })
  #     c.scaleColour({
  #       lightness:  25,
  #       saturation: -10
  #     })
  #
  scaleColour: (params = {}) ->
    kind = throwIfIncompatible params
    for key of params
      @[key] += (@[key] / 100) * params[key] if key in properties and key isnt 'hue'
    if kind[0] then rgbToHsl this else hslToRgb this
  
  
  ##### `changeColour(params = {})`
  #
  # Changes one or more properties of the colour to the absolute value provided. Takes an object
  # with the properties of red, green, blue, hue, saturation, lightness and alpha. All properties
  # are optional and you can't specify both RGB and HSL properties at the same time.
  #
  # Red, green and blue propeties should have a value between 0 and 255. The hue property should
  # have a value between 0 and 360. The saturation and lightness properties should have a value
  # between 0 and 100. The alpha property should have a value between 0 and 1. All properties will
  # be set to the new value.
  #
  #     c.changeColour({
  #       red:        255,
  #       green:      0,
  #       blue:       0
  #     })
  #     c.changeColour({
  #       hue:        0,
  #       lightness:  100,
  #       saturation: 100
  #     })
  #
  changeColour: (params = {}) ->
    kind = throwIfIncompatible params
    for key of params
      @[key] = params[key] if key in properties
    if kind[0] then rgbToHsl this else hslToRgb this
    
  
  ##### `mixWith(colour, weight = 50)`
  #
  # Mixes the colour with another 'mix' colour. The mix colour can be passed as either a jColour
  # object or a string. Each of the RGB components are averaged, optionally weighted with a given
  # percentage. The opacity of the colours is also considered when weighting the components.
  #
  # The weight specifies the weight of the mix. The default, 50%, means half the original colour
  # and half the mix colour will be used. A weight of 25% means the a quarter of the mix colour
  # will be mixed with three quarters of the original colour.
  #
  #     red = new jColour('#ff0000');
  #     red.mixWith('#ffffff', 75).rgb();   # -> 'rgb(255, 191, 191)'
  #
  mixWith: (colour, weight = 50) ->
    colour = new jColour(colour) unless colour instanceof jColour
    
    p = weight / 100
    w = p * 2 - 1
    a = colour.alpha - @alpha
    
    w1 = ((if w * a == -1 then w else (w + a) / (1 + w * a)) + 1) / 2
    w2 = 1 - w1
    
    @red    = (colour.red * w1)   + (@red * w2)
    @green  = (colour.green * w1) + (@green * w2)
    @blue   = (colour.blue * w1)  + (@blue * w2)
    @alpha  = (colour.alpha * p)  + (@alpha * (1-p))
    
    rgbToHsl this
  
  
  #### Private properties
  
  # This properties array is useful to have around.
  #
  properties = ['red', 'green', 'blue', 'hue', 'saturation', 'lightness', 'alpha']  
  
  
  # A mahoosive list of recognised colour keyword names as defined at
  # [http://www.w3.org/TR/SVG/types.html#ColorKeywords](http://www.w3.org/TR/SVG/types.html#ColorKeywords)
  #
  colourNames = 
    aliceblue:            '#F0F8FF'
    antiquewhite:         '#FAEBD7'
    aqua:                 '#00FFFF'
    aquamarine:           '#7FFFD4'
    azure:                '#F0FFFF'
    beige:                '#F5F5DC'
    bisque:               '#FFE4C4'
    black:                '#000000'
    blanchedalmond:       '#FFEBCD'
    blue:                 '#0000FF'
    blueviolet:           '#8A2BE2'
    brown:                '#A52A2A'
    burlywood:            '#DEB887'
    cadetblue:            '#5F9EA0'
    chartreuse:           '#7FFF00'
    chocolate:            '#D2691E'
    coral:                '#FF7F50'
    cornflowerblue:       '#6495ED'
    cornsilk:             '#FFF8DC'
    crimson:              '#DC143C'
    cyan:                 '#00FFFF'
    darkblue:             '#00008B'
    darkcyan:             '#008B8B'
    darkgoldenrod:        '#B8860B'
    darkgray:             '#A9A9A9'
    darkgreen:            '#006400'
    darkgrey:             '#A9A9A9'
    darkkhaki:            '#BDB76B'
    darkmagenta:          '#8B008B'
    darkolivegreen:       '#556B2F'
    darkorange:           '#FF8C00'
    darkorchid:           '#9932CC'
    darkred:              '#8B0000'
    darksalmon:           '#E9967A'
    darkseagreen:         '#8FBC8F'
    darkslateblue:        '#483D8B'
    darkslategray:        '#2F4F4F'
    darkslategrey:        '#2F4F4F'
    darkturquoise:        '#00CED1'
    darkviolet:           '#9400D3'
    deeppink:             '#FF1493'
    deepskyblue:          '#00BFFF'
    dimgray:              '#696969'
    dimgrey:              '#696969'
    dodgerblue:           '#1E90FF'
    firebrick:            '#B22222'
    floralwhite:          '#FFFAF0'
    forestgreen:          '#228B22'
    fuchsia:              '#FF00FF'
    gainsboro:            '#DCDCDC'
    ghostwhite:           '#F8F8FF'
    gold:                 '#FFD700'
    goldenrod:            '#DAA520'
    gray:                 '#808080'
    green:                '#008000'
    greenyellow:          '#ADFF2F'
    grey:                 '#808080'
    honeydew:             '#F0FFF0'
    hotpink:              '#FF69B4'
    indianred:            '#CD5C5C'
    indigo:               '#4B0082'
    ivory:                '#FFFFF0'
    khaki:                '#F0E68C'
    lavender:             '#E6E6FA'
    lavenderblush:        '#FFF0F5'
    lawngreen:            '#7CFC00'
    lemonchiffon:         '#FFFACD'
    lightblue:            '#ADD8E6'
    lightcoral:           '#F08080'
    lightcyan:            '#E0FFFF'
    lightgoldenrodyellow: '#FAFAD2'
    lightgray:            '#D3D3D3'
    lightgreen:           '#90EE90'
    lightgrey:            '#D3D3D3'
    lightpink:            '#FFB6C1'
    lightsalmon:          '#FFA07A'
    lightseagreen:        '#20B2AA'
    lightskyblue:         '#87CEFA'
    lightslategray:       '#778899'
    lightslategrey:       '#778899'
    lightsteelblue:       '#B0C4DE'
    lightyellow:          '#FFFFE0'
    lime:                 '#00FF00'
    limegreen:            '#32CD32'
    linen:                '#FAF0E6'
    magenta:              '#FF00FF'
    maroon:               '#800000'
    mediumaquamarine:     '#66CDAA'
    mediumblue:           '#0000CD'
    mediumorchid:         '#BA55D3'
    mediumpurple:         '#9370DB'
    mediumseagreen:       '#3CB371'
    mediumslateblue:      '#7B68EE'
    mediumspringgreen:    '#00FA9A'
    mediumturquoise:      '#48D1CC'
    mediumvioletred:      '#C71585'
    midnightblue:         '#191970'
    mintcream:            '#F5FFFA'
    mistyrose:            '#FFE4E1'
    moccasin:             '#FFE4B5'
    navajowhite:          '#FFDEAD'
    navy:                 '#000080'
    oldlace:              '#FDF5E6'
    olive:                '#808000'
    olivedrab:            '#6B8E23'
    orange:               '#FFA500'
    orangered:            '#FF4500'
    orchid:               '#DA70D6'
    palegoldenrod:        '#EEE8AA'
    palegreen:            '#98FB98'
    paleturquoise:        '#AFEEEE'
    palevioletred:        '#DB7093'
    papayawhip:           '#FFEFD5'
    peachpuff:            '#FFDAB9'
    peru:                 '#CD853F'
    pink:                 '#FFC0CB'
    plum:                 '#DDA0DD'
    powderblue:           '#B0E0E6'
    purple:               '#800080'
    red:                  '#FF0000'
    rosybrown:            '#BC8F8F'
    royalblue:            '#4169E1'
    saddlebrown:          '#8B4513'
    salmon:               '#FA8072'
    sandybrown:           '#F4A460'
    seagreen:             '#2E8B57'
    seashell:             '#FFF5EE'
    sienna:               '#A0522D'
    silver:               '#C0C0C0'
    skyblue:              '#87CEEB'
    slateblue:            '#6A5ACD'
    slategray:            '#708090'
    slategrey:            '#708090'
    snow:                 '#FFFAFA'
    springgreen:          '#00FF7F'
    steelblue:            '#4682B4'
    tan:                  '#D2B48C'
    teal:                 '#008080'
    thistle:              '#D8BFD8'
    tomato:               '#FF6347'
    turquoise:            '#40E0D0'
    violet:               '#EE82EE'
    wheat:                '#F5DEB3'
    white:                '#FFFFFF'
    whitesmoke:           '#F5F5F5'
    yellow:               '#FFFF00'
    yellowgreen:          '#9ACD32'
  
  
  #### Private helper methods
  #
  # The following methods are all used internally and are not accessible from outside the jColour object.
  #  
  
  ##### `rgbToHsl(c)`
  #
  # Converts the RGB representation to a HSL representation.
  #
  rgbToHsl = (c) ->
    c.red   = minMax c.red, 0, 255
    c.green = minMax c.green, 0, 255
    c.blue  = minMax c.blue, 0, 255
    c.alpha = minMax c.alpha, 0, 1
    r = c.red / 255
    g = c.green / 255
    b = c.blue / 255
    max = Math.max r, g, b
    min = Math.min r, g, b
    d = max - min
    h = switch max
      when min then 0
      when r then 60 * (g - b) / d
      when g then 60 * (b - r) / d + 120
      when b then 60 * (r - g) / d + 240
    l = (max + min) / 2
    s = if max == min
      0
    else if l < 0.5
      d / (2 * l)
    else
      d / (2 - 2 * l)
    c.hue         = h % 360
    c.saturation  = s * 100
    c.lightness   = l * 100
    c
  
  
  ##### `hslToRgb(c)`
  #
  # Converts the HSL representation to a RGB representation.
  #
  hslToRgb = (c) ->
    c.hue -= Math.floor(c.hue/360)*360 if c.hue >= 360
    c.hue -= Math.ceil(c.hue/360)*360  if c.hue < 0
    c.saturation  = minMax c.saturation, 0, 100
    c.lightness   = minMax c.lightness, 0, 100
    c.alpha       = minMax c.alpha, 0, 1
    h = c.hue / 360
    s = c.saturation / 100
    l = c.lightness / 100
    m2 = if l < 0.5 then l * (s + 1) else l + s - (l * s)
    m1 = l * 2 - m2
    r = hueToRgb m1, m2, h + 1/3
    g = hueToRgb m1, m2, h
    b = hueToRgb m1, m2, h - 1/3
    c.red   = r * 255
    c.green = g * 255
    c.blue  = b * 255
    c
  
  
  ##### `hueToRgb(p, q, t)`
  #
  # Algorithm for converting hue to each of the red, green and blue properties.
  #
  hueToRgb = (m1, m2, h) ->
    h += 1 if h < 0
    h -= 1 if h > 1
    return m1 + (m2 - m1) * h * 6 if h * 6 < 1
    return m2 if h * 2 < 1
    return m1 + (m2 - m1) * (2/3 - h) * 6 if h * 3 < 2
    m1
  
  
  ##### `hexify(n = '00')`
  #
  # Algorithm for converting each of the RGB colour channels to it's hex value.
  #
  hexify = (n = '00') ->
    n = parseInt n
    return '00' if n == 0 or isNaN n
    n = Math.round minMax(n, 0, 255)
    "0123456789ABCDEF".charAt((n-n%16)/16) + "0123456789ABCDEF".charAt(n%16)
  
  
  ##### `minMax(i, min, max)`
  #
  # Helper method to clip a provided number between a minimum and maximum value.
  #
  minMax = (i, min, max) ->
    Math.min Math.max(i, min), max
  
  
  ##### `throwIfIncompatible(params)`
  #
  # Throws an error if incompatible colour properties are provided.
  #
  throwIfIncompatible = (params) ->
    rgb = hsl = false
    for key of params
      rgb = true if key in ['red', 'green', 'blue']
      hsl = true if key in ['hue', 'saturation', 'luminosity']
    if rgb and hsl
      throw 'Cannot change both RGB and HSL properties.'
    [rgb, hsl]



#### Copyright
#
# Copyright (c) 2010-2011 [Aaron Russell](http://aaronrussell.co.uk).
# Licensed under the [MIT license](http://www.opensource.org/licenses/mit-license.php).

