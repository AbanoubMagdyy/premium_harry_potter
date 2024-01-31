import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:premium_fivver_note_app/models/note_model.dart';
import '../../components/components.dart';
import '../../components/constants.dart';
import '../../shared/add_note_bloc/cubit.dart';
import '../../shared/add_note_bloc/states.dart';
import '../../style/colors.dart';
import '../background_image.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AddNoteCubit, AddNotesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AddNoteCubit.get(context);

        return Scaffold(
          floatingActionButton:FloatingActionButton(
            onPressed: (){
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
                        child: Text('Add note to favorite'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            if(!cubit.notes[index].isFavorite) {
                              return noteItem(cubit.notes[index],context);
                            }else{
                              return Container();
                            }
                          },
                           itemCount: cubit.notes.length,
                          physics: const BouncingScrollPhysics(),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Icon(Icons.add),
          ) ,
          body: BackgroundImage(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    /// APPBAR
                    defAppBar(context: context, screenName: 'favorites'),
                    const SizedBox(height: 15,),
                    if(state is LeadingUpdateFavoriteField)
                      defLinearProgress(),
                    if(cubit.favoriteNotes.isNotEmpty)
                     Expanded(
                       child: StaggeredGridView.countBuilder(
                         crossAxisCount: 2,
                         crossAxisSpacing: 10,
                         mainAxisSpacing: 10,
                         itemCount: cubit.favoriteNotes.length,
                         itemBuilder: (context, index) {
                           return optionNoteItem(context, cubit.favoriteNotes[index], index);
                         },
                         staggeredTileBuilder: (index) {
                           return index == 0
                               ? const StaggeredTile.count(1, 1.0) //For Text
                               : const StaggeredTile.count(1, 1.2); // others item
                         },
                       ),
                     ),
                    if(cubit.favoriteNotes.isEmpty)
                    ifNotesEmpty(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Widget noteItem(NoteModel listModel,context) => InkWell(
    onTap: (){
  checkInternetConnectivity();
  if(isConnect){
    AddNoteCubit.get(context).updateFavouriteField(id: listModel.id, isFavorite: true).then((value) {
      toast(msg: 'Add to favorite success', isError: false);
    });
    Navigator.pop(context);
  }else {
    toast(
      msg: 'Please check the Internet',
      isError: true,);
  }

    },
    child: Container(
      margin: const EdgeInsetsDirectional.all(10),
      padding: const EdgeInsetsDirectional.all(15),
      decoration: BoxDecoration(
        color: secondColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [
          if(listModel.title.isNotEmpty)
            Text(listModel.title.toUpperCase(),style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
            ),
            ),
          if(listModel.note.isNotEmpty)
            Text(listModel.note.toUpperCase(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
        ],
      ),
    ),
  );
}
