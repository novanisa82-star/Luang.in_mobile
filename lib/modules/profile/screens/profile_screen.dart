import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luang_in/modules/profile/controllers/profile_controller.dart';
import 'package:luang_in/modules/profile/screens/informasi_pribadi_screen.dart';
import 'package:luang_in/core/services/storage_service.dart';
import 'package:luang_in/modules/profile/screens/skill_profile_screen.dart';

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
        child: RefreshIndicator(
          color: const Color(0xFF8833E6),
          onRefresh: controller.loadProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profil',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: Color(0xFF252238),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Atur akun dan preferensi kamu.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF898697)),
                ),
                const SizedBox(height: 25),

                Obx(() {
                  final photoUrl = controller.photoUrl;

                  return Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(color: const Color(0xFFEDEBF2)),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: controller.showPhotoOptions,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 29,
                                backgroundColor: const Color(0xFFEFE5FF),
                                backgroundImage: photoUrl != null
                                    ? NetworkImage(photoUrl)
                                    : null,
                                child: photoUrl == null
                                    ? Text(
                                        controller.initials,
                                        style: const TextStyle(
                                          color: Color(0xFF8833E6),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      )
                                    : null,
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 21,
                                  height: 21,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8833E6),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    size: 11,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.userName.value.isEmpty
                                    ? 'Memuat profil...'
                                    : controller.userName.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF29243A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.userEmail.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF898697),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                controller.userDomisili.value.isEmpty
                                    ? 'Domisili belum diisi'
                                    : controller.userDomisili.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFAAA5B3),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            Get.to(
                              () => const InformasiPribadiScreen(),
                              transition: Transition.rightToLeft,
                            );
                          },
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 19,
                            color: Color(0xFF777185),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                Obx(() {
                  if (!controller.isUploadingPhoto.value) {
                    return const SizedBox.shrink();
                  }

                  return const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: LinearProgressIndicator(
                      minHeight: 2,
                      color: Color(0xFF8833E6),
                      backgroundColor: Color(0xFFEFE5FF),
                    ),
                  );
                }),

                const SizedBox(height: 27),
                _sectionTitle('Akun'),
                const SizedBox(height: 11),

                _menuCard(
                  children: [
                    _menuItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Informasi pribadi',
                      subtitle: 'Nama, email, dan data diri',
                      onTap: () {
                        Get.to(
                          () => const InformasiPribadiScreen(),
                          transition: Transition.rightToLeft,
                        );
                      },
                    ),
                    _menuItem(
                      icon: Icons.workspace_premium_outlined,
                      title: 'Keahlian',
                      subtitle: 'Atur kemampuan dan pengalaman',
                      onTap: () {
                        Get.to(
                          () => SkillProfileScreen(),
                          transition: Transition.rightToLeft,
                        );
                      },
                    ),
                    _menuItem(
                      icon: Icons.badge_outlined,
                      title: 'Verifikasi identitas',
                      subtitle: 'Status verifikasi KTP',
                      onTap: () {
                        Get.snackbar(
                          'Verifikasi identitas',
                          'Fitur verifikasi identitas.',
                        );
                      },
                      last: true,
                    ),
                  ],
                ),

                const SizedBox(height: 25),
                _sectionTitle('Preferensi'),
                const SizedBox(height: 11),

                _menuCard(
                  children: [
                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            _menuIcon(Icons.notifications_none_rounded),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Notifikasi',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF302B40),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Info lamaran dan pekerjaan',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF9994A5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch.adaptive(
                              value: controller.pushNotifications.value,
                              activeColor: const Color(0xFF8833E6),
                              onChanged: controller.toggleNotifications,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _menuItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Pusat bantuan',
                      subtitle: 'Bantuan dan pertanyaan umum',
                      onTap: () {},
                      last: true,
                    ),
                  ],
                ),

                const SizedBox(height: 25),
                _sectionTitle('Lainnya'),
                const SizedBox(height: 11),

                _menuCard(
                  children: [
                    _menuItem(
                      icon: Icons.logout_rounded,
                      title: 'Keluar',
                      subtitle: 'Keluar dari akun Luang.In',
                      color: const Color(0xFFD94B5B),
                      onTap: () {
                        Get.dialog(
                          AlertDialog(
                            title: const Text('Keluar dari akun?'),
                            content: const Text(
                              'Kamu perlu login kembali untuk menggunakan akun ini.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Get.back();
                                  await Get.find<StorageService>().clearAuth();
                                  Get.offAllNamed('/LoginScreen');
                                },
                                child: const Text(
                                  'Keluar',
                                  style: TextStyle(color: Color(0xFFD94B5B)),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      last: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF302B40),
      ),
    );
  }

  static Widget _menuCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDEBF2)),
      ),
      child: Column(children: children),
    );
  }

  static Widget _menuIcon(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF3EBFF),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(icon, size: 18, color: const Color(0xFF8833E6)),
    );
  }

  static Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color color = const Color(0xFF8833E6),
    bool last = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, size: 18, color: color),
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
                          fontWeight: FontWeight.w700,
                          color: color == const Color(0xFFD94B5B)
                              ? color
                              : const Color(0xFF302B40),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9994A5),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFB2ADBC),
                  size: 21,
                ),
              ],
            ),
            if (!last)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Divider(height: 1, color: Color(0xFFF0EEF4)),
              ),
          ],
        ),
      ),
    );
  }
}
