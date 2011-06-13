(function() {
  window.jColour = (function() {
    var hexify, hslToRgb, hueToRgb, minMax, rgbToHsl, throwIfIncompatible;
    function jColour(col) {
      var hex, hsl, rgb;
      if (hex = col.match(/^#?([a-f0-9]{6,8})$/i)) {
        this.red = parseInt(hex[1].substring(0, 2), 16);
        this.green = parseInt(hex[1].substring(2, 4), 16);
        this.blue = parseInt(hex[1].substring(4, 6), 16);
        this.alpha = hex[1].substring(6, 8) ? parseInt(hex[1].substring(6, 8), 16) / 255 : 1;
        rgbToHsl(this);
      } else if (rgb = col.match(/^rgba?\(\s*(\d+)[,\s]*(\d+)[,\s]*(\d+)[,\s]*([\.\d]+)?\s*\)$/i)) {
        this.red = rgb[1];
        this.green = rgb[2];
        this.blue = rgb[3];
        this.alpha = rgb[4] ? rgb[4] : 1;
        rgbToHsl(this);
      } else if (hsl = col.match(/^hsla?\(\s*(\d+)[,\s]*(\d+)[,\s]*(\d+)[,\s]*([\.\d]+)?\s*\)$/i)) {
        this.hue = hsl[1];
        this.saturation = hsl[2];
        this.lightness = hsl[3];
        this.alpha = hsl[4] ? hsl[4] : 1;
        hslToRgb(this);
      }
    }
    jColour.prototype.hex = function(showAlpha) {
      if (showAlpha == null) {
        showAlpha = false;
      }
      if (showAlpha && this.alpha < 1) {
        return "#" + (hexify(this.red)) + (hexify(this.green)) + (hexify(this.blue)) + (hexify(this.alpha * 255));
      } else {
        return "#" + (hexify(this.red)) + (hexify(this.green)) + (hexify(this.blue));
      }
    };
    jColour.prototype.rgb = function() {
      if (this.alpha === 1) {
        return "rgb(" + (Math.round(this.red)) + ", " + (Math.round(this.green)) + ", " + (Math.round(this.blue)) + ")";
      } else {
        return "rgba(" + (Math.round(this.red)) + ", " + (Math.round(this.green)) + ", " + (Math.round(this.blue)) + ", " + (this.alpha.toPrecision(2)) + ")";
      }
    };
    jColour.prototype.hsl = function() {
      if (this.alpha === 1) {
        return "hsl(" + (Math.round(this.hue)) + ", " + (Math.round(this.saturation)) + ", " + (Math.round(this.lightness)) + ")";
      } else {
        return "hsla(" + (Math.round(this.hue)) + ", " + (Math.round(this.saturation)) + ", " + (Math.round(this.lightness)) + ", " + (this.alpha.toPrecision(2)) + ")";
      }
    };
    jColour.prototype.lighten = function(amount) {
      this.lightness += amount;
      return hslToRgb(this);
    };
    jColour.prototype.lightenPercent = function(percent) {
      this.lightness += (this.lightness / 100) * percent;
      return hslToRgb(this);
    };
    jColour.prototype.darken = function(amount) {
      this.lightness -= amount;
      return hslToRgb(this);
    };
    jColour.prototype.darkenPercent = function(percent) {
      this.lightness -= (this.lightness / 100) * percent;
      return hslToRgb(this);
    };
    jColour.prototype.saturate = function(amount) {
      this.saturation += amount;
      return hslToRgb(this);
    };
    jColour.prototype.saturatePercent = function(percent) {
      this.saturation += (this.saturation / 100) * percent;
      return hslToRgb(this);
    };
    jColour.prototype.desaturate = function(amount) {
      this.saturation -= amount;
      return hslToRgb(this);
    };
    jColour.prototype.desaturatePercent = function(percent) {
      this.saturation -= (this.saturation / 100) * percent;
      return hslToRgb(this);
    };
    jColour.prototype.adjustHue = function(degrees) {
      this.hue += degrees;
      return hslToRgb(this);
    };
    jColour.prototype.opacify = function(amount) {
      this.alpha += amount;
      this.alpha = minMax(this.alpha, 0, 1);
      return this;
    };
    jColour.prototype.transparentize = function(amount) {
      this.alpha -= amount;
      this.alpha = minMax(this.alpha, 0, 1);
      return this;
    };
    jColour.prototype.grayscale = function() {
      this.saturation = 0;
      return hslToRgb(this);
    };
    jColour.prototype.complement = function() {
      this.hue += 180;
      return hslToRgb(this);
    };
    jColour.prototype.invert = function() {
      var color, _i, _len, _ref;
      _ref = ['red', 'green', 'blue'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        color = _ref[_i];
        this[color] = 255 - this[color];
      }
      return rgbToHsl(this);
    };
    jColour.prototype.adjustColour = function(params) {
      var key, kind;
      if (params == null) {
        params = {};
      }
      kind = throwIfIncompatible(params);
      for (key in params) {
        this[key] += params[key];
      }
      if (kind[0]) {
        return rgbToHsl(this);
      } else {
        return hslToRgb(this);
      }
    };
    jColour.prototype.scaleColour = function(params) {
      var key, kind;
      if (params == null) {
        params = {};
      }
      kind = throwIfIncompatible(params);
      for (key in params) {
        this[key] += (this[key] / 100) * params[key];
      }
      if (kind[0]) {
        return rgbToHsl(this);
      } else {
        return hslToRgb(this);
      }
    };
    jColour.prototype.changeColour = function(params) {
      var key, kind;
      if (params == null) {
        params = {};
      }
      kind = throwIfIncompatible(params);
      for (key in params) {
        this[key] = params[key];
      }
      if (kind[0]) {
        return rgbToHsl(this);
      } else {
        return hslToRgb(this);
      }
    };
    jColour.prototype.mixWith = function(colour, weight) {
      var a, p, w, w1, w2;
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
      this.red = (colour.red * w1) + (this.red * w2);
      this.green = (colour.green * w1) + (this.green * w2);
      this.blue = (colour.blue * w1) + (this.blue * w2);
      this.alpha = (colour.alpha * p) + (this.alpha * (1 - p));
      return rgbToHsl(this);
    };
    rgbToHsl = function(c) {
      var b, d, g, h, l, max, min, r, s, _ref;
      c.red = minMax(c.red, 0, 255);
      c.green = minMax(c.green, 0, 255);
      c.blue = minMax(c.blue, 0, 255);
      c.alpha = minMax(c.alpha, 0, 1);
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
    hslToRgb = function(c) {
      var b, g, h, l, p, q, r, s;
      if (c.hue > 360) {
        c.hue -= Math.floor(c.hue / 360) * 360;
      }
      if (c.hue < 0) {
        c.hue -= Math.ceil(c.hue / 360) * 360;
      }
      c.saturation = minMax(c.saturation, 0, 100);
      c.lightness = minMax(c.lightness, 0, 100);
      c.alpha = minMax(c.alpha, 0, 1);
      h = c.hue / 360;
      s = c.saturation / 100;
      l = c.lightness / 100;
      if (s === 0) {
        r = g = b = l;
      } else {
        q = l < 0.5 ? l * (1 + s) : l + s - l * s;
        p = 2 * l - q;
        r = hueToRgb(p, q, h + 1 / 3);
        g = hueToRgb(p, q, h);
        b = hueToRgb(p, q, h - 1 / 3);
      }
      c.red = r * 255;
      c.green = g * 255;
      c.blue = b * 255;
      return c;
    };
    hueToRgb = function(p, q, t) {
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
    hexify = function(n) {
      if (n == null) {
        n = '00';
      }
      n = parseInt(n);
      if (n === 0 || isNaN(n)) {
        return '00';
      }
      n = Math.round(minMax(n, 0, 255));
      return "0123456789ABCDEF".charAt((n - n % 16) / 16) + "0123456789ABCDEF".charAt(n % 16);
    };
    minMax = function(i, min, max) {
      return Math.min(Math.max(i, min), max);
    };
    throwIfIncompatible = function(params) {
      var hsl, key, rgb;
      rgb = hsl = false;
      for (key in params) {
        if (key === 'red' || key === 'green' || key === 'blue') {
          rgb = true;
        }
        if (key === 'hue' || key === 'saturation' || key === 'luminosity') {
          hsl = true;
        }
      }
      if (rgb && hsl) {
        throw 'Cannot change both RGB and HSL properties';
      }
      return [rgb, hsl];
    };
    return jColour;
  })();
}).call(this);
