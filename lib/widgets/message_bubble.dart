import 'package:flutter/material.dart';

import '../models/message_model.dart';


class MessageBubble extends StatelessWidget {

  final MessageModel message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {

    final isMine = message.isMine;

    return Align(

      alignment: isMine
          ? Alignment.centerRight
          : Alignment.centerLeft,

      child: Container(

        margin: const EdgeInsets.symmetric(
          vertical: 5,
        ),

        padding: const EdgeInsets.all(12),

        constraints: const BoxConstraints(
          maxWidth: 280,
        ),

        decoration: BoxDecoration(

          color: isMine
              ? Colors.blue
              : Colors.grey.shade300,

          borderRadius: BorderRadius.circular(14),

        ),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(

              message.body,

              style: TextStyle(
                color: isMine
                    ? Colors.white
                    : Colors.black,
              ),
            ),

            const SizedBox(height: 6),

            Text(

              _formatTime(message.createdAt),

              style: TextStyle(
                fontSize: 10,
                color: isMine
                    ? Colors.white70
                    : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {

    final h = date.hour.toString().padLeft(2, '0');

    final m = date.minute.toString().padLeft(2, '0');

    return "$h:$m";
  }
}