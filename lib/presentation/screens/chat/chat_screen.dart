import 'package:flutter/material.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/chat/her_message_bubble.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/chat/message_field_box.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/chat/my_message_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              'https://aprendemosjuntos.bbva.com/wp-content/uploads/2024/09/1200x628-01-GREEICY-RENDON.jpg',
            ),
          ),
        ),
        title: const Text("Mi amor ✨"),
        centerTitle: false,
      ),
      body: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 100,
                itemBuilder: (context, index) {
                  return (index % 2 == 0)
                      ? const HerMessageBubble()
                      : const MyMessageBubble();
                },
              ),
            ),

            ///Caja de texto de mensajes:
            MessageFieldBox(),
          ],
        ),
      ),
    );
  }
}
