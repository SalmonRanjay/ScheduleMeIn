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
        var request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:3000/api/testServer")!);
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var err: NSError?
        do{
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(dictionaryData, options: []);
            
        }catch{
            
            print("Error happend");
        }
        
        var task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            print("Response: \(response)")
            var strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("Body: \(strData)")
            var err: NSError?
            do{
                var json =  try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? [String:AnyObject]
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    var success = parseJSON["success"] as? Int
                    print("Succes: \(success)")
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: \(jsonStr)")
                }
            }catch{
                
            }
            
        }
        //request.HTTPBody = NSJSONSerialization.dataWithJSONObject(authInfo, options: nil,  err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
     
    }

}
