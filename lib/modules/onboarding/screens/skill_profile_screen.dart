import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../utils/pallete_color.dart';

class SkillProfileController extends GetxController {
  final displayNameController = TextEditingController();
  final contactController = TextEditingController();
  final roleController = TextEditingController();
  final skillController = TextEditingController();

  var skills = <String>['Espresso Brewing', 'Cashier POS', 'Stock Inventory', 'Customer Care'].obs;
  var experience = '2 - 4 Years'.obs;
  
  final experienceOptions = ['< 1 Year', '1 - 2 Years', '2 - 4 Years', '> 4 Years'];

  @override
  void onClose() {
    displayNameController.dispose();
    contactController.dispose();
    roleController.dispose();
    skillController.dispose();
    super.onClose();
  }

  void addSkill() {
    if (skillController.text.trim().isNotEmpty) {
      skills.add(skillController.text.trim());
      skillController.clear();
    }
  }

  void removeSkill(String skill) {
    skills.remove(skill);
  }

  void updateExperience(String? value) {
    if (value != null) {
      experience.value = value;
    }
  }

  void saveProfile() {
    print(displayNameController.text);
    print(skills);
  }
}

class SkillProfileScreen extends StatelessWidget {
  SkillProfileScreen({Key? key}) : super(key: key);

  final SkillProfileController controller = Get.put(SkillProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PalleteColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: PalleteColor.inputBackground,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: PalleteColor.textDark,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Skill Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: PalleteColor.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: PalleteColor.lightPurple.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: PalleteColor.lightPurple),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.edit_outlined,
                      color: PalleteColor.primaryPurple,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Direct manual entry only. Add your verified skills and contacts below.',
                        style: TextStyle(
                          fontSize: 12,
                          color: PalleteColor.primaryPurple.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Display Name',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: PalleteColor.textDark,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.displayNameController,
                decoration: InputDecoration(
                  hintText: 'Budi Santoso',
                  hintStyle: const TextStyle(color: PalleteColor.textGrey),
                  filled: true,
                  fillColor: PalleteColor.inputBackground,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PalleteColor.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PalleteColor.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PalleteColor.primaryPurple),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Contact WhatsApp / Phone',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: PalleteColor.textDark,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.contactController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '+62 812-3456-7890',
                  hintStyle: const TextStyle(color: PalleteColor.textGrey),
                  filled: true,
                  fillColor: PalleteColor.inputBackground,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PalleteColor.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PalleteColor.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PalleteColor.primaryPurple),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Primary Trade / Role',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: PalleteColor.textDark,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.roleController,
                decoration: InputDecoration(
                  hintText: 'Barista & Event Coordinator',
                  hintStyle: const TextStyle(color: PalleteColor.textGrey),
                  filled: true,
                  fillColor: PalleteColor.inputBackground,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PalleteColor.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PalleteColor.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PalleteColor.primaryPurple),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Manual Skill Tags',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: PalleteColor.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.skillController,
                      decoration: InputDecoration(
                        hintText: 'Type a skill...',
                        hintStyle: const TextStyle(color: PalleteColor.textGrey),
                        filled: true,
                        fillColor: PalleteColor.inputBackground,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: PalleteColor.borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: PalleteColor.borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: PalleteColor.primaryPurple),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: controller.addSkill,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PalleteColor.primaryPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '+ Add',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: PalleteColor.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.skills.map((skill) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: PalleteColor.lightPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        skill,
                        style: const TextStyle(
                          color: PalleteColor.primaryPurple,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => controller.removeSkill(skill),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: PalleteColor.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              )),
              const SizedBox(height: 16),
              const Text(
                'Years of Experience',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: PalleteColor.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: PalleteColor.inputBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: PalleteColor.borderColor),
                ),
                child: Obx(() => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: controller.experience.value,
                    icon: const Icon(Icons.keyboard_arrow_down, color: PalleteColor.textDark),
                    items: controller.experienceOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 14,
                            color: PalleteColor.textDark,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: controller.updateExperience,
                  ),
                )),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PalleteColor.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save Skill Profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: PalleteColor.white,
                    ),
                  ),
                ),
              ),
            ],
          ).animate(delay: 50.ms)
              .fade(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutQuad),
        ),
      ),
    );
  }
}