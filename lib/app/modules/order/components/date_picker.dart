// import 'package:flutter/material.dart';

// class DatePickerSheet extends StatefulWidget {
//   const DatePickerSheet({super.key});

//   @override
//   State<DatePickerSheet> createState() => _DatePickerSheetState();
// }


// class _DatePickerSheetState extends State<DatePickerSheet> {
//   final now = DateTime.now();

//   int selectedMonth = DateTime.now().month;
//   int selectedDay = DateTime.now().day;
//   int selectedYear = DateTime.now().year;
//   int selectedHour = DateTime.now().hour;
//   int selectedMinute = DateTime.now().minute;

//   String? errorText;

//   List<String> months = const [
//     "Jan","Feb","Mar","Apr","May","Jun",
//     "Jul","Aug","Sep","Oct","Nov","Dec"
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Title
//           const Text(
//             "Expiration",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 24),

//           // Date wheels
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _wheel(
//                 items: months,
//                 initialIndex: selectedMonth - 1,
//                 onChanged: (i) => setState(() => selectedMonth = i + 1),
//               ),
//               _wheel(
//                 items: List.generate(31, (i) => (i + 1).toString()),
//                 initialIndex: selectedDay - 1,
//                 onChanged: (i) => setState(() => selectedDay = i + 1),
//               ),
//               _wheel(
//                 items: List.generate(5, (i) => (now.year + i).toString()),
//                 initialIndex: 0,
//                 onChanged: (i) => setState(() => selectedYear = now.year + i),
//               ),
//             ],
//           ),

//           const SizedBox(height: 24),

//           // Time wheels
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _wheel(
//                 items: List.generate(24, (i) => i.toString().padLeft(2, '0')),
//                 initialIndex: selectedHour,
//                 onChanged: (i) => setState(() => selectedHour = i),
//               ),
//               const SizedBox(width: 24),
//               _wheel(
//                 items: List.generate(60, (i) => i.toString().padLeft(2, '0')),
//                 initialIndex: selectedMinute,
//                 onChanged: (i) => setState(() => selectedMinute = i),
//               ),
//             ],
//           ),

//           const SizedBox(height: 24),

//           // Error text
//           if (errorText != null)
//             Text(
//               errorText!,
//               style: const TextStyle(color: Colors.red),
//             ),

//           const SizedBox(height: 16),

//           // Buttons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("Cancel"),
//               ),
//               TextButton(
//                 onPressed: _onOkPressed,
//                 child: const Text("OK"),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
  
 



// Widget _wheel({
//   required List<String> items,
//   required int initialIndex,
//   required ValueChanged<int> onChanged,
// }) {
//   return SizedBox(
//     height: 120,
//     width: 80,
//     child: ListWheelScrollView.useDelegate(
//       itemExtent: 40,
//       physics: const FixedExtentScrollPhysics(),
//       controller: FixedExtentScrollController(initialItem: initialIndex),
//       onSelectedItemChanged: onChanged,
//       childDelegate: ListWheelChildBuilderDelegate(
//         builder: (context, index) {
//           return Center(child: Text(items[index], style: const TextStyle(fontSize: 16)));
//         },
//         childCount: items.length,
//       ),
//     ),
//   );
// }





// void _onOkPressed() {
//   final selected = DateTime(
//     selectedYear,
//     selectedMonth,
//     selectedDay,
//     selectedHour,
//     selectedMinute,
//   );

//   if (selected.isBefore(now)) {
//     setState(() {
//       errorText =
//           "Selected value cannot be less than ${_format(now)}";
//     });
//   } else {
//     Navigator.pop(context, selected);
//     // final controller = Get.find<PlaceOrderController>();
//     // controller.expirationDate.value = selected;
//     // Get.back();
//   }
// }

// String _format(DateTime dt) {
//   return "${dt.month}/${dt.day}/${dt.year.toString().substring(2)} "
//          "${dt.hour.toString().padLeft(2, '0')}:"
//          "${dt.minute.toString().padLeft(2, '0')}";
// }
// }





import 'package:flutter/material.dart';
import 'package:netdania/app/config/theme/app_color.dart';

class DatePickerSheet extends StatefulWidget {

  const DatePickerSheet({super.key});
  

  @override

  State<DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<DatePickerSheet> {
  final DateTime now = DateTime.now();

  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;
  int selectedYear = DateTime.now().year;





  String? errorText;

  final List<String> months = const [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Expiration",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          /// Date wheels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _wheel(
                items: months,
                initialIndex: selectedMonth - 1,
                onChanged: (i) => setState(() => selectedMonth = i + 1),
              ),
              _wheel(
                items: List.generate(31, (i) => (i + 1).toString()),
                initialIndex: selectedDay - 1,
                onChanged: (i) => setState(() => selectedDay = i + 1),
              ),
              _wheel(
                items: List.generate(5, (i) => (now.year + i).toString()),
                initialIndex: 0,
                onChanged: (i) => setState(() => selectedYear = now.year + i),
              ),
            ],
          ),

          const SizedBox(height: 24),

          if (errorText != null)
            Text(
              errorText!,
              style: const TextStyle(color: Colors.red),
            ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel",style: TextStyle(color: AppColors.up),),
              ),
              TextButton(
                onPressed: _onOkPressed,
                child: Text("OK",style: TextStyle(color: AppColors.up),),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _wheel({
    required List<String> items,
    
    required int initialIndex,
    required ValueChanged<int> onChanged,
  }) {
    return SizedBox(
      height: 120,
      width: 80,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 40,
        physics: const FixedExtentScrollPhysics(),
        controller: FixedExtentScrollController(initialItem: initialIndex),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: items.length,
          builder: (_, index) => Center(
            child: Text(items[index], style: const TextStyle(fontSize: 16)),
          ),
          
        ),
      ),
    );
  }

  void _onOkPressed() {
    final selected = DateTime(
      selectedYear,
      selectedMonth,
      selectedDay,
    );

    final today = DateTime(now.year, now.month, now.day);

    if (selected.isBefore(today)) {
      setState(() {
        errorText = "Selected date cannot be before ${_format(today)}";
      });
    } else {
      Navigator.pop(context, selected);
    }
  }
  String _format(DateTime dt) {
    return "${months[dt.month - 1]} ${dt.day} ${dt.year}";
  }
}


