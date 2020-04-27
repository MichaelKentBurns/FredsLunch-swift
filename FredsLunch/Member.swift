//
//  Member.swift
//  FredsLunch
//
//  Created by MichaelBurns on 10/22/19.
//  Copyright © 2019 MichaelBurns. All rights reserved.
//

import Foundation
import CoreData

class Member: NSObject// NSManagedObject
   {
    public var balance = 0.0
      public var completed = false
      public var creationDate: Date?
      public var id: String?
      public var lastAteDate: Date?
      public var lastPaidDate: Date?
      public var name: String?
      public var group: MemberList?
      public var lunches: Participant?
      public var columnOrdinal = 0

    var storedName: String?
    var didEat = false
    var didPay = false
    var xml = "      <Member/>"
    let empty = ""
    var lunchData: LunchData?
    var context : NSManagedObjectContext?
    
    // create a new member and attach it to the lunch data
    init( name: String,
          lunchData: LunchData
        )
    {
        self.lunchData = lunchData
        self.name = name
        
    }
    
    

//    class func init( //managedObjectContext : NSManagedObjectContext
//                   ) -> Member
//    {
////        let newMember = NSEntityDescription.insertNewObject(forEntityName: "Member",
////                                            into: managedObjectContext ) as! Member
////        newMember.theManagedObjectContext = managedObjectContext
//
//    }

    
}
