import 'package:flutter/material.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../model/NotificationModel.dart';
import 'package:intl/intl.dart';

class NotificationItem extends StatelessWidget {
  final Data notification;

  const NotificationItem({super.key, required this.notification});

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: notification.isRead == true
            ? Colors.white
            : AppColors.navBarColor, // Light cream from design system
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
                if (notification.body != null &&
                    notification.body!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    notification.body!,
                    style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  _formatDate(notification.createdAt),
                  style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
