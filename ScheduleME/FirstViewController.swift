//
//  FirstViewController.swift
//  ScheduleME
//
//  Created by ranjay on 3/25/16.
//  Copyright © 2016 ranjay. All rights reserved.
// //Event-Background

import UIKit

class FirstViewController: UIViewController {

    private let kKeychainItemName = "Google Calendar API"
    private let kClientID = "575094967919-dcgt50cve9jimn0cjkcsn0m6j3s1kkjl.apps.googleusercontent.com"
    @IBOutlet weak var backgroundImageView:UIImageView!;
    @IBOutlet weak var collectionView:UICollectionView!;
    var authInfoVariable:GTMOAuth2Authentication = GTMOAuth2Authentication();
    
    var eventsArray:[Events] = [];
    
    
    @IBOutlet weak var output:UITextView!;
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLAuthScopeCalendar]
    
    private let service = GTLServiceCalendar()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        collectionView.backgroundColor = UIColor.clearColor()
        // Apply blurring effect
        backgroundImageView.image = UIImage(named: "sydney")
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
                service.authorizer = auth
                print("User AUth Data: \(auth)");
                authInfoVariable = auth
        }
        
        
      
        
        if UIScreen.mainScreen().bounds.size.height == 480.0 {
            let flowLayout = self.collectionView.collectionViewLayout as!
            UICollectionViewFlowLayout
            flowLayout.itemSize = CGSizeMake(250.0, 300.0)
        }
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 51/255, green: 153/255, blue: 255/255, alpha: 1);
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //tabBarController.tabBar.tintColor = UIColor.yellowColor()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // When the view appears, ensure that the Google Calendar API service is authorized
    // and perform API calls
    override func viewDidAppear(animated: Bool) {
        if let authorizer = service.authorizer,
            canAuth = authorizer.canAuthorize where canAuth {
                fetchEvents()
        } else {
            presentViewController(
                createAuthController(),
                animated: true,
                completion: nil
            )
        }
    }
    
    // Construct a query and get a list of upcoming events from the user calendar
    func fetchEvents() {
        var query = GTLQueryCalendar.queryForEventsListWithCalendarId("primary") as! GTLQueryProtocol;
        
        service.executeQuery(
            query,
            delegate: self,
            didFinishSelector: "displayResultWithTicket:finishedWithObject:error:"
        )
        
    }
    
    // Display the start dates and event summaries in the UITextView
    func displayResultWithTicket(
        ticket: GTLServiceTicket,
        finishedWithObject response : GTLCalendarEvents,
        error : NSError?) {
            
            if let error = error {
                showAlert("Error", message: error.localizedDescription)
                return
            }
            
            var eventString = ""
            
            if let events = response.items() where !events.isEmpty {
                for event in events as! [GTLCalendarEvent] {
                    let start : GTLDateTime! = event.start.dateTime ?? event.start.date
                    var startString = NSDateFormatter.localizedStringFromDate(
                        start.date,
                        dateStyle: .ShortStyle,
                        timeStyle: .ShortStyle
                    )
                    eventString += "\(startString) - \(event.summary)\n"
                    let newEvent: Events = Events(title: event.summary, date: startString)
                    self.eventsArray.append(newEvent);
                }
            } else {
                eventString = "No upcoming events found."
                self.eventsArray = [Events(title: "You Have NO Events", date: "")];
            }
            self.collectionView.reloadData();
            
            //output.text = eventString
    }
    
    // Handle completion of the authorization process, and update the Google Calendar API
    // with the new credentials.
    func viewController(vc : UIViewController,
        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
            
            if let error = error {
                service.authorizer = nil
                showAlert("Authentication Error", message: error.localizedDescription)
                return
            }
        
       
            service.authorizer = authResult
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Creates the auth controller for authorizing access to Google Calendar API
    private func createAuthController() -> GTMOAuth2ViewControllerTouch {
        
        let scopeString = scopes.joinWithSeparator(" ");
        return GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: kClientID,
            clientSecret: nil,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: "viewController:finishedWithAuth:error:"
        )
    }
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertView(
            title: title,
            message: message,
            delegate: nil,
            cancelButtonTitle: "OK"
        )
        alert.show()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "createEvent"){
            let destinationViewController = segue.destinationViewController as! CreateEventViewController;
            destinationViewController.authInfo = self.authInfoVariable;
        }
    }


}

extension FirstViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.eventsArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! EventTypeCollectionViewCell;
        let item = self.eventsArray[indexPath.row];
        
        cell.cellBackground.image = UIImage(named: "Event-Background");
        cell.eventInfo.text = "\(item.date!) - \(item.title!)";
        
        
        return cell;
    }
}

