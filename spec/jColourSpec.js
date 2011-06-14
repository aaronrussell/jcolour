describe('Creating a jColour object', function(){
  
  var c, c1, c2;
  
  it('should recognise a colour name', function(){
    c = new jColour('cornflowerblue');
    expect(c.hex()).toEqual('#6495ed')
  });
  
  it('should recognise a hex string', function(){
    c1 = new jColour('#ff0000');
    c2 = new jColour('#ff000077');
    expect(c1).toBeDefined();
    expect(c2).toBeDefined();
  });
  
  it('should recognise a rgb string', function(){
    c1 = new jColour('rgb(255, 0, 0)');
    c2 = new jColour('rgba( 255 , 0 , 0 , 0.5)');
    expect(c1).toBeDefined();
    expect(c2).toBeDefined();
  });
  
  it('should recognise a hsl string', function(){
    c1 = new jColour('hsl(0, 100, 50)');
    c2 = new jColour('hsla( 0 , 100 , 50 , 0.5)');
    expect(c1).toBeDefined();
    expect(c2).toBeDefined();
  });
  
  it('should default to white colour if no string passed', function(){
    c = new jColour();
    expect(c.hex()).toEqual('#ffffff');
  });
  
  it('should throw an error when an invalid string is supplied', function(){
    expect(function(){ new jColour('invalid') }).toThrow(new Error('Invalid colour string.'));
  });
    
});


describe('Colour conversions', function(){
  
  var c;
  
  it('should convert from hex', function(){
    c = new jColour('#5baa30');
    expect(c.rgb()).toEqual('rgb(91, 170, 48)');
    expect(c.hsl()).toEqual('hsl(99, 56, 43)');
  });
  
  it('should convert from rgb', function(){
    c = new jColour('rgb(147, 53, 213)');
    expect(c.hex()).toEqual('#9335d5');
    expect(c.hsl()).toEqual('hsl(275, 66, 52)');
  });
  
  it('should convert from hsl', function(){
    c = new jColour('hsl(159, 42, 84)');
    expect(c.rgb()).toEqual('rgb(197, 231, 219)');
    expect(c.hex()).toEqual('#c5e7db');
  });
  
});


describe('Accessing colour representations', function(){
  
  var c1, c2;
  
  beforeEach(function(){
    c1 = new jColour('#ff0000');
    c2 = new jColour('rgba(255, 0, 0, 0.5)');
  });
  
  it('should return a hex value', function(){
    expect(c1.hex()).toEqual('#ff0000');
    expect(c2.hex(true)).toEqual('#ff00007f');
  });
  
  it('should return a rgb value', function(){
    expect(c1.rgb()).toEqual('rgb(255, 0, 0)');
    expect(c2.rgb()).toEqual('rgba(255, 0, 0, 0.5)');
  });
  
  it('should return a hsl value', function(){
    expect(c1.hsl()).toEqual('hsl(0, 100, 50)');
    expect(c2.hsl()).toEqual('hsla(0, 100, 50, 0.5)');
  });
  
  it('should return a colour name', function(){
    expect(c1.toS()).toEqual('red');
    expect(c2.toS()).toEqual('red');
  });
  
});


describe('Adjusting lightness', function(){
  
  var c;
  
  beforeEach(function(){
    c = new jColour('hsl(0, 100, 50)');
  });
  
  it('should adjust lightness up', function(){
    c.lighten(10);
    expect(c.lightness).toEqual(60);
    expect(c.hsl()).toEqual('hsl(0, 100, 60)');
  });
  
  it('should scale lightness up', function(){
    c.lightenPercent(10);
    expect(c.lightness).toEqual(55);
    expect(c.hsl()).toEqual('hsl(0, 100, 55)');
  });
  
  it('should adjust lightness down', function(){
    c.darken(10);
    expect(c.lightness).toEqual(40);
    expect(c.hsl()).toEqual('hsl(0, 100, 40)');
  });
  
  it('should scale lightness down', function(){
    c.darkenPercent(10);
    expect(c.lightness).toEqual(45);
    expect(c.hsl()).toEqual('hsl(0, 100, 45)');
  });
  
});


describe('Adjusting saturation', function(){
  
  var c;
  
  beforeEach(function(){
    c = new jColour('hsl(0, 50, 100)');
  });
  
  it('should adjust saturation up', function(){
    c.saturate(10);
    expect(c.saturation).toEqual(60);
    expect(c.hsl()).toEqual('hsl(0, 60, 100)');
  });
  
  it('should scale saturation up', function(){
    c.saturatePercent(10);
    expect(c.saturation).toEqual(55);
    expect(c.hsl()).toEqual('hsl(0, 55, 100)');
  });
  
  it('should adjust saturation down', function(){
    c.desaturate(10);
    expect(c.saturation).toEqual(40);
    expect(c.hsl()).toEqual('hsl(0, 40, 100)');
  });
  
  it('should scale saturation down', function(){
    c.desaturatePercent(10);
    expect(c.saturation).toEqual(45);
    expect(c.hsl()).toEqual('hsl(0, 45, 100)');
  });
  
  it('should return a grayscale', function(){
    c.grayscale();
    expect(c.saturation).toEqual(0);
    expect(c.hsl()).toEqual('hsl(0, 0, 100)');
  });
  
});


describe('Adjusting hue', function(){
  
  var c;
  
  beforeEach(function(){
    c = new jColour('hsl(180, 50, 50)');
  });
  
  it('should adjust hue upwards', function(){
    c.adjustHue(90);
    expect(c.hue).toEqual(270);
    expect(c.hsl()).toEqual('hsl(270, 50, 50)');
  });
  
  it('should adjust hue downwards', function(){
    c.adjustHue(-90);
    expect(c.hue).toEqual(90);
    expect(c.hsl()).toEqual('hsl(90, 50, 50)');
  });
  
  it('should loop the hue', function(){
    c.adjustHue(200);
    expect(c.hue).toEqual(20);
    expect(c.hsl()).toEqual('hsl(20, 50, 50)');
  });
  
  it('should return the complement', function(){
    c.complement();
    expect(c.hue).toEqual(0);
    expect(c.hsl()).toEqual('hsl(0, 50, 50)');
  });
    
});


describe('Adjusting opacity', function(){
  
  var c;
  
  beforeEach(function(){
    c = new jColour('rgba(255, 0, 0, 0.5)');
  });
  
  it('should increase the opacity', function(){
    c.opacify(0.25);
    expect(c.alpha).toEqual(0.75);
    expect(c.rgb()).toEqual('rgba(255, 0, 0, 0.75)');
  });
  
  it('should increase the transparency', function(){
    
    c.transparentize(0.25);
    expect(c.alpha).toEqual(0.25);
    expect(c.rgb()).toEqual('rgba(255, 0, 0, 0.25)');
  });
  
});


describe('Inverting a colour', function(){
  
  var c;
  
  beforeEach(function(){
    c = new jColour('rgb(180, 180, 180)');
  });
  
  it('should invert the colour', function(){
    c.invert();
    expect(c.rgb()).toEqual('rgb(75, 75, 75)');
  });
  
});


describe('Adjusting a colour', function(){
  
  var c;
  
  beforeEach(function(){
    c = new jColour('rgb(180, 180, 180)');
  });
  
  it('should relatively adjust the rgba properties', function(){
    c.adjustColour({
      red:    25,
      green:  -80,
      blue:   12,
      alpha:  -0.5
    });
    expect(c.rgb()).toEqual('rgba(205, 100, 192, 0.5)');
  });
  
  it('should relatively adjust the hsla properties', function(){
    c.adjustColour({
      hue:        25,
      saturation: 80,
      lightness:  -12,
      alpha:      -0.5
    });
    expect(c.hsl()).toEqual('hsla(25, 80, 59, 0.5)');
  });
  
  it('should ignore invalid properties', function(){
    c.adjustColour({
      foo:    25,
      bar:    80,
      alpha:  -0.5
    });
    expect(c.rgb()).toEqual('rgba(180, 180, 180, 0.5)');
  });
  
  it('should throw an error when incompatible params passed', function(){
    expect(function(){
      c.adjustColour({
        red:  25,
        hue:  25
      });
    }).toThrow(new Error('Cannot change both RGB and HSL properties.'));
    
  });
  
});


describe('Scaling a colour', function(){
  
  var c;
  
  beforeEach(function(){
    c = new jColour('rgba(100, 150, 200, 0.6)');
  });
  
  it('should scale the rgba properties', function(){
    c.scaleColour({
      red:    -15,
      blue:   10,
      alpha:  25
    });
    expect(c.rgb()).toEqual('rgba(85, 150, 220, 0.75)');
  });
  
  it('should scale the hsla properties', function(){
    c.scaleColour({
      saturation: 15,
      lightness:  -12
    });
    expect(c.hsl()).toEqual('hsla(210, 55, 52, 0.6)'); 
  });
  
  it('should ignore invalid properties', function(){
    c.scaleColour({
      hue:    15,
      foo:    25,
      bar:    80,
      alpha:  25
    });
    expect(c.rgb()).toEqual('rgba(100, 150, 200, 0.75)');
  });
  
  it('should throw an error when incompatible params passed', function(){
    expect(function(){
      c.scaleColour({
        red:  25,
        hue:  25
      });
    }).toThrow(new Error('Cannot change both RGB and HSL properties.'));
  });
  
});


describe('Changing a colour', function(){
  
  var c;
  
  beforeEach(function(){
    c = new jColour('rgba(100, 150, 200, 0.6)');
  });
  
  it('should change the rgba properties', function(){
    c.changeColour({
      red:    -15,
      blue:   10,
      alpha:  0.25
    });
    expect(c.rgb()).toEqual('rgba(0, 150, 10, 0.25)');
  });
  
  it('should scale the hsla properties', function(){
    c.changeColour({
      hue:        220,
      saturation: 15,
      lightness:  -12
    });
    expect(c.hsl()).toEqual('hsla(220, 15, 0, 0.6)'); 
  });
  
  it('should ignore invalid properties', function(){
    c.changeColour({
      foo:    25,
      bar:    80,
      alpha:  1
    });
    expect(c.rgb()).toEqual('rgb(100, 150, 200)');
  });
  
  it('should throw an error when incompatible params passed', function(){
    expect(function(){
      c.changeColour({
        red:  25,
        hue:  25
      });
    }).toThrow(new Error('Cannot change both RGB and HSL properties.'));
  });
  
});


describe('Mixing two colours', function(){
  
  var c1, c2, mix;
  
  beforeEach(function(){
    c1 = new jColour('rgba(111, 175, 215, 0.6)');
    c2 = new jColour('rgba(23, 56, 155, 0.9)');
  });
  
  it('should mix evenly', function(){
    mix = c1.mixWith(c2);
    expect(mix.rgb()).toEqual('rgba(54, 98, 176, 0.75)');
  });
  
  it('should mix lightly', function(){
    mix = c1.mixWith(c2, 17);
    expect(mix.rgb()).toEqual('rgba(87, 142, 198, 0.65)');
  });
  
  it('should mix heavily', function(){
    mix = c1.mixWith(c2, 91);
    expect(mix.rgb()).toEqual('rgba(27, 62, 158, 0.87)');
  });
  
  it('should throw an error when incompatible params passed', function(){
    
  });
  
});
