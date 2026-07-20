// import 'package:flutter/material.dart';
//
// import '../models/supervisor_model.dart';
//
//
// class SupervisorTile extends StatelessWidget {
//   final SupervisorModel supervisor;
//   final VoidCallback onTap;
//
//   const SupervisorTile({
//     super.key,
//     required this.supervisor,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       margin: EdgeInsets.zero,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: ListTile(
//         onTap: onTap,
//
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 8,
//         ),
//
//         leading: CircleAvatar(
//           radius: 24,
//           child: Text(
//             supervisor.fullName.isNotEmpty
//                 ? supervisor.fullName[0].toUpperCase()
//                 : "?",
//           ),
//         ),
//
//         title: Text(
//           supervisor.fullName,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//
//         subtitle: Text(
//           supervisor.email,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//
//         trailing: const Icon(
//           Icons.chat_bubble_outline_rounded,
//         ),
//       ),
//     );
//   }
// }