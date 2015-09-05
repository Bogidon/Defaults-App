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
        
        if url.scheme!.lowercaseString == "comdefaults"
        {
            if url.host != nil
            {
                if url.host!.lowercaseString == "mail"
                {
                    var seperatedArray: [String] = url.relativeString!.lowercaseString.componentsSeparatedByString("comdefaults://mail")
                    
                    if seperatedArray.count > 1
                    {
                        var seperatedString = seperatedArray[1] as String
                        
                        if seperatedString != ""
                        {
                            seperatedString = dropFirst(seperatedString)
                            
                            var seperatedByAndArray: [String] = seperatedString.componentsSeparatedByString("&")
                            
                            if seperatedByAndArray.count > 0
                            {
                                for passedParameter in seperatedByAndArray
                                {
                                    if passedParameter.lowercaseString.hasPrefix("to=")
                                    {
                                        var toString = dropCharactersFromStartOfString(passedParameter, characterAmount: 3)
                                        
                                        if toString == "nil"
                                        {
                                            toIsNil = true
                                            println("To field was left empty.")
                                        }
                                        else
                                        {
                                            toIsNil = false
                                            println("Message is To: '\(toString)'.")
                                        }
                                    }
                                    else
                                    {
                                        if toIsNil != false
                                        {
                                            toIsNil = true
                                        }
                                    }
                                    
                                    if passedParameter.lowercaseString.hasPrefix("cc=")
                                    {
                                        var ccString = dropCharactersFromStartOfString(passedParameter, characterAmount: 3)
                                        
                                        if ccString == "nil"
                                        {
                                            ccIsNil = true
                                            println("CC field was left empty.")
                                        }
                                        else
                                        {
                                            ccIsNil = false
                                            println("Message is CC'd To: '\(ccString)'.")
                                        }
                                    }
                                    else
                                    {
                                        if ccIsNil != false
                                        {
                                            ccIsNil = true
                                        }
                                    }
                                    
                                    if passedParameter.lowercaseString.hasPrefix("bcc=")
                                    {
                                        var bccString = dropCharactersFromStartOfString(passedParameter, characterAmount: 4)
                                        
                                        if bccString == "nil"
                                        {
                                            bccIsNil = true
                                            println("BCC field was left empty.")
                                        }
                                        else
                                        {
                                            bccIsNil = false
                                            println("Message is BCC'd To: '\(bccString)'.")
                                        }
                                    }
                                    else
                                    {
                                        if bccIsNil != false
                                        {
                                            bccIsNil = true
                                        }
                                    }
                                    
                                    if passedParameter.lowercaseString.hasPrefix("subject=")
                                    {
                                        var subjectString = dropCharactersFromStartOfString(passedParameter, characterAmount: 8)
                                        
                                        if subjectString == "nil"
                                        {
                                            subjectIsNil = true
                                            println("Subject field was left empty.")
                                        }
                                        else
                                        {
                                            subjectIsNil = false
                                            println("Message's Subject is: '\(subjectString)'.")
                                        }
                                    }
                                    else
                                    {
                                        if subjectIsNil != false
                                        {
                                            subjectIsNil = true
                                        }
                                    }
                                    
                                    if passedParameter.lowercaseString.hasPrefix("body=")
                                    {
                                        var messageString = dropCharactersFromStartOfString(passedParameter, characterAmount: 5)
                                        
                                        if messageString == "nil"
                                        {
                                            messageIsNil = true
                                            println("Message field was left empty.")
                                        }
                                        else
                                        {
                                            messageIsNil = false
                                            println("Message's Message is: '\(messageString)'.")
                                        }
                                    }
                                    else
                                    {
                                        if messageIsNil != false
                                        {
                                            messageIsNil = true
                                        }
                                    }
                                }
                                
                                if toIsNil == true && ccIsNil == true && bccIsNil == true && subjectIsNil == true && messageIsNil == true
                                {
                                    throwTypeError()
                                }
                            }
                        }
                        else
                        {
                            println("This guy just wants to open Mail.")
                        }
                    }
                    
                    //mail?to=%@,cc=%@,bcc=%@,subject=%@body=%@
                    //comdefaults://mail?to=grantgoodman@optonline.net&cc=john@example.com&bcc=goodmang@live.northshoreschools.org&subject=Hello!&body=How%20are%20you?
                    
                    //comdefaults://navigate?daddr=%f,%f&saddr=%f,%f
                }
                else if url.host!.lowercaseString == "navigate"
                {
                    var seperatedArray: [String] = url.relativeString!.lowercaseString.componentsSeparatedByString("comdefaults://navigate")
                    
                    if seperatedArray.count > 1
                    {
                        var seperatedString = seperatedArray[1] as String
                        
                        if seperatedString != ""
                        {
                            seperatedString = dropFirst(seperatedString)
                            
                            var seperatedByAndArray: [String] = seperatedString.componentsSeparatedByString("&")
                            
                            if seperatedByAndArray.count > 0
                            {
                                for passedParameter in seperatedByAndArray
                                {
                                    if passedParameter.lowercaseString.hasPrefix("daddr=")
                                    {
                                        var destinationString = dropCharactersFromStartOfString(passedParameter, characterAmount: 5)
                                        
                                        if destinationString == "nil"
                                        {
                                            destinationIsNil = true
                                            println("Destination field was left empty.")
                                        }
                                        else
                                        {
                                            destinationIsNil = false
                                            println("Destination is: '\(destinationString)'.")
                                        }
                                    }
                                    else
                                    {
                                        if destinationIsNil != false
                                        {
                                            destinationIsNil = true
                                        }
                                    }
                                    
                                    if passedParameter.lowercaseString.hasPrefix("saddr=")
                                    {
                                        //comdefaults://navigate?daddr=5%20Callison%20Lane%20Voorhees%20NJ%2008043&saddr=nil
                                        
                                        var startingPointString = dropCharactersFromStartOfString(passedParameter, characterAmount: 6)
                                        
                                        if startingPointString == "nil"
                                        {
                                            startingPointIsNil = true
                                            println("Starting point field was left empty.")
                                        }
                                        else
                                        {
                                            startingPointIsNil = false
                                            println("Starting point is: '\(startingPointString)'.")
                                        }
                                    }
                                    else
                                    {
                                        if startingPointIsNil != false
                                        {
                                            startingPointIsNil = true
                                        }
                                    }
                                }
                            }
                            
                            if destinationIsNil == true && startingPointIsNil == true
                            {
                                throwTypeError()
                            }
                        }
                        else
                        {
                            println("This guy just wants to open Maps.")
                        }
                    }
                }
                else if url.host!.lowercaseString == "openurl"
                {
                    var seperatedArray: [String] = url.relativeString!.lowercaseString.componentsSeparatedByString("comdefaults://openurl")
                    
                    if seperatedArray.count > 1
                    {
                        var seperatedString = seperatedArray[1] as String
                        
                        if seperatedString != ""
                        {
                            seperatedString = dropFirst(seperatedString)
                            
                            var seperatedByAndArray: [String] = seperatedString.componentsSeparatedByString("&")
                            
                            if seperatedByAndArray.count > 0
                            {
                                for passedParameter in seperatedByAndArray
                                {
                                    if passedParameter.lowercaseString.hasPrefix("url=")
                                    {
                                        var urlString = dropCharactersFromStartOfString(passedParameter, characterAmount: 4)
                                        
                                        if urlString == "nil"
                                        {
                                            urlIsNil = true
                                            throwTypeError()
                                        }
                                        else
                                        {
                                            urlIsNil = false
                                            println("URL to Open is: '\(urlString)'.")
                                        }
                                    }
                                    else
                                    {
                                        if urlIsNil != false
                                        {
                                            urlIsNil = true
                                            throwTypeError()
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            println("This guy just wants to open Safari.")
                        }
                    }
                }
                else
                {
                    println("The URL host wasn't recognized.")
                }
                
            }
            else
            {
                println("No URL host was passed.")
            }
        }
        else
        {
            println("The correct URL scheme wasn't triggered.")
        }
        
        return false
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

