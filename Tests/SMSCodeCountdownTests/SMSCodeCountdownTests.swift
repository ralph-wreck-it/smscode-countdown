import XCTest
@testable import SMSCodeCountdown

final class SMSCodeCountdownTests: XCTestCase {
    func testExample() {
        let manager = SMSCodeCountdownManager<XTSMSCodeCountdownType>(configuration: XTSMSCodeCountdownTimeConfiguration.self)
        let viewController: XTViewController = XTViewController()
        manager.startItem(type: .signIn, countryCode: "+86", phoneNumber: "183", observer: viewController)
        manager.startItem(type: .signIn, countryCode: "+86", phoneNumber: "183", observer: viewController)
        manager.startItem(type: .signUp, countryCode: "+86", phoneNumber: "183", observer: viewController)
        manager.startItem(type: .signUp, countryCode: "+93", phoneNumber: "183", observer: viewController, countdownTime: 10)
        RunLoop.current.run()
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

enum XTSMSCodeCountdownType:Int, SMSCodeCountdownType {
    case signIn = 0
    case signUp = 1
}

class XTSMSCodeCountdownTimeConfiguration: SMSCodeCountdownTimeConfiguration {
    static func codeCountdownTime<T>(type: T) -> SMSCodeCountdownTime where T : SMSCodeCountdownType {
        guard let type = type as? XTSMSCodeCountdownType else {
            return 60
        }
        
        switch type {
        case .signIn:
            return 30
        case .signUp:
            return 20
        }
    }
}

class XTViewController: SMSCodeCountdownItemObservering {
    func SMSCodeCountdownTimeStart<T>(item: T) where T : SMSCodeCountdownItem {
        print("start type= \(item.type), countryCode = \(item.countryCode), phoneNumber = \(item.phoneNumber)")
    }
    
    func SMSCodeCountdownTimeChanged<T>(item: T) where T : SMSCodeCountdownItem {
        print("changed type= \(item.type), countryCode = \(item.countryCode), phoneNumber = \(item.phoneNumber), time = \(item.currentTime)")
    }
    
    func SMSCodeCountdownTimeEnd<T>(item: T) where T : SMSCodeCountdownItem {
        print("end type= \(item.type), countryCode = \(item.countryCode), phoneNumber = \(item.phoneNumber)")
    }
}
