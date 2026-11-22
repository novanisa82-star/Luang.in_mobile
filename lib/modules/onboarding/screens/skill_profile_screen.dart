import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/skill_profile_controller.dart';

class SkillProfileScreen extends StatelessWidget {
  SkillProfileScreen({Key? key}) : super(key: key);

  final SkillProfileController controller = Get.put(SkillProfileController());

  // Palette colors consistent with Login & Register screens
  static const Color primaryPurple = Color(0xFFA78BFA);
  static const Color accentPurple = Color(0xFF6B5DE8);
  static const Color softPeach = Color(0xFFF9A8B6);
  static const Color textDark = Color(0xFF1E1E2D);
  static const Color textGrey = Color(0xFF71717A);
  static const Color borderColor = Color(0xFFE4E4E7);
  static const Color lightPurpleBg = Color(0xFFF5EEFD);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [softPeach, primaryPurple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9FD),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Get.back(),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: textDark,
            ),
          ),
        ),
        title: const Text(
          'Profil Keahlian',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner Card matching Login & Register gradient aesthetic
              _buildHeader()
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.08, end: 0),

              const SizedBox(height: 28),

              // Section 1: Informasi Pribadi
              _buildSectionTitle(
                'Informasi Pribadi',
                'Kenali dirimu lebih dekat',
                Icons.person_outline_rounded,
              ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.04),

              const SizedBox(height: 16),

              _buildLabel('Nomor WhatsApp'),
              _buildTextField(
                controller: controller.contactController,
                hint: 'Contoh: 081234567890',
                icon: Icons.phone_iphone_rounded,
                keyboardType: TextInputType.phone,
              ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.06),

              const SizedBox(height: 18),

              _buildLabel('Pekerjaan / Peran Utama'),
              _buildTextField(
                controller: controller.roleController,
                hint: 'Contoh: Barista atau Kasir',
                icon: Icons.work_outline_rounded,
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.06),

              const SizedBox(height: 28),

              // Section 2: Keahlian yang Dimiliki
              _buildSectionTitle(
                'Keahlian yang Dimiliki',
                'Tambahkan kemampuan yang kamu kuasai',
                Icons.auto_awesome_rounded,
              ).animate().fadeIn(delay: 250.ms).slideX(begin: -0.04),

              const SizedBox(height: 16),

              // Add Skill Row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.skillController,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(
                        color: textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: _inputDecoration(
                        'Contoh: Membuat Latte Art',
                        Icons.lightbulb_outline_rounded,
                      ),
                      onSubmitted: (_) => controller.addSkill(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      gradient: brandGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: primaryPurple.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: controller.addSkill,
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.06),

              const SizedBox(height: 16),

              // Skill Chips or Empty State
              Obx(
                () => AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: controller.skills.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 22,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: const [
                              Icon(
                                Icons.lightbulb_outline_rounded,
                                size: 30,
                                color: Color(0xFFA1A1AA),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Belum ada keahlian',
                                style: TextStyle(
                                  color: Color(0xFF52525B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Tambahkan keahlianmu di kolom atas.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: textGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 10,
                          children: controller.skills.map((skill) {
                            return Container(
                              padding: const EdgeInsets.only(
                                left: 14,
                                right: 8,
                                top: 8,
                                bottom: 8,
                              ),
                              decoration: BoxDecoration(
                                color: lightPurpleBg,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: primaryPurple.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    size: 15,
                                    color: accentPurple,
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    skill,
                                    style: const TextStyle(
                                      color: textDark,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  InkWell(
                                    onTap: () => controller.removeSkill(skill),
                                    borderRadius: BorderRadius.circular(20),
                                    child: const Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Icon(
                                        Icons.close_rounded,
                                        size: 16,
                                        color: accentPurple,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 200.ms)
                                .scale(begin: const Offset(0.92, 0.92));
                          }).toList(),
                        ),
                ),
              ),

              const SizedBox(height: 28),

              // Section 3: Pengalaman Kerja
              _buildSectionTitle(
                'Pengalaman Kerja',
                'Pilih sesuai pengalamanmu',
                Icons.history_rounded,
              ).animate().fadeIn(delay: 350.ms).slideX(begin: -0.04),

              const SizedBox(height: 16),

              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: controller.experience.value,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: accentPurple,
                    ),
                    decoration: _inputDecoration(
                      'Pilih pengalaman kerja',
                      Icons.schedule_rounded,
                    ),
                    items: controller.experienceOptions.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            color: textDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: controller.updateExperience,
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.06),

              const SizedBox(height: 32),

              // Gradient Action Button: Simpan Profil Keahlian
              Obx(
                () => Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: controller.isLoading.value ? null : brandGradient,
                    color: controller.isLoading.value
                        ? const Color(0xFFD1D5DB)
                        : null,
                    boxShadow: controller.isLoading.value
                        ? []
                        : [
                            BoxShadow(
                              color: primaryPurple.withOpacity(0.35),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(26),
                      onTap: controller.isLoading.value
                          ? null
                          : controller.saveProfile,
                      child: Center(
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.check_circle_outline_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Simpan Profil Keahlian',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.08),

              const SizedBox(height: 18),

              // Security & Privacy notice
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Informasi profilmu digunakan untuk pencarian kerja.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 500.ms),
            ],
          ),
        ),
      ),
    );
  }

  /// Banner Card with soft pastel gradient & frosted badge elements matching Login & Register
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFA9FA8), // Soft coral/peach
            Color(0xFFA182F8), // Lavender/purple
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryPurple.withOpacity(0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background abstract translucent circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -30,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge icon container with frosted glass look
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1.2,
                  ),
                ),
                child: const Icon(
                  Icons.badge_outlined,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Bangun Profil Profesionalmu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Lengkapi informasi diri dan keahlianmu untuk menemukan peluang kerja yang sesuai.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.92),
                  fontSize: 12,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 18),
              // Pill badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 0.8,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Profil lebih lengkap, peluang lebih baik',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: lightPurpleBg,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: primaryPurple.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(icon, color: accentPurple, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(color: textGrey, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: textDark,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(
        color: textDark,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: _inputDecoration(hint, icon),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFFA1A1AA),
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: Icon(icon, color: primaryPurple, size: 20),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: borderColor, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: borderColor, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryPurple, width: 1.5),
      ),
    );
  }
}
