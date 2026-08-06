import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Circular avatar placeholder with a small camera badge, used to
/// let the user pick a profile photo. onTap should open an image
/// picker (e.g. image_picker package) once wired up.
class AvatarUploadPicker extends StatelessWidget {
  const AvatarUploadPicker({super.key, this.onTap, this.imageBytes});

  final VoidCallback? onTap;
  final Object? imageBytes; // wire up to actual image data later

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Container(
                width: 92,
                height: 92,
                decoration: const BoxDecoration(
                  color: AppColors.inputFill,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline,
                    color: AppColors.textMuted, size: 40),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: AppColors.limeAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt,
                      color: Colors.black, size: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'UPLOAD PROFILE PHOTO',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.limeAccent,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}