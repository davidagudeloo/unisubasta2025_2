import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import 'package:unisubasta_udea_v1/presentation/widgets/chat/message_field_box.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/chat/my_message_bubble.dart';
import 'package:unisubasta_udea_v1/presentation/widgets/chat/her_message_bubble.dart';

import 'package:unisubasta_udea_v1/data/services/user_service.dart';
import 'package:unisubasta_udea_v1/data/services/message_service.dart';
import 'package:unisubasta_udea_v1/data/models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final int chatId;
  final int otherUserId;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.otherUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String otherUserName = "Usuario";
  String otherUserPhoto = "";
  int? mySqlId;

  List<MessageModel> messages = [];
  StompClient? stompClient;

  @override
  void initState() {
    super.initState();
    loadChatData();
  }

  @override
  void dispose() {
    stompClient?.deactivate();
    super.dispose();
  }

  // ========================================================
  // Cargar datos iniciales: IDs, usuario, mensajes
  // ========================================================
  Future<void> loadChatData() async {
    try {
      final me = await UserService.getUserProfile(
        FirebaseAuth.instance.currentUser!,
      );
      mySqlId = me["idUsuario"];

      final data = await UserService.getUserById(widget.otherUserId);
      otherUserName = data["nombre"] ?? "Usuario";
      otherUserPhoto = data["urlFotoPerfil"] ?? "";

      messages = await MessageService.getMessages(widget.chatId);

      setState(() {});
      _connectWebSocket();

    } catch (e) {
      debugPrint("Error cargando chat: $e");
    }
  }

  // ========================================================
  // WEBSOCKET: Conectar usando SockJS
  // ========================================================
  void _connectWebSocket() {
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: "http://192.168.30.114:8080/ws-chat",
        onConnect: _onWebSocketConnected,
        onStompError: (frame) => debugPrint("STOMP ERROR: ${frame.body}"),
        onWebSocketError: (error) => debugPrint("WS ERROR: $error"),
        onDisconnect: (_) => debugPrint("WS desconectado"),
      ),
    );

    stompClient?.activate();
  }

  void _onWebSocketConnected(StompFrame frame) {
    debugPrint("WebSocket conectado correctamente.");

    stompClient?.subscribe(
      destination: "/topic/chat/${widget.chatId}",
      callback: (frame) {
        if (frame.body == null) return;

        final data = jsonDecode(frame.body!);

        final msg = MessageModel(
          id: data["id"],
          message: data["message"],
          chatId: data["chatId"],
          emitterId: data["emitterId"],
          dateTime: DateTime.tryParse(data["dateTime"] ?? "") ?? DateTime.now(),
        );

        setState(() {
          // Insertar al final para mantener orden ascendente
          messages.add(msg);
        });
      },
    );
  }

  // ========================================================
  // Enviar mensaje por WebSocket (fallback REST si falla)
  // ========================================================
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || mySqlId == null) return;

    final body = jsonEncode({
      "message": text.trim(),
      "chatId": widget.chatId,
      "emitterId": mySqlId,
    });

    try {
      stompClient?.send(
        destination: "/app/chat/${widget.chatId}/sendMessage",
        body: body,
      );
    } catch (e) {
      debugPrint("Error WS → fallback REST");

      await MessageService.sendMessage(
        chatId: widget.chatId,
        emitterId: mySqlId!,
        text: text.trim(),
      );

      messages = await MessageService.getMessages(widget.chatId);
      setState(() {});
    }
  }

  // ========================================================
  // UI
  // ========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(otherUserName),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(child: Text("No hay mensajes aún"))
                : ListView.builder(
                    reverse: false,
                    itemCount: messages.length,
                    itemBuilder: (_, index) {
                      final msg = messages[index];
                      final isMine = msg.emitterId == mySqlId;

                      return isMine
                          ? MyMessageBubble(text: msg.message)
                          : HerMessageBubble(text: msg.message, imageUrl: otherUserPhoto);
                    },
                  ),
          ),

          MessageFieldBox(onSend: sendMessage),
        ],
      ),
    );
  }
}
