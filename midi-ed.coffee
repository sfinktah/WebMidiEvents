oRed = new EventedVar 0, 1
oGreen = new EventedVar 0, 3
oBlue = new EventedVar 0, 5

fNotifyChangeInValue = (newValue) ->
  value = newValue * 2
  console.log "fNotifyChangeInValue on #{value}"

  ###
  # d3's rgb(x,y,z) parser
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
  ###
  d = document.getElementById "rgbSwatch"
  a = d.style.backgroundColor.split(/[\(\), ]/)
  # change colors
  a[@arbitaryValue] = value
  d.style.backgroundColor = "#{a[0]}(#{a[1]}, #{a[3]}, #{a[5]})"

  d = document.getElementById "colorBar#{@arbitaryValue}"
  d.style.width = (value >> 1) + "px"


  value

oRed.notifyChangeInValue =
oBlue.notifyChangeInValue =
oGreen.notifyChangeInValue = fNotifyChangeInValue

aControllerMap = [
  null
  oRed
  oGreen
  oBlue
]



class MidiLed
  construct: (@note, @controller = null, @channel = 1) ->
  on: ->
    WebMidi.playNote @note, 1, null, @controller, @channel
  off: ->
    WebMidi.stopNote @note, 1, @controller, @channel


  
onSuccess = ->

  dispatcher = new EventDispatcher
  dispatcher.addEventListener 'controlchange', (event) ->
    oController = aControllerMap[event.control]
    oController.value = event.value if !!oController

  dispatcher.addEventListener 'noteoff', (event) ->
    WebMidi.playNote event.note, 1, 1000, null, 1, '+500'
    

  test = (e) ->
    console.log e
    return

  console.log 'WebMidi enabled.'

  # Viewing available inputs and inputs
  console.log WebMidi.inputs
  console.log WebMidi.outputs

  # Getting the current time
  console.log WebMidi.time
  
  # Listening for a 'note on' message (on all devices and channels)
  # Will echo note back for 0.5 seconds, after a delay of 1 second
  # (this lights up the lights of my AKAI LPD8)

  WebMidi.addListener 'noteon', (e) ->
    note = e.note.number
    velocity = e.velocity
    console.log 'noteon', note, velocity
    dispatcher.dispatchEvent 'noteon',            note: note, velocity: velocity, e: e
    dispatcher.dispatchEvent 'noteon' + note,     note: note, velocity: velocity, e: e
    return

  # Listening for a 'note off' message (on 1st input device's channel 3)

  WebMidi.addListener 'noteoff', (e) ->
    note = e.note.number
    velocity = e.velocity
    console.log 'noteoff', note, velocity
    dispatcher.dispatchEvent 'noteoff',            note: note, velocity: velocity, e: e
    dispatcher.dispatchEvent 'noteoff' + note,     note: note, velocity: velocity, e: e
    return

  WebMidi.addListener 'controlchange', (e) ->
    control = e.control # data[2]
    value = e.value
    console.log 'controlchange', control, value
    dispatcher.dispatchEvent 'controlchange',            control: control, value: value, e: e
    dispatcher.dispatchEvent 'controlchange' + control,  control: control, value: value, e: e

    # oController = aControllerMap[control]
    # oController.value = value if !!oController
    return

  # Listening to other messages works the same way

  WebMidi.addListener 'pitchbend', (e) ->
    console.log 'pitchbend', e.value
    return

  # The special 'statechange' event tells you that a device has been plugged or
  # unplugged. For system-wide events, you do not need to specify a device or
  # channel.

  WebMidi.addListener 'statechange', (e) ->
    console.log 'statechange', e
    dispatcher.dispatchEvent 'statechange', e
    return
  
  # You can also check and remove event listeners (in this case, you shouldn't
  # use anonymous methods).

  WebMidi.addListener 'statechange', test
  console.log 'Has event listener: ', WebMidi.hasListener('statechange', test)
  WebMidi.removeListener 'statechange', test
  console.log 'Has event listener: ', WebMidi.hasListener('statechange', test)
  return

onFailure = (err) ->
  console.log 'WebMidi could not be enabled.', err
  return

WebMidi.enable onSuccess, onFailure
