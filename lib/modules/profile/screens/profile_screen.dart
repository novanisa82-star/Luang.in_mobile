
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luang_in/modules/auth/screens/login_screen.dart';
import 'package:luang_in/utils/pallete_color.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool pushNotifications = true;

  // Contoh data profil. Ganti dengan data akun dari AuthController.
  final String userName = 'Budi Santoso';
  final String userEmail = 'budi.santoso@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PalleteColor.pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pengaturan Akun',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: PalleteColor.textDark,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 20),

              // Kartu profil
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: PalleteColor.white,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: PalleteColor.borderColor.withOpacity(0.7),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: PalleteColor.primaryPurple.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        color: PalleteColor.primaryPurple,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _getInitials(userName),
                        style: const TextStyle(
                          color: PalleteColor.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: PalleteColor.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userEmail,
                            style: const TextStyle(
                              fontSize: 10,
                              color: PalleteColor.textGrey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 5),

                    _buildBadge(
                      'Verified',
                      PalleteColor.primaryPurple,
                      PalleteColor.lightPurple,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Menu pengaturan
              Container(
                decoration: BoxDecoration(
                  color: PalleteColor.white,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: PalleteColor.borderColor.withOpacity(0.7),
                  ),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Informasi Pribadi & Keahlian',
                      onTap: () {
                        _showComingSoon('Informasi Pribadi & Keahlian');
                      },
                    ),

                    _buildDivider(),

                    _buildMenuItem(
                      icon: Icons.shield_outlined,
                      title: 'Status Verifikasi KTP',
                      trailing: _buildBadge(
                        'Terverifikasi',
                        PalleteColor.successColor,
                        PalleteColor.successBackground,
                      ),
                      onTap: () {
                        _showComingSoon('KTP Sudah Terverifikasi');
                      },
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifikasi Aplikasi',
                      showArrow: false,
                      trailing: Switch.adaptive(
                        value: pushNotifications,
                        onChanged: (value) {
                          setState(() {
                            pushNotifications = value;
                          });
                        },
                        activeColor: PalleteColor.white,
                        activeTrackColor: PalleteColor.primaryPurple,
                        inactiveThumbColor: PalleteColor.white,
                        inactiveTrackColor: PalleteColor.borderColor,
                      ),
                      onTap: () {
                        setState(() {
                          pushNotifications = !pushNotifications;
                        });
                      },
                    ),

                    _buildDivider(),

                    _buildMenuItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Pusat Bantuan & FAQ',
                      onTap: () {
                        _showComingSoon('Pusat Bantuan & FAQ');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Tombol logout
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: _showLogoutDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0F2F7),
                    foregroundColor: PalleteColor.textGrey,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Keluar',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Membuat inisial nama pengguna.
  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || parts.first.isEmpty) {
      return 'U';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  // Badge status.
  Widget _buildBadge(
    String label,
    Color textColor,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // Item menu.
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
    bool showArrow = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 11,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: PalleteColor.primaryPurple,
                size: 18,
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: PalleteColor.textDark,
                  ),
                ),
              ),

              if (trailing != null)
                trailing
              else if (showArrow)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: PalleteColor.textGrey,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 42),
      child: Divider(
        height: 1,
        thickness: 0.6,
        color: PalleteColor.borderColor,
      ),
    );
  }

  // Dialog fitur yang belum dihubungkan.
  void _showComingSoon(String feature) {
    Get.snackbar(
      feature,
      'Halaman ini belum dihubungkan.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: PalleteColor.lightPurple,
      colorText: PalleteColor.textDark,
      margin: const EdgeInsets.all(16),
    );
  }

  // Dialog konfirmasi logout.
  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: PalleteColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Log Out',
          style: TextStyle(
            color: PalleteColor.textDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari akun?',
          style: TextStyle(
            color: PalleteColor.textGrey,
            fontSize: 13,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Batal',
              style: TextStyle(
                color: PalleteColor.textGrey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.offAll(() => LoginScreen());
              // TODO: Hubungkan dengan AuthController.
              Get.snackbar(
                'Logout',
                'Hubungkan dengan proses logout akun.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: PalleteColor.primaryPurple,
              foregroundColor: PalleteColor.white,
            ),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );
  }
}