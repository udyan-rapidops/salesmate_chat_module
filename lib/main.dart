import 'package:flutter/material.dart';
import 'package:salesmate_chat_flutter_sdk/salesmate_chat.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SalesmateChatSdk.initialize(
    SalesmateChatSettings(
      workspaceId: "4767fb55-97c3-4911-8cd2-6c5addeb2723",
      appKey: "e4bd8170-7f09-11eb-a375-eb59ba1215d5",
      tenantId: "chatplatform.salesmate.io",
      environment: ChatEnvironment.PRODUCTION,
    ),
  );

  runApp(const ChatApp());
}
