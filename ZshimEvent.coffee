define [], () ->
  class ZshimEvent
    @ZOOM_PROFILE_REQUEST = 'ZOOM_PROFILE_REQUEST'
    @ZOOM_PROFILE_MESSAGE = 'ZOOM_PROFILE_MESSAGE'
    @msg = {}

    # function ZshimEvent(arg1: String, arg2: Object = null)
    constructor: (@type, @msg = null) ->

    # clone = -> new (com.zynga.poker.zoom.ZshimEvent)(@type, @msg)

    # toString = -> formatToString 'ZshimEvent', 'type', 'bubbles', 'cancelable', 'eventPhase', 'msg'
