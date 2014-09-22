//
//  SCModel.swift
//  SwiftCurrency
//
//  Created by Teaualune Tseng on 2014/9/22.
//  Copyright (c) 2014年 corrugater. All rights reserved.
//

import Foundation

public class SCModel: NSObject {

    public let currencies: NSArray
    public var selected: SCCurrency?
    public let comparings: NSMutableArray

    private override init() {
        let filePath = NSBundle.mainBundle().pathForResource("countries", ofType: "json")
        let data = NSData(contentsOfFile: filePath!)
        let json: NSArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSArray
        let ccy = NSMutableArray(capacity: json.count)
        for j in json {
            ccy.addObject(SCCurrency(aCode: j as NSString))
        }
        self.currencies = ccy.copy() as NSArray
        self.comparings = NSMutableArray(capacity: self.currencies.count)
        super.init()
    }

    class var getInstance: SCModel {
        return singleton
    }
    
    class func getCurrency(code: NSString) -> SCCurrency? {
        var ccy: SCCurrency? = nil
        for _c in singleton.currencies {
            let c = _c as SCCurrency
            if c.code() == code.uppercaseString {
                ccy = c
                break
            }
        }
        return ccy
    }
}

let singleton = SCModel()