//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Dinh Thi Minh on 11/11/15.
//  Copyright © 2015 Dinh Thi Minh. All rights reserved.
//

import UIKit
import AFNetworking



class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var photos = [NSDictionary]()
    @IBOutlet var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Making network request to Instagram to get photos
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
        
        //Pull to refresh tableView
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView?.addSubview(refreshControl)
        
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }    // MARK: - Navigation
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        let photo = photos[indexPath.row]
        let vc = segue.destinationViewController as! PhotoDetailsViewController
  
        vc.photo = photo
  
    }    

}
