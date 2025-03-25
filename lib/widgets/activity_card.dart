import 'package:flutter/material.dart';
import 'package:ramadan_planner/models/activity.dart';
import 'package:ramadan_planner/utils/constants.dart';

/// Interactive widget to display and interact with a Ramadan activity
class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback onToggleCompletion;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onToggleCompletion,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Determine color scheme based on activity type and completion status
    Color typeColor;
    IconData typeIcon;
    
    switch (activity.type.toLowerCase()) {
      case 'prayer':
        typeColor = Colors.indigo;
        typeIcon = Icons.mosque;
        break;
      case 'spiritual':
        typeColor = Colors.teal;
        typeIcon = Icons.auto_stories;
        break;
      case 'food':
        typeColor = Colors.orange;
        typeIcon = Icons.restaurant;
        break;
      case 'charity':
        typeColor = Colors.green;
        typeIcon = Icons.volunteer_activism;
        break;
      case 'social':
        typeColor = Colors.blue;
        typeIcon = Icons.people;
        break;
      default:
        typeColor = AppConstants.primaryColor;
        typeIcon = Icons.event_note;
    }
    
    // Opacity based on completion
    final cardOpacity = activity.completed ? 0.7 : 1.0;
    
    return Dismissible(
      key: Key(activity.id.toString()),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        if (onDelete != null) {
          onDelete!();
          return true;
        }
        return false;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onToggleCompletion,
            onLongPress: onEdit,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Activity type icon
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        typeIcon,
                        color: typeColor.withOpacity(cardOpacity),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Activity details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: activity.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: activity.completed
                                  ? Colors.grey
                                  : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                activity.time,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: typeColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  activity.type[0].toUpperCase() + activity.type.substring(1),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: typeColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (activity.description != null && activity.description!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                activity.description!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Completion checkbox
                    GestureDetector(
                      onTap: onToggleCompletion,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: activity.completed
                              ? AppConstants.primaryColor
                              : Colors.white,
                          border: Border.all(
                            color: activity.completed
                                ? AppConstants.primaryColor
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: activity.completed
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}