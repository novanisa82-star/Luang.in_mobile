import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:luang_in/modules/riwayat/screens/riwayat_screen.dart';
import '../controllers/main_controller.dart';
import '../../../utils/pallete_color.dart';
import '../../home/screens/home_screen.dart';
import '../../profile/screens/profile_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final MainController controller = Get.put(MainController());

  final List<Widget> screens = [
    HomeScreen(),
    const Center(child: Text('AI Chat Screen')),
    const RiwayatScreen(),
    const ProfileScreen(),
  ];

  static const List<_NavItem> _items = [
    _NavItem(Icons.explore_outlined, Icons.explore_rounded, 'Home'),
    _NavItem(Icons.smart_toy_outlined, Icons.smart_toy_rounded, 'AI Chat'),
    _NavItem(
      Icons.receipt_long_outlined,
      Icons.receipt_long_rounded,
      'History',
    ),
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
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  // Kaca frosted modern: Putih semi-transparan
                  color: Colors.white.withOpacity(0.82),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.6),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: PalleteColor.primaryPurple.withOpacity(0.12),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Obx(() {
                  final selected = controller.selectedIndex.value;
                  final n = _items.length;
                  return Stack(
                    children: [
                      // Indikator sliding background (Kapsul aktif)
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        alignment: Alignment(
                          n > 1 ? -1 + (2 * selected / (n - 1)) : 0,
                          0,
                        ),
                        child: FractionallySizedBox(
                          widthFactor: 1 / n,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 6,
                            ),
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
                                        .withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Row tombol ikon + label
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
    final unselectedColor = Colors.grey.shade600;
    const selectedColor = Colors.white;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: isSelected ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            child: Icon(
              isSelected ? item.activeIcon : item.icon,
              size: 22,
              color: isSelected ? selectedColor : unselectedColor,
            ),
          ),
          const SizedBox(height: 3),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? selectedColor : unselectedColor,
            ),
            child: Text(item.label),
          ),
        ],
      ),
    );
  }
}
