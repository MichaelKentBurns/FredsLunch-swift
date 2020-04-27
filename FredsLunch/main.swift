//
//  main.swift
//  FredsLunch
//
//  Created by MichaelBurns on 10/22/19.
//  Copyright © 2019 MichaelBurns. All rights reserved.
//
// comment added from newly cloned FredsLunch-swift


import SwiftUI
import CoreData

print("Hello, Freds are having lunch!")

// test code

// Specify date components
var dateComponents = DateComponents()
dateComponents.year = 1980
dateComponents.month = 7
dateComponents.day = 11
dateComponents.timeZone = TimeZone(abbreviation: "CST") // Central Standard Time
dateComponents.hour = 8
dateComponents.minute = 34

// Create date from components
let userCalendar = Calendar.current // user calendar
let someDateTime = userCalendar.date(from: dateComponents)

let today : Date = Date()
let formatter = DateFormatter()
formatter.timeZone = TimeZone(identifier: "UTC")
formatter.locale = Locale(identifier: "en_US_POSIX")
formatter.dateFormat = "dd-MMM-yyyy"
let dateText = formatter.string(from: today)
print(" today is \(today) or \(dateText)")

dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
//dateComponents.year
//dateComponents.month
//dateComponents.day
//dateComponents.hour
//dateComponents.minute
//dateComponents.second


//: ## Creating dates from components
//let newDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents2)
let newDate = Calendar.current.date(from: dateComponents)

formatter.timeStyle = .none
let hoyDia = formatter.date(from: dateText)
print( "recreated date value=\(hoyDia)")



let RFC3339DateFormatter = DateFormatter()
RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
 
/* 39 minutes and 57 seconds after the 16th hour of December 19th, 1996 with an offset of -08:00 from UTC (Pacific Standard Time) */
let string = "1996-12-19T16:39:57-08:00"
let date = RFC3339DateFormatter.date(from: string)
var arguments: [String] = CommandLine.arguments
//var moc = NSManagedData

var name  : String?
var debug = false
var urlString = "FredsLunch.csv"
var url : URL?
var csv : CSV?
var nargs = arguments.count
var argno = 1
var objectContext : NSManagedObjectContext?

//print("What is your name? ")
//name = readLine(strippingNewline: true)
//if name == nil { name = "World" }
//if debug { print( "name: ", name! ) }
//if name != nil
//{
//    print("Hello, \(name!) !")
//}

// for debugging, test parameters
if nargs <= 1
{
    arguments = [ "pgm", "-d", "-f", "/Users/Shared/Xcode/fredsLunch shell/Chili's 2019.csv" ]
    nargs = arguments.count
}


var eaterNames : [ String ] = [String]()
var payerName : String?

// parse out the command line arguments
while argno < nargs
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
var lunchData = LunchData()
lunchData.debug = debug
var memberList = MemberList(lunchData: lunchData)
if debug
{    print ( "lunchData == \(String(describing: lunchData))" ) }

if url != nil   // we have a url for a csv file
{
    // read the csv lines into csv.rows and note special (non lunch) rows.
    csv = CSV(urlArg: url,debug: debug)
    if debug
    { print("csv == \(String(describing: csv))") }
    if csv == nil
    {
        print("ERROR: Unable to parse the CSV.")
        abort()
    }
    
    // build the list of members from the first line of csv
    if debug { print("DEBUG: Build a list of members from top line of CSV.")}
    if csv!.headers.count > 0
    {
        memberList = MemberList(lunchData: lunchData)
        var headerIndex = 0
        var blankHeaders = 0 // number of blankHeaders seen so far
        var columnOrdinal = 0
        for header in csv!.headers
        {
            if blankHeaders == 1  // if have seen a blank header
            {
                var member : Member
                member = Member(name: header, lunchData: lunchData)
                member.columnOrdinal = columnOrdinal
                memberList.addMember( member: member )
                if debug
                {    print ( "member: name = \(member.name) ordinal = \(member.columnOrdinal)" )
                }
                
            }
            if header == ""
            {
                blankHeaders += 1
            }
            headerIndex += 1
            columnOrdinal += 1
        }
    }
    else
    {
        print("ERROR: Unable to find column headers in parsed CSV.")
        abort()
    }
    
    // more to do here...
    // apply the beginning balance to all members
    let startingBalanceRowNumber = csv!.startingBalanceRowNumber
    if startingBalanceRowNumber != 0
    {
        for row in csv!.rows
        {
            if debug {
                print("row = \(row)") }
        }
        
        if debug { print("DEBUG: Initializing members with starting balances") }
        let startingBalanceRow = csv!.rows[startingBalanceRowNumber]
        if startingBalanceRowNumber != 0
        {
            let members = lunchData.memberList!.members
            for aMember in members
            {
                let thisMember = aMember.value
                let memberName = thisMember.name!
                if memberName != ""
                {
                    var startingValueDouble : Double?
                    if debug { print("bp target: member=\(thisMember) name=\(memberName)") }
                    
                    let startingValueItem = startingBalanceRow[memberName]
                    if  startingValueItem != nil
                    {
                        let startingValueAnyMaybe: AnyObject? = startingValueItem!
                        if startingValueAnyMaybe != nil
                        {
                            startingValueDouble = startingValueAnyMaybe! as! Double
                            if debug { print("bp target: startingBalance for member \(memberName) =\(startingValueDouble!)") }
                        }
                    }
                    if startingValueDouble != nil
                    {
                        thisMember.balance = startingValueDouble!
                    }
                }
            }
        }
        else
        {
            print("WARNING: Cannot find the starting balance row.")
        }
    }
    
    let maxColumnIndex = memberList.members.count + 4
    var columnBalance = [Double](repeating: 0.0, count: maxColumnIndex )
    if csv != nil
    {
        
        // turn the rows into a list of lunches
        if debug { print("DEBUG: Process CSV rows into a list of lunches.") }
        var lunches = lunchData.lunchList!.lunches
        for row in csv!.rows
        {
            if debug {
                print("row = \(row)") }
            let testObject : AnyObject? = row["Date"]
            if testObject != nil
            {
                let dateValue : Date? = testObject as! Date
                if dateValue != nil
                {
                    let newLunch = Lunch(date: dateValue! )
                   // lunches.append(newLunch)
                    lunches.insert(newLunch, at: 0)
                    
                    for memberName in memberList.memberNames
                    {
                        let value = row[memberName]
                        if value != nil
                        {
                            if let member = memberList.getMember(name: memberName)
                            {
                                let doubleValue = value as! Double
                                newLunch.balance += doubleValue
                                columnBalance[member.columnOrdinal] += doubleValue
                                if doubleValue < 0 // payer
                                {
                                    newLunch.addParticipant(member: member, amountEaten: 0.0, amountPaid: -(doubleValue))
                                }
                                else if doubleValue > 0
                                {
                                    newLunch.addParticipant(member: member, amountEaten: doubleValue, amountPaid: 0.0)
                                }
                            }
                        }
                    }
                    
                }
                
                
                
            }
        }
        lunchData.lunchList!.lunches = lunches
        if debug
        {
            print("list of lunches complete: ")
            
            var lunchNumber = 0
            for lunch in lunchData.lunchList!.lunches
            {
                print("lunch[\(lunchNumber)] : \(String(describing: lunch))")
                lunch.dump()
                
                lunchNumber += 1
            }
            
        }
        
    }
    // If we have arguments that describe a lunch process it, adding to the lunch list
    // print a report of the new lunch and the updated balances
    // update the final balances in the csv
    
    
    // check the lunches present and compare final balance with what is in the csv
    if debug { print("DEBUG: Process all of the lunches and check final balances.") }
    let lunches = lunchData.lunchList!.lunches
    for lunch in lunches
    {
        print("lunch=\(String.init(describing: lunch))")
        lunch.dump()
    }
    
    // if we started with a csv, then update it with the new lunch
    if debug { print("DEBUG: Updating the CSV file")}
    // print a report
    if debug { print("DEBUG: Printing report")}
    // and ??? 
}

