define 'PodSocket', ['EventDispatcher'], (EventDispatcher) ->
  class PodSocket extends EventDispatcher
    constructor: (@host, @port, @sourceIp = Zynga.info.proxy_src.split(':')[0], @ssl = false) ->
      @sourceIp ="203.26.88.85" unless @sourceIp?
      this.ccid = null

    ## STATIC METHODS AND PROPERTIES TO MANAGE CONNECTIONS
    @connections: {}
    @addConnection: (instance) =>
      @connections[instance.ccid] = instance
      return
    @getConnection: (id) =>
      return @connections[id] if @connections[id]?
      console.error msg = "PodSocket::getConnection cannot find connection '#{id}'"
      throw new Error(msg)
    @onerror:    (event)  => # does this include disconnection?
      console.debug("PodSocket::onerror", event)
      @getConnection(event.crossConnectError.id).onerror({}) # no useful data in event
      delete @connections[event.crossConnectError.id]
    @onclose:    (event)  =>
      console.debug("PodSocket::onclose", event)
      @getConnection(event.crossConnectData.id).onclose()
    @onopen:     (event)  =>
      console.debug("PodSocket::onopen", event)
      @getConnection(event.crossConnected.id).onopen({}) # no useful data in event
    @input:      (event)  =>
      console.debug("PodSocket::input", event)
      if event.crossConnectData.data.length is 0
           @onclose(event)
      else @getConnection(event.crossConnectData.id).ondata(event.crossConnectData.data)
    @create: (host, port, sourceIp, ssl) =>
      newConnection = new @ host, port, sourceIp, ssl

    ## INSTANCE METHODS AND PROPERTIES PER CONNECTION
    connect: =>
      self = this
      fz 'crossConnect', { sourceip: @sourceIp, host: @host, port: @port, ssl: @ssl }, (res) ->
        self.ccid = res.id
        # How do you call a static method from a closure? We can't assign a variable to point
        # to it, since it's not visible during construction.  self.addConnection does not exist.
        # this is pointed to the Window.  Just have to call it by it's name.
        PodSocket.addConnection self
        console.log("connect:", PodSocket.addConnection is self.addConnection)
      return this
    onclose:    (event)  =>  @dispatchEvent  "close",      target: this
    onerror:    (event)  =>  @dispatchEvent  "ioError",    target: this, event: event
    onopen:     (event)  =>  @dispatchEvent  "connect",    target: this
    ondata:     (data)   =>
        @dispatchEvent  "socketData", target: this, data: data
        arrows = "<<"
        simplelog "PodSocket #{arrows} " + data.replace /[\0-\x1f]/g, (c) ->
          return "" + "\\x" + ("00" + c.charCodeAt(0).toString(16)).substr(-2)

    output: (togo, flags) => # flags = MSG_MORE: 1
      if flags?.MSG_MORE?
        arrows = ".>"
      else
        arrows = ">>"
      simplelog "PodSocket #{arrows} " + togo.replace /[\0-\x1f]/g, (c) ->
        return "" + "\\x" + ("00" + c.charCodeAt(0).toString(16)).substr(-2)
      fz 'send', { id: this.ccid, data: togo }, null, flags

    _more: MSG_MORE: 1
    writeUTFBytes:  (togo,  flags=null)  ->  @output  togo,                      flags
    writeByte:      (byte,  flags=null)  ->  @output  String.fromCharCode(byte), flags
    write:          (togo,  flags=null)  ->  @output  togo,                      flags
    writeLn:        (togo,  flags=null)  ->  @output  togo + "\x17",             flags
    send:           (togo,  flags=null)  ->  @output  togo,                      flags
    flush:                               ->
    close:                               ->  @disconnect()
    disconnect: () ->
      fz 'disconnect', id: @ccid
      @onclose {}


## TEST CODE
  # if yes
    # require ['PodSocket'], (ps) ->
      # window.PodSocket = this.PodSocket = ps
      # if no
        # window.c = PodSocket.create("50.115.117.177", 25, "203.26.88.85", false)

        # ondata = (event)->
          # code = event.data.split(' ')[0]
          # c.writeLn("RSET") if code is "220"
          # c.writeLn("QUIT") if code is "250"

        # c.addEventListener('socketData', ondata);
        # c.connect();

# vim: set ts=2 sts=2 sw=2 et:
