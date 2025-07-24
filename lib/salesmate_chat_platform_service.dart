import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salesmate_chat_flutter_sdk/salesmate_chat.dart';

class SalesmateChatPlatformService {
  static const _salesmateChatPlatformChannel =
      MethodChannel('salesmate_chat_module');

  static void initialize() {
    _salesmateChatPlatformChannel
        .setMethodCallHandler(_handleSalesmateChatMethodCall);
  }

  static Future<dynamic> _handleSalesmateChatMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'initializeSalesmateChatSDK':
        await _initializeSalesmateChatSDK(call.arguments);
        return null;
      case 'startMessenger':
        runApp(const ChatApp());
        return null;
      case 'isInitialised':
        return SalesmateChatSdk.isInitialised;
      case 'getVisitorId':
        return SalesmateChatSdk.instance.getVisitorId();
      case 'getUserHash':
        return SalesmateChatSdk.instance.getUserHash();
      case 'getSalesmateChatSettings':
        return SalesmateChatSdk.instance.getSalesmateChatSettings();
      case 'login':
        await _handleLogin(call.arguments);
        return null;
      case 'logout':
        await _handleLogout();
        return null;
      case 'updateUser':
        await _handleUpdateUser(call.arguments);
        return null;
      case 'recordEvent':
        _handleRecordEvent(call.arguments);
        return null;
      case 'logDebug':
        SalesmateChatSdk.instance.logDebug(call.arguments as String);
        return null;
      case 'sendTokenToSalesmate':
        await _handleSendToken(call.arguments);
        return null;
      case 'isSalesmateChatSDKPush':
        return SalesmateChatSdk.instance
            .isSalesmateChatSDKPush(Map<String, dynamic>.from(call.arguments));
      case 'handleSalesmateChatSDKPush':
        SalesmateChatSdk.instance.handleSalesmateChatSDKPush(
            Map<String, dynamic>.from(call.arguments));
        return null;
      default:
        log('Unknown method call: ${call.method}');
        return null;
    }
  }

  static Future<void> _initializeSalesmateChatSDK(dynamic arguments) async {
    final params = Map<String, dynamic>.from(arguments);

    final workspaceId = params['workspaceId'] as String;
    final appKey = params['appKey'] as String;
    final tenantId = params['tenantId'] as String;
    final environment = params['environment'] as String? ?? 'production';

    ChatEnvironment chatEnvironment;
    switch (environment.toLowerCase()) {
      case 'staging':
        chatEnvironment = ChatEnvironment.STAGING;
        break;
      case 'development':
        chatEnvironment = ChatEnvironment.DEVELOPMENT;
        break;
      default:
        chatEnvironment = ChatEnvironment.PRODUCTION;
    }

    await SalesmateChatSdk.initialize(
      SalesmateChatSettings(
        workspaceId: workspaceId,
        appKey: appKey,
        tenantId: tenantId,
        environment: chatEnvironment,
      ),
    );
  }

  static Future<void> _handleLogin(dynamic arguments) async {
    print('Login Started');

    final params = Map<String, dynamic>.from(arguments);
    final userId = params['userId'] as String;
    final userDetailsMap = Map<String, dynamic>.from(params['userDetails']);

    final userDetails = UserDetails(
      firstName: userDetailsMap['firstName'],
      lastName: userDetailsMap['lastName'],
      email: userDetailsMap['email'],
      userHash: userDetailsMap['userHash'],
    );

    SalesmateChatSdk.instance.login(
      userId,
      userDetails,
      () {
        print('Login success');
      },
      (error) => print('Login error: $error'),
    );
  }

  static Future<void> _handleLogout() async {
    SalesmateChatSdk.instance.logout(
      () {},
      (error) => log('Logout error: $error'),
    );
  }

  static Future<void> _handleUpdateUser(dynamic arguments) async {
    final params = Map<String, dynamic>.from(arguments);
    final userId = params['userId'] as String;
    final userDetailsMap = Map<String, dynamic>.from(params['userDetails']);

    final userDetails = UserDetails(
      firstName: userDetailsMap['firstName'],
      lastName: userDetailsMap['lastName'],
      email: userDetailsMap['email'],
      userId: userDetailsMap['userId'],
    );

    SalesmateChatSdk.instance.update(
      userId,
      userDetails,
      () {},
      (error) => log('Update error: $error'),
    );
  }

  static void _handleRecordEvent(dynamic arguments) {
    final params = Map<String, dynamic>.from(arguments);
    final eventName = params['eventName'] as String;
    final data = Map<String, dynamic>.from(params['data']);

    SalesmateChatSdk.instance.recordEvent(eventName, data);
  }

  static Future<void> _handleSendToken(dynamic arguments) async {
    final deviceToken = arguments as String;

    SalesmateChatSdk.instance.sendTokenToSalesmate(
      deviceToken,
      () {},
      (error) => log('Send token error: $error'),
    );
  }
}
