
WebMidi.enable(onSuccess, onFailure);

function onSuccess() {
    console.log("WebMidi enabled.");
    // Viewing available inputs and inputs
    console.log(WebMidi.inputs);
    console.log(WebMidi.inputs);

    // Getting the current time
    console.log(WebMidi.time);
    //
    // Listening for a 'note on' message (on all devices and channels)
    WebMidi.addListener(
      'noteon',
      function(e){ 
          var note = e.note.number;
          var velocity = e.velocity;
          console.log("noteon", note, velocity); }
    );

    // Listening for a 'note off' message (on 1st input device's channel 3)
    WebMidi.addListener(
      'noteoff',
      function(e){
          var note = e.note.number;
          var velocity = e.velocity;
          console.log("noteoff", note, velocity); }
    );

    WebMidi.addListener(
      'controlchange',
      function(e){
          console.log("controlchange", e);
          // var note = e.note.number;
          // var velocity = e.velocity;
          // console.log("controlchange", note, velocity); 
          }
    );

    // Listening to other messages works the same way
    WebMidi.addListener(
      'pitchbend',
      function(e){ console.log("pitchbend", e.value); }
    );

    // The special 'statechange' event tells you that a device has been plugged or unplugged. For
    // system-wide events, you do not need to specify a device or channel.
    WebMidi.addListener(
      'statechange',
      function(e){ console.log(e); }
    );

    // You can also check and remove event listeners (in this case, you shouldn't use
    // anonymous methods).
    WebMidi.addListener('statechange', test);
    console.log("Has event listener: ",  WebMidi.hasListener('statechange', test) );
    WebMidi.removeListener('statechange', test);
    console.log("Has event listener: ",  WebMidi.hasListener('statechange', test) );

    function test(e) {
      console.log(e);
    }
}

function onFailure(err) {
    console.log("WebMidi could not be enabled.", err);
}

