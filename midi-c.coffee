oRed = new EventedVar 0, 1
oGreen = new EventedVar 0, 3
oBlue = new EventedVar 0, 5

fNotifyChangeInValue = (newValue) ->
  value = newValue * 2
  console.log "fNotifyChangeInValue on #{#{newValue * 2}"

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
    oGreen.notifyChangeInValue =
      fNotifyChangeInValue

aControllerMap = [
  null
  oRed
  oGreen
  oBlue
]
  
onSuccess = ->

  test = (e) ->
    console.log e
    return

  console.log 'WebMidi enabled.'

  # Viewing available inputs and inputs
  console.log WebMidi.inputs

  # Getting the current time
  console.log WebMidi.time
  
  # Listening for a 'note on' message (on all devices and channels)

  WebMidi.addListener 'noteon', (e) ->
    note = e.note.number
    velocity = e.velocity
    console.log 'noteon', note, velocity
    return

  # Listening for a 'note off' message (on 1st input device's channel 3)

  WebMidi.addListener 'noteoff', (e) ->
    note = e.note.number
    velocity = e.velocity
    console.log 'noteoff', note, velocity
    return

  WebMidi.addListener 'controlchange', (e) ->
    control = e.control # data[2]
    value = e.value
    console.log 'controlchange', control, value
    oController = aControllerMap[control]
    oController.value = value if !!oController
    return

  # Listening to other messages works the same way

  WebMidi.addListener 'pitchbend', (e) ->
    console.log 'pitchbend', e.value
    return

  # The special 'statechange' event tells you that a device has been plugged or
  # unplugged. For system-wide events, you do not need to specify a device or
  # channel.

  WebMidi.addListener 'statechange', (e) ->
    console.log e
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
