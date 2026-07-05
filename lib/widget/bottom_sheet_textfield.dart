import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors/app_colors.dart';
import '../utils/app_text_style/app_text_style.dart';
import '../core/responsive_layout/dimensions.dart';

class BottomSheetTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final List<String> items;
  final String? hint;

  const BottomSheetTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.items,
    this.hint,
  });

  void _openSheet(BuildContext context) {
    Get.bottomSheet(
      _ItemBottomSheet(
        title: label,
        items: items,
        onSelect: (value) {
          controller.text = value;
          Get.back();
        },
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openSheet(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          readOnly: true,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: AppTextStyles.inputLabel.copyWith(
              color: AppColors.darkGreyColor,
            ),
            hintText: hint,
            suffixIcon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.greyColor,
            ),
            filled: true,
            fillColor: AppColors.textFieldBackgroundColor,
            contentPadding: EdgeInsets.all(Dimensions.h(16)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.r(12)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.r(12)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.r(12)),
              borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}

class _ItemBottomSheet extends StatelessWidget {
  final String title;
  final List<String> items;
  final Function(String) onSelect;

  const _ItemBottomSheet({
    required this.title,
    required this.items,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.r(20)),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: Dimensions.h(12)),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.greyColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: Dimensions.h(20)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: AppTextStyles.h3.copyWith(color: AppColors.blackColor),
              ),
            ),
          ),
          SizedBox(height: Dimensions.h(12)),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(20),
                vertical: Dimensions.h(10),
              ),
              itemCount: items.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: AppColors.greyColor.withOpacity(0.1),
              ),
              itemBuilder: (_, index) {
                final item = items[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item,
                    style: AppTextStyles.cardTitle,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColors.greyColor,
                  ),
                  onTap: () => onSelect(item),
                );
              },
            ),
          ),
          SizedBox(height: Dimensions.h(30)),
        ],
      ),
    );
  }
}