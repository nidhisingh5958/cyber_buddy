import 'package:cyber_buddy/services/chat_api.dart';
import 'package:cyber_buddy/widgets/animated_particle.dart';
import 'package:cyber_buddy/screens/components/options_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:url_launcher/url_launcher.dart';

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

class ChatTab {
  final String id;
  final String title;
  final List<ChatMessage> messages;
  final DateTime createdAt;

  ChatTab({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _tabScrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final chatService = ChatService();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int _currentTabIndex = 0;
  List<ChatTab> _chatTabs = [];
  bool _isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();

    // Initialize with default chat
    _chatTabs.add(
      ChatTab(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: "Cyber Security Assistant",
        createdAt: DateTime.now(),
        messages: [],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _tabScrollController.dispose();
    _focusNode.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _createNewChat() {
    setState(() {
      String newChatId = DateTime.now().millisecondsSinceEpoch.toString();
      _chatTabs.add(
        ChatTab(
          id: newChatId,
          title: "~",
          createdAt: DateTime.now(),
          messages: [],
        ),
      );
      _currentTabIndex = _chatTabs.length - 1;
    });

    // Scroll to the newly created tab
    Future.delayed(Duration(milliseconds: 100), () {
      if (_tabScrollController.hasClients) {
        _tabScrollController.animateTo(
          _tabScrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    _scrollToBottom();
  }

  void _closeChat(int index) {
    if (_chatTabs.length > 1) {
      setState(() {
        _chatTabs.removeAt(index);
        if (_currentTabIndex >= index && _currentTabIndex > 0) {
          _currentTabIndex--;
        } else if (_currentTabIndex >= _chatTabs.length) {
          _currentTabIndex = _chatTabs.length - 1;
        }
      });
    }
  }

  void _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _chatTabs[_currentTabIndex].messages.add(
        ChatMessage(text: message, isUser: true, timestamp: DateTime.now()),
      );
      _isLoading = true;
    });

    _messageController.clear();

    try {
      final response = await chatService.sendMessage(message);
      setState(() {
        _chatTabs[_currentTabIndex].messages.add(
          ChatMessage(
            // Fix the response handling
            text: response.toString(),
            timestamp: DateTime.now(),
            isUser: false,
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _chatTabs[_currentTabIndex].messages.add(
          ChatMessage(
            text: 'Error: ${e.toString()}',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch URL: $url'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid URL: $url'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<ChatMessage> get _currentMessages {
    return _chatTabs.isNotEmpty ? _chatTabs[_currentTabIndex].messages : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0f0f0f),
      body: Column(
        children: [
          // Top bar with tabs
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1a1a1a), Color(0xFF2d2d2d)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    // home icon
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 6),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Navigate to home or perform home action
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFF2d2d2d),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Color(0xFF404040).withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.home,
                              color: Colors.grey[300],
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Chat Tabs
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _tabScrollController,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            ..._chatTabs.asMap().entries.map((entry) {
                              int index = entry.key;
                              ChatTab tab = entry.value;
                              bool isActive = index == _currentTabIndex;

                              return Container(
                                margin: EdgeInsets.only(right: 6),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _currentTabIndex = index;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(6),
                                    child: Container(
                                      constraints: BoxConstraints(
                                        minWidth: 100,
                                        maxWidth: 200,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isActive
                                                ? Color(0xFF2d2d2d)
                                                : Color(0xFF1a1a1a),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color:
                                              isActive
                                                  ? Color(
                                                    0xFF4a9eff,
                                                  ).withOpacity(0.5)
                                                  : Color(
                                                    0xFF404040,
                                                  ).withOpacity(0.3),
                                          width: 1,
                                        ),
                                        boxShadow:
                                            isActive
                                                ? [
                                                  BoxShadow(
                                                    color: Color(
                                                      0xFF4a9eff,
                                                    ).withOpacity(0.2),
                                                    blurRadius: 8,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ]
                                                : null,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 6),
                                            child: Icon(
                                              Icons.security,
                                              size: 14,
                                              color:
                                                  isActive
                                                      ? Color(0xFF4a9eff)
                                                      : Colors.grey[500],
                                            ),
                                          ),
                                          Flexible(
                                            child: Container(
                                              constraints: BoxConstraints(
                                                maxWidth:
                                                    _chatTabs.length > 1
                                                        ? 120
                                                        : 140,
                                              ),
                                              child: Text(
                                                tab.title,
                                                style: TextStyle(
                                                  color:
                                                      isActive
                                                          ? Colors.white
                                                          : Colors.grey[400],
                                                  fontSize: 13,
                                                  fontWeight:
                                                      isActive
                                                          ? FontWeight.w600
                                                          : FontWeight.w500,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          if (_chatTabs.length > 1) ...[
                                            SizedBox(width: 4),
                                            GestureDetector(
                                              onTap: () => _closeChat(index),
                                              child: Container(
                                                padding: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 14,
                                                  color:
                                                      isActive
                                                          ? Colors.grey[300]
                                                          : Colors.grey[500],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),

                    // Add New Tab Button
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _createNewChat,
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFF2d2d2d),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Color(0xFF404040).withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.grey[300],
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Menu/Options Button
                    Container(
                      margin: EdgeInsets.only(right: 6),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Add menu functionality here
                            showOptionsMenu(
                              context,
                              _currentTabIndex,
                              _chatTabs,
                              () {
                                setState(() {
                                  _currentTabIndex = 0;
                                });
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFF2d2d2d),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Color(0xFF404040).withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey[300],
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // User Profile
                    Container(
                      margin: EdgeInsets.only(right: 12),
                      child: Container(
                        padding: EdgeInsets.all(1.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF4a9eff), Color(0xFF6c5ce7)],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(0xFF2d2d2d),
                          child: Text(
                            'N',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          Expanded(
            child: Stack(
              children: [
                // Animated particle background
                ...List.generate(8, (index) => AnimatedParticle(index: index)),
                // Main chat content with fade animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 170, 170, 176).withOpacity(0.95),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child:
                              _currentMessages.isEmpty
                                  ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.security,
                                          size: 64,
                                          color: Colors.grey[600],
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Welcome to Cyber Buddy',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Ask me about cybersecurity topics',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  : ListView.builder(
                                    controller: _scrollController,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    itemCount:
                                        _currentMessages.length +
                                        (_isLoading ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index == _currentMessages.length &&
                                          _isLoading) {
                                        return _buildLoadingMessage();
                                      }
                                      return _buildMessageText(
                                        _currentMessages[index],
                                        index,
                                      );
                                    },
                                  ),
                        ),
                        _buildMessageInput(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMessage() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1a1a1a).withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF2d2d2d), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4a9eff), Color(0xFF00b894)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.psychology_outlined,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'AI Assistant',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4a9eff)),
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Thinking...',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageText(ChatMessage message, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF1a1a1a).withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      message.isUser
                          ? Color(0xFF4a9eff).withOpacity(0.3)
                          : Color(0xFF2d2d2d),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with user/assistant indicator and timestamp
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:
                                message.isUser
                                    ? [Color(0xFF6c5ce7), Color(0xFF4a9eff)]
                                    : [Color(0xFF4a9eff), Color(0xFF00b894)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              message.isUser
                                  ? Icons.person_outline
                                  : Icons.security,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 6),
                            Text(
                              message.isUser ? 'You' : 'Cyber Buddy',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        child: GestureDetector(
                          child: Icon(
                            message.isUser ? Icons.person_outline : Icons.copy,
                            color:
                                message.isUser
                                    ? Color(0xFF6c5ce7)
                                    : Color(0xFF4a9eff),
                            size: 16,
                          ),
                          onTap: () {
                            // Handle copy or user profile action
                            if (message.isUser) {
                              // Show user profile
                              debugPrint('User profile tapped');
                            } else {
                              // Copy message text to clipboard
                              Clipboard.setData(
                                ClipboardData(text: message.text),
                              ).then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Copied to your clipboard !'),
                                  ),
                                );
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Message copied to clipboard'),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF2d2d2d),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Message content
                  _buildFormattedText(message.text),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormattedText(String text) {
    return MarkdownWidget(
      data: text,
      config: MarkdownConfig(
        configs: [
          // Code block configuration
          PreConfig(
            decoration: BoxDecoration(
              color: Color(0xFF2d2d2d).withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color(0xFF4a9eff).withOpacity(0.3),
                width: 1,
              ),
            ),
            padding: EdgeInsets.all(12),
            textStyle: TextStyle(
              color: Color(0xFF00ff88), // Green color for code
              fontFamily: 'Courier New',
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          // Inline code configuration
          CodeConfig(
            style: TextStyle(
              color: Color(0xFF00ff88),
              backgroundColor: Color(0xFF2d2d2d).withOpacity(0.6),
              fontFamily: 'Courier New',
              fontSize: 13,
            ),
          ),
          // H1 heading configuration
          H1Config(
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          // H2 heading configuration
          H2Config(
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          // H3 heading configuration
          H3Config(
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          // H4 heading configuration
          H4Config(
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          // H5 heading configuration
          H5Config(
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          // H6 heading configuration
          H6Config(
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          // Paragraph configuration
          PConfig(
            textStyle: TextStyle(
              color: Colors.grey[300],
              fontSize: 14,
              height: 1.5,
            ),
          ),
          // Link configuration
          LinkConfig(
            style: TextStyle(
              color: Color(0xFF4a9eff),
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
            onTap: (url) {
              // Handle link taps
              _launchURL(url);
            },
          ),
          // Blockquote configuration
          // BlockquoteConfig(
          //   style: TextStyle(
          //     color: Colors.grey[300],
          //     fontSize: 14,
          //     fontStyle: FontStyle.italic,
          //   ),
          // ),
          // Table configuration
          TableConfig(),
        ],
      ),
      shrinkWrap: true,
      selectable: true,
    );
  }

  String _formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1a1a1a).withOpacity(0.9),
        border: Border(top: BorderSide(color: Color(0xFF2d2d2d), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _focusNode,
              style: TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                border: InputBorder.none,
              ),
              onSubmitted: (text) => _sendMessage(text),
              textInputAction: TextInputAction.send,
            ),
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () => _sendMessage(_messageController.text),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF4a9eff),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
