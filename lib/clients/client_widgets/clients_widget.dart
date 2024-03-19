import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/clients/client_class.dart';
import 'package:ip_planner_flutter/design/social_widgets/social_widget.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import '../../dates/date_mixin.dart';
import '../../design/app_colors.dart';
import '../../design/text_widgets/text_custom.dart';
import '../../links/open_url_class.dart';
import '../../links/url_path_enum.dart';

class ClientWidget extends StatelessWidget {
  final ClientCustom client; // Передаваемая переменная
  final VoidCallback onDelete; // Передаваемая переменная
  final VoidCallback onEdit; // Передаваемая переменная

  const ClientWidget({super.key, required this.client, required this.onDelete, required this.onEdit}); // required - значит, что обязательно

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.blackLight,
          borderRadius: BorderRadius.circular(15), // настройте радиус скругления углов для контейнера
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: TextCustom(
                      text: client.name,
                      textState: TextState.bodyBig,
                    //weight: FontWeight.bold,
                    )
                  ),
                const SizedBox(width: 30,),
                GestureDetector(
                  child: const Icon(FontAwesomeIcons.x, size: 16, color: AppColors.attentionRed,),
                  onTap: (){
                    onDelete();
                  },
                ),
              ],
            ),

            if (client.birthDay != DateTime(2100)) const SizedBox(height: 5,),

            if (client.birthDay != DateTime(2100)) TextCustom(
                text: 'День рождения: ${DateMixin.getHumanDateFromDateTime(client.birthDay)}',
              textState: TextState.labelMedium,
            ),

            const SizedBox(height: 5,),

            TextCustom(
              text: 'Создан: ${DateMixin.getHumanDateFromDateTime(client.createDate)}',
              textState: TextState.labelMedium,
              color: AppColors.greyLight,
            ),

            if (
                client.whatsapp.isNotEmpty ||
                client.telegram.isNotEmpty ||
                client.instagram.isNotEmpty ||
                client.phone.isNotEmpty
            ) const SizedBox(height: 15,),

            SocialWidget(
              whatsapp: client.whatsapp,
              telegram: client.telegram,
              instagram: client.instagram,
              phone: client.phone,
            )

          ],
        ),
      ),
    );
  }
}