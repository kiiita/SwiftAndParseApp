//
//  ComposeViewController.swift
//  SwiftAndParse
//
//  Created by kiiita on 2014/08/10.
//  Copyright (c) 2014年 Yuto Kitakuni. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController,UITextViewDelegate {

    @IBOutlet strong var tweetTextView: UITextView! = UITextView()
    @IBOutlet strong var charRemainingLabel: UILabel! = UILabel()
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tweetTextView.layer.borderColor = UIColor.blackColor().CGColor
        tweetTextView.layer.borderWidth = 0.5
        tweetTextView.layer.cornerRadius = 5
        tweetTextView.delegate = self
        
        tweetTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sendTweet(sender: AnyObject) {
        // classの作成
        var tweet:PFObject = PFObject(className: "Tweets")
        
        //culomun, ユーザーの作成と内容の作成
        tweet["content"] = tweetTextView.text
        tweet["tweeter"] = PFUser.currentUser()
        
        tweet.saveInBackground()
        
        self.navigationController.popToRootViewControllerAnimated(true)
        
    }
    
    
    func textView(textView: UITextView!,
        shouldChangeTextInRange range: NSRange,
        replacementText text: String!) -> Bool{
            
            // 入力文字数のカウント
            var newLength:Int = (textView.text as NSString).length + (text as NSString).length - range.length
            var remainingChar: Int = 140 - newLength
            
            charRemainingLabel.text = "残り\(remainingChar)"
            
            return (newLength > 140) ? false : true
            
            
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
