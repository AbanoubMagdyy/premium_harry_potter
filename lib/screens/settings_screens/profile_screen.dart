import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:premium_fivver_note_app/components/components.dart';
import 'package:premium_fivver_note_app/layout/layout_screen.dart';
import 'package:premium_fivver_note_app/screens/background_image.dart';
import 'package:premium_fivver_note_app/shared/bloc/cubit.dart';
import 'package:premium_fivver_note_app/shared/bloc/states.dart';
import '../../components/constants.dart';
import '../../models/profile_lists_model.dart';
import '../../style/colors.dart';
import '../view_profile_list_screen.dart';

class ProfileScreen extends StatelessWidget {

  final double requiredWidth = 300;

   const ProfileScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: WillPopScope(
        onWillPop: () async{
          navigateTo(context, const LayoutScreen());
          return false;
        },
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double availableWidth = constraints.maxWidth;
              double radius = constraints.maxWidth / 13;
              return BackgroundImage(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// APPBAR

                        if(requiredWidth <= availableWidth)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: [
                              defAppBar(
                                context: context,
                                screenName: 'profile',
                              ),
                              const Spacer(),
                              BlocConsumer<NotesCubit,NotesStates>(
                                listener: (context,state){},
                                builder: (context,state){
                                  var cubit = NotesCubit.get(context);
                                  return InkWell(
                                    onTap: () {
                                    },
                                    child: Container(
                                      width: 110,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: defColor,
                                        borderRadius:
                                        BorderRadiusDirectional
                                            .circular(30),
                                      ),
                                      child:  Center(
                                        child: Text(
                                          '${totalSizeImagesInGB.toStringAsFixed(2)} / ${cubit.model.maximumSizeOfImagesInGB} GB',
                                          style: const TextStyle(
                                            color: secondColor,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),


                        /// name and bio and lists
                        BlocConsumer<NotesCubit,NotesStates>(
                          listener: (context,state){},
                          builder: (context,state){
                            var cubit = NotesCubit.get(context);
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      /// name
                                      Text(
                                        'my name is ${cubit.model.name}'.toUpperCase(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 20, fontWeight: FontWeight.bold),
                                      ),

                                      /// bio
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                                        child: Text(
                                          cubit.model.bio.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      /// lists
                                      Text(
                                        'and these are my favorite lists'.toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        /// LISTS
                          Expanded(
                            flex: 6,
                            child: StaggeredGridView.countBuilder(
                              crossAxisCount: requiredWidth + 280 > availableWidth ? 1 : 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 5,
                              itemCount: profileLists.length,
                              itemBuilder: (context, index) {
                                return listItem(profileLists[index],context,radius);
                              },
                              staggeredTileBuilder: (index) {
                                return const StaggeredTile.count(1,1); // others item
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }


  Widget listItem(ProfileListsModel model,context,radius)=> InkWell(
    onTap: (){
      navigateTo(context,ViewProfileListScreen(model));
    },
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        /// title
        Container(
          color: defColor.withOpacity(0.6),
          margin: const EdgeInsetsDirectional.only(top: 50),
          padding:
          const EdgeInsetsDirectional.only(top: 70),
          child: Center(
            child: Text(
              model.title.toUpperCase(),
              style: const TextStyle(
                color: secondColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
         /// image
         CircleAvatar(
          radius: radius,
          backgroundColor: defColor.withOpacity(0.6),
          child: CircleAvatar(
            radius: radius -5,
            backgroundImage: CachedNetworkImageProvider(model.image!),
          ),
        ),
      ],
    ),
  );
}
