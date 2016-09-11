define ['cs!PokerToolbar'], (PokerToolbar) ->
  fzi = (Zynga, zoomHost = "chips5.nt4.com") ->
    pokerToolbar = new PokerToolbar
             # connect: (host,     port,                    password,           zid,           firstName, lastName,   pictureURL,                                                                                                                                                                                           friendZIDs, hiddenPresence = false) ->
    pokerToolbar.connect zoomHost, Zynga.zoomInfo.zoomPort, Zynga.zoomInfo.zpw, Zynga.our_zid, Zynga.our_name, "n/a", "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfa1/v/t1.0-1/35162_118841968161841_4370335_n.jpg?oh=ca250fdb8de997f1728465d8bb34456c&oe=559A7A5E&__gda__=1436097833_9c0d9af67f4adbce3549edb7f586e133", ["1:4", Zynga.our_zid]
    return pokerToolbar
  return fzi


# 1%201%20n%2Fa%20n%2Fa%2040518954%2096
# 1%201%20undefined%20n%2Fa

# 1 1 n/a n/a 40518954 96
# 1 1 undefined n/a

# Hawa >>> 4 ochat to:1:Darla msg:tableInvitation\x00<
# Hawa >>> 4 ochat to:1:Darla msg:toolbarInvitation\x00<
# Darla <<< ichat private 1:Hawa tableInvitation\x00<
# Darla <<< ichat private 1:Hawa toolbarInvitation\x00<
