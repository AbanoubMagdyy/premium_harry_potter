import 'package:cached_network_image/cached_network_image.dart';
import 'package:premium_fivver_note_app/components/components.dart';
import 'package:premium_fivver_note_app/screens/view_image_screen.dart';
import 'package:premium_fivver_note_app/shared/add_note_bloc/cubit.dart';
import 'package:premium_fivver_note_app/shared/add_note_bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/constants.dart';
import '../layout/layout_screen.dart';
import '../models/note_model.dart';
import '../shared/bloc/cubit.dart';
import '../style/colors.dart';
import 'background_image.dart';

class NoteScreen extends StatelessWidget {
  final NoteModel note;
  final double requiredWidth = 350;
  final double requiredHeight = 750;
  final titleController = TextEditingController();
  final noteController = TextEditingController();

  NoteScreen(this.note, {super.key});

  @override
  Widget build(BuildContext context) {


    if (note.isFavorite) {
      AddNoteCubit.get(context).isFavorite = true;
    } else {
      AddNoteCubit.get(context).isFavorite = false;
    }
    titleController.text = note.title;
    noteController.text = note.note;
    AddNoteCubit.get(context).category = '';
    AddNoteCubit.get(context).imageUrls = [];
    AddNoteCubit.get(context).imageFiles = [];
    AddNoteCubit.get(context).noteImages = [];

    if (note.images.isNotEmpty) {
      for (String i in note.images) {
        AddNoteCubit.get(context).noteImages.add(i);
      }
    }

    return BlocConsumer<AddNoteCubit, AddNotesStates>(
      listener: (context, state) {
        if (state is SuccessGetNotes) {
          toast(msg: 'Update note success', isError: false);
          navigateTo(context, const LayoutScreen());
        }
      },
      builder: (context, state) {
        var cubit = AddNoteCubit.get(context);
        return WillPopScope(
          onWillPop: () async {
            if(noteController.text != note.note || titleController.text != note.title){
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: secondColor,
                    contentPadding: const EdgeInsetsDirectional.all(50),
                    content: Text(
                      'Do you want to save this edit'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          checkInternetConnectivity();
                          if (isConnect) {
                            var images = calculateTotalFileSizeInGB(
                                cubit.noteImages, false);
                            if (images <=
                                NotesCubit.get(context)
                                    .model
                                    .maximumSizeOfImagesInGB) {
                              calculateTotalFileSizeInGB(cubit.noteImages, true);
                              cubit.updateNote(
                                  id: note.id,
                                  title: titleController.text,
                                  note: noteController.text);
                            } else {
                              toast(
                                  msg:
                                  'You have exceeded the maximum available space. You need to delete some images or increase the space if you wish, contact the programmer',
                                  isError: true);
                            }
                          } else {
                            toast(
                              msg: 'Please check the Internet',
                              isError: true,
                            );
                          }
                        },
                        child: Text(
                          'save'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          navigateTo(context, const LayoutScreen());
                        },
                        child: Text(
                          'cancel'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            return true;
          },
          child: Scaffold(
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double availableWidth = constraints.maxWidth;
                final double availableHeight = constraints.maxHeight;
                return BackgroundImage(
                  sigma: 25,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 10, bottom: 10),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ///appBar
                          if(requiredWidth <= availableWidth)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                              children: [
                                /// back
                                defIconButton(
                                  icon: Icons.arrow_back_ios,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                const Spacer(),

                                /// save update
                                defIconButton(
                                  icon: Icons.save_outlined,
                                  onTap: () {
                                    checkInternetConnectivity();
                                    if (isConnect) {
                                      var images = calculateTotalFileSizeInGB(
                                          cubit.noteImages, false);
                                      if (images <=
                                          NotesCubit.get(context)
                                              .model
                                              .maximumSizeOfImagesInGB) {
                                        calculateTotalFileSizeInGB(
                                            cubit.noteImages, true);
                                        cubit.updateNote(
                                            id: note.id,
                                            title: titleController.text,
                                            note: noteController.text);
                                      } else {
                                        toast(
                                            msg:
                                                'You have exceeded the maximum available space. You need to delete some images or increase the space if you wish, contact the programmer',
                                            isError: true);
                                      }
                                    } else {
                                      toast(
                                        msg: 'Please check the Internet',
                                        isError: true,
                                      );
                                    }
                                  },
                                ),

                                /// photos
                                defIconButton(
                                  icon: Icons.photo_library_outlined,
                                  onTap: () {
                                    cubit.selectImages(cubit.noteImages);
                                  },
                                ),

                                /// favorite
                                defIconButton(
                                  icon: cubit.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  onTap: () {
                                    cubit.changeFavourites();
                                  },
                                ),

                                ///  change  category
                                defIconButton(
                                  icon: Icons.change_circle_outlined,
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: defColor,
                                      builder: (context) {
                                        return Column(
                                          children: [
                                            Container(
                                              margin:
                                                  const EdgeInsetsDirectional.all(
                                                      10),
                                              padding:
                                                  const EdgeInsetsDirectional.all(
                                                      15),
                                              decoration: BoxDecoration(
                                                color: secondColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                'change to category'
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                itemBuilder: (context, index) =>
                                                    categoryItem(
                                                        categories[index],
                                                        context,
                                                        character: note.category),
                                                itemCount: categories.length,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                          ),
                            ),
                          if (state is LeadingUpdateNote ||
                              state is LeadingGetNotes ||
                              state is FormatNoteImages ||
                              state is LeadingUploadImages)
                            defLinearProgress(),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                children: [
                                  /// title
                                  TextFormField(
                                    minLines: 1,
                                    maxLines: 1,
                                    controller: titleController,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      wordSpacing: 5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Title',
                                    ),
                                  ),
                                  /// note
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 1000,
                                      controller: noteController,
                                      keyboardType: TextInputType.multiline,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        wordSpacing: 5,
                                        height: 1.3,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            'Type Something if you want ot edit ...',
                                      ),
                                    ),
                                  ),

                                  /// images
                                  if (cubit.noteImages.isNotEmpty)
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: ListView.separated(
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(width: 5),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: cubit.noteImages.length,
                                          itemBuilder: (context, index) {
                                            final file =
                                                cubit.noteImages[index];
                                            return InkWell(
                                              onTap: () {
                                                navigateTo(
                                                  context,
                                                  FullScreenImage(
                                                    imagePath: file,
                                                  ),
                                                );
                                              },
                                              child: Stack(
                                                children: [
                                                  displayImage(file),
                                                  if(availableHeight >= 750)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 8.0,
                                                    ),
                                                    child:  defIconButton(
                                                      height:  40 ,
                                                      icon: Icons.delete_outline ,
                                                      onTap: () =>
                                                          cubit.removeImage(
                                                              cubit.noteImages,
                                                              file),
                                                    ),
                                                  ),
                                                  if(requiredHeight > availableHeight && availableHeight > 350)
                                                    IconButton(
                                                      icon:const Icon(Icons.remove_circle_outline_sharp),
                                                      onPressed: () =>
                                                          cubit.removeImage(
                                                              cubit.noteImages,
                                                              file),
                                                      alignment: Alignment.topLeft,
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Text('LAST UPDATE  ${note.lastUpdate}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget displayImage(image) {
    if (image is String) {
      return CachedNetworkImage(
        imageUrl: image,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      return Image.file(image);
    }
  }
}
