//
//  main.swift
//  FredsLunch
//
//  Created by MichaelBurns on 10/22/19.
//  Copyright © 2019 MichaelBurns. All rights reserved.
//
// comment added from newly cloned FredsLunch-swift
// comment added in Tifig


import SwiftUI
import CoreData


class FredsLunchMain: NSObject
{
    
    //########## instance variables
    var lunchData : LunchData = LunchData()
    var name : String = String()
    var arguments: [String] = CommandLine.arguments
    //var moc = NSManagedData
     
      var debug = false  // turns on verbose debugging output
      var urlString = "FredsLunch.csv"
      var url : URL?
      var csv : CSV?
      var argno = 1
      var objectContext : NSManagedObjectContext?
      var numArgs = 0
    
    // create a new member and attach it to the lunch data
    init( name: String )
    {

        self.name = name
        print("Hello, Freds are having lunch!")
        
        numArgs = arguments.count
        
        // for debugging, test parameters
        if numArgs <= 1
        {
            arguments = [ "pgm", "-d", "-f", "/Users/Shared/Xcode/fredsLunch shell/Chili's 2019.csv" ]
            numArgs = arguments.count
        }
        
        var eaterNames : [ String ] = [String]()
        var payerName : String?
        
        // parse out the command line arguments
        while argno < numArgs
        {
            let arg = arguments[argno]
            argno += 1
            
            // -d signals debug output
            if arg == "-d" { debug = true }
            
            if debug { print( "argument: ", arg ) }
            
            // -f names the input file path
            if arg == "-file" || arg == "-f"
            {
                urlString = arguments[argno]
                argno += 1
                url = URL(fileURLWithPath: urlString)
            }
            
            // -eats signals a list of members who ate lunch
            if arg == "-eaters" || arg == "-eats"
            {
                while ( !(arguments[ argno ].hasPrefix("-") ) )
                {
                    let eaterName = arguments[argno]
                    argno += 1
                    eaterNames[eaterNames.count] = eaterName
                }
            }
            
            // -pays signals a single payer name for todays lunch
            if arg == "-payer" || arg == "-pays"
            {
                while ( !(arguments[ argno ].hasPrefix("-") ) )
                {
                    let thisPayerName = arguments[argno]
                    argno += 1
                    if payerName == nil
                    {
                        payerName = thisPayerName
                    }
                    else
                    {
                        print("ERROR: Only one payer is allowed so we don't expect \"\(thisPayerName)\" ")
                        abort()
                    }
                }
                
            }
        }  // for all args
        
        // setup the hub of the data model and the list for group members
        let lunchData = LunchData()
            lunchData.debug = debug
        
        if debug
        {    print ( "lunchData == \(String(describing: lunchData))" ) }
        
        if url != nil   // we have a url for a csv file
        {
            lunchData.setUrl(newUrl: url! as NSURL)
        }
    }
    
    func setArguments( argv : [String])
    {
       arguments = argv
        numArgs = arguments.count
    }
    
    func getArguments() -> [String]
    {
        return arguments
    }
    
//    func run()
//    {
//      if debug { print("DEBUG: FredsLunchMain.run  starting. ")}
//
//
//      if debug { print("DEBUG: FredsLunchMain.run  finished. ")}
//    }
    
    
}
