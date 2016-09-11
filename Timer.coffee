# define 'ED', ['bean-ori'], (bean) ->
  # class ED
    # dispatchEvent: (type) ->
      # bean.fire(this, type)

define ['EventDispatcher', 'cs!GetterSetter'], (EventDispatcher) ->
  # http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/utils/Timer.html
  class Timer extends EventDispatcher # extends EventDispatcher
    ## Public Properties
    # currentCount : int [read-only] The total number of times the timer has fired since it started at zero.
    @getter 'currentCount', -> @_currentCount
    
    # delay : Number The delay, in milliseconds, between timer events.
    @getter 'delay', -> @_delay
    @setter 'delay', (@_delay) -> 

    # repeatCount : int The total number of times the timer is set to run.
    @getter 'repeatCount', -> @_repeatCount
    @setter 'repeatCount', (@_repeatCount) -> 
    
    # running : Boolean [read-only] The timer's current state; true if the timer is running, otherwise false.
    @getter 'running', -> @_isRunning
    ## 
        
    ## Public Methods
    # Timer(delay:Number, repeatCount:int = 0) Constructs a new Timer object with the specified delay and repeatCount states.
    constructor: (@_delay, @_repeatCount = 0) ->
      @_intervalID = null
      @_currentCount = 0
      @_isRunning = false # Don't manually reset this, do it in a method that removes the timer

    # reset():void Stops the timer, if it is running, and sets the currentCount property back to 0, like the reset button of a stopwatch.
    reset: ->
      @stop()
      @_currentCount = 0
      return
    
    # start():void Starts the timer, if it is not already running.
    start: ->
      return if @_isRunning
      @_intervalID = setInterval(@_onInterval, @_delay)
      @_isRunning = true
      return

    # stop():void Stops the timer. When start() is called after stop(), the timer instance runs for the remaining
    #             number of repetitions, as set by the repeatCount property.
    stop: ->
      return unless @_isRunning
      clearInterval(@_intervalID)
      @_intervalID = null
      @_isRunning = false
      return
    
    _onInterval: =>
      if ++@_currentCount >= @_repeatCount
        @stop()
        @_dispatchComplete() # Should it trigger an interval trigger AND a completion?
      else
        @_dispatchInterval()
      return

    # _addEventListener: (type, fn) ->
      # bean.on(this, type, fn)

    _dispatchInterval: ->
      # bean.fire(this, "timer")
      @dispatchEvent("timer")

    _dispatchComplete: ->
      # bean.fire(this, "timerComplete")
      @dispatchEvent("timer")
      @dispatchEvent("timerComplete")
        






## Events
# timer Dispatched whenever a Timer object reaches an interval specified according to the Timer.delay property. Timer
# timerComplete Dispatched whenever it has completed the number of requests set by Timer.repeatCount. Timer




