//
//  File.swift
//
//
//  Created by Ralph on 2020/8/11.
//

import Foundation

public final class SMSCodeCountdownManager<T: SMSCodeCountdownType> {
    private var configuration: SMSCodeCountdownTimeConfiguration.Type
    private var itemSet: Set<SMSCodeCountdownDefaultItem> = Set<SMSCodeCountdownDefaultItem<T>>()
    private var timer: DispatchSourceTimer?
    
    private enum CheckResult {
        case nonExistent
        case existent(SMSCodeCountdownDefaultItem<T>)
    }
    
    public init(configuration: SMSCodeCountdownTimeConfiguration.Type) {
        self.configuration = configuration
    }
    
    public func startItem(type: T, countryCode: String, phoneNumber: String, observer: SMSCodeCountdownItemObservering?) {
        self.startItem(type: type, countryCode: countryCode, phoneNumber: phoneNumber, observer: observer, countdownTime: configuration.codeCountdownTime(type: type))
    }
    
    public func startItem(type: T, countryCode: String, phoneNumber: String, observer: SMSCodeCountdownItemObservering?, countdownTime: SMSCodeCountdownTime) {
        guard !self.checkItemIsRunning(type: type, countryCode: countryCode, phoneNumber: phoneNumber, addobserverIfRunning: observer) else {
            return
        }
        var item = self.createItem(type: type, countryCode: countryCode, phoneNumber: phoneNumber, countdownTime: countdownTime)
        self.itemSet.insert(item)
        if let observer = observer {
            item.add(observer: observer)
        }
        item.start()
        self.startIfNeed()
    }
    
    public func checkItemIsRunning(type: T, countryCode: String, phoneNumber: String, addobserverIfRunning observer: SMSCodeCountdownItemObservering?) -> Bool {
        let checkResult = self.checkIsRunning(type: type, countryCode: countryCode, phoneNumber: phoneNumber)
        switch checkResult {
        case .nonExistent:
            return false
        case .existent(let item):
            if let observer = observer {
                item.add(observer: observer)
            }
            return true
        }
    }
    
    public func checkItemIsRunning(type: T, countryCode: String, phoneNumber: String) -> Bool {
        let checkResult = self.checkIsRunning(type: type, countryCode: countryCode, phoneNumber: phoneNumber)
        switch checkResult {
        case .nonExistent:
            return false
        case .existent(_):
            return true
        }
    }
    
    public func removeItem(type: T, countryCode: String, phoneNumber: String) {
        let checkResult = self.checkIsRunning(type: type, countryCode: countryCode, phoneNumber: phoneNumber)
        switch checkResult {
        case .existent(let item):
            self.itemSet.remove(item)
        default: break
        }
    }
    
    public func removeobserver(type: T, countryCode: String, phoneNumber: String, observer: SMSCodeCountdownItemObservering) {
        let checkResult = self.checkIsRunning(type: type, countryCode: countryCode, phoneNumber: phoneNumber)
        switch checkResult {
        case .existent(let item):
            item.remove(observer: observer)
        default: break
        }
    }
    
    public func removeobserver(observer: SMSCodeCountdownItemObservering) {
        for item in self.itemSet {
            item.remove(observer: observer)
        }
    }
    
    private func checkIsRunning(type: T, countryCode: String, phoneNumber: String) -> CheckResult {
        let item = createItem(type: type, countryCode: countryCode, phoneNumber: phoneNumber, countdownTime: 0)
        if self.itemSet.contains(item) {
            let metaItem = self.itemSet.insert(item).memberAfterInsert
            return .existent(metaItem)
        }
        return .nonExistent
    }
    
    private func createItem(type: T, countryCode: String, phoneNumber: String, countdownTime: SMSCodeCountdownTime) -> SMSCodeCountdownDefaultItem<T> {
        return SMSCodeCountdownDefaultItem(type: type, countryCode: countryCode, phoneNumber: phoneNumber, countdownTime: countdownTime)
    }
    
    private func startIfNeed() {
        if self.timer == nil {
            start()
        }
    }
    
    private func start() {
        self.timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        self.timer?.schedule(deadline: DispatchTime.now(), repeating: .seconds(1))
        self.timer?.setEventHandler(handler: {
            DispatchQueue.main.async { [weak self] in
             self?.timerHandler()
            }
        })
        self.timer?.resume()
    }
    
    private func timerHandler() {
        for item in Array(self.itemSet) {
            defer {
                if item.isStopped {
                    item.stop()
                    self.itemSet.remove(item)
                }
                if self.itemSet.isEmpty {
                    self.timer?.cancel()
                    self.timer = nil
                }
            }
            if !item.observersIsEmpty {
                item.minusOneSecond()
            }
        }
    }
}

