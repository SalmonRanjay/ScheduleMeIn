//
//  CreateEventViewController.swift
//  ScheduleME
//
//  Created by ranjay on 3/26/16.
//  Copyright © 2016 ranjay. All rights reserved.
//

import UIKit
import EventKit

class CreateEventViewController: UIViewController {
    
    @IBOutlet weak var titleTextField:UITextField!;
    @IBOutlet weak var dateTextField:UITextField!;
    @IBOutlet weak var backgroundView:UIView!;
    
    var authInfo: GTMOAuth2Authentication = GTMOAuth2Authentication();
    var dictionaryData = NSMutableDictionary()
    
    let eventMaker = GTLCalendarEventCreator();
    let event = GTLCalendarEvent()
    // ...
    
    var calendars: [EKCalendar]?
    // 1
    let eventStore = EKEventStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        dictionaryData = authInfo.parameters;
        // Do any additional setup after loading the view.
        
        
        
        
        self.backgroundView.backgroundColor = UIColor(red: 51/255, green: 153/255, blue: 255/255, alpha: 1);
        
        checkCalendarAuthorizationStatus();
        
        for calendar in self.calendars!{
        
            print(calendar);
        }

    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch (status) {
        case EKAuthorizationStatus.NotDetermined:
            // This happens on first-run
            requestAccessToCalendar()
            break;
        case EKAuthorizationStatus.Authorized:
            // Things are in line with being able to show the calendars in the table view
            loadCalendars()
            break
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            // We need to help them give us permission
            //needPermissionView.fadeIn()
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Request access to calendar
    // ...
    
    func requestAccessToCalendar() {
        eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
            (accessGranted: Bool, error: NSError?) in
            
            if accessGranted == true {
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadCalendars()
                                   })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                                    })
            }
        })
    }
    
    
    
    func loadCalendars() {
        self.calendars = eventStore.calendarsForEntityType(EKEntityType.Event)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func goToSettings(sender: AnyObject){
    
        let openSettingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(openSettingsUrl!)
    
    }
    
    @IBAction func createEvent(sender: AnyObject){
    
    }
    
    
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
