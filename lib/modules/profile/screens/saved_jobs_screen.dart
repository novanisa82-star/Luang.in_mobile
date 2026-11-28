import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luang_in/core/services/saved_jobs_service.dart';
import 'package:luang_in/data/models/home_model.dart';
import 'package:luang_in/modules/home/screens/detail_screen.dart';
import 'package:luang_in/utils/pallete_color.dart';

class SavedJobsScreen extends StatelessWidget {
  const SavedJobsScreen({super.key});

  String _formatRupiah(String rawUpah) {
    final digits = rawUpah.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return 'Rp0';
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      final remaining = digits.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write('.');
      }
    }
    return 'Rp$buffer';
  }

  @override
  Widget build(BuildContext context) {
    final savedService = Get.find<SavedJobsService>();
    savedService.syncUserSavedJobs();

    return Scaffold(
      backgroundColor: PalleteColor.pageBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: PalleteColor.textDark,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Lowongan Tersimpan',
          style: TextStyle(
            color: PalleteColor.textDark,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final items = savedService.savedJobs;

        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: PalleteColor.lightPurple,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.bookmark_border_rounded,
                      size: 38,
                      color: PalleteColor.primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Belum Ada Lowongan Tersimpan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: PalleteColor.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ketuk ikon simpan (bookmark) pada rincian lowongan untuk menyimpannya ke daftar favorit Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: PalleteColor.textGrey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final job = items[index];
            return _buildSavedCard(context, job, savedService);
          },
        );
      }),
    );
  }

  Widget _buildSavedCard(
    BuildContext context,
    HomeModel job,
    SavedJobsService savedService,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Get.to(
            () => DetailScreen(
              jobId: job.id,
              job: job,
              rating: job.rating,
            ),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 280),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: PalleteColor.borderColor),
            boxShadow: [
              BoxShadow(
                color: PalleteColor.primaryPurple.withOpacity(0.04),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: PalleteColor.lightPurple,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.business_center_rounded,
                      color: PalleteColor.primaryPurple,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.judul,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: PalleteColor.textDark,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.namaPt,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: PalleteColor.textGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Hapus dari simpanan',
                    icon: const Icon(
                      Icons.bookmark_rounded,
                      color: PalleteColor.primaryPurple,
                      size: 22,
                    ),
                    onPressed: () async {
                      await savedService.removeJob(job.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Lowongan dihapus dari simpanan'),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFF1EEF8)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    _formatRupiah(job.upah),
                    style: const TextStyle(
                      color: PalleteColor.primaryPurple,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      job.durasi.isNotEmpty ? '/ ${job.durasi}' : '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: PalleteColor.textGrey,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const Text(
                    'Lihat detail',
                    style: TextStyle(
                      color: PalleteColor.primaryPurple,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: PalleteColor.primaryPurple,
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
