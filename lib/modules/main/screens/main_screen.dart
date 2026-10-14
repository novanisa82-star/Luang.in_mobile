import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:luang_in/modules/riwayat/screens/riwayat_screen.dart';
import 'package:luang_in/modules/profile/screens/profile_screen.dart';
import 'package:luang_in/utils/pallete_color.dart';
import '../controllers/main_controller.dart';
import 'package:luang_in/modules/home/screens/home_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final MainController controller = Get.put(MainController());

  final List<Widget> screens = [
    HomeScreen(),
    const Center(child: Text('AI Chat Screen')),
    const RiwayatScreen(),
    const ProfileScreen(),
  ];

  final List<_NavItem> items = const [
    _NavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    _NavItem(
      label: 'AI Chat',
      icon: Icons.auto_awesome_outlined,
      activeIcon: Icons.auto_awesome_rounded,
    ),
    _NavItem(
      label: 'Riwayat',
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long_rounded,
    ),
    _NavItem(
      label: 'Profil',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PalleteColor.pageBackground,
      extendBody: true,
      body: Obx(
        () => AnimatedSwitcher(
          duration: 450.ms,
          switchInCurve: Curves.easeOutQuart,
          switchOutCurve: Curves.easeInQuart,
          transitionBuilder: (child, animation) {
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0.025, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutQuart,
              ),
            );

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey(controller.selectedIndex.value),
            child: screens[controller.selectedIndex.value],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: PalleteColor.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: PalleteColor.borderColor,
            ),
            boxShadow: [
              BoxShadow(
                color: PalleteColor.textDark.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Obx(
            () => Row(
              children: List.generate(items.length, (index) {
                final isSelected =
                    controller.selectedIndex.value == index;

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (!isSelected) {
                        HapticFeedback.selectionClick();
                        controller.changeTabIndex(index);
                      }
                    },
                    child: AnimatedContainer(
                      duration: 300.ms,
                      curve: Curves.easeOutQuart,
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? PalleteColor.lightPurple
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedSwitcher(
                            duration: 250.ms,
                            switchInCurve: Curves.easeOutBack,
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: Icon(
                              isSelected
                                  ? items[index].activeIcon
                                  : items[index].icon,
                              key: ValueKey(isSelected),
                              color: isSelected
                                  ? PalleteColor.primaryPurple
                                  : PalleteColor.textGrey,
                              size: 23,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedDefaultTextStyle(
                            duration: 250.ms,
                            curve: Curves.easeOutQuart,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? PalleteColor.primaryPurple
                                  : PalleteColor.textGrey,
                            ),
                            child: Text(items[index].label),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}