// import 'package:flutter/material.dart';

// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   final TextEditingController _searchController = TextEditingController();
//   final List<String> _allItems = [
//     'AAPL', 'GOOGL', 'AMZN', 'MSFT', 'TSLA',
//     'FB', 'NFLX', 'NVDA', 'BABA', 'V'
//   ];

//   List<String> _filteredItems = [];

//   @override
//   void initState() {
//     super.initState();
//     // _filteredItems = _allItems;
//     _searchController.addListener(_onSearchChanged);
//   }

//   void _onSearchChanged() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       // _filteredItems = _allItems
//       //     .where((item) => item.toLowerCase().contains(query))
//       //     .toList();
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: TextField(
//           controller: _searchController,
//           style: const TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             hintText: 'Search...',
//             hintStyle: const TextStyle(color: Colors.white54),
//             border: InputBorder.none,
//             suffixIcon: const Icon(Icons.search, color: Colors.white),
//             enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: Colors.white)
//             ) 
//           ),
//         ),
//       ),
//       body: Row(
//         children: [
//           Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: Icon(Icons.info_outline,color: Colors.white,),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: Text('Default action:',style: TextStyle(color: Colors.white),),
//               ),
//                 Padding(
//                       padding: const EdgeInsets.only(left: 70),
//                       child: DropdownButton<String>(
//                         dropdownColor: Colors.black,
//                         value: 'Quote details',
//                         style: TextStyle(color: Colors.white),
//                         underline: Container(height: 2,color: Colors.white,),
//                         icon: Icon(Icons.arrow_drop_down,color: Colors.white,),
//                         items:    <String>['Quote details', 'Add to Quotelist']
//                                   .map(
//                                     (String value) => DropdownMenuItem<String>(
//                                       value: value,
//                                       child: Text(value),
//                                     ),
//                                   )
//                                   .toList(), 
//                       onChanged:  (String? newValue) {
//                             print('Selected: $newValue');
//                           },),
//                     )
//                   ],
//                 )
//               ],
//             ),

//           );
//         }
//       } 
      

