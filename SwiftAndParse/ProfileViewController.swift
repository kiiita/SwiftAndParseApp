//
//  ProfileViewController.swift
//  SwiftAndParse
//
//  Created by kiiita on 2014/08/17.
//  Copyright (c) 2014年 Yuto Kitakuni. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = PFUser.currentUser().username as String

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
