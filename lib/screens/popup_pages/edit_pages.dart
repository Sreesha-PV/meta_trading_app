
// import 'package:flutter/material.dart';

// class EditSymbolPage extends StatelessWidget {
//   const EditSymbolPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor:  Colors.white,
//         automaticallyImplyLeading: false,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 const Text(
//                   "Edit Symbols",
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 )
//               ],
//             ),

          
//             GestureDetector(
//               onTap: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     backgroundColor: Colors.grey[900],
//                     // title: const Text("Info", style: TextStyle(color: Colors.white)),
//                     content: const Text(
//                       "Drag items using to change display order or between lists to add/remove items from display",
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text("OK", style: TextStyle(color: Colors.white)),
//                       ),
//                     ],
                    
//                   ),
//                 );
//               },
//               child: const Icon(Icons.info_outline_rounded, color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//       body: const Center(
//         child: Text(
//           'Edit your symbols here.',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
