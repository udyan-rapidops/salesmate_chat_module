import Foundation
import Flutter

@objc(SalesmateChat)
public class SalesmateChat: NSObject {
    private static let flutterEngineCacheKey = "salesmate_chat_engine"
    private static let methodChannelName = "salesmate_chat_module"
    
    private static var flutterEngine: FlutterEngine?
    
    private static func withEngine<T>(_ action: (FlutterEngine) -> T) -> T? {
        guard let engine = flutterEngine else { return nil }
        return action(engine)
    }
    
    private static func invokeMethod(_ methodName: String, arguments: Any? = nil) {
        withEngine { engine in
            let channel = FlutterMethodChannel(name: methodChannelName, binaryMessenger: engine.binaryMessenger)
            channel.invokeMethod(methodName, arguments: arguments)
        }
    }
    
    private static func invokeMethodWithResult<T>(_ methodName: String, arguments: Any? = nil, defaultValue: T, completion: @escaping (T) -> Void) {
        withEngine { engine in
            let channel = FlutterMethodChannel(name: methodChannelName, binaryMessenger: engine.binaryMessenger)
            channel.invokeMethod(methodName, arguments: arguments) { result in
                if let typedResult = result as? T {
                    completion(typedResult)
                } else {
                    completion(defaultValue)
                }
            }
        } ?? completion(defaultValue)
    }
    
    @objc public static func initialize(settings: SalesmateChatSettings) {
        let flutterDartProject = FlutterDartProject()
        flutterEngine = FlutterEngine(name: flutterEngineCacheKey, project: flutterDartProject)
        
        guard let engine = flutterEngine else { return }
        
        engine.run()
        
        invokeMethod("initializeSalesmateChatSDK", arguments: settings.toMap())
    }
    
    @objc public static func launchApp(from viewController: UIViewController) {
        guard let engine = flutterEngine else { return }
        
        let flutterViewController = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
        viewController.present(flutterViewController, animated: true)
    }
    
    @objc public static func startMessenger() {
        invokeMethod("startMessenger")
    }
    
    @objc public static func isInitialised(completion: @escaping (Bool) -> Void) {
        invokeMethodWithResult("isInitialised", defaultValue: false, completion: completion)
    }
    
    @objc public static func getVisitorId(completion: @escaping (String) -> Void) {
        invokeMethodWithResult("getVisitorId", defaultValue: "", completion: completion)
    }
    
    @objc public static func getUserHash(completion: @escaping (String) -> Void) {
        invokeMethodWithResult("getUserHash", defaultValue: "", completion: completion)
    }
    
    @objc public static func login(userId: String, userDetails: UserDetails) {
        let params: [String: Any] = [
            "userId": userId,
            "userDetails": userDetails.toMap()
        ]
        invokeMethod("login", arguments: params)
    }
    
    @objc public static func logout() {
        invokeMethod("logout")
    }
    
    @objc public static func updateUser(userId: String, userDetails: UserDetails) {
        let params: [String: Any] = [
            "userId": userId,
            "userDetails": userDetails.toMap()
        ]
        invokeMethod("updateUser", arguments: params)
    }
    
    @objc public static func recordEvent(eventName: String, data: [String: Any]) {
        let params: [String: Any] = [
            "eventName": eventName,
            "data": data
        ]
        invokeMethod("recordEvent", arguments: params)
    }
    
    @objc public static func logDebug(message: String) {
        invokeMethod("logDebug", arguments: message)
    }
    
    @objc public static func sendTokenToSalesmate(deviceToken: String) {
        invokeMethod("sendTokenToSalesmate", arguments: deviceToken)
    }
    
    @objc public static func isSalesmateChatSDKPush(valueMap: [String: Any], completion: @escaping (Bool) -> Void) {
        invokeMethodWithResult("isSalesmateChatSDKPush", arguments: valueMap, defaultValue: false, completion: completion)
    }
    
    @objc public static func handleSalesmateChatSDKPush(valueMap: [String: Any]) {
        invokeMethod("handleSalesmateChatSDKPush", arguments: valueMap)
    }
}
