//
//  File.swift
//  
//
//  Created by Ralph on 2020/8/11.
//

import Foundation

public protocol SMSCodeCountdownItemObservering: class {
    func SMSCodeCountdownTimeStart<T: SMSCodeCountdownItem>(item: T)
    func SMSCodeCountdownTimeChanged<T: SMSCodeCountdownItem>(item: T)
    func SMSCodeCountdownTimeEnd<T: SMSCodeCountdownItem>(item: T)
}

