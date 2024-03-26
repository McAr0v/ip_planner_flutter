import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/design/app_colors.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import '../note_class.dart';

class NoteWidget extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteWidget({super.key, required this.note, required this.onTap, required this.onDelete}); // required - значит, что обязательно

  @override
  Widget build(BuildContext context) {
    return Container(
      height: note.imageUrl.isNotEmpty ? 300 : null,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(15.0),
        image: note.imageUrl.isNotEmpty ? DecorationImage(
          image: NetworkImage(note.imageUrl),
          fit: BoxFit.cover,
        ) : null,
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.black.withOpacity(0),
              AppColors.black.withOpacity(0),
              AppColors.black.withOpacity(0),
              AppColors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: note.imageUrl.isNotEmpty ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextCustom(text: note.headline, textState: TextState.bodyBig, weight: FontWeight.bold,),
                    if (note.desc.isNotEmpty) TextCustom(text: note.desc, textState: TextState.labelMedium, maxLines: 5,),
                  ],
                )),
            IconButton(
                onPressed: onTap,
                icon: const Icon(Icons.edit, size: 20,),
                style: note.imageUrl.isNotEmpty ? ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                    return AppColors.black;
                  },
                ),
              ) : null
            ),
            IconButton(
                onPressed: onDelete,
                icon: const Icon(FontAwesomeIcons.x, size: 15,),
                style: note.imageUrl.isNotEmpty ? ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      return AppColors.black;
                    },
                  ),
                ) : null
            ),
          ],
        ),
      ),
    );
  }
}