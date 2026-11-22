import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class DocumentHelper {
  /// Memeriksa apakah ekstensi berkas adalah gambar
  static bool isImageFile(String path) {
    final ext = path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'webp', 'heic', 'bmp'].contains(ext);
  }

  /// Memeriksa apakah ekstensi berkas adalah PDF
  static bool isPdfFile(String path) {
    return path.toLowerCase().endsWith('.pdf');
  }

  /// Format ukuran berkas (bytes -> KB/MB)
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Ekstraksi teks dari berkas CV (PDF atau teks biasa)
  static Future<String> extractTextFromFile(File file) async {
    final path = file.path.toLowerCase();

    if (path.endsWith('.txt') ||
        path.endsWith('.csv') ||
        path.endsWith('.md') ||
        path.endsWith('.rtf')) {
      try {
        return await file.readAsString();
      } catch (_) {
        final bytes = await file.readAsBytes();
        return latin1.decode(bytes);
      }
    }

    if (path.endsWith('.pdf')) {
      return await _extractTextFromPdf(file);
    }

    // Default fallback untuk file teks lainnya
    try {
      final bytes = await file.readAsBytes();
      final sample = utf8.decode(bytes, allowMalformed: true);
      if (sample.trim().isNotEmpty) {
        return sample;
      }
    } catch (_) {}

    return 'Format dokumen ini memerlukan pembaca khusus.';
  }

  /// Ekstraksi teks menggunakan Syncfusion PDF TextExtractor resmi
  static Future<String> _extractTextFromPdf(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final String extractedText = PdfTextExtractor(document).extractText();
      document.dispose();

      final cleanText = extractedText.trim();
      if (cleanText.isNotEmpty) {
        debugPrint(
          '✅ [PDF EXTRACT SUCCESS] Berhasil mengekstrak ${cleanText.length} karakter teks.',
        );
        return cleanText;
      }

      return 'Dokumen PDF terbaca, namun tidak ditemukan teks (kemungkinan berupa pindaian/scan foto). Disarankan mengunggah foto langsung atau dokumen teks.';
    } catch (e) {
      debugPrint('⚠️ [PDF EXTRACT ERROR] $e');
      return 'Gagal mengekstrak isi dokumen PDF: $e';
    }
  }
}
