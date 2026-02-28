import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_ai/services/chatbot_service.dart';

class ChatbotOverlay {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;
  static bool _isChatOpen = false;
  static final List<String> _disabledScreens = [];

  static void initialize(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(builder: (context) => const ChatbotWidget());

    Overlay.of(context).insert(_overlayEntry!);
    _isVisible = true;
  }

  static void disableForScreen(String screenName) {
    if (!_disabledScreens.contains(screenName)) {
      _disabledScreens.add(screenName);
    }
  }

  static void enableForScreen(String screenName) {
    _disabledScreens.remove(screenName);
  }

  static bool isDisabledForScreen(String screenName) {
    return _disabledScreens.contains(screenName);
  }

  static void show() {
    _isVisible = true;
    _overlayEntry?.markNeedsBuild();
  }

  static void hide() {
    _isVisible = false;
    _isChatOpen = false;
    _overlayEntry?.markNeedsBuild();
  }

  static void remove() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isVisible = false;
    _isChatOpen = false;
  }

  static void toggleChat() {
    _isChatOpen = !_isChatOpen;
    _overlayEntry?.markNeedsBuild();
  }

  static bool get isVisible => _isVisible;
  static bool get isChatOpen => _isChatOpen;
}

class ChatbotWidget extends StatefulWidget {
  const ChatbotWidget({super.key});

  @override
  State<ChatbotWidget> createState() => _ChatbotWidgetState();
}

class _ChatbotWidgetState extends State<ChatbotWidget> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Welcome message
    _messages.add(
      ChatMessage(
        text: "Hello! I'm Krishi AI Assistant. How can I help you today?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
      _isTyping = true;
    });

    _textController.clear();
    _scrollToBottom();

    // Build conversation history
    final history = _messages
        .where((msg) => msg != _messages.last) // Exclude the current message
        .map(
          (msg) => {
            'role': msg.isUser ? 'user' : 'assistant',
            'content': msg.text,
          },
        )
        .toList();

    // Get bot response from backend
    final response = await ChatbotService.chatWithBot(text, history: history);

    setState(() {
      _messages.add(
        ChatMessage(text: response, isUser: false, timestamp: DateTime.now()),
      );
      _isTyping = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!ChatbotOverlay.isVisible) return const SizedBox.shrink();

    // Check if we're on language, login, or signup screen by traversing widget tree
    bool isOnRestrictedScreen = false;
    context.visitAncestorElements((element) {
      final widgetType = element.widget.runtimeType.toString();
      if (widgetType.contains('KrishiLanguageScreen') ||
          widgetType.contains('KrishiAILoginScreen') ||
          widgetType.contains('KrishiAISignUpScreen') ||
          widgetType.contains('KrishiAISplashScreen')) {
        isOnRestrictedScreen = true;
        return false; // Stop traversing
      }
      return true; // Continue traversing
    });

    if (isOnRestrictedScreen) {
      return const SizedBox.shrink();
    }

    const primary = Color(0xFF59F20D);
    const backgroundDark = Color(0xFF0A0F08);
    const surfaceDark = Color(0xFF162210);

    // Get keyboard height
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Chat Window
        if (ChatbotOverlay.isChatOpen)
          Positioned(
            right: 16,
            bottom: keyboardHeight > 0 ? keyboardHeight + 10 : 165,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: keyboardHeight > 0
                    ? screenHeight * 0.4
                    : screenHeight * 0.6,
                decoration: BoxDecoration(
                  color: backgroundDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: primary.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surfaceDark,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: primary.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.smart_toy,
                              color: primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Krishi AI Chatbot 🤖",
                                  style: GoogleFonts.spaceGrotesk(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "Online • Always here to help",
                                  style: GoogleFonts.spaceGrotesk(
                                    color: primary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                ChatbotOverlay.toggleChat();
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    // Messages Area
                    Expanded(
                      child: Container(
                        color: backgroundDark,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _messages.length,
                          reverse: false,
                          itemBuilder: (context, index) {
                            return _buildMessageBubble(_messages[index]);
                          },
                        ),
                      ),
                    ),

                    // Typing Indicator
                    if (_isTyping)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: surfaceDark,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildTypingDot(0),
                                  const SizedBox(width: 4),
                                  _buildTypingDot(1),
                                  const SizedBox(width: 4),
                                  _buildTypingDot(2),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Input Area
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: surfaceDark,
                        border: Border(
                          top: BorderSide(
                            color: primary.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                      child: SafeArea(
                        top: false,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                style: GoogleFonts.spaceGrotesk(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Ask me anything...",
                                  hintStyle: GoogleFonts.spaceGrotesk(
                                    color: Colors.grey[600],
                                  ),
                                  filled: true,
                                  fillColor: backgroundDark,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: primary.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: primary.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: primary,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                onSubmitted: _handleSubmit,
                                maxLines: null,
                                textInputAction: TextInputAction.send,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.send),
                                color: backgroundDark,
                                onPressed: () {
                                  _handleSubmit(_textController.text);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Floating Action Button
        Positioned(
          right: 16,
          bottom: 100,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF0A0F08), width: 2),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    ChatbotOverlay.toggleChat();
                  });
                },
                borderRadius: BorderRadius.circular(24),
                child: Icon(
                  ChatbotOverlay.isChatOpen ? Icons.close : Icons.chat,
                  color: backgroundDark,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    const primary = Color(0xFF59F20D);
    const surfaceDark = Color(0xFF162210);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.smart_toy, color: primary, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? primary : surfaceDark,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isUser ? 16 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 16),
                ),
                border: Border.all(
                  color: message.isUser
                      ? primary
                      : Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Text(
                message.text,
                style: GoogleFonts.spaceGrotesk(
                  color: message.isUser
                      ? const Color(0xFF0A0F08)
                      : Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person, color: primary, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -4 * (value * (index % 2 == 0 ? 1 : -1))),
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF59F20D),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () {
        if (mounted && _isTyping) {
          setState(() {});
        }
      },
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
