//
//  Lunch.swift
//  FredsLunch
//
//  Created by MichaelBurns on 10/22/19.
//  Copyright © 2019 MichaelBurns. All rights reserved.
//
import Foundation
import CoreData

class Lunch
{
    
    var balance = 0.0
    var date : Date?
    var eaterBalance = 0.0
    var id: String?
    var lunchDescription: String?
    var payerName: String?
    var recordedBalance: Double?
    var participants: [Participant] = []
    var lunchData: LunchData
 //   var lunchList: LunchList?
  
    init( lunchData : LunchData )
    {
        self.lunchData = lunchData
    }
    
    init( lunchData : LunchData, date: Date)
    {
        
        self.lunchData = lunchData
        self.date = date
    }
    
    
      func setLunchData( lunchData: LunchData )
      {
          self.lunchData = lunchData
      }
      
    // register a member to have participated in the new lunch
    func addParticipant( member: Member,  amountEaten: Double, amountPaid: Double )
    {
        let participant = Participant( member: member, lunch: self, amountEaten: amountEaten, amountPaid: amountPaid )
        participants.append(participant)
    }
    
    func setPayer(payerName: String, amountPaid : Double)
    {
        self.payerName = payerName
        let memberList = lunchData.memberList
        if memberList != nil
        {
            let member = memberList!.getMember(name: payerName)
            if member != nil
            {
                addParticipant( member: member!, amountEaten: 0.0, amountPaid: -(amountPaid))
            }
        }
    }
    
    func setEaters(eaterNames: [String])
    {
        let memberList = lunchData.memberList
        if memberList != nil
        {
            for eaterName in eaterNames
            {
                let member = memberList!.getMember(name: eaterName)
                if member != nil
                {
                    self.addParticipant( member: member!, amountEaten: 1.0, amountPaid: 0.0)
                }
            }
        }
    }
    
    func dump()
    {
        print( " date=\(String(describing: self.date)) payer=\(String(describing: self.payerName)) balance=\(self.balance) eaterBalance=\(self.eaterBalance) \n participants:")
        for participant in self.participants
        {
            print("  id=\(participant.id) eaten=\(participant.amountEaten) payed=\(participant.amountPaid) ")
        }
        if ( self.balance != 0 )
        {
            print("ERROR: balance is not 0.")
        }
    }
        
}
