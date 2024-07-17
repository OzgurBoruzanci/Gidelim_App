import 'package:bootcamp91/product/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoadingWidget extends StatelessWidget {
  final double size;
  final Color color;

  const CustomLoadingWidget({
    Key? key,
    this.size = 50.0,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.inkDrop(
        color: ProjectColors.project_yellow,
        size: 50 ,
      ),
    );
  }
}
