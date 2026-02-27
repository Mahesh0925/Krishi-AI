import 'package:flutter/material.dart';
import 'package:krishi_ai/widgets/chatbot_overlay.dart';

class ChatbotWrapper extends StatefulWidget {
  final Widget child;
  final bool showChatbot;

  const ChatbotWrapper({
    super.key,
    required this.child,
    this.showChatbot = true,
  });

  @override
  State<ChatbotWrapper> createState() => _ChatbotWrapperState();
}

class _ChatbotWrapperState extends State<ChatbotWrapper> {
  @override
  void initState() {
    super.initState();
    if (widget.showChatbot) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ChatbotOverlay.initialize(context);
      });
    }
  }

  @override
  void didUpdateWidget(ChatbotWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showChatbot != oldWidget.showChatbot) {
      if (widget.showChatbot) {
        ChatbotOverlay.show();
      } else {
        ChatbotOverlay.hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
