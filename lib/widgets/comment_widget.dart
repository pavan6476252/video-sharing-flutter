// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../models/comment_model.dart';
// import '../providers/store_comments_provider.dart';

// class CommentWidget extends ConsumerWidget {
//   final String videoId;
//   final Comment comment;

//   const CommentWidget({Key? key, required this.videoId, required this.comment})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context ,WidgetRef ref) {
   
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
       
//         ExpansionTile(
//           subtitle: Text(comment.date.toLocal().toString()),
//           title:  Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: Text(
//             comment.text,
//             style: TextStyle(fontSize: 16),
//           ),
          
//         ),children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               for (Comment reply in comment.replies)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Row(
//                     children: [
//                       Icon(Icons.reply, size: 16),
//                       SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           reply.text,
//                           style: TextStyle(fontSize: 14),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(Icons.reply, size: 16),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: 'Reply to this comment',
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                   OutlinedButton(
//                     onPressed: () {
//                       // replyToComment(
//                       //     videoId,
//                       //     comment.id,
//                       //     Comment(
//                       //         id: comment.id,
//                       //         text: "sub comment",
//                       //         date: DateTime.now()));
//                     },
//                     child: Text('Reply'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),])
//       ],
//     );
//   }
// }
