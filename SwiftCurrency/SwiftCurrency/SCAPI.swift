//
//  SCAPI.swift
//  SwiftCurrency
//
//  Created by Teaualune Tseng on 2014/9/22.
//  Copyright (c) 2014年 corrugater. All rights reserved.
//

import Foundation
import Alamofire

let api = "https://query.yahooapis.com/v1/public/yql"
//let queryTemplate = "select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22SHPUSD%22%2C%22GBPUSD%22)"
let queryTemplate = "select * from yahoo.finance.xchange where pair in ({{pairs}})"

public class SCAPI {
    class func getData(main: SCCurrency, comparings: Array<SCCurrency>, callback: ((results: NSArray) -> Void)!) {
        var params = [
            "q": self.queryStringFromData(main, comparings: comparings),
            "format": "json",
            "env": "store://datatables.org/alltableswithkeys"
        ] as [String: AnyObject]
        Alamofire.request(.GET, api, parameters: params).response {(req, res, _data, err) in
            let data: NSData = _data as NSData!
            let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            let results: NSArray = ((json["query"] as NSDictionary)["results"] as NSDictionary)["rate"] as NSArray
            callback(results: results)
        }
    }
    
    private class func queryStringFromData(main: SCCurrency, comparings: Array<SCCurrency>) -> NSString {
        var codes = ""
        if comparings.count > 0 {
            codes = "\"" + main.code() + comparings[0].code() + "\""
            for var i = 1; i < comparings.count; ++i {
                codes += ", \"" + main.code() + comparings[i].code() + "\""
            }
        }
        return "select * from yahoo.finance.xchange where pair in (" + codes + ")"
    }
}