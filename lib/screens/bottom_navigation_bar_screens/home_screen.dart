import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:premium_fivver_note_app/components/components.dart';
import 'package:premium_fivver_note_app/shared/add_note_bloc/cubit.dart';
import 'package:premium_fivver_note_app/shared/add_note_bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNoteCubit, AddNotesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AddNoteCubit.get(context);

        return Visibility(
          visible:state is! LeadingGetNotes && state is! LeadingUpdateFavoriteField,
          replacement:  Lottie.asset('assets/leading_animation.json'),
          child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            if(cubit.notes.isNotEmpty)
              Expanded(
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                itemCount: cubit.notes.length,
                itemBuilder: (context, index) {
                  return optionNoteItem(
                      context, cubit.notes[index], index);
                },
                staggeredTileBuilder: (index) {
                  return index == 0
                      ? const StaggeredTile.count(
                      1, 1.0) //For Text
                      : const StaggeredTile.count(
                      1, 1.2); // others item
                },
              ),
            ),
            if(cubit.notes.isEmpty)
              ifNotesEmpty(),
          ],
        ),
        ),
        );
      },
    );
  }
}