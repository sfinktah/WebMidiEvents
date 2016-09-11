Function::getter = (prop, get) ->
  Object.defineProperty @prototype, prop, {get, configurable: yes}
  return
Function::setter = (prop, set) ->
  Object.defineProperty @prototype, prop, {set, configurable: yes}
  return

class EventedVar
  constructor: (@_value, @arbitaryValue) ->
  # delay : Number The delay, in milliseconds, between timer events.
  @getter 'value', -> @_value
  @setter 'value', (value) -> @updateValue value
  updateValue: (newValue) ->
    if newValue isnt @_value
      @_value = @notifyChangeInValue newValue
    return
  notifyChangeInValue: (newValue) ->
    console.log "Change in value #{newValue}"
    return newValue
   
