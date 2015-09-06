//
//  ViewController.swift
//  DefaultsApp
//
//  Created by Grant Goodman on 9/5/15.
//  Copyright (c) 2015 Macster Software Inc. All rights reserved.
//

import UIKit
import PureLayout

class MainController: UIViewController, UIGestureRecognizerDelegate
{
    
    @IBOutlet weak var Calendar: UIView!
    @IBOutlet weak var Navigation: UIView!
    @IBOutlet weak var Mail: UIView!
    @IBOutlet weak var Browser: UIView!
    @IBOutlet weak var CalendarLabel: UILabel!
    @IBOutlet weak var MailLabel: UILabel!
    @IBOutlet weak var BrowserLabel: UILabel!
    @IBOutlet weak var NavigationLabel: UILabel!
    
    static var calendarHost = "applecalendar"
    static var navigationHost = "applemaps"
    static var mailHost = "applemail"
    static var browserHost = "safari"
    
    var defaultTypesDictionary: NSDictionary?
    var providerItemsArray = [NSDictionary]?()
    var currentApplicationDictionary: NSDictionary!
    
    var applicationCategory: String! = ""
    var urlScheme: String! = ""
    
    var chosenDefaults = [String:String]()
    
    var equivalentApplicationsArray = [NSDictionary]()
    
    var passedUrlScheme: String! = ""
    
    var applicationName: String! = ""
    var alternativeApplicationName: String! = ""
    
    var reconstructedLink: String! = ""
    
    var subParameterArray: NSArray!
    var otherSubParameterArray: NSArray!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Gesture recognizers
        let tap = UITapGestureRecognizer(target: self, action: Selector("navigate"))
        tap.delegate = self
        Navigation.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: Selector("mail"))
        tap1.delegate = self
        Mail.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: Selector("browser"))
        tap2.delegate = self
        Browser.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: Selector("calendar"))
        tap3.delegate = self
        Calendar.addGestureRecognizer(tap3)
        
       
        passedUrlScheme = "fb://profile"
        
        var seperatedArray = passedUrlScheme.componentsSeparatedByString("://")
        
        var passedURLSchemeHeader = seperatedArray[0] + "://"
        
        alternativeApplicationName = "GenericFacebook"
        
        ///
        
        var rootDictionary: NSDictionary?
        
        if let pathToPlist = NSBundle.mainBundle().pathForResource("Providers", ofType: "plist")
        {
            rootDictionary = NSDictionary(contentsOfFile: pathToPlist)
        }
        
        if let verifiedRootDictionary = rootDictionary
        {
            defaultTypesDictionary = verifiedRootDictionary["Default Types"] as? NSDictionary
            providerItemsArray = (verifiedRootDictionary["Provider Items"] as? [NSDictionary])!
        }
        
        for retrievedDictionary in providerItemsArray!
        {
            if retrievedDictionary.valueForKey("URL Scheme") as! String == passedURLSchemeHeader
            {
                applicationName = retrievedDictionary.valueForKey("Name") as! String
                currentApplicationDictionary = retrievedDictionary
                chosenDefaults[applicationName] = alternativeApplicationName
            }
        }
        
        applicationCategory = currentApplicationDictionary["Category"] as! String
        urlScheme = currentApplicationDictionary["URL Scheme"] as! String
        
        getEquivalentApplications()
        demoParameterToss()
    }
    
    func navigate() {
        // handling code
        switch MainController.navigationHost {
        case "applemaps":
            MainController.navigationHost = "googlemaps"
            NavigationLabel.text = "Google Maps"
        case "googlemaps":
            MainController.navigationHost = "waze"
            NavigationLabel.text = "Waze"
        case "waze":
            MainController.navigationHost = "applemaps"
            NavigationLabel.text = "Apple Maps"
        default:
            MainController.navigationHost = "applemaps"
            NavigationLabel.text = "Apple Maps"
        }
    }
    
    func mail() {
        // handling code
        switch MainController.mailHost {
        case "applemail":
            MainController.mailHost = "gmail"
            MailLabel.text = "Gmail"
        case "gmail":
            MainController.mailHost = "applemail"
            MailLabel.text = "Apple Mail"
        default:
            MainController.mailHost = "applemail"
            MailLabel.text = "Apple Mail"
        }
    }
    
    func browser() {
        // handling code
        switch MainController.browserHost {
        case "safari":
            MainController.browserHost = "chrome"
            BrowserLabel.text = "Google Chrome"
        case "chrome":
            MainController.browserHost = "safari"
            BrowserLabel.text = "Safari"
        default:
            MainController.browserHost = "safari"
            BrowserLabel.text = "Safari"
        }
    }
    
    func calendar() {
        // handling code
        switch MainController.calendarHost {
        case "applecalendar":
            MainController.calendarHost = "sunrise"
            CalendarLabel.text = "Sunrise Calendar"
        case "sunrise":
            MainController.calendarHost = "applecalendar"
            CalendarLabel.text = "Apple Calendar"
        default:
            MainController.calendarHost = "applecalendar"
            CalendarLabel.text = "Apple Calendar"
        }
    }

    func getEquivalentApplications()
    {
        for retrievedDictionary in providerItemsArray!
        {
            if retrievedDictionary.valueForKey("Category") as? String == applicationCategory
            {
                equivalentApplicationsArray.append(retrievedDictionary)
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    func demoParameterToss()
    {
        //Let's say we're converting a Twitter URL scheme to a Tweetbot one. We're converting the 'user' parameter.
        
        for retrievedDictionary in providerItemsArray!
        {
            if retrievedDictionary.valueForKey("Uses Initial Parameters") as! Bool == true
            {
                var chosenDefault = chosenDefaults[applicationName]
                
                if retrievedDictionary.valueForKey("Name") as? String == chosenDefault
                {
                    var firstURLSchemeSuffixVariable = passedUrlScheme.componentsSeparatedByString("://")[1].componentsSeparatedByString("?")[0] as String
                    var secondURLSchemeSuffixVariable = passedUrlScheme.componentsSeparatedByString("://")[1].componentsSeparatedByString("?")[1].componentsSeparatedByString("=")[0]
                    
                    var parametersOfCurrentApplication = currentApplicationDictionary["Parameters"] as! NSDictionary
                    
                    var subParametersOfVariable = parametersOfCurrentApplication[firstURLSchemeSuffixVariable]!.valueForKey("Sub-Parameters") as! NSArray
                    
                    for someDictionary in subParametersOfVariable
                    {
                        if someDictionary.valueForKey("typeId") as! String == secondURLSchemeSuffixVariable
                        {
                            var parameterType = someDictionary.valueForKey("parameterType") as! String
                            
                            var equivalentApplicationDictionary = retrievedDictionary["Parameters"]! as! NSDictionary
                            
                            var equivalentApplicationDictionaryValuesArray = Array(equivalentApplicationDictionary.allValues)
                            
                            for specificValue in equivalentApplicationDictionaryValuesArray
                            {
                                for deeperSpecificValue in Array(arrayLiteral: specificValue)
                                {
                                    if deeperSpecificValue.count > 1
                                    {
                                        subParameterArray = deeperSpecificValue["Sub-Parameters"] as! NSArray
                                    }
                                    
                                    for thing in subParameterArray
                                    {
                                        if thing.valueForKey("parameterType") as! NSString == NSString(string: parameterType)
                                        {
                                            var equivalentUrlScheme = retrievedDictionary["URL Scheme"] as! String
                                            var equivalentTypeId = String(subParameterArray[0].valueForKey("typeId") as! NSString)
                                            
                                            var equivalentApplicationDictionaryKeysArray = Array(equivalentApplicationDictionary.allKeys)
                                            
                                            for specificKey in equivalentApplicationDictionaryKeysArray
                                            {
                                                var arrayOfSpecificKeys = equivalentApplicationDictionary[specificKey as! NSString] as! NSDictionary
                                                
                                                if arrayOfSpecificKeys.count > 1
                                                {
                                                    otherSubParameterArray = arrayOfSpecificKeys["Sub-Parameters"] as! NSArray
                                                }
                                                
                                                for deeperSpecificKey in otherSubParameterArray
                                                {
                                                    var typeIdOfDeeperSpecificKey = deeperSpecificKey.valueForKey("typeId") as! String
                                                    
                                                    var variablePassedIntoURLScheme = passedUrlScheme.componentsSeparatedByString("://")[1].componentsSeparatedByString("?")[1].componentsSeparatedByString("=")[1]
                                                    
                                                    if typeIdOfDeeperSpecificKey == equivalentTypeId
                                                    {
                                                        if retrievedDictionary.valueForKey("Uses Initial Parameters") as! Bool == true
                                                        {
                                                            reconstructedLink = "\(equivalentUrlScheme)\(specificKey as! NSString)?\(equivalentTypeId)=\(variablePassedIntoURLScheme)"
                                                        }
                                                        else
                                                        {
                                                            reconstructedLink = "\(equivalentUrlScheme)\(equivalentTypeId)=\(variablePassedIntoURLScheme)"
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                    }
                }
            }
            else
            {
                var chosenDefault = chosenDefaults[applicationName]
                
                if retrievedDictionary.valueForKey("Name") as? String == chosenDefault
                {
                    var firstURLSchemeSuffixVariable = passedUrlScheme.componentsSeparatedByString("://")[1].componentsSeparatedByString("?")[0] as String
                    
                    var parametersOfCurrentApplication = currentApplicationDictionary["Parameters"] as! NSDictionary
                    
                    var subParameterOfVariable = parametersOfCurrentApplication[firstURLSchemeSuffixVariable]!.valueForKey("topLevelParameterType") as! NSString
                    
                    var equivalentUrlScheme = retrievedDictionary["URL Scheme"] as! String
                    var parametersArray = Array(retrievedDictionary.valueForKey("Parameters") as! NSDictionary)
                    
                    for retrievedItem in parametersArray
                    {
                        if retrievedItem.1.valueForKey("topLevelParameterType") as! NSString == subParameterOfVariable
                        {
                            reconstructedLink = "\(equivalentUrlScheme)\(retrievedItem.0 as! NSString)"
                        }
                    }
                }
            }
        }
        
        println("Original Link: '\(passedUrlScheme)'.")
        println("Reconstructed Link: '\(reconstructedLink)'.")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

