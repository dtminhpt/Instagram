//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Dinh Thi Minh on 11/11/15.
//  Copyright © 2015 Dinh Thi Minh. All rights reserved.
//

import UIKit
import AFNetworking
//import UIImageView


class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var photos = [NSDictionary]()
    
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // sample code in the Swift class I'm teaching, on making network request to Instagram to get photos
        // if you like to use Swift's Dictionary data type, you can use: `let photos = [Dictionary<String, AnyObject>]()`
        
        
        let url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=67fbaa3afa9945198b4909aadee317b6")!
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            
            guard error == nil else  {
                print("error loading from URL", error!)
                return
            }
            
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            self.photos = json["data"] as! [NSDictionary]
            
            //reload tableview
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
            
        }
        
        tableView.rowHeight = 320
       
        tableView.dataSource = self
        tableView.delegate = self
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return photos.count
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        let photo = photos[indexPath.row]
        let url = NSURL(string: ((photo["images"] as? NSDictionary)?["low_resolution"] as? NSDictionary)?["url"] as! String)!
        cell.imgView.setImageWithURL(url)

        return cell
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
