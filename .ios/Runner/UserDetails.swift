import Foundation

@objc public class UserDetails: NSObject {
    @objc public var email: String
    @objc public var firstName: String
    @objc public var lastName: String
    @objc public var userHash: String
    
    @objc public init(email: String, firstName: String, lastName: String, userHash: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.userHash = userHash
        super.init()
    }
    
    public func toMap() -> [String: String] {
        return [
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "userHash": userHash
        ]
    }
}
