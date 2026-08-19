import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextStyle displayLarge(bool isDark) => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
      );

  static TextStyle titleLarge(bool isDark) => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
      );

  static TextStyle titleMedium(bool isDark) => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
      );

  static TextStyle titleSmall(bool isDark) => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
      );

  static TextStyle bodyLarge(bool isDark) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
      );

  static TextStyle bodyMedium(bool isDark) => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
      );

  static TextStyle labelBold(bool isDark) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
      );

  static TextStyle labelMuted(bool isDark) => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
      );

  static TextStyle mono(bool isDark) => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
      );
}
