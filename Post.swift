//
//  Post.swift
//  EventsApp
//
//  Created by Arivoli Tirouvingadame on 4/5/15.
//  Copyright (c) 2015 olisource. All rights reserved.
//

import Foundation
class Post {
    var eventid : Int
    var eventdate :String
    var eventname:String
    var eventdesc:String
    var eventguest:String
    var eventimage: String
    var eventlocation:String
    var strdate:String


init(eventid:Int,eventdate:String,eventname:String,eventdesc:String,eventguest:String,eventimage: String,eventlocation:String,strdate:String)
{
    self.eventid = eventid
    self.eventdate = eventdate
    self.eventname = eventname
    self.eventdesc = eventdesc
    self.eventguest = eventguest
    self.eventimage = eventimage
    self.eventlocation = eventlocation
    self.strdate = eventdate
}
}
func toJSON() -> String{
return ""
}
