import 'package:cached_network_image/cached_network_image.dart';
import 'package:premium_fivver_note_app/components/constants.dart';
import 'package:premium_fivver_note_app/screens/settings_screens/about_app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:premium_fivver_note_app/screens/settings_screens/favorites_screen.dart';
import 'package:premium_fivver_note_app/screens/settings_screens/profile_screen.dart';
import '../../components/components.dart';
import '../../shared/bloc/cubit.dart';
import '../../shared/bloc/states.dart';
import '../../style/colors.dart';
import '../settings_screens/edit_screen.dart';

class SettingsScreen extends StatelessWidget {
  final double requiredWidth = 280;

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesCubit, NotesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        NotesCubit cubit = NotesCubit.get(context);
        return Center(
          child: SingleChildScrollView(
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              final double availableWidth = constraints.maxWidth;
              double radius = constraints.maxWidth / 3;

              return Column(
                children: [
                  ///   image
                  CircleAvatar(
                    radius: radius,
                    backgroundColor: secondColor,
                    child: CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(cubit.model.profile),
                      radius: radius -15,
                    ),
                  ),

                  ///   NAME
                  text(text: cubit.model.name),

                  /// birthday
                  text(text: cubit.model.birthday),

                  /// ITEMS
                  if(requiredWidth <= availableWidth)
                  Column(
                    children: [
                      /// PROFILE
                      item(
                          leftIcon: Icons.person_outline,
                          itemName: 'profile',
                          context: context,
                          onTap: () =>
                              navigateTo(context, const ProfileScreen())),

                      /// favorites
                      item(
                          leftIcon: Icons.favorite,
                          itemName: 'favorites',
                          context: context,
                          onTap: () =>
                              navigateTo(context, const FavoritesScreen())),

                      /// about app
                      item(
                          leftIcon: Icons.info_outline,
                          itemName: 'about app',
                          context: context,
                          onTap: () =>
                              navigateTo(context, const AboutAppScreen())),

                      /// edit profile
                      item(
                          leftIcon: Icons.mode_edit_outline_outlined,
                          itemName: 'edit profile',
                          context: context,
                          onTap: () => navigateTo(context, EditScreen())),

                      /// log out
                      item(
                        leftIcon: Icons.logout_outlined,
                        itemName: 'log out',
                        context: context,
                        onTap: () => logout(context),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Widget item({
    required IconData leftIcon,
    required String itemName,
    required context,
    required void Function() onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              defIconButton(icon: leftIcon),
              const SizedBox(
                width: 10,
              ),
              Text(
                itemName.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              defIconButton(icon: Icons.arrow_forward_ios),
              const SizedBox(
                width: 7,
              ),
            ],
          ),
        ),
      );

  Widget text({
    required String text,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: defColor,
          ),
        ),
      );
}
