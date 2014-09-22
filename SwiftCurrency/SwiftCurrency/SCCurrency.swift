//
//  SCCurrency.swift
//  SwiftCurrency
//
//  Created by Teaualune Tseng on 2014/9/22.
//  Copyright (c) 2014年 corrugater. All rights reserved.
//

import Foundation

public class SCCurrency {
    private var _code: String
    private var _rate: Float = 1.0

    init(aCode: String) {
        _code = aCode.uppercaseString
    }

    public func code(lower: Bool = false) -> String {
        return lower ? _code.lowercaseString : _code
    }

    public var imageName: String {
        return code(lower: true) + ".png"
    }

    public var fullName: String {
        return NSLocalizedString(_code, tableName: "Currencies", comment: "")
    }

    public var rate: Float {
        return _rate
    }

    public func rate(r: Float) -> Void {
        _rate = r
    }
}