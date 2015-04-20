//
//  PostService.swift
//  EventsApp
//
//  Created by Arivoli Tirouvingadame on 4/5/15.
//  Copyright (c) 2015 olisource. All rights reserved.
//

import Foundation

class PostService {
    
    var settings : Settings!
    
    init() {
        self.settings = Settings()
    }
    
    func getPosts(callback :(NSArray) -> ()) {
        request(settings.viewPosts, callback: callback)
    }
    
    func request(url:String, callback:(NSArray) -> ()) {
        var nsURl = NSURL(string: url)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(nsURl!, completionHandler: { (data, response, error) -> Void in
            
            if (error != nil) {
                println("API error: \(error), \(error.userInfo)")
            }
            var jsonError:NSError?
            var json:NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as NSArray
            if (jsonError != nil) {
                println("Error parsing json: \(jsonError)")
            }
            else {
                //let items:NSArray! = json[0]["products"] as? NSArray
                //let t:String! = items[0]["tilte"] as? String
                callback(json)
            }
            //var error:NSError?
            //var response = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
            //callback(response)
            
        })
        task.resume()
    }
}