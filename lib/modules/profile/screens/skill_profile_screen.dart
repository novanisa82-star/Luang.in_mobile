import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luang_in/modules/profile/controllers/skill_profile_controller.dart';
import 'package:luang_in/utils/pallete_color.dart';

class SkillProfileScreen extends StatelessWidget {
  SkillProfileScreen({super.key});

  final SkillProfileController controller = Get.put(SkillProfileController());

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      child: Scaffold(
        backgroundColor: PalleteColor.pageBackground,
        appBar: AppBar(
          backgroundColor: PalleteColor.pageBackground,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: PalleteColor.textDark),
          ),
          title: Text(
            'Keahlian',
            style: GoogleFonts.plusJakartaSans(
              color: PalleteColor.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: PalleteColor.primaryPurple,
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Text(
                'Kenali kemampuanmu',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color: PalleteColor.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Lengkapi informasi keahlian agar perusahaan dapat mengenal kemampuanmu.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  height: 1.5,
                  color: PalleteColor.textGrey,
                ),
              ),
              const SizedBox(height: 28),

              _sectionTitle('Bidang pekerjaan'),
              const SizedBox(height: 10),

              Obx(() {
                final roleValue =
                    controller.roles.contains(controller.selectedRole.value)
                    ? controller.selectedRole.value
                    : null;

                return DropdownButtonFormField<String>(
                  value: roleValue,
                  isExpanded: true,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: PalleteColor.textDark,
                  ),
                  decoration: _inputDecoration(
                    hint: 'Pilih bidang pekerjaan',
                    icon: Icons.work_outline,
                  ),
                  items: controller.roles.toSet().map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedRole.value = value;
                      controller.primaryRoleController.text = value;
                    }
                  },
                );
              }),

              const SizedBox(height: 25),

              _sectionTitle('Keahlian yang dimiliki'),
              const SizedBox(height: 6),
              Text(
                'Tambahkan kemampuan yang kamu kuasai.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: PalleteColor.textGrey,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.skillController,
                      textInputAction: TextInputAction.done,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: PalleteColor.textDark,
                      ),
                      onSubmitted: (_) => controller.addSkill(),
                      decoration: _inputDecoration(
                        hint: 'Contoh: Figma, Excel, Flutter',
                        icon: Icons.lightbulb_outline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  SizedBox(
                    height: 52,
                    width: 52,
                    child: ElevatedButton(
                      onPressed: controller.addSkill,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PalleteColor.primaryPurple,
                        foregroundColor: PalleteColor.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Obx(() {
                if (controller.skills.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: PalleteColor.white,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: PalleteColor.borderColor),
                    ),
                    child: Text(
                      'Belum ada keahlian yang ditambahkan.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: PalleteColor.textGrey,
                      ),
                    ),
                  );
                }

                return Wrap(
                  spacing: 8,
                  runSpacing: 9,
                  children: controller.skills.map((skill) {
                    return Container(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 5,
                        top: 7,
                        bottom: 7,
                      ),
                      decoration: BoxDecoration(
                        color: PalleteColor.lightPurple,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            skill,
                            style: GoogleFonts.plusJakartaSans(
                              color: PalleteColor.textDark,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () => controller.removeSkill(skill),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: PalleteColor.primaryPurple,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }),

              const SizedBox(height: 27),

              _sectionTitle('Pengalaman kerja'),
              const SizedBox(height: 10),

              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedExperience.value.isEmpty
                      ? null
                      : controller.selectedExperience.value,
                  isExpanded: true,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: PalleteColor.textDark,
                  ),
                  decoration: _inputDecoration(
                    hint: 'Pilih pengalaman kerja',
                    icon: Icons.timeline_outlined,
                  ),
                  items: controller.experiences.map((experience) {
                    return DropdownMenuItem(
                      value: experience,
                      child: Text(experience),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedExperience.value = value;
                    }
                  },
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                height: 51,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isSaving.value
                        ? null
                        : controller.saveSkillProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PalleteColor.primaryPurple,
                      foregroundColor: PalleteColor.white,
                      disabledBackgroundColor: PalleteColor.primaryPurple
                          .withValues(alpha: 0.5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: controller.isSaving.value
                        ? const SizedBox(
                            height: 21,
                            width: 21,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: PalleteColor.white,
                            ),
                          )
                        : Text(
                            'Simpan Keahlian',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        color: PalleteColor.textDark,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        color: PalleteColor.textGrey,
      ),
      prefixIcon: Icon(icon, size: 19, color: PalleteColor.primaryPurple),
      filled: true,
      fillColor: PalleteColor.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: PalleteColor.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: PalleteColor.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: PalleteColor.primaryPurple,
          width: 1.3,
        ),
      ),
    );
  }
}
