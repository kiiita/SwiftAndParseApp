//
//  EditViewController.swift
//  SwiftAndParse
//
//  Created by kiiita on 2014/08/15.
//  Copyright (c) 2014年 Yuto Kitakuni. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    // timelineTableViewControllerからの受け取り
    var param:AnyObject!
    var query = PFQuery(className:"Tweets")
    @IBOutlet weak var tweet: UITextView! = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        tweet.text = param.objectForKey("content") as String

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func updateTweet(sender: AnyObject) {
        query.getObjectInBackgroundWithId(param.objectId) {
            (targetTweet: PFObject!, error: NSError!) -> Void in
            if error {
                NSLog("%@", error)
            } else {
                targetTweet["content"] = self.tweet.text
                targetTweet.saveInBackground()
                self.navigationController.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    @IBAction func deleteTweet(sender: AnyObject) {
        query.getObjectInBackgroundWithId(param.objectId) {
            (targetTweet: PFObject!, error: NSError!) -> Void in
            if error {
                NSLog("%@", error)
            } else {
                targetTweet.deleteInBackground()
                self.navigationController.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
