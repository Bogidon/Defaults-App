//
//  ViewController.swift
//  DefaultsApp
//
//  Created by Grant Goodman on 9/5/15.
//  Copyright (c) 2015 Macster Software Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        passedUrlScheme = "twitter://user?screen_name=MJMaker6"
        
        var seperatedArray = passedUrlScheme.componentsSeparatedByString("://")
        
        var passedURLSchemeHeader = seperatedArray[0] + "://"
        
        alternativeApplicationName = "GenericTwitter"
        
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
    
    func demoParameterToss()
    {
        //Let's say we're converting a Twitter URL scheme to a Tweetbot one. We're converting the 'user' parameter.

        for retrievedDictionary in providerItemsArray!
        {
            var chosenDefault = chosenDefaults[applicationName]
            
            if retrievedDictionary.valueForKey("Name") as? String == chosenDefault
            {
                var firstURLSchemeSuffixVariable = passedUrlScheme.componentsSeparatedByString("://")[1].componentsSeparatedByString("?")[0] as String
                var secondURLSchemeSuffixVariable = passedUrlScheme.componentsSeparatedByString("://")[1].componentsSeparatedByString("?")[1].componentsSeparatedByString("=")[0]
                
                var parametersOfCurrentApplication = currentApplicationDictionary["Parameters"] as! NSDictionary
                
                var subParametersOfVariable = parametersOfCurrentApplication[firstURLSchemeSuffixVariable] as! NSArray
                
                for someDictionary in subParametersOfVariable
                {
                    if someDictionary.valueForKey("typeId") as! String == secondURLSchemeSuffixVariable
                    {
                        var parameterType = someDictionary.valueForKey("parameterType") as! String
                        
                        var equivalentApplicationDictionary = retrievedDictionary["Parameters"]! as! NSDictionary
                        
                        var equivalentApplicationDictionaryValuesArray = Array(equivalentApplicationDictionary.allValues)
                        
                        for specificValue in equivalentApplicationDictionaryValuesArray
                        {
                            for deeperSpecificValue in specificValue as! NSArray
                            {
                                if deeperSpecificValue["parameterType"] as! NSString == NSString(string: parameterType)
                                {
                                    var equivalentUrlScheme = retrievedDictionary["URL Scheme"] as! String
                                    var equivalentTypeId = String(deeperSpecificValue["typeId"] as! NSString)
                                    
                                    var equivalentApplicationDictionaryKeysArray = Array(equivalentApplicationDictionary.allKeys)
                                    
                                    for specificKey in equivalentApplicationDictionaryKeysArray
                                    {
                                        var arrayOfSpecificKeys = equivalentApplicationDictionary[specificKey as! NSString] as! NSArray
                                        
                                        for deeperSpecificKey in arrayOfSpecificKeys
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
        
        println("Original Link: '\(passedUrlScheme)'.")
        println("Reconstructed Link: '\(reconstructedLink)'.")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

