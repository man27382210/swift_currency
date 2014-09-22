//
//  SCAPI.swift
//  SwiftCurrency
//
//  Created by Teaualune Tseng on 2014/9/22.
//  Copyright (c) 2014年 corrugater. All rights reserved.
//

import Foundation
import Alamofire

let path = "https://query.yahooapis.com/v1/public/yql?format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&q="

public class SCAPI {
    class func getData(main: SCCurrency, comparings: Array<SCCurrency>, callback: ((results: NSArray?) -> Void)!) {
        if comparings.count == 0 {
            callback(results: nil)
            return
        }
        let api = path + self.queryStringFromData(main, comparings: comparings)
        Alamofire.request(.GET, api).response {(req, res, _data, err) in
            if err != nil {
                callback(results: nil)
            } else {
                let data: NSData = _data as NSData!
                let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                let results: NSArray = ((json["query"] as NSDictionary)["results"] as NSDictionary)["rate"] as NSArray
                callback(results: results)
            }
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
        return ("select * from yahoo.finance.xchange where pair in (" + codes + ")").stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)!
    }
}