//
//  PhotoDetailsViewController.swift
//  Instagram
//
//  Created by Dinh Thi Minh on 11/13/15.
//  Copyright © 2015 Dinh Thi Minh. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    
    
    @IBOutlet weak var imgView: UIImageView!
    //var photo: NSDictionary!
    var photo: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = NSURL(string: ((photo["images"] as? NSDictionary)?["standard_resolution"] as? NSDictionary)?["url"] as! String)!
        imgView.setImageWithURL(url)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
