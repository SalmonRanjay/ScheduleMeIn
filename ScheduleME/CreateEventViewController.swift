//
//  CreateEventViewController.swift
//  ScheduleME
//
//  Created by ranjay on 3/26/16.
//  Copyright © 2016 ranjay. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {
    
    var authInfo: GTMOAuth2Authentication = GTMOAuth2Authentication();
    var dictionaryData = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        dictionaryData = authInfo.parameters;
        // Do any additional setup after loading the view.
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
    
    
    @IBAction func submitEvent(sender: AnyObject) {
        //http://localhost:3000/api/testServer
        // let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
        print("Button Pressed")
        let url:NSURL = NSURL(string: "http://localhost:3000/api/testServer")!
        
       
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        
        
        do {
            
            let json = try NSJSONSerialization.dataWithJSONObject(dictionaryData, options: .PrettyPrinted)
            
            let paramString =  NSString(data: json, encoding: NSUTF8StringEncoding)! as String
            
            print(paramString);
            
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(dataString)
            
        }
        
        task.resume()
        } catch{
        
        }
    }

}
