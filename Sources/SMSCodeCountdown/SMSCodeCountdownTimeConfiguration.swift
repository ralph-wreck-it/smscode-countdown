//
//  File.swift
//  
//
//  Created by Ralph on 2020/8/11.
//

import Foundation

public protocol SMSCodeCountdownTimeConfiguration {
    static func codeCountdownTime<T: SMSCodeCountdownType>(type: T) -> SMSCodeCountdownTime
}
