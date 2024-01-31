import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:premium_fivver_note_app/components/constants.dart';
import 'package:premium_fivver_note_app/shared/add_note_bloc/cubit.dart';
import '../models/category_model.dart';
import '../models/note_model.dart';
import '../screens/note_screen.dart';
import '../style/colors.dart';

Widget defTextField({
  required TextEditingController controller,
  required IconData rightIcon,
  IconData? leftIcon,
  String? text,
  void Function()? onTap,
  void Function()? leftIconOnPressed,
  double fontSize = 25,
  int maxLines = 1,
  int? maxLength,
  bool hideInput = false,
  TextInputType keyboard = TextInputType.text,
  bool hideKeyboard = false,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: TextFormField(
        maxLength: maxLength,
        maxLines: maxLines,
        readOnly: hideKeyboard,
        obscureText: hideInput,
        keyboardType: keyboard,
        style: TextStyle(
          fontSize: fontSize,
          wordSpacing: 5,
          fontWeight: FontWeight.bold,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter some information';
          }
          return null;
        },
        onTap: onTap,
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: defColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: defColor,
            ),
          ),
          prefixIcon: Icon(
            rightIcon,
            color: defColor,
          ),
          suffixIcon: IconButton(
            onPressed: leftIconOnPressed,
            icon: Icon(
              leftIcon,
              color: defColor,
            ),
          ),
          hintText: text?.toUpperCase(),
          hintStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

Widget defTextButton({
  String? text,
  required bool uploadData,
  void Function()? onTap,
}) =>
    Container(
      height: 60,
      width: 210,
      margin: const EdgeInsetsDirectional.symmetric(vertical: 15),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: defColor,
        borderRadius: BorderRadiusDirectional.circular(30),
      ),
      child: uploadData
          ? MaterialButton(
              onPressed: () {},
              color: defColor,
              child: const CircularProgressIndicator(),
            )
          : MaterialButton(
              onPressed: onTap,
              color: defColor,
              child: Text(
                text!,
                style: const TextStyle(
                  color: secondColor,
                  fontSize: 18,
                ),
              ),
            ),
    );

void navigateAndFinish(context, Widget screen) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
      (route) => false,
    );

void navigateTo(context, Widget screen) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );

Widget defIconButton({
  void Function()? onTap,
  required IconData icon,
  double margin = 10,
  double height = 45,
  Color iconColor = secondColor,
}) =>
    Container(
      height: height,
      margin: EdgeInsetsDirectional.only(start: margin),
      decoration: BoxDecoration(
        color: defColor,
        borderRadius: BorderRadiusDirectional.circular(20),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );



Widget defAppBar({
  required context,
  required String screenName,
  double fontSize = 24,
  bool useInViewCategoryScreen = false,
}) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          defIconButton(
            icon: Icons.arrow_back_ios,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            constraints: useInViewCategoryScreen ? null :
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 4),
            child: Text(
              screenName.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style:  TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

Widget noteItem({required NoteModel model, index}) => LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double availableWidth = constraints.maxWidth;
        const double minWidthForDate = 200;
        const double requiredWidthForTitle = 100;
        const double minWidthForFavoriteIcon = 150;
        return Container(
          color: defColor.withOpacity(0.6),
          padding: const EdgeInsetsDirectional.all(15),
          child: Builder(builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// title and fav icon
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /// title
                      if (model.title.isNotEmpty &&
                          requiredWidthForTitle <= availableWidth)
                        Expanded(
                          child: Text(
                            model.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                height: 1.2,
                                color: secondColor),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      if (minWidthForFavoriteIcon <= availableWidth)
                        IconButton(
                          onPressed: () {
                            AddNoteCubit.get(context).updateFavouriteField(
                                id: model.id, isFavorite: !model.isFavorite);
                          },
                          padding: EdgeInsetsDirectional.zero,
                          icon: model.isFavorite
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.yellowAccent,
                                  size: 35,
                                )
                              : const Icon(
                                  Icons.favorite_outline,
                                  color: secondColor,
                                  size: 35,
                                ),
                        )
                    ],
                  ),
                ),

                /// note
                Expanded(
                  flex: 2,
                  child: Text(
                    model.note,
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.15,
                      color: secondColor,
                    ),
                  ),
                ),

                /// image
                if (model.images.isNotEmpty)
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5, top: 5),
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 5),
                        scrollDirection: Axis.horizontal,
                        itemCount: model.images.length,
                        itemBuilder: (context, index) {
                          final file = model.images[index];
                          return networkImage(file);
                        },
                      ),
                    ),
                  ),

                /// date
                if (minWidthForDate <= availableWidth)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          model.date,
                          style: const TextStyle(
                            color: secondColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          model.time,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: secondColor,
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            );
          }),
        );
      },
    );

Widget optionNoteItem(context, NoteModel model, index) => FocusedMenuHolder(
      animateMenuItems: false,
      duration: const Duration(milliseconds: 0),
      menuWidth: MediaQuery.of(context).size.width * 0.50,
      menuItems: <FocusedMenuItem>[
        /// open
        FocusedMenuItem(
            title: const Text(
              'open',
              style: TextStyle(fontSize: 25, height: 1.15, color: defColor),
            ),
            onPressed: () {
              NoteModel note = NoteModel(
                category: model.category,
                lastUpdate: model.lastUpdate,
                isFavorite: model.isFavorite,
                title: model.title,
                id: model.id,
                note: model.note,
                date: model.date,
                time: model.time,
                images: model.images,
              );
              navigateTo(
                context,
                NoteScreen(note),
              );
            },
            trailingIcon: const Icon(Icons.open_in_new_rounded)),

        /// add or remove item favorite
        FocusedMenuItem(
            title: model.isFavorite
                ? const Text(
                    'remove from favorite',
                    style:
                        TextStyle(fontSize: 25, height: 1.15, color: defColor),
                  )
                : const Text(
                    'add to favorite',
                    style:
                        TextStyle(fontSize: 25, height: 1.15, color: defColor),
                  ),
            onPressed: () {
              AddNoteCubit.get(context).updateFavouriteField(
                  id: model.id, isFavorite: !model.isFavorite);
            },
            trailingIcon: model.isFavorite
                ? const Icon(
                    Icons.favorite_outline,
                  )
                : const Icon(
                    Icons.favorite,
                    color: Colors.yellowAccent,
                  ),
            backgroundColor: model.isFavorite
                ? Colors.red.withOpacity(.5)
                : Colors.yellow[700]),

        /// add or remove category
        FocusedMenuItem(
          title: Text(
            model.category == ''
                ? 'add to category'
                : 'Remove from ${model.category.split(' ')[0]}\'s category',
            style: const TextStyle(fontSize: 25, height: 1.15, color: defColor),
          ),
          onPressed: () {
            if (model.category == '') {
              showModalBottomSheet(
                context: context,
                backgroundColor: defColor,
                builder: (context) {
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsetsDirectional.all(10),
                        padding: const EdgeInsetsDirectional.all(15),
                        decoration: BoxDecoration(
                          color: secondColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Add to category'.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) => categoryItem(
                              categories[index], context,
                              id: model.id),
                          itemCount: categories.length,
                          physics: const BouncingScrollPhysics(),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              AddNoteCubit.get(context)
                  .updateCategoryField(id: model.id, category: '');
            }
          },
          trailingIcon: Icon(
            model.category == '' ? Icons.add : Icons.delete_outline,
          ),
          backgroundColor:
              model.category == '' ? Colors.white : Colors.red.withOpacity(0.8),
        ),

        /// delete
        FocusedMenuItem(
          title: const Text(
            'delete',
            style: TextStyle(fontSize: 25, height: 1.15, color: defColor),
          ),
          onPressed: () {
            AddNoteCubit.get(context).deleteNote(model.id);
          },
          trailingIcon: const Icon(
            Icons.delete_outline,
          ),
          backgroundColor: Colors.red,
        ),
      ],
      onPressed: () {},
      child: InkWell(
        onTap: () {
          NoteModel note = NoteModel(
            lastUpdate: model.lastUpdate,
            category: model.category,
            isFavorite: model.isFavorite,
            title: model.title,
            id: model.id,
            note: model.note,
            date: model.date,
            time: model.time,
            images: model.images,
          );

          navigateTo(
            context,
            NoteScreen(note),
          );
        },
        child: noteItem(model: model,index: index),
      ),
    );

Widget ifNotesEmpty() => Expanded(
      child: networkImage(
          'https://drive.google.com/uc?export=view&id=1S0TYoRKDvX3yXYnqinUvsU0sqC4hOAlE',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill),
    );

Future<bool?> toast({
  required String msg,
  required bool isError,
}) =>
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: isError ? Colors.red : Colors.black,
        textColor: Colors.white,
        fontSize: 18);

Widget defCircularProgress() => const SizedBox(
      height: 210,
      width: 210,
      child: CircularProgressIndicator(
        strokeWidth: 12,
        color: secondColor,
      ),
    );

Widget defLinearProgress() => const Padding(
      padding: EdgeInsets.only(top: 15, bottom: 10),
      child: LinearProgressIndicator(
        color: defColor,
        backgroundColor: secondColor,
      ),
    );

Widget categoryItem(CategoryModel model, context, {character, id}) =>
    LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final double availableWidth = constraints.maxWidth;
      const double requiredWidth = 340;

      double radius = constraints.maxWidth / 10;

      return InkWell(
        onTap: () {
          if (id != null) {
            AddNoteCubit.get(context)
                .updateCategoryField(id: id, category: model.name);
          } else {
            AddNoteCubit.get(context).selectCategory(model.name);
          }

          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsetsDirectional.all(10),
          padding: const EdgeInsetsDirectional.all(15),
          decoration: BoxDecoration(
              color: secondColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: model.name == AddNoteCubit.get(context).category
                        ? Colors.white
                        : Colors.black,
                    spreadRadius: 10),
                BoxShadow(
                    color:
                        character == model.name ? Colors.white : Colors.black,
                    spreadRadius: 5)
              ]),
          child: Row(
            children: [
              CircleAvatar(
                  radius: radius,
                  backgroundImage: CachedNetworkImageProvider(model.image)),
              const Spacer(),
              if(requiredWidth <= availableWidth)
              Text(
                model.name.toUpperCase(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    },
    );

networkImage(file, {fit, width, height}) => CachedNetworkImage(
      imageUrl: file,
      height: height,
      width: width,
      fit: fit,
      placeholder: (context, url) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
        ],
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );

Widget socialMediaItem({
  required String image,
  required double radius,
  required Function() onTap,
}) =>
    InkWell(
        onTap: onTap,
        child: CircleAvatar(
          radius: radius,
          backgroundImage: CachedNetworkImageProvider(image),
        ));
