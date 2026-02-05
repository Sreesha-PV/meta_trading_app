import 'package:flutter/material.dart';
import 'package:netdania/app/config/theme/app_color.dart';

class AddSymbolPage extends StatelessWidget {
  const AddSymbolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
    );
  }
  
    PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      // backgroundColor: Colors.white,
      backgroundColor: AppColors.background,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Icon(Icons.arrow_back,
          // color: Colors.black ,
          color: AppColors.textPrimary,
          ),
          const Expanded(
            child: Text('Add Symbol', style: TextStyle(
              // color: Colors.black
              color: AppColors.textPrimary
              )),
          ),
        ],
      ),
      actions: [
        IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.add)),

      ],
    );
  }
}