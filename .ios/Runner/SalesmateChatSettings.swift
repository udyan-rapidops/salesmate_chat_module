import Foundation

@objc public class SalesmateChatSettings: NSObject {
    @objc public var workspaceId: String
    @objc public var appKey: String
    @objc public var tenantId: String
    @objc public var environment: Environment
    
    @objc public init(workspaceId: String, appKey: String, tenantId: String, environment: Environment = .production) {
        self.workspaceId = workspaceId
        self.appKey = appKey
        self.tenantId = tenantId
        self.environment = environment
        super.init()
    }
    
    public func toMap() -> [String: String] {
        return [
            "workspaceId": workspaceId,
            "appKey": appKey,
            "tenantId": tenantId,
            "environment": environment.value
        ]
    }
}
