//
//  File.swift
//  
//
//  Created by Ralph on 2020/8/11.
//

import Foundation

public typealias SMSCodeCountdownTime = UInt

public protocol SMSCodeCountdownItem: Hashable {
    associatedtype T: SMSCodeCountdownType
    var type: T { get }
    var countryCode: String { get }
    var phoneNumber: String { get }
    var countdownTime: SMSCodeCountdownTime { get }
    var currentTime: SMSCodeCountdownTime { get }
}
