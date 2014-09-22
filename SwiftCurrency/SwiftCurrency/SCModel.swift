//
//  SCModel.swift
//  SwiftCurrency
//
//  Created by Teaualune Tseng on 2014/9/22.
//  Copyright (c) 2014年 corrugater. All rights reserved.
//

import Foundation

public class SCModel {

    public let currencies: [SCCurrency]
    public var selected: SCCurrency?
    public var comparings: [SCCurrency] = []

    private init() {
        let filePath = NSBundle.mainBundle().pathForResource("countries", ofType: "json")
        let data = NSData(contentsOfFile: filePath!)
        let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as Array<String>
        self.currencies = json.map({
            (n: String) -> SCCurrency in
            return SCCurrency(aCode: n)
        })
    }

    class var getInstance: SCModel {
        return singleton
    }
    
    class func getCurrency(code: String) -> SCCurrency? {
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

    class func update(callback: (() -> Void)) {
        if singleton.selected == nil {
            return
        }
        SCAPI.getData(singleton.selected!, comparings: singleton.comparings, callback: {
            (results) in
            singleton.selected!.rate(1.0)
            if results != nil {
                for var i = 0; i < results!.count; ++i {
                    let rate: NSString = (results![i] as NSDictionary)["Rate"] as NSString
                    singleton.comparings[i].rate(rate.floatValue)
                }
            }
            callback()
        })
    }

}

let singleton = SCModel()
