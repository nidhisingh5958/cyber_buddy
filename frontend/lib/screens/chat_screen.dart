import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedParticle extends StatefulWidget {
  final int index;

  AnimatedParticle({required this.index});

  @override
  _AnimatedParticleState createState() => _AnimatedParticleState();
}

class _AnimatedParticleState extends State<AnimatedParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _moveAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 4 + widget.index * 2),
      vsync: this,
    );

    _moveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticInOut));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      Color(0xFF4a9eff).withOpacity(0.15),
      Color(0xFF6c5ce7).withOpacity(0.15),
      Color(0xFFfd79a8).withOpacity(0.15),
      Color(0xFFfdcb6e).withOpacity(0.15),
      Color(0xFF00b894).withOpacity(0.15),
      Color(0xFFe17055).withOpacity(0.15),
    ];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: 30.0 + widget.index * 120.0 + _moveAnimation.value * 80,
          top: 80.0 + widget.index * 100.0 + _moveAnimation.value * 150,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 40 + widget.index * 15.0,
                height: 40 + widget.index * 15.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colors[widget.index % colors.length],
                      colors[widget.index % colors.length].withOpacity(0.05),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors[widget.index % colors.length],
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
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
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _tabScrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int _currentTabIndex = 0;
  List<ChatTab> _chatTabs = [];

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
        title: "plan a ai assistant making plan for cyber security",
        createdAt: DateTime.now(),
        messages: [
          ChatMessage(
            text: "plan a ai assistant making plan for cyber security",
            isUser: true,
            timestamp: DateTime.now().subtract(Duration(minutes: 5)),
          ),
          ChatMessage(
            text:
                """I'll help you create a plan for developing an AI assistant focused on cybersecurity. I'll structure this as a comprehensive plan that covers key aspects of development and security considerations.

1. Core Functionality Requirements:
• Threat detection and analysis
• Security assessment capabilities
• Incident response guidance
• Vulnerability scanning
• Security best practices recommendations
• Compliance monitoring

2. Security Features:
• End-to-end encryption
• Secure data handling
• Authentication and authorization
• Audit logging
• Data anonymization
• Access control mechanisms

3. Development Phases:

Phase 1: Foundation
• Define scope and use cases
• Design system architecture
• Implement core security features""",
            isUser: false,
            timestamp: DateTime.now().subtract(Duration(minutes: 4)),
          ),
        ],
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

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty || _chatTabs.isEmpty) return;

    setState(() {
      _chatTabs[_currentTabIndex].messages.add(
        ChatMessage(
          text: _messageController.text.trim(),
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );

      // Update tab title if it's "~" (new chat)
      if (_chatTabs[_currentTabIndex].title == "~") {
        String newTitle = _messageController.text.trim();
        if (newTitle.length > 40) {
          newTitle = newTitle.substring(0, 40) + "...";
        }
        _chatTabs[_currentTabIndex] = ChatTab(
          id: _chatTabs[_currentTabIndex].id,
          title: newTitle,
          createdAt: _chatTabs[_currentTabIndex].createdAt,
          messages: _chatTabs[_currentTabIndex].messages,
        );
      }
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response after a delay
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _chatTabs[_currentTabIndex].messages.add(
          ChatMessage(
            text:
                """I'd be happy to help you with that! Here are some key considerations:

**Technical Requirements:**
• Programming language selection
• Framework and libraries needed
• Database requirements
• API integrations

**Project Scope:**
• Core features to implement
• User interface requirements
• Performance expectations
• Security considerations

**Development Approach:**
• Project timeline
• Testing strategy
• Deployment plan

Can you provide more details about what specific type of project you're working on?""",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
      _scrollToBottom();
    });
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

  List<ChatMessage> get _currentMessages {
    return _chatTabs.isNotEmpty ? _chatTabs[_currentTabIndex].messages : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0f0f0f),
      body: Column(
        children: [
          // Replace the existing top bar Container in your ChatScreen build method with this:
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
                height: 50, // Reduced height for more compact look
                child: Row(
                  children: [
                    // Chat Tabs - with improved spacing
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _tabScrollController,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(
                          left: 12,
                        ), // Reduced left padding
                        child: Row(
                          children: [
                            ..._chatTabs.asMap().entries.map((entry) {
                              int index = entry.key;
                              ChatTab tab = entry.value;
                              bool isActive = index == _currentTabIndex;

                              return Container(
                                margin: EdgeInsets.only(
                                  right: 6,
                                ), // Reduced margin between tabs
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
                                        minWidth: 100, // Reduced minimum width
                                        maxWidth: 200, // Reduced maximum width
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            8, // Reduced horizontal padding
                                        vertical: 8, // Reduced vertical padding
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
                                          // Tab icon - smaller
                                          Container(
                                            margin: EdgeInsets.only(right: 6),
                                            child: Icon(
                                              Icons.chat_bubble_outline,
                                              size: 14,
                                              color:
                                                  isActive
                                                      ? Color(0xFF4a9eff)
                                                      : Colors.grey[500],
                                            ),
                                          ),
                                          // Tab title - with better flex handling
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
                                                  fontSize:
                                                      13, // Slightly smaller font
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
                                          // Close button - better positioned and sized
                                          if (_chatTabs.length > 1) ...[
                                            SizedBox(
                                              width: 4,
                                            ), // Reduced space between title and close button
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
                                                  size:
                                                      14, // Smaller close icon
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
                            }).toList(),
                          ],
                        ),
                      ),
                    ),

                    // Add New Tab Button - more compact
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _createNewChat,
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: EdgeInsets.all(8), // Reduced padding
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
                              size: 16, // Smaller icon
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Menu/Options Button - more compact
                    Container(
                      margin: EdgeInsets.only(right: 6),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Add menu functionality here
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: EdgeInsets.all(8), // Reduced padding
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
                              size: 16, // Smaller icon
                            ),
                          ),
                        ),
                      ),
                    ),

                    // User Profile - more compact
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
                          radius: 14, // Smaller avatar
                          backgroundColor: Color(0xFF2d2d2d),
                          child: Text(
                            'N',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12, // Smaller font
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
                          Color(0xFF0f0f0f).withOpacity(0.95),
                          Color(0xFF1a1a1a).withOpacity(0.98),
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
                                          Icons.chat_bubble_outline,
                                          size: 64,
                                          color: Colors.grey[600],
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Start a new conversation',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Type a message to begin',
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
                                    itemCount: _currentMessages.length,
                                    itemBuilder: (context, index) {
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
                                  : Icons.psychology_outlined,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 6),
                            Text(
                              message.isUser ? 'You' : 'AI Assistant',
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

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1a1a1a).withOpacity(0.95), Color(0xFF2d2d2d)],
        ),
        border: Border(
          top: BorderSide(color: Color(0xFF404040).withOpacity(0.5), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF2d2d2d),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.attach_file_outlined,
                color: Colors.white70,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFF1a1a1a),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFF404040).withOpacity(0.7),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
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
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      maxLines: null,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFF2d2d2d),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.mic_outlined,
                        color: Colors.white70,
                        size: 18,
                      ),
                      onPressed: () {},
                      padding: EdgeInsets.all(8),
                      constraints: BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4a9eff), Color(0xFF6c5ce7)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF4a9eff).withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.send_rounded, color: Colors.white, size: 20),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildFormattedText(String text) {
    List<Widget> widgets = [];
    List<String> lines = text.split('\n');

    for (String line in lines) {
      if (line.trim().isEmpty) {
        widgets.add(SizedBox(height: 8));
        continue;
      }

      // Handle numbered sections (1. 2. 3.)
      if (RegExp(r'^\d+\.\s+').hasMatch(line)) {
        widgets.add(SizedBox(height: 16));
        widgets.add(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFF2d2d2d).withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              line,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
        );
        widgets.add(SizedBox(height: 8));
        continue;
      }

      // Handle bullet points (•)
      if (line.startsWith('•')) {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(left: 20, top: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 8, right: 12),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Color(0xFF4a9eff),
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    line.substring(1).trim(),
                    style: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        continue;
      }

      // Handle phase headers (Phase 1: Foundation)
      if (line.startsWith('Phase ')) {
        widgets.add(SizedBox(height: 16));
        widgets.add(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4a9eff).withOpacity(0.2),
                  Color(0xFF6c5ce7).withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFF4a9eff).withOpacity(0.3)),
            ),
            child: Text(
              line,
              style: TextStyle(
                color: Color(0xFF4a9eff),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
        );
        widgets.add(SizedBox(height: 12));
        continue;
      }

      // Handle bold text (**text**)
      if (line.contains('**')) {
        widgets.add(SizedBox(height: 12));
        widgets.add(_buildRichText(line));
        widgets.add(SizedBox(height: 8));
        continue;
      }

      // Regular text
      widgets.add(
        Text(
          line,
          style: TextStyle(
            color: Colors.grey[100],
            fontSize: 16,
            height: 1.6,
            letterSpacing: 0.2,
          ),
        ),
      );

      if (lines.indexOf(line) < lines.length - 1) {
        widgets.add(SizedBox(height: 6));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildRichText(String text) {
    List<TextSpan> spans = [];
    RegExp boldRegex = RegExp(r'\*\*(.*?)\*\*');
    int lastIndex = 0;

    for (Match match in boldRegex.allMatches(text)) {
      // Add text before the bold part
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: TextStyle(color: Colors.grey[100], fontSize: 16),
          ),
        );
      }

      // Add bold text with gradient color
      spans.add(
        TextSpan(
          text: match.group(1),
          style: TextStyle(
            color: Color(0xFF4a9eff),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastIndex),
          style: TextStyle(color: Colors.grey[100], fontSize: 16),
        ),
      );
    }

    return RichText(text: TextSpan(children: spans));
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
