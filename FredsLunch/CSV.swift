//
//  CSV.swift
//  FredsLunch
//
//  Created by MichaelBurns on 10/22/19.
//  Copyright © 2019 MichaelBurns. All rights reserved.
//

import Foundation
class CSV
{
    public var headers = [String]()
    public var rows = [[String : AnyObject]]()
    public let columns = [String: AnyObject]()
    
    let separator = ","
    var hasData : Bool = false
    let lineSeparator = "\r\n"
    let columnSeparator = ","
    // let possibleLineSeparators = ["\r\n","\r","\n"]
    var lines : [String]? = nil
    var debug : Bool = false
    var endingBalanceRowNumber = 0
    var startingBalanceRowNumber = 0
    var columnBalanceRowNumber = 0
    var firstColumnName : String?
    
    
    
    // initialize the CSF instance
    init(urlArg: URL?, debug: Bool)
    {
        self.debug = debug
        var csvString: String?
        var url = urlArg
        if url == nil
        {
            url = URL(fileURLWithPath: "./FredsLunch.csv")
        }
        
        // read all the data from the csv file
        do
        {
            csvString = try String(contentsOf: url!)
        } catch
        {
            print("ERROR: An error occurred reading. url=(url) error: \(error.localizedDescription) ")
        }
        
        if debug && csvString != nil
        {
            print("Fetched data text  Data=\(csvString!)")
        }
        
        if let csvStringToParse = csvString
        {
            
            lines = csvStringToParse.components(separatedBy: "\r\n")
            
            if lines != nil
            {
                // parse out the header column names
                headers = parseHeaders(fromLines: lines!)
                
                // if there were any values, go through them
                if headers.count > 0
                {   if debug { print("\nColumn Headers:") }
                    var columnIndex = 0
                    for value in headers
                    {
                        if debug
                        {
                            print("column #\(columnIndex) is titled \(value)")
                        }
                        
                        if columnIndex == 0
                        {
                            // this is the first column
                            firstColumnName = value
                        }
                        columnIndex += 1
                    }
                }
                
                // read the rest of the file and create rows array
                rows = parseRows(fromLines: lines!)
                hasData = true
            }
            
        }
    }
    
    // parse out the column headers from the first line
    func parseHeaders(fromLines lines: [String]) -> [String]
    {
        return lines[0].components(separatedBy: CharacterSet.init(charactersIn: columnSeparator))
    }
    
    // read the lines and create rows in an array as appropriate
    func parseRows(fromLines lines: [String]) -> [[String: AnyObject]]
    {
        var lineNumber = 0
        for line in lines
        {
            
            lineNumber += 1
            // ignore the header line
            if ( lineNumber == 1 )
            { continue }
            
            if debug { print("\nline \(lineNumber) : \(line)") }
            //            var row = Dictionary<String, AnyObject?>()
            
            // create an empty rowValues dictionary
            var rowValues : [ String : AnyObject ] = [:]
            
            // break the line into columns
            let values = line.components(separatedBy: CharacterSet(charactersIn: columnSeparator ))
            let rowIndex = rows.count
            if debug { print(" lineNumber=\(lineNumber) rowIndex=\(rowIndex)") }
            rowValues["_N_"] = lineNumber as AnyObject?
            
            // go through the columns in this line
            var columnIndex = 0
            for header in self.headers
            {
                // if it's not empty line and the column header is not empty
                if ( values.count > columnIndex && header != "" )
                {
                    // the columnName is the value of the column in the headers line
                    let columnName : String = headers[columnIndex]
                    let textValue = values[columnIndex]
                    
                    // Three lines have special meanings
                    
                    
                    // try all the supported data types until we find a match
                    var value : AnyObject? = nil
                    if let intValue = Int(textValue)
                    {
                        value = intValue as AnyObject?
                    }
                    else if textValue == "true"
                    {
                        value = true as AnyObject?
                    }
                    else if textValue == "false"
                    {
                        value = false as AnyObject?
                    }
                    else
                    {
                        let testValue = "\(textValue)"
                        if !testValue.isEmpty
                        {
                            value = testValue as AnyObject
                        }
                    }
                    
                    if value != nil
                    {
                        
                        // stow the value in the row as appropriate type
                        rowValues[columnName] = value
                        if debug
                        {
                           print("row[\(rowIndex)] lineNumber=\(lineNumber) column=\(columnIndex) value=\(String(describing: value))")
                        }
                        
                    }
                    
                    // a few rows contain special information rather than lunch data
                    if firstColumnName != nil && columnName == firstColumnName!
                    {
                        if textValue == "(numeric)"
                        {
                            endingBalanceRowNumber = rowIndex
                            if debug
                            {
                                print("Found ending balance row. number=\(endingBalanceRowNumber)")
                            }
                        }
                        else if textValue.hasPrefix("From ")
                        {
                            startingBalanceRowNumber = rowIndex
                            
                            if debug
                            {
                                print("Found starting balance row. number=\(startingBalanceRowNumber)")
                            }
                        }
                        else if textValue == "ColumnBalance"
                        {
                            columnBalanceRowNumber = rowIndex
                            if debug
                            {
                                print("Found ending balance row. number=\(columnBalanceRowNumber)")
                            }
                        }
                    }
                }
                columnIndex += 1
                
            }
            
            if rowValues.count > 2
            {
                rows.append(rowValues)
            }
        }
        
        return rows
    }
    
    func parseColumns(fromLines lines: [String]) -> [String: AnyObject?]
        
    {
        let columns = [String: AnyObject?]()
        
        for header in self.headers
        {
            // ??
            let column = self.rows.map { row in row[header]! }
            //     columns[header] = column
            if debug { print("column = \(column)") }
        }
        
        return columns
    }
    
}
