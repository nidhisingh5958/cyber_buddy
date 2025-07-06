import 'package:cyber_buddy/services/api_service.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

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

  // Add API service instance
  late ApiService _apiService;

  int _currentTabIndex = 0;
  List<ChatTab> _chatTabs = [];
  bool _isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();

    // Initialize API service
    _apiService = ApiService();

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

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty ||
        _chatTabs.isEmpty ||
        _isLoading)
      return;

    final userMessage = _messageController.text.trim();

    setState(() {
      // Add user message
      _chatTabs[_currentTabIndex].messages.add(
        ChatMessage(text: userMessage, isUser: true, timestamp: DateTime.now()),
      );

      // Update tab title if it's "~" (new chat)
      if (_chatTabs[_currentTabIndex].title == "~") {
        String newTitle = userMessage;
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

      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // Call the API
      String response = await _apiService.chat(userMessage);

      setState(() {
        _chatTabs[_currentTabIndex].messages.add(
          ChatMessage(text: response, isUser: false, timestamp: DateTime.now()),
        );
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        _chatTabs[_currentTabIndex].messages.add(
          ChatMessage(
            text:
                "Sorry, I encountered an error while processing your request. Please check your connection and try again.\n\nError: ${e.toString()}",
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
                            }).toList(),
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
                            _showOptionsMenu(context);
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

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1a1a1a),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20),
              _buildMenuOption(
                icon: Icons.clear_all,
                title: 'Clear Chat',
                onTap: () {
                  Navigator.pop(context);
                  _clearCurrentChat();
                },
              ),
              _buildMenuOption(
                icon: Icons.file_upload_outlined,
                title: 'Export Chat',
                onTap: () {
                  Navigator.pop(context);
                  _exportChat();
                },
              ),
              _buildMenuOption(
                icon: Icons.settings,
                title: 'Settings',
                onTap: () {
                  Navigator.pop(context);
                  _showSettings();
                },
              ),
              _buildMenuOption(
                icon: Icons.info_outline,
                title: 'About',
                onTap: () {
                  Navigator.pop(context);
                  _showAbout();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFF2d2d2d),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey[300], size: 20),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[500], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _clearCurrentChat() {
    setState(() {
      _chatTabs[_currentTabIndex].messages.clear();
    });
  }

  void _exportChat() {
    // Implement chat export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Export functionality coming soon!'),
        backgroundColor: Color(0xFF4a9eff),
      ),
    );
  }

  void _showSettings() {
    // Implement settings screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings screen coming soon!'),
        backgroundColor: Color(0xFF4a9eff),
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Color(0xFF1a1a1a),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.security, color: Color(0xFF4a9eff)),
                SizedBox(width: 8),
                Text('Cyber Buddy', style: TextStyle(color: Colors.white)),
              ],
            ),
            content: Text(
              'Your personal cybersecurity assistant.\n\nVersion 1.0.0\nBuilt with Flutter',
              style: TextStyle(color: Colors.grey[300]),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK', style: TextStyle(color: Color(0xFF4a9eff))),
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
    final lines = text.split('\n');
    List<Widget> widgets = [];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Handle different text formatting
      if (line.startsWith('# ')) {
        // Header
        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: 8, top: i > 0 ? 12 : 0),
            child: Text(
              line.substring(2),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else if (line.startsWith('## ')) {
        // Subheader
        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: 6, top: i > 0 ? 10 : 0),
            child: Text(
              line.substring(3),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      } else if (line.startsWith('### ')) {
        // Sub-subheader
        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: 4, top: i > 0 ? 8 : 0),
            child: Text(
              line.substring(4),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      } else if (line.startsWith('> ')) {
        // Quote
        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: 8, top: i > 0 ? 12 : 0),

            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF2d2d2d).withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xFF4a9eff).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                line.substring(2),
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        );
      } else if (line.startsWith('```')) {
        // Code block
        if (i == 0 || !lines[i - 1].startsWith('```')) {
          widgets.add(
            Padding(
              padding: EdgeInsets.only(bottom: 8, top: i > 0 ? 12 : 0),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF2d2d2d).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xFF4a9eff).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  line.substring(3), // Skip the ``` and language
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Courier',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }
      } else {
        // Regular text
        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: 8, top: i > 0 ? 12 : 0),
            child: Text(
              line,
              style: TextStyle(color: Colors.grey[300], fontSize: 14),
            ),
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
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
              style: TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
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
