//
//  NewsFeedTableViewController.swift
//  InstaGive
//
//  Created by ben on 16/12/2014.
//  Copyright (c) 2014 Ben Chamla. All rights reserved.
//

import UIKit

class NewsFeedTableViewController: UITableViewController {

    var descriptions = [String]()
    var usernames = [String]()
    var imagesPosted = [UIImage]()
    var profilePics = [UIImage]()
    var imageFiles = [PFFile]()
    var followedUser = [String]()
    var refresher: UIRefreshControl!
    var UniqueArray = [""]
    var  isInUnicArr = 0
    var imageShownCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
     
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
        return descriptions.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell: NewsFeedCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as NewsFeedCell

        // Configure the cell...
        myCell.descriptionLabel.text = descriptions[indexPath.row]
        myCell.userNameLabel.text = usernames[indexPath.row]
        
        imageFiles[indexPath.row].getDataInBackgroundWithBlock{(imageData: NSData!, error: NSError!) ->Void in
            
            if error == nil {
                let image = UIImage(data: imageData)
                myCell.postedImage.image = image
            }
            }
        return myCell
    }
    
    func UpdateNewsFeed(){
        println("started")
        
        var getFollowedUsersQuery = PFQuery(className: "followers")
        getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.currentUser().username)
     
        getFollowedUsersQuery.findObjectsInBackgroundWithBlock ({
            (followers: [AnyObject]!, error: NSError!) -> Void in
            
            
           

            if error == nil {
                // The find succeeded.
                
                // Do something with the found objects
                
                self.followedUser = []
                for object in followers {
                    
                    self.followedUser.append(object["following"] as String)
                    
                }
                
               self.UniqueArray = [] 
               self.arrayUnic(self.followedUser)
                
                
            }
            
            
            var query = PFQuery(className:"Post")
            query.whereKey("username", containedIn: self.UniqueArray)
            query.orderByDescending("createdAt")
            query.limit = 4
            query.findObjectsInBackgroundWithBlock ({
                (posts: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    // The find succeeded.
                    
                    // Do something with the found objects
                    
                        self.descriptions = []
                        self.usernames = []
                        self.imageFiles = []

                        for object in posts {
                                self.descriptions.append(object["title"] as String)
                                self.usernames.append(object["username"] as String)
                                self.imageFiles.append(object["imageFile"] as PFFile)
                            
                        }
                    self.imageShownCount += 4
                        self.tableView.reloadData()
                    
                    
                } else {
                    // Log details of the failure
                    println(error)
                }
            })
        })
        self.refresher.endRefreshing()
        println("end")
    }
    
    
    func refresh() {
        println("refreshed")
        UpdateNewsFeed()
    }

    func arrayUnic(array: NSArray) {
    
    UniqueArray = [PFUser.currentUser().username]
        for  var i = 0 ; i < array.count ; i++ {
             isInUnicArr = 0
            for var j = 0 ; j < UniqueArray.count ; j++ {
                if array[i] as NSString == UniqueArray[j]{
                    
                    isInUnicArr++
                }
            }
            
            if isInUnicArr == 0 {
                UniqueArray.append(array[i] as NSString)
            }
        }
        println(UniqueArray)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UpdateNewsFeed()
    }
    
    

    @IBAction func loadMoreButtonPressed(sender: AnyObject) {
        var getFollowedUsersQuery = PFQuery(className: "followers")
        getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.currentUser().username)

        getFollowedUsersQuery.findObjectsInBackgroundWithBlock ({
            (followers: [AnyObject]!, error: NSError!) -> Void in
            
            
            
            
            if error == nil {
                // The find succeeded.
                
                // Do something with the found objects
                
                self.followedUser = []
                for object in followers {
                    
                    self.followedUser.append(object["following"] as String)
                    
                }
                
                self.UniqueArray = []
                self.arrayUnic(self.followedUser)
                
                
            }
            
            
            var query = PFQuery(className:"Post")
            query.whereKey("username", containedIn: self.UniqueArray)
            query.orderByDescending("createdAt")
            query.skip = self.imageShownCount
            query.limit = 4
            query.findObjectsInBackgroundWithBlock ({
                (posts: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    // The find succeeded.
                    
                    // Do something with the found objects
                    
                    
                    
                    for object in posts {
                        self.descriptions.append(object["title"] as String)
                        self.usernames.append(object["username"] as String)
                        self.imageFiles.append(object["imageFile"] as PFFile)
                        
                    }
                    self.tableView.reloadData()
                    self.imageShownCount += 4
                    
                } else {
                    // Log details of the failure
                    println(error)
                }
            })
        })
        self.refresher.endRefreshing()
        println("end")

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
