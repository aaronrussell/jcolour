(function() {
  /*
  jColour JavaScript library
  A JavaScript colour manipulation library, inspired by the SASS/Compass colour functions
  
  @version  0.1.0.beta1
  @homepage http://github.com/aaronrussell/jcolour/
  @author   Aaron Russell (http://www.aaronrussell.co.uk)
  
  @license Copyright (c) 2010-2011 Aaron Russell (aaron@gc4.co.uk)
  Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
  and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
  */  var hexify, hsl_to_rgb, hue_to_rgb, min_max, rgb_to_hsl;
  window.jColour = (function() {
    /*
      Creates a new jColour object
      
      @constructor
      @this {jColour}
      @param {string} col The colour reference - either in hexidecimal format, rgb or hsl
      */    function jColour(col) {
      var hex, hsl, rgb;
      if (hex = col.match(/^#?([a-f0-9]{6,8})$/i)) {
        this.red = parseInt(hex[1].substring(0, 2), 16);
        this.green = parseInt(hex[1].substring(2, 4), 16);
        this.blue = parseInt(hex[1].substring(4, 6), 16);
        this.alpha = hex[1].substring(6, 8) ? parseInt(hex[1].substring(6, 8), 16) / 255 : 1;
        rgb_to_hsl(this);
      } else if (rgb = col.match(/^rgba?\(\s*(\d+)[,\s]*(\d+)[,\s]*(\d+)[,\s]*([\.\d]+)?\s*\)$/i)) {
        this.red = rgb[1];
        this.green = rgb[2];
        this.blue = rgb[3];
        this.alpha = rgb[4] ? rgb[4] : 1;
        rgb_to_hsl(this);
      } else if (hsl = col.match(/^hsla?\(\s*(\d+)[,\s]*(\d+)[,\s]*(\d+)[,\s]*([\.\d]+)?\s*\)$/i)) {
        this.hue = hsl[1];
        this.saturation = hsl[2];
        this.lightness = hsl[3];
        this.alpha = hsl[4] ? hsl[4] : 1;
        hsl_to_rgb(this);
      }
    }
    /*
      Returns the hexidecimal value of the colour
      
      @return {string} Hexidecimal value of colour
      */
    jColour.prototype.hex = function() {
      if (this.alpha === 1) {
        return "#" + (hexify(this.red)) + (hexify(this.green)) + (hexify(this.blue));
      } else {
        return "#" + (hexify(this.red)) + (hexify(this.green)) + (hexify(this.blue)) + (hexify(this.alpha * 255));
      }
    };
    /*
      Returns the RGB value of the colour
      
      @return {string} RGB value of colour
      */
    jColour.prototype.rgb = function() {
      if (this.alpha === 1) {
        return "rgb(" + (Math.round(this.red)) + ", " + (Math.round(this.green)) + ", " + (Math.round(this.blue)) + ")";
      } else {
        return "rgba(" + (Math.round(this.red)) + ", " + (Math.round(this.green)) + ", " + (Math.round(this.blue)) + ", " + (this.alpha.toPrecision(2)) + ")";
      }
    };
    /*
      Returns the HSL value of the colour
      
      @return {string}
      */
    jColour.prototype.hsl = function() {
      if (this.alpha === 1) {
        return "hsl(" + (Math.round(this.hue)) + ", " + (Math.round(this.saturation)) + ", " + (Math.round(this.lightness)) + ")";
      } else {
        return "hsla(" + (Math.round(this.hue)) + ", " + (Math.round(this.saturation)) + ", " + (Math.round(this.lightness)) + ", " + (this.alpha.toPrecision(2)) + ")";
      }
    };
    /*
      Makes the colour lighter by an absolute amount
      Takes an amount between 0 and 100 and returns the new colour
      
      @param {number} amount
      @return {jColour}
      */
    jColour.prototype.lighten = function(amount) {
      this.lightness += amount;
      return hsl_to_rgb(this);
    };
    /*
      Makes the colour lighter by a percentage of it's current lightness
      Takes an amount between 0 and 100 and returns the new colour
      
      @param {number} percent
      @return {jColour}
      */
    jColour.prototype.lighten_percent = function(percent) {
      this.lightness += (this.lightness / 100) * percent;
      return hsl_to_rgb(this);
    };
    /*
      Makes the colour darker by an absolute amount
      Takes an amount between 0 and 100 and returns the new colour
      
      @param {number} amount
      @return {jColour}
      */
    jColour.prototype.darken = function(amount) {
      this.lightness -= amount;
      return hsl_to_rgb(this);
    };
    /*
      Makes the colour darker by a percentage of it's current lightness
      Takes an amount between 0 and 100 and returns the new colour
      
      @param {number} percent
      @return {jColour}
      */
    jColour.prototype.darken_percent = function(percent) {
      this.lightness -= (this.lightness / 100) * percent;
      return hsl_to_rgb(this);
    };
    /*
      Makes the colour more saturated by an absolute amount
      Takes an amount between 0 and 100 and returns the new colour
      
      @param {number} amount
      @return {jColour}
      */
    jColour.prototype.saturate = function(amount) {
      this.saturation += amount;
      return hsl_to_rgb(this);
    };
    /*
      Makes the colour more saturated by a percentage of it's current saturation
      Takes an amount between 0 and 100 and returns the new colour
      
      @param {number} percent
      @return {jColour}
      */
    jColour.prototype.saturate_percent = function(percent) {
      this.saturation += (this.saturation / 100) * percent;
      return hsl_to_rgb(this);
    };
    /*
      Makes the colour less saturated by an absolute amount
      Takes an amount between 0 and 100 and returns the new colour
      
      @param {number} amount
      @return {jColour}
      */
    jColour.prototype.desaturate = function(amount) {
      this.saturation -= amount;
      return hsl_to_rgb(this);
    };
    /*
      Makes the colour less saturated by a percentage of it's current saturation
      Takes an amount between 0 and 100 and returns the new colour
      
      @param {number} percent
      @return {jColour}
      */
    jColour.prototype.desaturate_percent = function(percent) {
      this.saturation -= (this.saturation / 100) * percent;
      return hsl_to_rgb(this);
    };
    /*
      Changes the hue of the colour whilst retaining the lightness and saturation
      Takes a number of degrees (usually between -360 and 360) and returns the new colour
      
      @param {number} degrees
      @return {jColour}
      */
    jColour.prototype.adjust_hue = function(degrees) {
      this.hue += degrees;
      return hsl_to_rgb(this);
    };
    /*
      Makes the colour more opaque
      Takes an amount between 0 and 1
      and returns the colour with its opacity increased 
      
      @param {number} amount
      @return {jColour}
      */
    jColour.prototype.opacify = function(amount) {
      this.alpha += amount;
      this.alpha = min_max(this.alpha, 0, 1);
      return this;
    };
    /*
      Makes the colour more transparent
      Takes an amount between 0 and 1
      and returns the colour with its opacity decreased 
    
      @param {number} amount
      @return {jColour}
      */
    jColour.prototype.transparentize = function(amount) {
      this.alpha -= amount;
      this.alpha = min_max(this.alpha, 0, 1);
      return this;
    };
    /*
      Converts the color to grayscale
      
      @return {jColour}
      */
    jColour.prototype.grayscale = function() {
      this.saturation = 0;
      return hsl_to_rgb(this);
    };
    /*
      Returns the complement of the colour
      This is identical to adjust_hue(180)
      
      @return {jColour}
      */
    jColour.prototype.complement = function() {
      this.hue += 180;
      return hsl_to_rgb(this);
    };
    /*
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
      */
    jColour.prototype.mix_with = function(colour, weight) {
      var a, alpha, p, rgb, w, w1, w2;
      if (weight == null) {
        weight = 50;
      }
      if (!(colour instanceof jColour)) {
        colour = new jColour(colour);
      }
      p = weight / 100;
      w = p * 2 - 1;
      a = colour.alpha - this.alpha;
      w1 = ((w * a === -1 ? w : (w + a) / (1 + w * a)) + 1) / 2;
      w2 = 1 - w1;
      rgb = {
        red: (colour.red * w1) + (this.red * w2),
        green: (colour.green * w1) + (this.green * w2),
        blue: (colour.blue * w1) + (this.blue * w2)
      };
      alpha = (colour.alpha * p) + (this.alpha * (1 - p));
      return new jColour("rgba(" + (Math.round(rgb.red)) + ", " + (Math.round(rgb.green)) + ", " + (Math.round(rgb.blue)) + ")");
    };
    return jColour;
  })();
  /*
  @private
  */
  rgb_to_hsl = function(c) {
    var b, d, g, h, l, max, min, r, s, _ref;
    c.red = min_max(c.red, 0, 255);
    c.green = min_max(c.green, 0, 255);
    c.blue = min_max(c.blue, 0, 255);
    c.alpha = min_max(c.alpha, 0, 1);
    r = c.red / 255;
    g = c.green / 255;
    b = c.blue / 255;
    max = Math.max(r, g, b);
    min = Math.min(r, g, b);
    h = s = l = (max + min) / 2;
    if (max === min) {
      h = s = 0;
    } else {
      d = max - min;
      s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
      switch (max) {
        case r:
          h = (g - b) / d + ((_ref = g < b) != null ? _ref : {
            6: 0
          });
          break;
        case g:
          h = (b - r) / d + 2;
          break;
        case b:
          h = (r - g) / d + 4;
      }
      h /= 6;
    }
    c.hue = h * 360;
    c.saturation = s * 100;
    c.lightness = l * 100;
    return c;
  };
  /*
  @private
  */
  hsl_to_rgb = function(c) {
    var b, g, h, l, p, q, r, s;
    if (c.hue > 360) {
      c.hue -= Math.floor(c.hue / 360) * 360;
    }
    if (c.hue < 0) {
      c.hue -= Math.ceil(c.hue / 360) * 360;
    }
    c.saturation = min_max(c.saturation, 0, 100);
    c.lightness = min_max(c.lightness, 0, 100);
    c.alpha = min_max(c.alpha, 0, 1);
    h = c.hue / 360;
    s = c.saturation / 100;
    l = c.lightness / 100;
    if (s === 0) {
      r = g = b = l;
    } else {
      q = l < 0.5 ? l * (1 + s) : l + s - l * s;
      p = 2 * l - q;
      r = hue_to_rgb(p, q, h + 1 / 3);
      g = hue_to_rgb(p, q, h);
      b = hue_to_rgb(p, q, h - 1 / 3);
    }
    c.red = r * 255;
    c.green = g * 255;
    c.blue = b * 255;
    return c;
  };
  /*
  @private
  */
  hue_to_rgb = function(p, q, t) {
    if (t < 0) {
      t += 1;
    }
    if (t > 1) {
      t -= 1;
    }
    if (t < 1 / 6) {
      return p + (q - p) * 6 * t;
    }
    if (t < 1 / 2) {
      return q;
    }
    if (t < 2 / 3) {
      return p + (q - p) * (2 / 3 - t) * 6;
    }
    return p;
  };
  /*
  @private
  */
  hexify = function(n) {
    if (n == null) {
      n = '00';
    }
    n = parseInt(n);
    if (n === 0 || isNaN(n)) {
      return '00';
    }
    n = Math.max(0, n);
    n = Math.min(n, 255);
    n = Math.round(n);
    return "0123456789ABCDEF".charAt((n - n % 16) / 16) + "0123456789ABCDEF".charAt(n % 16);
  };
  /*
  @private
  */
  min_max = function(i, min, max) {
    return Math.min(Math.max(i, min), max);
  };
}).call(this);
