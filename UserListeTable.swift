//
//  UserListeTable.swift
//  InstaGive
//
//  Created by ben on 15/12/2014.
//  Copyright (c) 2014 Ben Chamla. All rights reserved.
//

import UIKit

class UserListeTable: UITableViewController {

    var users = [""]
    var userIsfollowing = [String]()
    var following = [Bool]()
    var refresher: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        UpdateUserTable()
        
        println(PFUser.currentUser())
                refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return users.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        
        if following.count > indexPath.row {
        if following[indexPath.row] {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
        cell.textLabel?.text = users[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
       
        if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            var query = PFQuery(className:"followers")
            query.whereKey("follower", equalTo: PFUser.currentUser().username)
            query.whereKey("following", equalTo: cell.textLabel?.text)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    // The find succeeded.
                    
                    // Do something with the found objects
                    for object in objects {
                       object.deleteInBackgroundWithBlock(nil)
                    }
                } else {
                    // Log details of the failure
                    println(error)
                }
            }
            
        }else {
        
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            var following = PFObject(className: "followers")
            following["following"] = cell.textLabel?.text
            following["follower"] = PFUser.currentUser().username
            
            following.saveInBackgroundWithBlock(nil)
       
        }
    }

    func UpdateUserTable(){
        var queryUser = PFUser.query()
        
        queryUser.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            
            self.users.removeAll(keepCapacity: true)
            
            for object in objects {
                
                var user:PFUser = object as PFUser
                
                
                
                if user.username != PFUser.currentUser().username {
                    self.users.append(user.username)
                    //this is the method of the tutorial... but it is really not scalable
                    /* isFollowing = false
                    
                    var query = PFQuery(className:"followers")
                    query.whereKey("follower", equalTo: PFUser.currentUser().username)
                    query.whereKey("following", equalTo: user.username)
                    query.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]!, error: NSError!) -> Void in
                    if error == nil {
                    // The find succeeded.
                    
                    // Do something with the found objects
                    for object in objects {
                    isFollowing = true
                    self.tableView.reloadData()
                    
                    }
                    
                    self.following.append(isFollowing)
                    
                    } else {
                    // Log details of the failure
                    println(error)
                    }
                    }*/
                    
                }
            }
            
            
            var queryFollower = PFQuery(className:"followers")
            queryFollower.whereKey("follower", equalTo: PFUser.currentUser().username)
            
            queryFollower.findObjectsInBackgroundWithBlock ({
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    // The find succeeded.
                    
                    // Do something with the found objects
                    for object in objects {
                        var followUser = object as PFObject
                        
                        self.userIsfollowing.append(followUser.objectForKey("following") as String)
                        
                    }
                    
                    
                } else {
                    // Log details of the failure
                    println(error)
                }
                
                var isFollowing = false
                for userItem in self.users {
                    isFollowing = false
                    for followingItem in self.userIsfollowing{
                        
                        if userItem == followingItem {
                            
                            isFollowing = true
                        }
                    }
                    self.following.append(isFollowing)
                    
                }
                
                self.tableView.reloadData()
                self.refresher.endRefreshing()
            })
        })

    }
    
    func refresh() {
        println("refreshed")
        UpdateUserTable()
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
