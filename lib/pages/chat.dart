import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  bool _isLoading = false;
  late AnimationController _dotsController;
  late Animation<int> _dotCount;

  @override
  void initState() {
    super.initState();
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
    _dotCount = IntTween(begin: 1, end: 3).animate(_dotsController);
  }

  @override
  void dispose() {
    _dotsController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final input = _controller.text.trim();
    if (input.isEmpty || _isLoading) return;

    setState(() {
      _messages.add({"from": "user", "text": input});
      _controller.clear();
      _isLoading = true;
    });

    try {
      final response = await Gemini.instance.text(input);
      setState(() {
        _messages.add({
          "from": "bot",
          "text": response?.output ?? "Maaf, saya tidak bisa menjawab itu.",
        });
      });
    } catch (e) {
      setState(() {
        _messages.add({
          "from": "bot",
          "text": "Terjadi kesalahan. Silakan coba lagi nanti.",
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildMessage(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF3B2F6B) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return AnimatedBuilder(
      animation: _dotCount,
      builder: (context, child) {
        final dots = '.' * _dotCount.value;
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              "Bot sedang mengetik$dots",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:
            const Text("Chat Bot", style: TextStyle(color: Color(0xFF3B2F6B))),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.chat, color: Colors.black45),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                "⬇ Online",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 12),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return _buildTypingIndicator();
                }
                final message = _messages[index];
                return _buildMessage(
                    message["text"], message["from"] == "user");
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => sendMessage(),
                      decoration: const InputDecoration(
                        hintText: "Mulai Chat...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: sendMessage,
                  child: const CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFF3B2F6B),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
