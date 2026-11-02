import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luang_in/modules/profile/controllers/profile_controller.dart';

class InformasiPribadiScreen extends GetView<ProfileController> {
  const InformasiPribadiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8FB),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
            color: Color(0xFF302B40),
          ),
        ),
        title: const Text(
          'Informasi Pribadi',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Color(0xFF252238),
          ),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF8833E6),
                ),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Perbarui data akun kamu agar informasi tetap sesuai.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: Color(0xFF898697),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _label('Nama lengkap'),
                    const SizedBox(height: 8),
                    _input(
                      controller: controller.nameController,
                      hint: 'Masukkan nama lengkap',
                      icon: Icons.person_outline_rounded,
                    ),

                    const SizedBox(height: 19),
                    _label('Email'),
                    const SizedBox(height: 8),
                    _input(
                      controller: TextEditingController(
                        text: controller.userEmail.value,
                      ),
                      hint: 'Email akun',
                      icon: Icons.email_outlined,
                      readOnly: true,
                    ),

                    const SizedBox(height: 19),
                    _label('Nomor WhatsApp'),
                    const SizedBox(height: 8),
                    _input(
                      controller: controller.whatsappController,
                      hint: 'Masukkan nomor WhatsApp',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 19),
                    _label('Domisili'),
                    const SizedBox(height: 8),
                    _input(
                      controller: controller.domisiliController,
                      hint: 'Contoh: Indramayu, Jawa Barat',
                      icon: Icons.location_on_outlined,
                    ),

                    const SizedBox(height: 23),
                    SizedBox(
                      width: double.infinity,
                      height: 51,
                      child: ElevatedButton(
                        onPressed: controller.isSaving.value
                            ? null
                            : controller.saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8833E6),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              const Color(0xFFC9A8EB),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: controller.isSaving.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Simpan Perubahan',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    const Divider(color: Color(0xFFEAE7EF)),
                    const SizedBox(height: 22),

                    const Text(
                      'Keamanan Akun',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF302B40),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Gunakan password yang berbeda dan sulit ditebak.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF898697),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _label('Password lama'),
                    const SizedBox(height: 8),
                    _input(
                      controller: controller.currentPasswordController,
                      hint: 'Masukkan password lama',
                      icon: Icons.lock_outline_rounded,
                      obscure: true,
                    ),

                    const SizedBox(height: 17),
                    _label('Password baru'),
                    const SizedBox(height: 8),
                    _input(
                      controller: controller.newPasswordController,
                      hint: 'Minimal 8 karakter',
                      icon: Icons.lock_outline_rounded,
                      obscure: true,
                    ),

                    const SizedBox(height: 17),
                    _label('Konfirmasi password baru'),
                    const SizedBox(height: 8),
                    _input(
                      controller: controller.confirmPasswordController,
                      hint: 'Ulangi password baru',
                      icon: Icons.lock_outline_rounded,
                      obscure: true,
                    ),

                    const SizedBox(height: 23),
                    SizedBox(
                      width: double.infinity,
                      height: 51,
                      child: OutlinedButton(
                        onPressed: controller.isChangingPassword.value
                            ? null
                            : controller.changePassword,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF8833E6),
                          side: const BorderSide(
                            color: Color(0xFF8833E6),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: controller.isChangingPassword.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Color(0xFF8833E6),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Perbarui Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
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

  static Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF484255),
      ),
    );
  }

  static Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool readOnly = false,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: 13,
        color: readOnly
            ? const Color(0xFF9994A5)
            : const Color(0xFF302B40),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 12,
          color: Color(0xFFAAA5B3),
        ),
        prefixIcon: Icon(
          icon,
          size: 19,
          color: const Color(0xFF8833E6),
        ),
        filled: true,
        fillColor:
            readOnly ? const Color(0xFFF0EFF3) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFEAE7EF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFEAE7EF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Color(0xFF8833E6),
            width: 1.3,
          ),
        ),
      ),
    );
  }
}
