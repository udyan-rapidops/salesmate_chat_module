import Foundation

@objc public enum Environment: Int, CaseIterable {
    case production
    case staging
    case development
    
    public var value: String {
        switch self {
        case .production:
            return "production"
        case .staging:
            return "staging"
        case .development:
            return "development"
        }
    }
    
    public static func from(string: String) -> Environment {
        switch string.lowercased() {
        case "staging":
            return .staging
        case "development":
            return .development
        default:
            return .production
        }
    }
}
