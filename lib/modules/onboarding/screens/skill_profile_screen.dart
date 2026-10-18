import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../utils/pallete_color.dart';
import '../controllers/skill_profile_controller.dart';

class SkillProfileScreen extends StatelessWidget {
  SkillProfileScreen({Key? key}) : super(key: key);

  final SkillProfileController controller = Get.put(SkillProfileController());

  Color get purple => PalleteColor.primaryPurple;
  Color get dark => PalleteColor.textDark;
  Color get grey => PalleteColor.textGrey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PalleteColor.pageBackground,
      appBar: AppBar(
        backgroundColor: PalleteColor.pageBackground,
        foregroundColor: dark,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Profil Keahlian',
          style: TextStyle(
            color: dark,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader()
                  .animate()
                  .fadeIn(duration: 450.ms)
                  .slideY(begin: 0.12, end: 0),

              const SizedBox(height: 26),

              _buildSectionTitle(
                'Informasi Pribadi',
                'Kenali dirimu lebih dekat',
                Icons.person_outline_rounded,
              ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.05),

              const SizedBox(height: 16),

              _buildLabel('Nomor WhatsApp'),
              _buildTextField(
                controller: controller.contactController,
                hint: 'Contoh: 081234567890',
                icon: Icons.phone_iphone_rounded,
                keyboardType: TextInputType.phone,
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.08),

              const SizedBox(height: 18),

              _buildLabel('Pekerjaan / Peran Utama'),
              _buildTextField(
                controller: controller.roleController,
                hint: 'Contoh: Barista atau Kasir',
                icon: Icons.work_outline_rounded,
              ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.08),

              const SizedBox(height: 30),

              _buildSectionTitle(
                'Keahlian yang Dimiliki',
                'Tambahkan kemampuan yang kamu kuasai',
                Icons.auto_awesome_rounded,
              ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.05),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.skillController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: _inputDecoration(
                        'Contoh: Membuat Latte Art',
                        Icons.lightbulb_outline_rounded,
                      ),
                      onSubmitted: (_) => controller.addSkill(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 54,
                    width: 54,
                    decoration: BoxDecoration(
                      gradient: PalleteColor.gradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: purple.withOpacity(0.22),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
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
              ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.08),

              const SizedBox(height: 16),

              Obx(
                () => AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: controller.skills.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: PalleteColor.borderColor),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.lightbulb_outline_rounded,
                                size: 30,
                                color: grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Belum ada keahlian',
                                style: TextStyle(
                                  color: grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tambahkan keahlianmu di kolom atas.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: grey, fontSize: 12),
                              ),
                            ],
                          ),
                        )
                      : Wrap(
                          spacing: 9,
                          runSpacing: 10,
                          children: controller.skills.map((skill) {
                            return Container(
                                  padding: const EdgeInsets.only(
                                    left: 13,
                                    right: 7,
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: PalleteColor.lightPurple,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: purple.withOpacity(0.14),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle_rounded,
                                        size: 15,
                                        color: purple,
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        skill,
                                        style: TextStyle(
                                          color: dark,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      InkWell(
                                        onTap: () =>
                                            controller.removeSkill(skill),
                                        borderRadius: BorderRadius.circular(20),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: Icon(
                                            Icons.close_rounded,
                                            size: 16,
                                            color: purple,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .animate()
                                .fadeIn(duration: 250.ms)
                                .scale(
                                  begin: const Offset(0.9, 0.9),
                                  duration: 250.ms,
                                );
                          }).toList(),
                        ),
                ),
              ),

              const SizedBox(height: 30),

              _buildSectionTitle(
                'Pengalaman Kerja',
                'Pilih sesuai pengalamanmu',
                Icons.history_rounded,
              ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.05),

              const SizedBox(height: 16),

              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.experience.value,
                  isExpanded: true,
                  icon: Icon(Icons.keyboard_arrow_down_rounded, color: purple),
                  decoration: _inputDecoration(
                    'Pilih pengalaman kerja',
                    Icons.schedule_rounded,
                  ),
                  items: controller.experienceOptions.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(
                          color: dark,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: controller.updateExperience,
                ),
              ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.08),

              const SizedBox(height: 32),

              Obx(
                () => Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: controller.isLoading.value
                        ? null
                        : PalleteColor.gradient,
                    color: controller.isLoading.value
                        ? grey.withOpacity(0.3)
                        : null,
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: controller.isLoading.value
                        ? []
                        : [
                            BoxShadow(
                              color: purple.withOpacity(0.24),
                              blurRadius: 16,
                              offset: const Offset(0, 7),
                            ),
                          ],
                  ),
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      disabledBackgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 23,
                            width: 23,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline_rounded),
                              SizedBox(width: 10),
                              Text(
                                'Simpan Profil Keahlian',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),

              const SizedBox(height: 18),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline_rounded, size: 14, color: grey),
                    const SizedBox(width: 6),
                    Text(
                      'Informasi profilmu digunakan untuk pencarian kerja.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: grey),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 550.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: PalleteColor.gradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: purple.withOpacity(0.23),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -15,
            top: -20,
            child: Container(
              height: 115,
              width: 115,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -35,
            child: Container(
              height: 75,
              width: 75,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.17),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: const Icon(
                  Icons.badge_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Bangun Profil Profesionalmu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Lengkapi informasi diri dan keahlianmu untuk menemukan peluang kerja yang sesuai.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.88),
                  fontSize: 12,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    SizedBox(width: 7),
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
          height: 43,
          width: 43,
          decoration: BoxDecoration(
            color: PalleteColor.lightPurple,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: purple, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: dark,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: grey, fontSize: 11)),
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
        style: TextStyle(
          color: PalleteColor.textDark,
          fontSize: 13,
          fontWeight: FontWeight.w700,
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
      style: TextStyle(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
      decoration: _inputDecoration(hint, icon),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: grey.withOpacity(0.8),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: Icon(icon, color: purple.withOpacity(0.8), size: 21),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: PalleteColor.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: PalleteColor.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: purple, width: 1.5),
      ),
    );
  }
}