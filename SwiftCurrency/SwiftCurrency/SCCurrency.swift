//
//  SCCurrency.swift
//  SwiftCurrency
//
//  Created by Teaualune Tseng on 2014/9/22.
//  Copyright (c) 2014年 corrugater. All rights reserved.
//

import Foundation

public class SCCurrency: NSObject {
    private var _code: NSString

    init(aCode: NSString) {
        _code = aCode.uppercaseString
        super.init()
    }
    
    public func code(_lower: Bool?) -> NSString {
        let lower = (_lower != nil) ? _lower! : false
        return lower ? _code.lowercaseString : _code
    }

    public var imageName: NSString {
        return code(true) + ".png"
    }

    public var fullName: NSString {
        return NSLocalizedString(_code, tableName: "Currencies", comment: "")
    }

}