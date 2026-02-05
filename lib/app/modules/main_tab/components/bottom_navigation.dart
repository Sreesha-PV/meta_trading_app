import 'package:flutter/material.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/modules/main_tab/view/main_tab_view.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  final String selectedDropdownValue = 'Basic';
  // final TickerDataController _tickerController = TickerDataController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<int>(
          valueListenable:MainTabView.selectedIndexNotifier,
          builder: (context, index, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: MainTabView.isMoreExpandedNotifier,
              builder: (context, isExpanded, _) {
                return BottomNavigationBar(
                  currentIndex: index,
                  onTap: (newIndex) {
                    if (newIndex == 5) {
                      MainTabView.isMoreExpandedNotifier.value = !isExpanded;
                    } else {
                      MainTabView.selectedIndexNotifier.value = newIndex;
                      MainTabView.isMoreExpandedNotifier.value = false;
                    }
                  },
                  type: BottomNavigationBarType.fixed,
                  // selectedItemColor: Colors.blue,
                  selectedItemColor: AppColors.info,
                  // unselectedItemColor: Colors.black,
                  unselectedItemColor: AppColors.textPrimary,
                  // backgroundColor: const Color.fromARGB(255, 36, 36, 36),
                  // backgroundColor: Colors.white,
                  backgroundColor: AppColors.background,
                  items: [
                    // const BottomNavigationBarItem(
                    //   icon: Icon(Icons.dashboard_outlined),
                    //   label: 'Dashboard',
                    // ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.swap_vert),
                      label: 'Quotes',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.bar_chart_rounded),
                      label: 'Charts',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.show_chart_rounded),
                      label: 'Trade'
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.history),
                      label: 'History'
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat_bubble_outline_rounded),
                      label: 'Message'
                    ),
                    // BottomNavigationBarItem(
                    //   icon: Icon(
                    //     isExpanded
                    //         ? CupertinoIcons.chevron_down
                    //         : CupertinoIcons.chevron_up,
                    //   ),
                    //   label: isExpanded ? 'Less' : 'More',
                    // ),
                  ],
                );
              },
            );
          },
        ),
      
      ],
    );
  }
}

class _MoreNavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MoreNavItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, 
        // color: Colors.grey
        color:AppColors.textSecondary
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(
          // color: Colors.grey
          color:AppColors.textSecondary
          )),
      ],
    );
  }
}
