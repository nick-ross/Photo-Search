//
//  ViewController.swift
//  Photo-Search
//
//  Created by Nick Ross on 8/25/14.
//  Copyright (c) 2014 Nick Ross. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
                            
    @IBOutlet weak var scrollView: UIScrollView!
        
        let instagramClientID = "7c82b2a0df224ba68e6f00075c0638bf"
        
        func searchInstagramByHashtag(searchString: String) {
            for subview in self.scrollView.subviews {
                subview.removeFromSuperview()
            }
        
        let instagramURLString = "https://api.instagram.com/v1/tags/" + searchString + "/media/recent?client_id=" + instagramClientID
            
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET( instagramURLString,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                println("JSON: " + responseObject.description)
                
                if let dataArray = responseObject.valueForKey("data") as? [AnyObject] {
                    self.scrollView.contentSize = CGSizeMake(320, CGFloat(320*dataArray.count))
                    for var i = 0; i < dataArray.count; i++ {
                        let dataObject: AnyObject = dataArray[i]
                        if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String {
                            println("image " + String(i) + " URL is " + imageURLString)
                            
                            let imageView = UIImageView(frame: CGRectMake(0, CGFloat(320*i), 320, 320))
                            self.scrollView.addSubview(imageView)
                            imageView.setImageWithURL( NSURL(string: imageURLString))
                        }
                    }
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar!) {

        searchBar.resignFirstResponder()
        searchInstagramByHashtag(searchBar.text)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            searchInstagramByHashtag("clararockmore")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

