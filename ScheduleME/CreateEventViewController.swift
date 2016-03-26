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
        
        
        
//        for calendar in self.calendars!{
//        
//            print(calendar);
//        }

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
    
    
    @IBAction func goToSettings(sender: AnyObject){
    
        let openSettingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(openSettingsUrl!)
    
    }
    
    @IBAction func createEvent(sender: AnyObject){
        
        
        
    
        let event:EKEvent = EKEvent(eventStore: eventStore)
        event.title = self.titleTextField.text!
        event.startDate = NSDate()
        event.endDate = NSDate()
        event.notes = self.dateTextField.text
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {try eventStore.saveEvent(event, span: EKSpan.ThisEvent, commit: true);}catch{}
        //eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
        
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.minute = 5
        let notifdate = NSDate().dateByAddingTimeInterval(5.0 * 60.0) //calendar.dateByAddingComponents(components, toDate: NSDate(), options: [])
        
        // create a corresponding local notification
        var notification = UILocalNotification()
        notification.alertBody = "ASA Event \"\(self.titleTextField.text)\" Scheduled" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = notifdate // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["UUID": NSUUID().UUIDString, ] // assign a unique identifier to the notification so that we can retrieve it later
        notification.category = "ASA Event"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        self.dismissViewControllerAnimated(true, completion: nil)
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
