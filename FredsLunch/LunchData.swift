//
//  LunchData.swift
//  FredsLunch
//
//  Created by MichaelBurns on 10/22/19.
//  Copyright © 2019 MichaelBurns. All rights reserved.
//

import CoreData
import Foundation

class LunchData: NSObject {
    var accountName: String?
    var lunchList: LunchList?
    var memberList: MemberList?

    var csv: CSV?
    var url: NSURL?
    var dataURLString: String?
    // lunchList :
    // var memberList: MemberList?
    var debug = true
    let encoding = String.Encoding.utf8
    var postDone = false

    var fredsBaseURL = // "http://localhost:8081/FredsLunch"
        "http://www.fathersWork.org:8081/FredsLunch"
    var fredsAccountName = "fred"

    let urlSep = "/"
    var fredsAccountURL: String!
    var fredsDataURL: String!

    var lunchDate = FredsLunchDate()

    override init() {
        super.init()
        lunchList = LunchList(self)
        memberList = MemberList(lunchData: self)
    }

    func setUrl(newUrl: NSURL) {
        url = newUrl
    }

    func parseRawData() {
        // read the csv lines into csv.rows and note special (non lunch) rows.

        csv = CSV(urlArg: url! as URL, debug: debug)
        if debug
            { print("csv == \(String(describing: csv))") }
        if csv == nil {
            print("ERROR: Unable to parse the CSV.")
            abort()
        }
    }

    func gatherColumns() {
        // build the list of members from the first line of csv
        if debug { print("DEBUG: Build a list of members from top line of CSV.") }
        if csv!.headers.count > 0 {
            memberList = MemberList(lunchData: self)
            var headerIndex = 0
            var blankHeaders = 0 // number of blankHeaders seen so far
            var columnOrdinal = 0
            for header in csv!.headers {
                if blankHeaders == 1 // if have seen a blank header
                {
                    var member: Member
                    member = Member(name: header, lunchData: self)
                    member.columnOrdinal = columnOrdinal
                    memberList!.addMember(member: member)
                    if debug { print("member: name = \(String(describing: member.name)) ordinal = \(member.columnOrdinal)")
                    }
                }
                if header == "" {
                    blankHeaders += 1
                }
                headerIndex += 1
                columnOrdinal += 1
            }
        } else {
            print("ERROR: Unable to find column headers in parsed CSV.")
            abort()
        }
    }

    func gatherStartingBalance() {
        // more to do here...
        // apply the beginning balance to all members
        let startingBalanceRowNumber = csv!.startingBalanceRowNumber
        if startingBalanceRowNumber != 0 {
            for row in csv!.rows {
                if debug {
                    print("row = \(row)")
                }
            }

            if debug { print("DEBUG: Initializing members with starting balances") }
            let startingBalanceRow = csv!.rows[startingBalanceRowNumber]
            if startingBalanceRowNumber != 0 {
                let members = memberList!.members
                for aMember in members {
                    let thisMember = aMember.value
                    let memberName = thisMember.name!
                    if memberName != "" {
                        var startingValueDouble: Double?
                        if debug { print("bp target: member=\(thisMember) name=\(memberName)") }

                        let startingValueItem = startingBalanceRow[memberName]
                        if startingValueItem != nil {
                            let startingValueAnyMaybe: AnyObject? = startingValueItem!
                            if startingValueAnyMaybe != nil {
                                startingValueDouble = (startingValueAnyMaybe! as! Double)
                                if debug { print("bp target: startingBalance for member \(memberName) =\(startingValueDouble!)") }
                            }
                        }
                        if startingValueDouble != nil {
                            thisMember.balance = startingValueDouble!
                        }
                    }
                }
            } else {
                print("WARNING: Cannot find the starting balance row.")
            }
        }
    }
    
    func gatherLunches()
    {

        let maxColumnIndex = memberList!.members.count + 4
        var columnBalance = [Double](repeating: 0.0, count: maxColumnIndex)
        if csv != nil {
            // turn the rows into a list of lunches
            if debug { print("DEBUG: Process CSV rows into a list of lunches.") }
            var lunches = lunchList!.lunches
            for row in csv!.rows {
                if debug {
                    print("row = \(row)")
                }
                let testObject: AnyObject? = row["Date"]
                if testObject != nil {
                    var dateValue: Date?
                    let dateString: String? = (testObject as! String)
                    if dateString != nil {
                        dateValue = lunchDate.parseDate(text: dateString!)
                    }
                    //  let dateValue : Date? = (testObject as! Date)
                    if dateValue != nil {
                        let newLunch = Lunch(lunchData: self)
                        newLunch.date = dateValue!
                        // lunches.append(newLunch)
                        lunches.insert(newLunch, at: 0)

                        for memberName in memberList!.memberNames {
                            let value = row[memberName]
                            if value != nil {
                                if let member = memberList!.getMember(name: memberName) {
                                    let doubleValue = value as! Double
                                    newLunch.balance += doubleValue
                                    columnBalance[member.columnOrdinal] += doubleValue
                                    if doubleValue < 0 // payer
                                    {
                                        newLunch.addParticipant(member: member, amountEaten: 0.0, amountPaid: -doubleValue)
                                    } else if doubleValue > 0 {
                                        newLunch.addParticipant(member: member, amountEaten: doubleValue, amountPaid: 0.0)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            lunchList!.lunches = lunches
            if debug
            {
                print("list of lunches complete: ")

                var lunchNumber = 0
                for lunch in lunchList!.lunches
                {
                    print("lunch[\(lunchNumber)] : \(String(describing: lunch))")
                    lunch.dump()

                    lunchNumber += 1
                }
            }
        }
    }
    
    func checkBalances()
    {
        // If we have arguments that describe a lunch process it, adding to the lunch list
        // print a report of the new lunch and the updated balances
        // update the final balances in the csv

        // check the lunches present and compare final balance with what is in the csv
        if debug { print("DEBUG: Process all of the lunches and check final balances.") }
        let lunches = lunchList!.lunches
        for lunch in lunches
        {
            if debug
            {
                print("lunch=\(String(describing: lunch))")
                lunch.dump()
            }
        }
    }
    
    func updateCSV()
    {
        // if we started with a csv, then update it with the new lunch
        if debug { print("DEBUG: Updating the CSV file") }
        
        if debug { print("WARNING: Updating CSV is not yet supported.") }
    }
    
    func printRow( rowNumber: Int)
    {
        var lineText = ""
        let columnLength = 9
        let row = csv!.rows[ (rowNumber) ]
        var columnNumber = 0
        while columnNumber < csv!.headers.count
        {
            let key = csv!.headers[columnNumber]
            let value = row[key]
            var stringValue : String?
            var intValue : Int?
            if value == nil && debug
            {
                print("key=\(key) value=nil")
            }
            if key.count == 0
            {
                stringValue = ""
            }
            else if key == "Date"
            {
              var dateValue = value!
                if debug { print("dateValue=\(dateValue)") }
                stringValue = "\(dateValue)"
                    // self.lunchDate.formatDate(date: dateValue as? Date)
                
            }
            //else if key ==
            else if value is String
            {
                if value != nil
                {
                stringValue = value! as! String
                }
            }
            else if value is Int
            {
                var intValue = value! as! Int
                stringValue = "\(intValue)"
            }
            if stringValue == nil
            {
                if debug {print("key=\(key) value=\(stringValue)")}
                 stringValue = "        "
            }
            while stringValue!.count < columnLength
            {
                stringValue = " \(stringValue!)"
            }
            lineText = "\(lineText)\(stringValue!)"
            columnNumber += 1
        }
        print( "\(lineText)" )
    }
    
    func printReport()
    {
        // print a report
        if debug { print("DEBUG: Printing report") }
        if debug { print("WARNING: Printing report is not yet supported.") }
        var rowNumber = 0
        for row in csv!.rows
        {
            printRow( rowNumber: rowNumber )
            rowNumber += 1
        }
    }

    func gatherData()
    {
        if url != nil
        {
            // parseData(url : String)
            // read the csv lines into csv.rows and note special (non lunch) rows.
            parseRawData()
            gatherColumns()
            gatherStartingBalance()
            gatherLunches()
            checkBalances()
            printReport()

            // and ???
        }
    }
}
