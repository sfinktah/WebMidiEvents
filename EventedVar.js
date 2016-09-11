// Generated by CoffeeScript 1.9.1
var EventedVar;

Function.prototype.getter = function(prop, get) {
  Object.defineProperty(this.prototype, prop, {
    get: get,
    configurable: true
  });
};

Function.prototype.setter = function(prop, set) {
  Object.defineProperty(this.prototype, prop, {
    set: set,
    configurable: true
  });
};

EventedVar = (function() {
  function EventedVar(_value, arbitaryValue) {
    this._value = _value;
    this.arbitaryValue = arbitaryValue;
  }

  EventedVar.getter('value', function() {
    return this._value;
  });

  EventedVar.setter('value', function(value) {
    return this.updateValue(value);
  });

  EventedVar.prototype.updateValue = function(newValue) {
    if (newValue !== this._value) {
      this._value = this.notifyChangeInValue(newValue);
    }
  };

  EventedVar.prototype.notifyChangeInValue = function(newValue) {
    console.log("Change in value " + newValue);
    return newValue;
  };

  return EventedVar;

})();