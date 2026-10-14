import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:luang_in/modules/auth/screens/login_screen.dart';
import 'package:luang_in/modules/profile/controllers/profile_controller.dart';
import 'package:luang_in/utils/pallete_color.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profil',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                  color: Color(0xFF252238),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Atur akun dan preferensi kamu.',
                style: TextStyle(fontSize: 13, color: Color(0xFF898697)),
              ),
              const SizedBox(height: 26),
              Obx(
                    () => Container(
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFEDEBF2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFE5FF),
                              borderRadius: BorderRadius.circular(19),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              controller.initials,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: PalleteColor.primaryPurple,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.userName.value,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF29243A),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  controller.userEmail.value,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF898697),
                                  ),
                                ),
                                const SizedBox(height: 9),
                                const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified_rounded,
                                      size: 14,
                                      color: Color(0xFF168B67),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Akun terverifikasi',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF168B67),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _showComingSoon('Edit profil');
                            },
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: Color(0xFF777387),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 350.ms)
                  .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),
              const SizedBox(height: 27),
              _sectionTitle('Akun'),
              const SizedBox(height: 10),
              _menuGroup([
                _menuItem(
                  icon: Icons.person_outline_rounded,
                  title: 'Informasi pribadi',
                  subtitle: 'Nama, email, dan data diri',
                  onTap: () => _showComingSoon('Informasi pribadi'),
                ),
                _menuDivider(),
                _menuItem(
                  icon: Icons.workspace_premium_outlined,
                  title: 'Keahlian',
                  subtitle: 'Atur kemampuan dan pengalaman',
                  onTap: () => _showComingSoon('Keahlian'),
                ),
                _menuDivider(),
                _menuItem(
                  icon: Icons.badge_outlined,
                  title: 'Verifikasi identitas',
                  subtitle: 'Status verifikasi KTP',
                  trailing: const Icon(
                    Icons.check_circle_rounded,
                    size: 19,
                    color: Color(0xFF168B67),
                  ),
                  onTap: () => _showComingSoon('Verifikasi identitas'),
                ),
              ]).animate().fadeIn(delay: 100.ms, duration: 350.ms),
              const SizedBox(height: 24),
              _sectionTitle('Preferensi'),
              const SizedBox(height: 10),
              _menuGroup([
                Obx(
                  () => _menuItem(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifikasi',
                    subtitle: 'Info lamaran dan pekerjaan',
                    showArrow: false,
                    trailing: Switch.adaptive(
                      value: controller.pushNotifications.value,
                      onChanged: controller.toggleNotifications,
                      activeTrackColor: PalleteColor.primaryPurple,
                    ),
                    onTap: () => controller.toggleNotifications(
                      !controller.pushNotifications.value,
                    ),
                  ),
                ),
                _menuDivider(),
                _menuItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Pusat bantuan',
                  subtitle: 'Bantuan dan pertanyaan umum',
                  onTap: () => _showComingSoon('Pusat bantuan'),
                ),
              ]).animate().fadeIn(delay: 180.ms, duration: 350.ms),
              const SizedBox(height: 24),
              _sectionTitle('Lainnya'),
              const SizedBox(height: 10),
              _menuGroup([
                _menuItem(
                  icon: Icons.info_outline_rounded,
                  title: 'Tentang Luang.in',
                  subtitle: 'Informasi aplikasi',
                  onTap: () => _showComingSoon('Tentang Luang.in'),
                ),
                _menuDivider(),
                _menuItem(
                  icon: Icons.logout_rounded,
                  title: 'Keluar dari akun',
                  titleColor: const Color(0xFFD94A60),
                  showArrow: false,
                  onTap: _showLogoutDialog,
                ),
              ]).animate().fadeIn(delay: 250.ms, duration: 350.ms),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Luang.in',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFAAA6B6),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  'Temukan peluang, isi waktu dengan berarti.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Color(0xFFAAA6B6)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Color(0xFF302B40),
      ),
    );
  }

  Widget _menuGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDEBF2)),
      ),
      child: Column(children: children),
    );
  }

  Widget _menuDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 58),
      child: Divider(height: 1, thickness: 0.7, color: Color(0xFFF0EEF4)),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    bool showArrow = true,
    Color? titleColor,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EEFA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: titleColor ?? PalleteColor.primaryPurple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: titleColor ?? const Color(0xFF302B40),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF918C9F),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                trailing
              else if (showArrow)
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 21,
                  color: Color(0xFFAAA6B6),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    Get.snackbar(
      feature,
      'Fitur ini belum tersedia.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF302B40),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 14,
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Keluar dari akun?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF302B40),
          ),
        ),
        content: const Text(
          'Kamu perlu masuk kembali untuk menggunakan akun Luang.in.',
          style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF898697)),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text(
              'Batal',
              style: TextStyle(color: Color(0xFF898697)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.offAll(() => LoginScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD94A60),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
