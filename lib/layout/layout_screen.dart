import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:premium_fivver_note_app/screens/background_image.dart';
import 'package:premium_fivver_note_app/screens/search_screen.dart';
import 'package:premium_fivver_note_app/shared/bloc/cubit.dart';
import 'package:premium_fivver_note_app/shared/bloc/states.dart';
import 'package:premium_fivver_note_app/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/components.dart';
import '../screens/bottom_navigation_bar_screens/add_note_screen.dart';
import '../screens/settings_screens/edit_screen.dart';

class LayoutScreen extends StatelessWidget {
  final double requiredWidth = 280;


  const LayoutScreen({super.key});

  @override

  @override
  Widget build(BuildContext context) {
    var hour = DateTime.now().hour;
    String greeting = "";
    if (hour < 12 && hour > 6) {
      greeting = "Good Morning";
    } else if (hour > 12 && hour < 18) {
      greeting = "Good Afternoon";
    } else if (hour > 18 && hour < 24) {
      greeting = "Good Evening";
    } else {
      greeting = "Good Night";
    }
    return BlocConsumer<NotesCubit, NotesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = NotesCubit.get(context);
        final pageController = PageController(initialPage: cubit.currantIndex);
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: secondColor,
            onPressed: () {
              navigateTo(context, AddNoteScreen());
            },
            child: const Icon(
              Icons.add,
            ),
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
            backgroundColor: defColor,
            inactiveColor: secondColor,
            activeColor: Colors.white,
            shadow: const Shadow(blurRadius: 10),
            gapLocation: GapLocation.center,
            onTap: (int index) {
              cubit.changeBNB(index);
              if (pageController.hasClients) {
                pageController.animateToPage(cubit.currantIndex,
                    duration: const Duration(milliseconds: 1),
                    curve: Curves.ease);
              }
            },
            activeIndex: cubit.currantIndex,
            icons: const [
              Icons.home_outlined,
              Icons.cake_outlined,
              Icons.category_outlined,
              Icons.settings
            ],
          ),
          body: WillPopScope(
            onWillPop: () async {
              SystemNavigator.pop();
              return false;
            },
            child: BlocConsumer<NotesCubit, NotesStates>(
              listener: (context, state) {},
              builder : (context, state) {
                var cubit = NotesCubit.get(context);
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double availableWidth = constraints.maxWidth;
                    return BackgroundImage(
                      child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                /// appbar
                                if(requiredWidth <= availableWidth)
                                SizedBox(
                                  height: 65,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      /// text
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                      2 -
                                                      80,
                                                ),
                                                child: Text(
                                                  'Hi ,${cubit.model.name.toUpperCase().split(' ')[0]}',
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 22,
                                                      height: 1.14),
                                                ),
                                              ),
                                              const Text(
                                                '👋',
                                                style: TextStyle(
                                                    fontSize: 23, height: 1.14),
                                              )
                                            ],
                                          ),
                                          Text(
                                            greeting,
                                            style: const TextStyle(
                                                fontSize: 23, height: 1.14),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),

                                      /// item
                                      if(cubit.model.profile != 'profile' && cubit.model.name != 'Harry' )
                                        InkWell(
                                          onTap: () {
                                            navigateTo(
                                                context, EditScreen());
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: defColor,
                                                  borderRadius:
                                                  BorderRadiusDirectional
                                                      .circular(30),
                                                ),
                                                child: Row(
                                                  children: [
                                                    /// text
                                                    Container(
                                                      margin:
                                                      const EdgeInsetsDirectional
                                                          .symmetric(
                                                          horizontal: 10),
                                                      constraints: BoxConstraints(
                                                        maxWidth:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                            2 -
                                                            110,
                                                      ),
                                                      child: Text(
                                                        NotesCubit.get(context)
                                                            .model
                                                            .name
                                                            .toUpperCase()
                                                            .split(' ')[0],
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          color: secondColor,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),

                                                    ///image
                                                    CircleAvatar(
                                                      backgroundImage:
                                                      CachedNetworkImageProvider(cubit
                                                          .model.profile),
                                                      radius: 21,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      /// search
                                      defIconButton(
                                        onTap: () {
                                          navigateTo(
                                            context,
                                            SearchScreen(),
                                          );
                                        },
                                        icon: Icons.search,
                                      ),
                                    ],
                                  ),
                                ),
                                /// body
                                Expanded(
                                  child: PageView(
                                    controller: pageController,
                                    children: cubit.screens,
                                    onPageChanged: (int index) {
                                      cubit.changeBNB(index);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}








