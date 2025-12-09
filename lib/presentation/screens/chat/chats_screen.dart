import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unisubasta_udea_v1/constants/app_colors.dart';
import 'package:unisubasta_udea_v1/data/services/chat_service.dart';
import 'package:unisubasta_udea_v1/data/services/user_service.dart';
import 'package:unisubasta_udea_v1/data/models/chat_model.dart';
import 'package:unisubasta_udea_v1/presentation/screens/chat/chat_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  bool loading = true;
  List<ChatModel> chats = [];

  int? myUserId;

  // Guarda nombre y foto del usuario
  Map<int, Map<String, String>> userDataCache = {};

  @override
  void initState() {
    super.initState();
    loadChats();
  }

  Future<void> loadChats() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final chatList = await ChatService.getMyChats();
      final id = await ChatService.getMyUserId();

      setState(() {
        chats = chatList;
        myUserId = id;
      });

      await _loadUserData(chatList);

      setState(() => loading = false);
    } catch (e) {
      debugPrint("Error cargando chats: $e");
      setState(() => loading = false);
    }
  }

  // =====================================================
  // Obtener nombre + foto del otro usuario
  // =====================================================
  Future<void> _loadUserData(List<ChatModel> chats) async {
    for (final chat in chats) {
      final int otherId =
          (chat.sellerId == myUserId) ? chat.buyerId : chat.sellerId;

      if (!userDataCache.containsKey(otherId)) {
        try {
          final data = await UserService.getUserById(otherId);

          userDataCache[otherId] = {
            "nombre": data["nombre"] ?? "Usuario",
            "foto": data["urlFotoPerfil"] ?? "", // ← CORRECTO
          };
        } catch (e) {
          userDataCache[otherId] = {
            "nombre": "Usuario",
            "foto": "",
          };
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Chats"),
        backgroundColor: AppColors.verdeClaro,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : chats.isEmpty
              ? const Center(
                  child: Text(
                    "No tienes chats todavía.",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];

                    final otherUserId =
                        (chat.sellerId == myUserId) ? chat.buyerId : chat.sellerId;

                    final data = userDataCache[otherUserId];

                    final nombre = data?["nombre"] ?? "Usuario";
                    final foto = data?["foto"] ?? "";

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.verdeClaro,
                        backgroundImage:
                            (foto.isNotEmpty) ? NetworkImage(foto) : null,
                        child: (foto.isEmpty)
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      title: Text(nombre),
                      subtitle: const Text(
                        "Toca para abrir el chat",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              chatId: chat.id,
                              otherUserId: otherUserId,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
