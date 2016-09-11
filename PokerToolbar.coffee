define ['cs!ZshimController', 'cs!UserPresence'], (ZshimController, UserPresence) ->
  class PokerToolbar
        TOOLBAR_ROOM_DESCRIPTION = 'TOOLBAR'
        TOOLBAR_ROOM_ID = -1
        TOOLBAR_SERVER_ID = -100
        @GAME_ID = 1

        get_numberOfFriendsOnline: ->
          if @onlineFriends then @onlineFriends.length else 0
        get_numberOfFriendsAtTables: ->
          loc2 = null
          loc1 = 0
          if @onlineFriends
            loc3 = 0
            loc4 = @onlineFriends
            for loc2 of loc4
              `loc2 = loc2`
              if !(loc2.nRoomId > 0)
                i++
                continue
              ++loc1
          loc1
        onZoomSocketClose: (arg1) ->
          @onlineFriends = []
          return
        onZoomSocketError: (arg1) ->
          @onlineFriends = []
          return
        onZoomAddFriend: (arg1) ->
          @addOrUpdateFriend arg1.msg
          return
        onZoomRemoveFriend: (arg1) ->
          @removeFriend arg1.msg
          return
        onZoomUpdate: (arg1) ->
          @addOrUpdateFriend arg1.msg
          return
        onZoomToolbarInviteReceived: (arg1) ->
          loc2 = null
          loc1 = @getOnlineFriend(arg1.msg.uid)
          if loc1
            loc2 = ''
            loc2 = loc2 + loc1.sZid + ',' + loc1.sFirstName + ',' + loc1.sPicURL
          return
        onZoomToolbarGameSwfLoadedReponse: (arg1) ->
          @gameSwfIsLoaded = true
          return
        onZoomToolbarPlayerStatusReceived: (arg1) ->
          return
        onZoomToolbarInviteRemove: (arg1) ->
          return
        friendsOnlineZids: ->
          loc2 = 0
          loc3 = null
          loc1 = null
          if @onlineFriends
            if @onlineFriends.length
              loc1 = ''
              loc2 = 0
              while loc2 < @onlineFriends.length
                loc3 = @onlineFriends[loc2]
                loc1 = loc1 + loc3.sZid
                if loc2 + 1 < @onlineFriends.length
                  loc1 = loc1 + ','
                ++loc2
          loc1
        addOrUpdateFriend: (arg1) ->
          loc1 = false
          loc2 = 0
          loc3 = null
          if arg1
            loc1 = false
            loc2 = 0
            while loc2 < @onlineFriends.length
              if (loc3 = @onlineFriends[loc2]) and arg1.sZid == loc3.sZid
                @onlineFriends[loc2].nServerId = arg1.nServerId
                @onlineFriends[loc2].nRoomId = arg1.nRoomId
                @onlineFriends[loc2].sRoomDesc = arg1.sRoomDesc
                @onlineFriends[loc2].tableStakes = arg1.tableStakes
                if arg1.sFirstName.length > 0 and !(arg1.sFirstName == 'n/a')
                  @onlineFriends[loc2].sFirstName = arg1.sFirstName
                if arg1.sLastName.length > 0 and !(arg1.sLastName == 'n/a')
                  @onlineFriends[loc2].sLastName = arg1.sLastName
                if arg1.sPicURL.length > 0 and !(arg1.sPicURL == 'n/a')
                  @onlineFriends[loc2].sPicURL = arg1.sPicURL
                loc1 = true
                break
              ++loc2
            if !loc1
              @onlineFriends.push arg1
          return
        removeFriend: (arg1) ->
          loc1 = 0
          loc2 = null
          if arg1
            loc1 = 0
            while loc1 < @onlineFriends.length
              loc2 = @onlineFriends[loc1]
              if loc2 and arg1.sZid == loc2.sZid
                @onlineFriends.splice loc1, 1
                break
              ++loc1
          return
          return
        getOnlineFriend: (arg1) ->
          loc1 = null
          loc2 = 0
          loc3 = @onlineFriends
          for loc1 of loc3
            `loc1 = loc1`
            if arg1 != loc1.sZid
              i++
              continue
            return loc1
          null
        getIsConnected: ->
          if @zoomController and @zoomController.isConnected() then true else false
        getOnlineFriendCount: ->
          @get_numberOfFriendsOnline()
        joinUser: (arg1) ->
          @zidUserToJoin = arg1
          if @zoomController
            @zoomController.sendToolbarJoin arg1
            if no
              if @gameSwfLoadedTimer == null
                @gameSwfIsLoaded = false
                @gameSwfLoadedTimer = new (flash.utils.Timer)(1 * 1000, 1)
#                 @gameSwfLoadedTimer.addEventListener flash.events.TimerEvent.TIMER_COMPLETE, @onGameSwfLoadedTimerComplete
                @gameSwfLoadedTimer.start()
          return
        onGameSwfLoadedTimerComplete: (arg1) ->
          if no
            if @gameSwfLoadedTimer != null
#               @gameSwfLoadedTimer.removeEventListener flash.events.TimerEvent.TIMER_COMPLETE, @onGameSwfLoadedTimerComplete
              @gameSwfLoadedTimer.stop()
              @gameSwfLoadedTimer = null
          return
        updatePlayerStatus: (arg1) ->
          if @zoomController
            @zoomController.sendToolbarPlayerStatus arg1
          return
        removeUserInvite: (arg1) ->
          if @zoomController
            @zoomController.sendToolbarInvitationRemove arg1
          return
        onStartSendingOnlineFriendsToJSTimerComplete: (arg1) ->
          if @startSendingOnlineFriendsToJSTimer != null
#             @startSendingOnlineFriendsToJSTimer.removeEventListener flash.events.TimerEvent.TIMER_COMPLETE, @onStartSendingOnlineFriendsToJSTimerComplete
            @startSendingOnlineFriendsToJSTimer.stop()
            @startSendingOnlineFriendsToJSTimer = null
          return
        onZoomSocketConnect: (arg1) ->
          @onlineFriends = []
          return
        reconnect: ->
          if @zoomController and !@zoomController.isConnected()
            @zoomController.connect @heartbeatDelay
          return
        disconnect: ->
          if @zoomController and @zoomController.isConnected()
            @zoomController.disconnect()
          return
        connect: (host, port, password, zid, firstName, lastName, pictureURL, friendZIDs, hiddenPresence = false) ->
          changingHosts = if !(@host == host) or !(@port == port) then true else false
          @host = host
          @port = port
          @password = password
          @zid = zid
          @firstName = firstName
          @lastName = lastName
          @pictureUrl = pictureURL
          @friendZIDs = friendZIDs
          if zid and host and port and password and friendZIDs
            # constructor:                                      (@sZid,             @nGameId, @nServerId,          @nRoomId,           @sRoomDesc,                           @sFirstName, @last, @sRelationship, @sPicURL, @sFriendIds,        @tableStakes, @nChipStack, @nLevel) ->
            @userPresence = Zynga.userPresence = new UserPresence @zid, PokerToolbar.GAME_ID, Zynga.our_casino_id, Zynga.activeRoomId, PokerToolbar.TOOLBAR_ROOM_DESCRIPTION, @firstName, @lastName, 'n/a', @pictureUrl, @friendZIDs.join(","), 'n/a', Zynga.our_points, Zynga.our_level
            if @zoomController != null
              if changingHosts
                if @zoomController.isConnected()
                   @zoomController.disconnect()
                @zoomController = ZshimController.getInstance(host, int(port), password, @userPresence, hiddenPresence)
                @zoomController.connect @heartbeatDelay
              else if !@zoomController.isConnected()
                @reconnect()
            else
              @zoomController = ZshimController.getInstance(host, port, password, @userPresence, hiddenPresence)
#               @zoomController.addEventListener ZshimController.ZOOM_SOCKET_CONNECT, @onZoomSocketConnect
              @zoomController.addEventListener ZshimController.ZOOM_SOCKET_CLOSE, @onZoomSocketClose
              @zoomController.addEventListener ZshimController.ZOOM_SOCKET_ERROR, @onZoomSocketError
#               @zoomController.addEventListener ZshimController.ZOOM_ADD_FRIEND, @onZoomAddFriend
#               @zoomController.addEventListener ZshimController.ZOOM_REMOVE_FRIEND, @onZoomRemoveFriend
#               @zoomController.addEventListener ZshimController.ZOOM_UPDATE, @onZoomUpdate
#               @zoomController.addEventListener ZshimController.ZOOM_TOOLBAR_INVITATION, @onZoomToolbarInviteReceived
#               @zoomController.addEventListener ZshimController.ZOOM_TOOLBAR_GAMESWFLOADEDCALLBACK, @onZoomToolbarGameSwfLoadedReponse
#               @zoomController.addEventListener ZshimController.ZOOM_TOOLBAR_PLAYERSTATUS, @onZoomToolbarPlayerStatusReceived
#               @zoomController.addEventListener ZshimController.ZOOM_TOOLBAR_INVITATIONREMOVE, @onZoomToolbarInviteRemove
#              @zoomController.connect @heartbeatDelay
#            if @startSendingOnlineFriendsToJSTimer == null
#              @startSendingOnlineFriendsToJSTimer = new (flash.utils.Timer)(1 * 1000, 1)
#               @startSendingOnlineFriendsToJSTimer.addEventListener flash.events.TimerEvent.TIMER_COMPLETE, @onStartSendingOnlineFriendsToJSTimerComplete
#              @startSendingOnlineFriendsToJSTimer.start()
          return
        init: (arg1) ->
          loc1 = NaN
          if !@initComplete
            @initComplete = true
            if arg1['heartbeat']
              loc1 = Number(unescape(arg1['heartbeat']))
              if !isNaN(loc1) and loc1 > 0
                @heartbeatDelay = loc1
            @connect arg1.host, arg1.port, unescape arg1.zpw, arg1.zid, unescape arg1.firstName, unescape arg1.lastName, unescape arg1.picUrl, unescape arg1.friends
          return
        localInit: (arg1) ->
          @init arg1
          return
        constructor: ->
          @onlineFriends = null
          @zoomController = null
          @gameSwfLoadedTimer = null
          @startSendingOnlineFriendsToJSTimer = null
          @onlineFriends = []
          return

        friendZIDs: ''
        pictureUrl: ''
        lastName: ''
        firstName: ''
        zid: ''
        password: ''
        port: ''
        host: ''
        onlineFriends: null
        initComplete: false
        zoomController: null
        heartbeatDelay: 1
        gameSwfLoadedTimer: null
        gameSwfIsLoaded: false
        zidUserToJoin: null
        startSendingOnlineFriendsToJSTimer: null


# vim: set ts=2 sts=2 sw=2 et:
