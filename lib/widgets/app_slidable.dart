import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_trips_app/core/app_colors.dart';

class AppSlidable extends StatelessWidget {
  final Widget child;
  final Function()? onDelete;
  final Function()? onEdit;
  final double extendRatio;
  const AppSlidable({
    Key? key,
    required this.child,
    this.onDelete,
    this.onEdit,
    this.extendRatio = 0.22,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: key,
      endActionPane: ActionPane(
        extentRatio: extendRatio,
        motion: const ScrollMotion(),
        children: [
          if (onDelete != null)
            SlidableAction(
              icon: Icons.delete,
              foregroundColor: Colors.red,
              onPressed: (context) {
                onDelete!();
              },
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
          if (onEdit != null)
            SlidableAction(
              foregroundColor: AppColors.primary,
              icon: Icons.edit,
              onPressed: (context) {
                onEdit!();
              },
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
        ],
      ),
      child: child,
    );
  }
}
