define ['EventDispatcher'], (EventDispatcher) ->
  class UserPresence extends EventDispatcher
    constructor: (@sZid, @nGameId, @nServerId, @nRoomId, @sRoomDesc, @sFirstName, @sLastName, @sRelationship, @sPicURL, @sFriendIds, @tableStakes="", @nChipStack=-1, @nLevel=-1) ->
      @LOBBY_ROOM_ID = -1

    dispatchEvents: () ->
      @dispatchEvent 'updated'

# vim: set ts=2 sts=2 sw=2 et:
