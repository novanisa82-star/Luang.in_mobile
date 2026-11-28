import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:luang_in/data/models/home_model.dart';
import 'package:luang_in/modules/home/screens/detail_screen.dart';
import 'package:luang_in/utils/document_helper.dart';
import 'package:luang_in/utils/pallete_color.dart';
import '../controllers/ai_chat_controller.dart';
import '../models/ai_message_model.dart';

class AiChatScreen extends StatelessWidget {
  AiChatScreen({super.key});

  final AiChatController controller = Get.isRegistered<AiChatController>()
      ? Get.find<AiChatController>()
      : Get.put(AiChatController(), permanent: true);

  Color get purple => PalleteColor.primaryPurple;
  Color get lightPurple => PalleteColor.lightPurple;
  Color get pageColor => PalleteColor.pageBackground;
  Color get darkColor => PalleteColor.textDark;
  Color get greyColor => PalleteColor.textGrey;
  Color get borderColor => PalleteColor.borderColor;

  @override
  Widget build(BuildContext context) {
    // Sinkronkan chat dengan akun yang sedang login saat ini (mencegah chat tertukar)
    controller.syncUserChatHistory();

    return Scaffold(
      backgroundColor: pageColor,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            // Chat message list
            Expanded(
              child: Obx(
                () => ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.messages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildQuickSuggestions();
                    }
                    final message = controller.messages[index - 1];
                    return _buildMessageItem(context, message);
                  },
                ),
              ),
            ),

            // Attachment preview (if any file/photo is selected)
            Obx(() => _buildAttachmentPreview()),

            // Input bar with WhatsApp style attachment button
            _buildInputBar(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: PalleteColor.gradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: purple.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Chat Luang.In',
                  style: TextStyle(
                    color: darkColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Obx(
                        () => Text(
                          '📍 ${controller.userLocationName.value} (Radius 10 km)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: greyColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Perbarui Lokasi',
          icon: Icon(Icons.my_location_rounded, color: purple, size: 20),
          onPressed: () => controller.detectLocation(),
        ),
        IconButton(
          tooltip: 'Hapus Riwayat Chat',
          icon: Icon(Icons.delete_outline_rounded, color: greyColor, size: 22),
          onPressed: () => _confirmClearChat(context),
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: borderColor, height: 1),
      ),
    );
  }

  void _confirmClearChat(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Hapus Riwayat Chat?',
          style: TextStyle(color: darkColor, fontWeight: FontWeight.w800, fontSize: 16),
        ),
        content: Text(
          'Seluruh percakapan AI Chat untuk akun Anda akan dihapus dari penyimpanan.',
          style: TextStyle(color: greyColor, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Batal', style: TextStyle(color: greyColor, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              controller.clearChatHistory();
            },
            child: const Text('Hapus', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSuggestions() {
    final suggestions = [
      {'icon': Icons.description_rounded, 'label': '📄 Pindai Dokumen CV'},
      {'icon': Icons.camera_alt_rounded, 'label': '📸 Pindai Foto CV'},
      {'icon': Icons.coffee_rounded, 'label': '☕ Lowongan Barista'},
      {'icon': Icons.trending_up_rounded, 'label': '💰 Upah Tertinggi'},
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          final s = suggestions[idx];
          return ActionChip(
            backgroundColor: Colors.white,
            elevation: 0,
            side: BorderSide(color: borderColor),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            label: Text(
              s['label'] as String,
              style: TextStyle(
                color: purple,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              if (idx == 0) {
                controller.pickDocument();
              } else if (idx == 1) {
                controller.pickImageFromGallery();
              } else if (idx == 2) {
                controller.sendMessage(
                  'Ada rekomendasi lowongan untuk barista atau F&B?',
                );
              } else if (idx == 3) {
                controller.sendMessage(
                  'Tolong carikan lowongan dengan upah tertinggi hari ini.',
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildMessageItem(BuildContext context, AiMessage message) {
    if (message.isUser) {
      return _buildUserBubble(message);
    } else {
      return _buildAiBubble(context, message);
    }
  }

  Widget _buildUserBubble(AiMessage message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14, left: 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: purple,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(6),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: purple.withOpacity(0.18),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Lampiran user jika ada
            if (message.hasAttachment) ...[
              _buildAttachmentTag(message),
              const SizedBox(height: 8),
            ],
            if (message.text.isNotEmpty)
              Text(
                message.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentTag(AiMessage message) {
    if (message.isImage && message.attachmentPath != null) {
      final file = File(message.attachmentPath!);
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 180, maxWidth: 220),
          child: Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white24,
              child: const Icon(Icons.broken_image, color: Colors.white),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.insert_drive_file_rounded,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.attachmentName ?? 'Dokumen CV',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                if (message.attachmentSize != null)
                  Text(
                    DocumentHelper.formatFileSize(message.attachmentSize!),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiBubble(BuildContext context, AiMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, right: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: PalleteColor.gradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: message.isLoading
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: purple,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              message.text,
                              style: TextStyle(
                                color: greyColor,
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          message.text,
                          style: TextStyle(
                            color: darkColor,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                ),

                // Kartu Rekomendasi Lowongan (Bila cocok dengan CV)
                if (message.recommendedJobIds.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _buildRecommendedJobsSection(
                    context,
                    message.recommendedJobIds,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedJobsSection(BuildContext context, List<int> jobIds) {
    // Ambil lowongan yang sesuai berdasarkan ID yang direkomendasikan
    final displayJobs = <HomeModel>[];
    for (final id in jobIds) {
      final found =
          controller.availableJobs.firstWhereOrNull((j) => j.id == id);
      if (found != null && !displayJobs.any((j) => j.id == found.id)) {
        displayJobs.add(found);
      }
    }

    // Selalu lengkapi hingga minimal 5 lowongan dari lowongan aktif lainnya
    for (final job in controller.availableJobs) {
      if (displayJobs.length >= 5) break;
      if (!displayJobs.any((j) => j.id == job.id)) {
        displayJobs.add(job);
      }
    }

    if (displayJobs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              Icon(Icons.stars_rounded, color: purple, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Rekomendasi Lowongan (${displayJobs.length} Lowongan):',
                  style: TextStyle(
                    color: darkColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        ...displayJobs.map((job) => _buildJobCard(context, job)),
      ],
    );
  }

  Widget _buildJobCard(BuildContext context, HomeModel job) {
    final distanceKm = controller.getJobDistanceKm(job);
    final isWithin10Km = controller.isWithin10Km(job);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isWithin10Km
              ? const Color(0xFF86EFAC)
              : purple.withOpacity(0.35),
          width: isWithin10Km ? 1.4 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: purple.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
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
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: lightPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.business_center_rounded,
                        color: purple,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Judul / Nama Pekerjaan (Besar, Jelas, maxLines 2)
                          Text(
                            job.judul,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: darkColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Nama Perusahaan / Usaha
                          Row(
                            children: [
                              Icon(
                                Icons.apartment_rounded,
                                size: 13,
                                color: greyColor,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  job.namaPt,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: greyColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              // Badge Durasi / Shift
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: lightPurple,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  job.durasi,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: purple,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              // Badge Jarak & Radius 10 km
                              if (distanceKm >= 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isWithin10Km
                                        ? const Color(0xFFDCFCE7)
                                        : const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(6),
                                    border: isWithin10Km
                                        ? Border.all(
                                            color: const Color(0xFF86EFAC),
                                            width: 0.8,
                                          )
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isWithin10Km
                                            ? Icons.near_me_rounded
                                            : Icons.location_on_rounded,
                                        size: 11,
                                        color: isWithin10Km
                                            ? const Color(0xFF16A34A)
                                            : greyColor,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        isWithin10Km
                                            ? '${distanceKm.toStringAsFixed(1)} km (Radius 10 km)'
                                            : '${distanceKm.toStringAsFixed(1)} km',
                                        style: TextStyle(
                                          color: isWithin10Km
                                              ? const Color(0xFF15803D)
                                              : greyColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFF1EEF8)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Rp ${job.upah}',
                      style: TextStyle(
                        color: purple,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          'Lihat Lowongan',
                          style: TextStyle(
                            color: purple,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: purple,
                          size: 14,
                        ),
                      ],
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

  Widget _buildAttachmentPreview() {
    final path = controller.selectedAttachmentPath.value;
    final name = controller.selectedAttachmentName.value;
    final type = controller.selectedAttachmentType.value;
    final size = controller.selectedAttachmentSize.value;

    if (type == ChatAttachmentType.none || path == null) {
      return const SizedBox.shrink();
    }

    final isImg = type == ChatAttachmentType.image;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: purple.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: purple.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isImg)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 44,
                height: 44,
                child: Image.file(
                  File(path),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: lightPurple,
                    child: Icon(Icons.image, color: purple),
                  ),
                ),
              ),
            )
          else
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: lightPurple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.description_rounded, color: purple, size: 24),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name ?? 'Berkas Terpilih',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: darkColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  size != null
                      ? '${isImg ? 'Foto CV' : 'Dokumen CV'} · ${DocumentHelper.formatFileSize(size)}'
                      : (isImg
                            ? 'Foto CV siap dipindai'
                            : 'Dokumen CV siap dipindai'),
                  style: TextStyle(color: greyColor, fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            color: greyColor,
            onPressed: controller.clearAttachment,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          // WhatsApp style attachment button (Paperclip)
          Material(
            color: lightPurple,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => _showWhatsAppAttachmentMenu(context),
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                child: Icon(Icons.attach_file_rounded, color: purple, size: 22),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Text Field
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: pageColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: borderColor),
              ),
              child: TextField(
                controller: controller.textController,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Tulis pesan atau lampirkan CV...',
                  hintStyle: TextStyle(color: greyColor, fontSize: 13),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send button
          Obx(() {
            final isBusy = controller.isGenerating.value;
            return Material(
              color: purple,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: isBusy ? null : () => controller.sendMessage(),
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  child: isBusy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// WhatsApp-style attachment sheet
  void _showWhatsAppAttachmentMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (ctx) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Pilih Lampiran CV Pekerja',
                  style: TextStyle(
                    color: darkColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kirim berkas dokumen atau foto CV Anda untuk dipindai oleh AI.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: greyColor, fontSize: 11),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttachmentOption(
                      icon: Icons.insert_drive_file_rounded,
                      label: 'Dokumen',
                      gradientColors: const [
                        Color(0xFF5B60F6),
                        Color(0xFF7F4FF5),
                      ],
                      onTap: () {
                        Navigator.pop(ctx);
                        controller.pickDocument();
                      },
                    ),
                    _buildAttachmentOption(
                      icon: Icons.photo_library_rounded,
                      label: 'Galeri',
                      gradientColors: const [
                        Color(0xFFAC44CF),
                        Color(0xFFE040FB),
                      ],
                      onTap: () {
                        Navigator.pop(ctx);
                        controller.pickImageFromGallery();
                      },
                    ),
                    _buildAttachmentOption(
                      icon: Icons.camera_alt_rounded,
                      label: 'Kamera',
                      gradientColors: const [
                        Color(0xFF00B0FF),
                        Color(0xFF00E5FF),
                      ],
                      onTap: () {
                        Navigator.pop(ctx);
                        controller.pickImageFromCamera();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: gradientColors.first.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: darkColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
