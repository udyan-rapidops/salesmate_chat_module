import 'package:flutter/widgets.dart';

import 'salesmate_chat_platform_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SalesmateChatPlatformService.initialize();
}