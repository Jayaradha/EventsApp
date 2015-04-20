//
//  MasterViewController.swift
//  EventsApp
//
//  Created by Arivoli Tirouvingadame on 4/5/15.
//  Copyright (c) 2015 olisource. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var postsCollection = [Post]()
    var service:PostService!
    var imageCache = [String : UIImage]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "EventApp"
        self.navigationController?.navigationBar.barTintColor = UIColorFromRGB(0x99CCFF)
        // Do any additional setup after loading the view, typically from a nib.
        //
        //        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        //        self.navigationItem.rightBarButtonItem = addButton
        
        service = PostService()
        service.getPosts {
            (response) in
            self.loadPosts(response)
        }
    }
    
    func loadPosts(posts : NSArray) {
        var items:NSArray! = posts[0]["events"] as?NSArray
        for item in items{
            var eventid:Int! = (item["eventid"]! as String).toInt()
            var eventdate  = item["eventdate"]! as String
            var eventname = item["eventname"]! as String
            var eventdesc = item["eventdesc"]! as String
            var eventguest = item["eventguest"]! as String
            var eventimage = item["eventimage"]! as String
            var eventlocation = item["eventlocation"]! as String
            var strdate = item["strdate"]! as String
            var postObj = Post(eventid:eventid,eventdate:eventdate,eventname:eventname,eventdesc:eventdesc,eventguest:eventguest,eventimage:eventimage,eventlocation:eventlocation,strdate:strdate)
            postsCollection.append(postObj)
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let post = postsCollection[indexPath.row]
                (segue.destinationViewController as DetailViewController).detailItem = post
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsCollection.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        let object = postsCollection[indexPath.row]
        cell.textLabel?.text = object.eventname + object.eventguest
        cell.detailTextLabel?.text = object.eventname + object.eventguest
        var image = self.imageCache["thumb"]
        
        if( image == nil ) {
            // If the image does not exist, we need to download it
            var imgURL: NSURL? = NSURL(string: "http://www.gmail.com/\(object.eventimage)")
            
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    image = UIImage(data: data)
                    
                    // Store the image in to our cache
                    self.imageCache["thumb"] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                            cellToUpdate.imageView?.image = image
                        }
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                    cellToUpdate.imageView?.image = image
                }
            })
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    /*override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    postsCollection.removeAtIndex(indexPath.row)
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    }*/
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
