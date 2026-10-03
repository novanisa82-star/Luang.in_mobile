import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../../utils/pallete_color.dart';
import '../../home/screens/home_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final MainController controller = Get.put(MainController());

  final List<Widget> screens = [
    HomeScreen(),
    const Center(child: Text('AI Chat Screen')),
    const Center(child: Text('History Screen')),
    const Center(child: Text('Profile Screen')),
  ];

  static const List<_NavItem> _items = [
    _NavItem(Icons.explore_outlined, Icons.explore_rounded, 'Home'),
    _NavItem(Icons.smart_toy_outlined, Icons.smart_toy_rounded, 'AI Chat'),
    _NavItem(Icons.receipt_long_outlined, Icons.receipt_long_rounded, 'History'),
    _NavItem(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PalleteColor.white,
      // Konten tampil sampai ke belakang navbar (efek floating + glass)
      extendBody: true,
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: screens,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1A2E).withOpacity(0.92),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: PalleteColor.primaryPurple.withOpacity(0.25),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Obx(() {
                  final selected = controller.selectedIndex.value;
                  final n = _items.length;
                  return Stack(
                    children: [
                      // Indikator yang meluncur ke tab aktif
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutBack,
                        alignment: Alignment(-1 + 2 * selected / (n - 1), 0),
                        child: FractionallySizedBox(
                          widthFactor: 1 / n,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF9F4BFF),
                                    PalleteColor.primaryPurple,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: PalleteColor.primaryPurple
                                        .withOpacity(0.55),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Ikon + label
                      Row(
                        children: List.generate(n, (index) {
                          return Expanded(
                            child: _NavButton(
                              item: _items[index],
                              isSelected: selected == index,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                controller.changeTabIndex(index);
                              },
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem(this.icon, this.activeIcon, this.label);
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: isSelected ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            child: Icon(
              isSelected ? item.activeIcon : item.icon,
              size: 24,
              color: isSelected ? Colors.white : Colors.white54,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.white54,
            ),
            child: Text(item.label),
          ),
        ],
      ),
    );
  }
}