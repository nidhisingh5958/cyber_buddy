import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Chat',
        onMenuPressed: () {
          Scaffold.of(context).openDrawer();
        },
        centerTitle: true,
        backgroundColor: white,
        foregroundColor: black,
        elevation: 1.0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: 24,
              color: black.withValues(alpha: .8),
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(child: SideMenu()),
      // floatingActionButton: _buildChatBotFloatingButton(context),
      body: Column(
        children: [
          Container(
            color: transparent,
            child: TabBar(
              controller: _tabController,
              tabs: const [Tab(text: 'Messages'), Tab(text: 'Requests')],
              labelColor: black,
              labelStyle: TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelColor: grey600,
              indicator: BoxDecoration(
                border: Border(bottom: BorderSide(color: black, width: 2)),
              ),
              splashBorderRadius: BorderRadius.circular(38),
              dividerColor: Colors.transparent,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildChatList(chatData), _buildRequestList(chatData)],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildChatBotFloatingButton(BuildContext context) {
  //   return FloatingActionButton(
  //     onPressed: () => context.goNamed(RouteConstants.chatBot),
  //     backgroundColor: white,
  //     child: Icon(Icons.chat_bubble_outline),
  //   );
  // }

  Widget _buildChatList(List<ChatData> data) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final chat = data[index];
        return ChatListTile(chat: chat);
      },
    );
  }

  Widget _buildRequestList(List<ChatData> data) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final chat = data[index];
        return ChatListTile(chat: chat);
      },
    );
  }
}

class ChatListTile extends StatelessWidget {
  final ChatData chat;

  const ChatListTile({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen(chat: chat)),
        );
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade100, width: 2),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(chat.avatarUrl),
            ),
          ),
          if (chat.isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green.shade400,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        chat.name,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontSize: 16, color: black),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          chat.lastMessage,
          style: TextStyle(color: grey600, fontSize: 14, height: 1.3),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            chat.time,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: grey600,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '2',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
