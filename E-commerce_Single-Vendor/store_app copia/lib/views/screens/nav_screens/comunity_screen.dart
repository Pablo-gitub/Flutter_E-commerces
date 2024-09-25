import 'package:flutter/material.dart';
import 'package:store_app/views/screens/inner_screens/chat_screen.dart';
import 'package:store_app/views/screens/inner_screens/post_screen.dart';

class ComunityScreen extends StatelessWidget {
  const ComunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 30,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Align(
            alignment: Alignment.center,
            child: Text(
              'Chook World',
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white70,
            tabs: [
              Tab(
                child: Text('Post'),
              ),
              Tab(
                child: Text('Chat'),
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PostScreen(),
            ChatScreen(),
          ],
        ),
      ),
    );
  }
}
