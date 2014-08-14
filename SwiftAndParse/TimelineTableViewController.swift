//
//  TimelineTableViewController.swift
//  SwiftAndParse
//
//  Created by kiiita on 2014/08/10.
//  Copyright (c) 2014年 Yuto Kitakuni. All rights reserved.
//

import UIKit

class TimelineTableViewController: UITableViewController {
    
    var timelineData:NSMutableArray = NSMutableArray()
    
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    func loadData(){
        timelineData.removeAllObjects()
        
        // call databases
        var findTimelineData:PFQuery = PFQuery(className: "Tweets")
        
        findTimelineData.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!)->Void in
            
            if !error{
                for object in objects{
                    self.timelineData.addObject(object)
                }
                
                let array:NSArray = self.timelineData.reverseObjectEnumerator().allObjects
                self.timelineData = array as NSMutableArray
                
                self.tableView.reloadData()
            }
        }
    }

    
    override func viewDidAppear(animated: Bool) {
        
        // twwetのデータを取得
        self.loadData()
        
        // ログイン、サインアップのアラート
        if (!PFUser.currentUser()) {
            var loginAlert:UIAlertController = UIAlertController(title: "Sign UP / Loign", message: "Plase sign up or login", preferredStyle: UIAlertControllerStyle.Alert)
            
            loginAlert.addTextFieldWithConfigurationHandler({
                textfield in
                textfield.placeholder = "Your username"
            })
            
            loginAlert.addTextFieldWithConfigurationHandler({
                textfield in
                textfield.placeholder = "Your Password"
                textfield.secureTextEntry = true
            })
            
            loginAlert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: {
                    alertAction in
                    let textFields:NSArray = loginAlert.textFields as NSArray
                let usernameTextfield:UITextField = textFields.objectAtIndex(0) as UITextField
                let passwordTextfield:UITextField = textFields.objectAtIndex(1) as UITextField

                var tweeter:PFUser = PFUser()
                tweeter.username = usernameTextfield.text
                tweeter.password = passwordTextfield.text
                
                // Check already registerd user
                var checkExist = PFUser.query()
                checkExist.whereKey("username", equalTo: tweeter.username) // usernameをキーにしてDBを検索
                checkExist.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]!, error: NSError!) -> Void in
                    if(objects.count > 0){
                        println("its username is taken \(objects.count)")
                        self.signIn(tweeter.username, password:tweeter.password) // Login for already registerd user
                    } else {                                                    
                        println("its username hasn't token yet. Let's register!")
                        self.signUp(tweeter) // Sign up for new user
                    }                       
                }
                
                
                
                }))
            
            self.presentViewController(loginAlert, animated: true, completion: nil)
        }
    }
    
    func signIn(username:NSString, password:NSString) {
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser!, error: NSError!) -> Void in
            if user {
                println("existed user")
            } else {
                println("not existed user")
            }
        }
    }
    
    func signUp(tweeter:PFUser) {
        tweeter.signUpInBackgroundWithBlock{
            (success:Bool!, error:NSError!)->Void in
            if !error{
                println("Sign up succeeded.")
            }else{
                let errorString = error.userInfo["error"] as NSString
                println(errorString)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        // データの数だけrowを返す
        return timelineData.count
    }

    
    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell:TweetTableViewCell = tableView!.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TweetTableViewCell
        
        let tweet:PFObject = self.timelineData.objectAtIndex(indexPath!.row) as PFObject
        
        // デザイン部分
        cell.tweetTextView.alpha = 0
        cell.timestampLabel.alpha = 0
        cell.usernameLabel.alpha = 0
        
        // Tweetの内容をParse.comから取得
        cell.tweetTextView.text = tweet.objectForKey("content") as String
        
        var dataFormatter:NSDateFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.timestampLabel.text = dataFormatter.stringFromDate(tweet.createdAt)
        
        // objectIdをforeignKeyとして、user(tweeter)を取得
        var findTweeter:PFQuery = PFUser.query()
        findTweeter.whereKey("objectId", equalTo: tweet.objectForKey("tweeter").objectId)
        
        findTweeter.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!)->Void in
            if !error{
                let user:PFUser = (objects as NSArray).lastObject as PFUser
                cell.usernameLabel.text = "@\(user.username)"
                
                
                // CELLの表示を少しずつずらす
                UIView.animateWithDuration(0.5, animations: {
                    cell.tweetTextView.alpha = 1
                    cell.timestampLabel.alpha = 1
                    cell.usernameLabel.alpha = 1
                    })
            }
        }

        // Configure the cell...

        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
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
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
