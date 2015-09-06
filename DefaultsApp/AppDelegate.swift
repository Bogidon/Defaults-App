//
//  AppDelegate.swift
//  DefaultsApp
//
//  Created by Grant Goodman on 9/5/15.
//  Copyright (c) 2015 Macster Software Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool
    {
        var toIsNil: Bool?
        var ccIsNil: Bool?
        var bccIsNil: Bool?
        var subjectIsNil: Bool?
        var messageIsNil: Bool?
        
        var destinationIsNil: Bool?
        var startingPointIsNil: Bool?
        
        var urlIsNil: Bool?
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("openURL:"), userInfo: ["url": url], repeats: false)
        
        return false
    }
    
    func openURL(timer: NSTimer) {
        var url  = timer.userInfo?.objectForKey("url")! as! NSURL!
        
        if url.scheme!.lowercaseString == "comdefaults"
        {
            var urlString : String = url.absoluteString!
            if urlString.rangeOfString("navigate") != nil {
                let navProvider = MainController.navigationHost
                
                switch navProvider {
                case "googlemaps":
                    UIApplication.sharedApplication().openURL(NSURL(string: "comgooglemaps://?daddr=3601%20S%20Broad%20St,Philadelphia,%20PA%2019148")!)
                case "applemaps":
                    UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/?daddr=3601%20S%20Broad%20St,Philadelphia,%20PA%2019148")!)
                case "waze":
                    UIApplication.sharedApplication().openURL(NSURL(string: "waze://?q=3601%20S%20Broad%20St,Philadelphia,%20PA%2019148")!)
                default:
                    UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/?daddr=3601%20S%20Broad%20St,Philadelphia,%20PA%2019148")!)
                }
            }
            else if urlString.rangeOfString("mail") != nil {
                let mailProvider = MainController.mailHost
                
                switch mailProvider {
                case "applemail":
                    UIApplication.sharedApplication().openURL(NSURL(string: "mailto:bogdan@chehacks.com?&subject=About%20your%20app...")!)
                case "gmail":
                    UIApplication.sharedApplication().openURL(NSURL(string: "googlegmail:///co?to=bogdan@chehacks.com&subject=About%20your%20app...")!)
                default:
                    UIApplication.sharedApplication().openURL(NSURL(string: "mailto:bogdan@chehacks.com?&subject=About%20your%20app...")!)
                }
            }
            else if urlString.rangeOfString("browser") != nil {
                let browserProvider = MainController.browserHost
                
                switch browserProvider {
                case "safari":
                    UIApplication.sharedApplication().openURL(NSURL(string: "https://2015f.pennapps.com/")!)
                case "chrome":
                    UIApplication.sharedApplication().openURL(NSURL(string: "googlechrome://2015f.pennapps.com/")!)
                default:
                    UIApplication.sharedApplication().openURL(NSURL(string: "mailto:bogdan@chehacks.com?&subject=About%20your%20app...")!)
                }
            }
        }
        else
        {
            println("The correct URL scheme wasn't triggered.")
        }
    }
    
    func dropCharactersFromStartOfString(dropString: String, characterAmount: Int) -> String
    {
        var mutableCharacterAmount = characterAmount
        var mutableDropString = dropString
        
        for (mutableCharacterAmount = characterAmount; mutableCharacterAmount > 0; mutableCharacterAmount--)
        {
            mutableDropString = dropFirst(mutableDropString)
        }
        
        return mutableDropString
    }
    
    func throwTypeError()
    {
        var typeAlertView = UIAlertView()
        typeAlertView.title = "Improper Format"
        typeAlertView.message = "The format of the URL scheme was not valid.\n\n Please try again."
        typeAlertView.addButtonWithTitle("Dismiss")
        
        if typeAlertView.visible == false
        {
            typeAlertView.show()
        }
    }
}

