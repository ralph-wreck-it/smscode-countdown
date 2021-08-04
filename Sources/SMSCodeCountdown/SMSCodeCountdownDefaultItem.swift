//
//  File.swift
//  
//
//  Created by Ralph on 2020/8/11.
//

import Foundation

struct SMSCodeCountdownDefaultItem<T: SMSCodeCountdownType>: SMSCodeCountdownItem {
    private (set) var type: T
    private (set) var countryCode: String
    private (set) var phoneNumber: String
    private (set) var countdownTime: SMSCodeCountdownTime
    private var observers: NSHashTable = NSHashTable<AnyObject>.weakObjects()
    private var endDate: Date
    
    var currentTime: SMSCodeCountdownTime {
        return SMSCodeCountdownTime(max(self.endDate.timeIntervalSinceNow, 0))
    }
    
    var isStopped: Bool {
        return currentTime == 0
    }
    
    var observersIsEmpty: Bool {
        return self.observers.allObjects.isEmpty
    }
    
    init(type: T, countryCode: String, phoneNumber: String, countdownTime: SMSCodeCountdownTime) {
        self.type = type
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
        self.countdownTime = countdownTime
        endDate = Date(timeIntervalSinceNow: TimeInterval(countdownTime))
    }
    
    @discardableResult
    func add(observer: SMSCodeCountdownItemObservering) -> Bool {
        guard self.observers.contains(observer) == false else {
            return false
        }
        self.observers.add(observer)
        return true
    }
    
    func remove(observer: SMSCodeCountdownItemObservering) {
        self.observers.remove(observer)
    }
    
    mutating func start() {
        for observer in self.observers.allObjects {
            if let observer = observer as? SMSCodeCountdownItemObservering {
                observer.SMSCodeCountdownTimeStart(item: self)
            }
        }
    }
    
    func minusOneSecond() {
        for observer in self.observers.allObjects {
            if let observer = observer as? SMSCodeCountdownItemObservering {
                observer.SMSCodeCountdownTimeChanged(item: self)
            }
        }
    }
    
    func stop() {
        for observer in self.observers.allObjects {
            if let observer = observer as? SMSCodeCountdownItemObservering {
                observer.SMSCodeCountdownTimeEnd(item: self)
            }
        }
    }
}

extension SMSCodeCountdownDefaultItem {
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(countryCode)
        hasher.combine(phoneNumber)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.type == rhs.type && lhs.countryCode == rhs.countryCode && lhs.phoneNumber == rhs.phoneNumber
    }
}
