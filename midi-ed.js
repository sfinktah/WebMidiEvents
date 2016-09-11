// Generated by CoffeeScript 1.9.1
var MidiLed, aControllerMap, fNotifyChangeInValue, oBlue, oGreen, oRed, onFailure, onSuccess;

oRed = new EventedVar(0, 1);

oGreen = new EventedVar(0, 3);

oBlue = new EventedVar(0, 5);

fNotifyChangeInValue = function(newValue) {
  var a, d, value;
  value = newValue * 2;
  console.log("fNotifyChangeInValue on " + value);

  /*
   * d3's rgb(x,y,z) parser
  parse = (format, rgb, hsl) ->
    m1 = /([a-z]+)\((.*)\)/.exec(format = format.toLowerCase())
    if m1
      m2 = m1[2].split(',')
      switch m1[1]
        when 'hsl'
          return hsl(parseFloat(m2[0]), parseFloat(m2[1]) / 100, parseFloat(m2[2]) / 100)
        when 'rgb'
          return rgb(d3_rgb_parseNumber(m2[0]), d3_rgb_parseNumber(m2[1]), d3_rgb_parseNumber(m2[2]))
    return
  #
   */
  d = document.getElementById("rgbSwatch");
  a = d.style.backgroundColor.split(/[\(\), ]/);
  a[this.arbitaryValue] = value;
  d.style.backgroundColor = a[0] + "(" + a[1] + ", " + a[3] + ", " + a[5] + ")";
  d = document.getElementById("colorBar" + this.arbitaryValue);
  d.style.width = (value >> 1) + "px";
  return value;
};

oRed.notifyChangeInValue = oBlue.notifyChangeInValue = oGreen.notifyChangeInValue = fNotifyChangeInValue;

aControllerMap = [null, oRed, oGreen, oBlue];

MidiLed = (function() {
  function MidiLed() {}

  MidiLed.prototype.construct = function(note1, controller, channel) {
    this.note = note1;
    this.controller = controller != null ? controller : null;
    this.channel = channel != null ? channel : 1;
  };

  MidiLed.prototype.on = function() {
    return WebMidi.playNote(this.note, 1, null, this.controller, this.channel);
  };

  MidiLed.prototype.off = function() {
    return WebMidi.stopNote(this.note, 1, this.controller, this.channel);
  };

  return MidiLed;

})();

onSuccess = function() {
  var dispatcher, test;
  dispatcher = new EventDispatcher;
  dispatcher.addEventListener('controlchange', function(event) {
    var oController;
    oController = aControllerMap[event.control];
    if (!!oController) {
      return oController.value = event.value;
    }
  });
  dispatcher.addEventListener('noteoff', function(event) {
    return WebMidi.playNote(event.note, 1, 1000, null, 1, '+500');
  });
  test = function(e) {
    console.log(e);
  };
  console.log('WebMidi enabled.');
  console.log(WebMidi.inputs);
  console.log(WebMidi.outputs);
  console.log(WebMidi.time);
  WebMidi.addListener('noteon', function(e) {
    var note, velocity;
    note = e.note.number;
    velocity = e.velocity;
    console.log('noteon', note, velocity);
    dispatcher.dispatchEvent('noteon', {
      note: note,
      velocity: velocity,
      e: e
    });
    dispatcher.dispatchEvent('noteon' + note, {
      note: note,
      velocity: velocity,
      e: e
    });
  });
  WebMidi.addListener('noteoff', function(e) {
    var note, velocity;
    note = e.note.number;
    velocity = e.velocity;
    console.log('noteoff', note, velocity);
    dispatcher.dispatchEvent('noteoff', {
      note: note,
      velocity: velocity,
      e: e
    });
    dispatcher.dispatchEvent('noteoff' + note, {
      note: note,
      velocity: velocity,
      e: e
    });
  });
  WebMidi.addListener('controlchange', function(e) {
    var control, value;
    control = e.control;
    value = e.value;
    console.log('controlchange', control, value);
    dispatcher.dispatchEvent('controlchange', {
      control: control,
      value: value,
      e: e
    });
    dispatcher.dispatchEvent('controlchange' + control, {
      control: control,
      value: value,
      e: e
    });
  });
  WebMidi.addListener('pitchbend', function(e) {
    console.log('pitchbend', e.value);
  });
  WebMidi.addListener('statechange', function(e) {
    console.log('statechange', e);
    dispatcher.dispatchEvent('statechange', e);
  });
  WebMidi.addListener('statechange', test);
  console.log('Has event listener: ', WebMidi.hasListener('statechange', test));
  WebMidi.removeListener('statechange', test);
  console.log('Has event listener: ', WebMidi.hasListener('statechange', test));
};

onFailure = function(err) {
  console.log('WebMidi could not be enabled.', err);
};

WebMidi.enable(onSuccess, onFailure);
