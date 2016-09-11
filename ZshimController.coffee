# Converted to javascript-ish with
# %s@\v: (com.[a-zA-Z0-9_.]+|void|String|Number|int|uint|Boolean|Float|void|Double| \* )@ /* & */ @g
# %s/: \*= / = /g
# %s/: \* ;/;
# %s/for each/for/g
# %s/\v(arg[0-9]+) \/\* : ([^ ]+) \*\/  \= ([^),]+)/\1 \/* \3 \*\//g
# %s/\v^(\s+)(var [a-zA-Z_][a-zA-Z_0-9]+): ([^,; ]+)/\1\2 \/* \3 *\//g
##
# Imrpoved imports
#
# (Converted) to javascript-ish with
#
# "" Function Arguments
# " Remove crap after function arguments with defaults arg1: type = blah
# Search:
# \v(arg[0-9]+): (([a-zA-Z0-9_.]+|\* )( \= )|\*\= )([^,)]+)
# Replace:
# %s/\v(arg[0-9]+): (([a-zA-Z0-9_.]+|\* )( \= )|\*\= )([^,)]+)/\1/g
#
# " Remove type spec of function arguments
# %s/\v(arg[0-9]+): ([a-zA-Z0-9_.]+|\*)([^,)]+)/\1/g
#
# "" Variables
# " With default values (include const)
# \v(^\s+var )([a-zA-Z_][a-zA-Z0-9_]+):[^=]+\= ([^;]+);
# %s/\v(^\s+)(var|const) ([a-zA-Z_][a-zA-Z0-9_]+):[^=]+\= ([^;]+);/\1var \3 = \4;/
#
# " Without default values
# \v(^\s+var )([a-zA-Z_][a-zA-Z0-9_]+)(:[^;]+);
# %s/\v(^\s+var )([a-zA-Z_][a-zA-Z0-9_]+)(:[^;]+);/\1\2;/
#
# "" Function Return Types
# \v(function )(.*\)):(.*)\{
# %s/\v(function )(.*\)):(.*)\{/\1\2 \/* \3 *\/ {
##
##
# coffeescript conversions done with
# %s/ = (\([^)]\+\)) ->/: (\1) ->
# '<,'>s/\(\s\+\)\([^ ]\+\) = /\1@\2:
##
# package  {
# import *;
# import *;
# import *;
# import *;
# import flash.events.*;
# import flash.net.*;
# import flash.system.*;
# import flash.utils.*;


define ['cs!UserPresence', 'cs!PodSocket', 'EventDispatcher', 'cs!Timer', 'cs!ZshimEvent', 'cs!GetterSetter'], (UserPresence, PodSocket, EventDispatcher, Timer, ZshimEvent, gs) ->
  class ZshimController extends EventDispatcher
      constructor: (arg1) ->
          @msgQ = new Array
          @commandBuffer = new Array
          # return
          # can't really see why this needs or wants to be a singleton
          super()
          if ZshimController.mSingletonInst or arg1 == null
              throw new Error('ZshimController class cannot be instantiated')
          ZshimController.mSingletonInst = this
          return

      sendGameSwfLoadedResponse: ->
          @sendMsg '4 ochat to:' + @user.sZid + ' msg:gameSwfLoadedCallback'
          return

      sendToolbarPlayerStatus: (arg1) ->
          if arg1
              @sendMsg '4 hide ' + arg1
          return

      sendToolbarInvitationRemove: (arg1) ->
          if arg1
              @sendMsg '4 ochat to:' + @user.sZid + ' msg:' + encodeURIComponent('toolbarInvitationRemove ' + arg1)
          return

      # msg:gameInfo:55 -1 n/a 0 557578081 NaN
      updateGameInfo: (nServerId = @user.nServerId, nRoomId = 1, sRoomDesc="n/a", tableStakes='', nChipStack=Zynga.our_points, nLevel=if Zynga.our_level? then Zynga.our_level else -1) ->
          if @user.nServerId == nServerId and @user.nRoomId == nRoomId and @user.tableStakes == tableStakes and nChipStack == -1 and nLevel == -1
              return
          @user.nServerId = nServerId
          @user.nRoomId = nRoomId
          @user.sRoomDesc = sRoomDesc
          if tableStakes? then @user.tableStakes = tableStakes
          nLevel = 1 unless nLevel?
          if tableStakes? then @user.tableStakes = tableStakes
          else @user.tableStakes = ""
          loc1 = ''
          loc1 += String(@user.nServerId)
          loc1 += ' ' + @user.nRoomId
          loc1 += ' ' + @user.sRoomDesc
          loc1 += if tableStakes == '' then ' 0' else ' ' + tableStakes
          loc1 += ' ' + nChipStack
          loc1 += ' ' + nLevel
          @sendMsg '4 update scope:both msg:gameInfo:' + encodeURIComponent(loc1) + ' gid:' + @user.nGameId
          return

      # not called internally
      registerMessageHandler: (arg1) ->
          if !@_handlers
              @_handlers = []
              addEventListener  this,  ZOOM_UPDATE,              @onZoomUpdate
              addEventListener  this,  ZOOM_ADD_FRIEND,          @onZoomAddFriend
              addEventListener  this,  ZOOM_REMOVE_FRIEND,       @onZoomRemoveFriend
              addEventListener  this,  ZOOM_SOCKET_CLOSE,        @onZoomSocketClose
              addEventListener  this,  ZOOM_SHOUT,               @onZoomShout
              addEventListener  this,  ZOOM_TABLE_INVITATION,    @onZoomTableInvitation
              addEventListener  this,  ZOOM_LEADERBOARD_UPDATE,  @onLeaderboardGetUpdate
          if @_handlers.indexOf(arg1) == -1
              @_handlers.push arg1
          return

      # not called internally
      unregisterMessageHandler: (arg1) ->
          loc1 = 0
          if @_handlers and arg1
              loc1 = @_handlers.indexOf(arg1)
              if loc1 != -1
                  @_handlers = @_handlers.splice(loc1, 1)
          return

      # this does absolutely nothing
      broadcastMessage: (functionName, args) ->

      # therefore, all these do nothing either
      onLeaderboardGetUpdate:  (arg1)  ->  @broadcastMessage  'onLeaderboardGetUpdate',  arg1
      onZoomAddFriend:         (arg1)  ->  @broadcastMessage  'onZoomAddFriend',         arg1
      onZoomRemoveFriend:      (arg1)  ->  @broadcastMessage  'onZoomRemoveFriend',      arg1
      onZoomShout:             (arg1)  ->  @broadcastMessage  'onZoomShout',             arg1
      onZoomSocketClose:       (arg1)  ->  @broadcastMessage  'onZoomSocketClose',       arg1
      onZoomTableInvitation:   (arg1)  ->  @broadcastMessage  'onZoomTableInvitation',   arg1
      onZoomToolbarJoin:       (arg1)  ->  @broadcastMessage  'onZoomToolbarJoin',       arg1
      onZoomUpdate:            (arg1)  ->  @broadcastMessage  'onZoomUpdate',            arg1

      getSessionCommand: ->
          loc1 = new Array('4', 'session')
          loc1.push 'uid:' + @user.sZid
          loc1.push 'gid:' + @user.nGameId
          if @user.sFriendIds
              loc1.push 'friends:' + @user.sFriendIds
          if @user.sFirstName or @user.sLastName
              loc1.push 'name:' + encodeURIComponent((if @user.sFirstName then @user.sFirstName else 'n/a') + ' ' + (if @user.sLastName then @user.sLastName else 'n/a'))
          if @user.sPicURL
              loc1.push 'image:' + encodeURIComponent(@user.sPicURL)
          loc1.push 'gameInfo:' + encodeURIComponent(@user.nServerId + ' ' + @user.nRoomId + ' ' + @user.sRoomDesc + ' ' + @user.tableStakes)
          if @password
              loc2 = @password.split(':')
              if loc2.length == 2
                  loc1.push 'SKEY:' + loc2[0]
                  loc1.push 'timestamp:' + loc2[1]
          loc1.push 'notif:1'
          if @hidePresence
              loc1.push 'hide:1'
          loc1.join ' '

      reconnect: ->
        if yes
          if @reconnectTimer == null or !@reconnectTimer.running
              if @reconnectTimer == null
                  @reconnectTimer = new (Timer)(5000, 1)
              @reconnectTimer.addEventListener "timer", @onReconnectTimer
              @reconnectTimer.start()
          return

      onReconnectTimer: (arg1) =>
          @reconnectTimer.stop()
          @reconnectTimer.removeEventListener "timer", @onReconnectTimer
          @reconnectAttempts = @reconnectAttempts + 1
          if @reconnectAttempts <= @reconnectAttemptsMax
            if !(@socket == null) and @socket.connected
              @socket.close()
            @connect()
          return

      connect: () ->
          # @heartbeatDelay = heartbeatDelay
          if @host == null or @port == -1
              return
          if @doReconnect and @socket?
              @socket.close()

          @doReconnect = false
          if @socket is null or @socket.connected
            @msgQ.splice 0, 0, @getSessionCommand()
            @isConnecting = true
            try
                  @socket = new PodSocket @host, @port
                  @socket.addEventListener  "ioError",        @onSocketIOError
                  @socket.addEventListener  "securityError",  @onSocketSecurityError
                  @socket.addEventListener  "connect",        @onSocketConnect
                  @socket.addEventListener  "close",          @onSocketClose
                  @socket.addEventListener  "socketData",     @onSocketData
                  @socket.connect()
            catch error
                console.debug "ZshimController::connect exception: ", error.message
          return

      disconnect: ->
          @sendMsg 'quit'
          return

      sendMsg: (message, isStatMaybe) ->
          @msgQ.push message
          if @connected
            result = @processMsg()
            if message.indexOf('heartbeat') < 0
              @startHeartbeatTimer()
          else if !@isConnecting and isStatMaybe
              @reconnect()
          if !result and !isStatMaybe
              @msgQ.shift()
          result

      consolidateCommands: ->
          loc1 = false
          loc2 = ''
          arrayBuf = new Array
          while @msgQ.length > 0
            loc3 = @msgQ.shift()
            if (loc5 = loc3.split(' ')).length > 1
              loc6 = loc5[1]
              switch loc6
                  when 'session'
                    loc1 = true
                    continue
                  when 'update'
                    loc2 = loc3
                    continue
                  else
                    break
            arrayBuf.push loc3
          if loc2.length > 0
            arrayBuf.unshift loc2
          if loc1
            arrayBuf.unshift @getSessionCommand()
          @msgQ = arrayBuf
          return

      processMsg: ->
          @consolidateCommands()
          while @msgQ.length > 0
            loc1 = @msgQ.shift()
            @socket.writeUTFBytes loc1 + "\x00"
            # @socket.writeByte 0
            @socket.flush()
          true

      onSocketSecurityError: (event) =>
          @connected = false
          @isConnecting = false
          @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_SOCKET_ERROR, null)
          @stopHeartbeatTimer()
          return

      onSocketIOError: (event) =>
          console.info "ZshimController::onSocketIOError"
          @connected = false
          @isConnecting = false
          @socket = null
          @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_SOCKET_ERROR, null)
          @stopHeartbeatTimer()
          return

      onSocketConnect: (event) =>
          @connected = true
          @hasConnected = true
          @isConnecting = false
          @processMsg()
          @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_SOCKET_CONNECT, null)
          @startHeartbeatTimer()
          return

      onSocketClose: (event) =>

          console.info "ZshimController::onSocketClose"
          @connected = false
          @isConnecting = false
          @socket = null
          @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_SOCKET_CLOSE, null)
          @stopHeartbeatTimer()
          @reconnect()
          return

      getUserPresence: (sZid, nSessionNumber, gameInfoEncoded, fullName, sPicURL) ->
          loc11 = null
          nServerId = -1
          nRoomId = -1
          sRoomDesc = 'Lobby'
          gameInfo = decodeURIComponent(gameInfoEncoded).split(' ')
          tableStakes = ''
          nChipStack = -1
          nLevel = -1
          if gameInfo.length >= 3
            if gameInfoEncoded.indexOf(':', 0) == -1
                  nServerId = if gameInfo[0] != 'n/a' then gameInfo[0] else -1
            else
                  loc11 = gameInfo[0].split(':')
                  nServerId = if gameInfo[0] != 'n/a' then loc11[1] else -1
            nRoomId = if gameInfo[1] != 'n/a' then gameInfo[1] else -1
            sRoomDesc = if gameInfo[2] != 'n/a' then gameInfo[2] else 'Lobby'
            if gameInfo[3] != null
                  tableStakes = gameInfo[3]
            if gameInfo.length == 6
                  if gameInfo[4] != null
                      nChipStack = Number(gameInfo[4])
                  if gameInfo[5] != null
                      nLevel = Number(gameInfo[5])
          loc8 = decodeURIComponent(fullName).split(' ')
          sFirstName = fullName
          sLastName = ''
          if loc8.length >= 2
            sFirstName = if loc8[0] != 'n/a' then loc8[0] else ''
            sLastName = if loc8[1] != 'n/a' then loc8[1] else ''
          new (UserPresence)(sZid, nSessionNumber, nServerId, nRoomId, sRoomDesc, sFirstName, sLastName, '', sPicURL, '', tableStakes, nChipStack, nLevel)

      onSocketData: (event) =>
          str = "" + event.data
          # @socket.readBytes str, 0, @socket.bytesAvailable
          for char in str
            if char is "\x00"
              @commandBuffer.push @inBuffer
              @inBuffer = ''
            else
              @inBuffer += char
          @processCommand()
          return

      processCommand: ->
          while @commandBuffer.length > 0
            line = @commandBuffer.shift()
            console.info("processCommand #{@commandBuffer.length}: " + line)
            words = line.split(' ')
            word0 = words[0]
            switch word0
              when 'pres' #
                  #   0     word 1   2 3    word 4        word 5         word 6            word 7
                  # pres 1:528061310 1 on Paolo_Guevarra https%3A// 109_440_N/A_2K/4K_1 status:existlogin
                  # pres 1:528061310 1 on Paolo_Guevarra https%3A// 0_0_n/a             status:newlogin
                  if words[3] isnt 'on'
                    userPresence = @getUserPresence(words[1], @user.nGameId, '', '', '')
                    @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_REMOVE_FRIEND, userPresence)
                  else
                    userPresence = @getUserPresence(words[1], words[2], words[6], words[4], words[5])
                    @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_ADD_FRIEND, userPresence)
                  continue
              when 'groupIdList'
                  loc5 = words[2].split(':::')
                  loc6 = 0
                  while loc6 < loc5.length
                    loc8 = (loc7 = loc5[loc6].split('::'))[0]
                    loc9 = loc7[1].split(',')
                    loc10 = 0
                    while loc10 < loc9.length
                      loc11 = loc9[loc10].split('&')
                      loc12 = @getUserPresence(loc11[0], @user.nGameId, loc11[3], loc11[1], loc11[2])
                      if @user.sZid != loc12.sZid
                          @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_ADD_NETWORK, loc12)
                      ++loc10
                    ++loc6
                  continue
              when 'presLogon'
                  loc13 = decodeURIComponent(words[3]).split('&')
                  loc14 = @getUserPresence(words[1], @user.nGameId, loc13[2], loc13[0], loc13[1])
                  @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_ADD_NETWORK, loc14)
                  continue
              when 'presLogoff'
                  @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_REMOVE_NETWORK, @getUserPresence(words[1], @user.nGameId, '', '', ''))
                  continue
              when 'updateNotify' # used updateNotify 1:528061310 gameInfo:153%201%20N%2FA%20%201 [gameInfo:153 1 N/A  1]
                  @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_UPDATE, @getUserPresence(words[1], @user.nGameId, words[2], '', ''))
                  continue
              when 'ichat' # used #   ichat private 1:705934206 toolbarInvitationRemove%20clearall
                  words3 = decodeURIComponent(words[3]).split(' ') # toolbarInvitationRemove, clearall
                  word3_0 = words3[0]
                  switch word3_0
                    when 'tableInvitation'
                        zidword2 = String(words[2])
                        @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_TABLE_INVITATION, new (ZoomTableInvitationMessage)(zidword2))
                    when 'profileReq'
                      zidword2 = String(words[2])
                      (loc19 = new Object).uid = zidword2
                      @dispatchEvent new (ZshimEvent)(ZshimEvent.ZOOM_PROFILE_REQUEST, loc19)
                      break
                    when 'profileURL'
                      zidword2 = String(words[2])
                      loc20 = String(words3[1])
                      @dispatchEvent new (ZoomProfileURLMessage)(ZshimEvent.ZOOM_PROFILE_MESSAGE, zidword2, loc20)
                      break
                    when 'toolbarInvitation' # used
                      zidword2 = String(words[2])
                      (loc21 = new Object).uid = zidword2
                      @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_TOOLBAR_INVITATION, loc21)
                      break
                    when 'toolbarJoin'
                      zidword2 = String(words[2])
                      loc22 = String(words3[1])
                      (loc23 = new Object).uid = loc22
                      @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_TOOLBAR_JOIN, loc23)
                      break
                    when 'gameSwfLoadedCallback'
                      @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_TOOLBAR_GAMESWFLOADEDCALLBACK)
                      break
                    when 'toolbarInvitationRemove' # used
                      zidword2 = String(words[2])
                      (loc24 = new Object).uid = String(words3[1])
                      @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_TOOLBAR_INVITATIONREMOVE, loc24)
                      break
                    when 'updateLeaderBoard'
                      @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_LEADERBOARD_UPDATE)
                      break
                    when 'zoomShout'
                      if (zidword2 = String(words[2])) == '1' or zidword2 == '1:1' or zidword2 == @user.sZid
                          @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_SHOUT, String(words[4]))
                      break
                    when 'initiateMiniGames'
                      @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_INITIATE_MINIGAMES)
                      break
                    when 'PlayersClubVIPPointsUpdate'
                      @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_PLAYERSCLUB_VIPUPDATE, String(words[4]))
                      break
                    when 'PlayersClubBigHandReward'
                      @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_PLAYERSCLUB_BIGHANDREWARD, String(words[4]))
                      break
                    when 'PlayersClubPostPurchaseReward'
                      @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_PLAYERSCLUB_POSTPURCHASEREWARD, String(words[4]))
                      break
                    when 'PlayersClubAppEntryReward'
                      @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_PLAYERSCLUB_APPENTRYREWARD, String(words[4]))
                      break
                    when 'XPBoostWithPurchase'
                      @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_XPBOOST_WITH_PURCHASE, String(words[4]))
                      break
                    when 'forceChipUpdate'
                      @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_FORCE_CHIP_UPDATE, String(words[4]))
                      break
                  continue
              when 'hideRequest'
                  loc26 = String(words[1])
                  @dispatchEvent new (ZshimEvent)(ZshimController.ZOOM_TOOLBAR_PLAYERSTATUS, loc26)
                  continue
          return
  ##
  #  new UserPresence(sZid, nGameId, nServerId, nRoomId, sRoomDesc,
  #    sFirstName, sLastName, sRelationship, sPicURL,
  #    sFriendIds, tableStakes, nChipStack, nLevel)
  ##
      # getInstance(loc6.zoomHost, loc6.zoomPort, loc6.zpw, loc5);
      # loc5 = new UserPresence
      # (this.viewer.zid, 1, Number(this.pgData.serverId), this.pgData.rejoinRoom, loc4, loc2, loc3, "n/a",
      # this._configModel.getStringForFeatureConfig("user", "pic_url"), this.zoomGetFriendsList(), this.pgData.gameRoomStakes,
      # this.pgData.points, this.pgData.xpLevel);

      # @getInstance: () ->
        # @_instance = new @ true unless @_instance?
        # @_instance
      @getInstance: (zoomHost, zoomPort, zpw, userPresence, hidePresence = false) ->
          # loc1 = null
          if userPresence == null
            throw new Error('ZshimController.getInstance: invalid UserPresence')
          if !ZshimController.mSingletonInst
            loc1 = new ZshimController 'singleton' # sets mSingletonInst in constructor
          if !ZshimController.mSingletonInst
            console.info "ZshimController.mSingletonInst wasn't set"
            ZshimController.mSingletonInst = loc1
          ZshimController.mSingletonInst.bind zoomHost, zoomPort, zpw, userPresence, hidePresence
          ZshimController.mSingletonInst

      onUserPresenceUpdated: () =>
          userPresence = @user
          @updateGameInfo userPresence.nServerId, userPresence.nRoomId, userPresence.sRoomDesc, \
          userPresence.tableStakes, userPresence.nChipStack, userPresence.nLevel


      bind: (zoomHost, zoomPort, zpw, userPresence, hidePresence) ->
          if !(@host == zoomHost) or !(@port == zoomPort) or !(zpw == zpw)
            @doReconnect = true
            @host = zoomHost
            @port = zoomPort
            @password = zpw
          @hidePresence = hidePresence
          if @user != null
            @updateGameInfo userPresence.nServerId, userPresence.nRoomId, userPresence.sRoomDesc, \
            userPresence.tableStakes, userPresence.nChipStack, userPresence.nLevel
          else
            @user = userPresence
            @user.addEventListener 'updated', @onUserPresenceUpdated
          return

      isConnected: ->
          @connected

      startHeartbeatTimer: =>
          console.debug "startHeartbeatTimer"
          unless @heartbeatTimer?
              @heartbeatTimer = new Timer(Math.round(@heartbeatDelay * 60 * 1000))
              @heartbeatTimer.addEventListener "timer", @onHeartbeatTimer
          @heartbeatTimer.reset()
          @heartbeatTimer.start()
          return

      stopHeartbeatTimer: ->
          if @heartbeatTimer
              @heartbeatTimer.reset()
          return

      onHeartbeatTimer: (arg1) =>
          console.debug "onHeartbeatTimer"
          @sendHeartbeat()
          return

      sendToolbarJoin: (arg1) ->
          if arg1
            @sendMsg '4 ochat to:' + @user.sZid + ' msg:' + encodeURIComponent('toolbarJoin ' + arg1)
          return

      sendToolbarInvitation: (arg1) ->
          if arg1
            @sendMsg '4 ochat to:' + arg1 + ' msg:toolbarInvitation'
          return

      sendProfileURL: (arg1, arg2) ->
          if arg2
            @sendMsg '4 ochat to:' + arg2 + ' msg:' + encodeURIComponent('profileURL ' + arg1)
          return

      sendHeartbeat: =>
          console.debug("sendHeartbeat", this.sendMsg)
          @sendMsg '4 ping'
          return

      sendStatRequest: (arg1, arg2, arg3, arg4) ->
          loc1 = null
          if arg1 and arg4 and arg2 and arg3 > 0
            loc1 = '4 stat ' + arg1 + ' ' + arg4 + ' ' + escape(arg2) + ':' + arg3
            return @sendMsg(loc1, false)
          false

      sendProfileReq: (arg1) ->
          if arg1
            @sendMsg '4 ochat to:' + arg1 + ' msg:profileReq'
          return

      sendTableInvitation: (arg8) ->
          if arg1
            @sendMsg '4 ochat to:' + arg1 + ' msg:tableInvitation'
          return

      @mSingletonInst: null
      @ZOOM_REMOVE_NETWORK: 'zoom_remove_network'
      @ZOOM_SOCKET_CONNECT: 'zoom_socket_connect'
      @ZOOM_SOCKET_CLOSE: 'zoom_socket_close'
      @ZOOM_SOCKET_ERROR: 'zoom_socket_error'
      @ZOOM_TABLE_INVITATION: 'zoom_table_invitation'
      @ZOOM_PROFILE_REQUEST: 'zoom_profile_request'
      @ZOOM_TOOLBAR_INVITATION: 'zoom_toolbar_invitation'
      @ZOOM_TOOLBAR_JOIN: 'zoom_toolbar_join'
      @ZOOM_TOOLBAR_GAMESWFLOADEDCALLBACK: 'zoom_toolbar_gameswfloadedcallback'
      @ZOOM_TOOLBAR_PLAYERSTATUS: 'zoom_toolbar_playerstatus'
      @ZOOM_TOOLBAR_INVITATIONREMOVE: 'zoom_toolbar_invitationremove'
      @ZOOM_SHOUT: 'zoom_shout'
      @ZOOM_LEADERBOARD_UPDATE: 'updateLeaderBoard'
      @ZOOM_PLAYERSCLUB_VIPUPDATE: 'PlayersClubVIPPointsUpdate'
      @ZOOM_PLAYERSCLUB_BIGHANDREWARD: 'PlayersClubBigHandReward'
      @ZOOM_PLAYERSCLUB_POSTPURCHASEREWARD: 'PlayersClubPostPurchaseReward'
      @ZOOM_PLAYERSCLUB_APPENTRYREWARD: 'PlayersClubAppEntryReward'
      @ZOOM_INITIATE_MINIGAMES: 'initiateMinigames'
      @ZOOM_XPBOOST_WITH_PURCHASE: 'XPBoostWithPurchase'
      @ZOOM_FORCE_CHIP_UPDATE: 'forceChipUpdate'
      @ZOOM_ADD_NETWORK: 'zoom_add_network'
      @ZOOM_REMOVE_FRIEND: 'zoom_remove_friend'
      @ZOOM_ADD_FRIEND: 'zoom_add_friend'
      @ZOOM_UPDATE: 'zoom_update'
      _handlers: undefined
      socket: null
      commandBuffer: undefined
      inBuffer: ''
      msgQ: undefined
      user: null
      heartbeatDelay: 1
      heartbeatTimer: undefined
      hidePresence: false
      doReconnect: false
      password: ''
      port: -1
      host: ''
      reconnectTimer: null
      reconnectAttempts: 0
      reconnectAttemptsMax: 5
      isConnecting: false
      hasConnected: false
      connected: false

# vim: set ts=4 sts=4 sw=4 et:
