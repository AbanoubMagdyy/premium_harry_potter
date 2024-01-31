import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:premium_fivver_note_app/components/components.dart';
import 'package:premium_fivver_note_app/screens/view_category_screen.dart';
import 'package:premium_fivver_note_app/style/colors.dart';
import '../../models/category_model.dart';
import '../../shared/add_note_bloc/cubit.dart';
import '../../shared/add_note_bloc/states.dart';

class CategoryScreen extends StatelessWidget {
  final double requiredWidth = 185;

  const CategoryScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AddNoteCubit, AddNotesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AddNoteCubit.get(context);
        final List<CategoryModel> categories = [
          CategoryModel(
            image: 'https://drive.google.com/uc?export=view&id=1GDaF511dMmkF69NAjKluTnq9v2VAFOI0',
            name: 'Harry Potter',
            numberOfItem: cubit.harryPotter.length
          ),
          CategoryModel(
            image: 'https://drive.google.com/uc?export=view&id=1jommcRhcLR0bCvhNePl3ewCzx4H-Psu9',
            name: 'Albus Dumbledore',
              numberOfItem: cubit.albusDumbledore.length
          ),
          CategoryModel(
            image: 'https://drive.google.com/uc?export=view&id=1soxx2vMHuoj-Sw31k_1yrIzaAmE3wdbs',
            name: 'Ginny Weasley',
              numberOfItem: cubit.ginnyWeasley.length
          ),
          CategoryModel(
            image: 'https://drive.google.com/uc?export=view&id=1p2Y2GougQiZQ6yUfd_qc8k04q-2givb-',
            name: 'Hermione Granger',
              numberOfItem: cubit.hermioneGranger.length
          ),
          CategoryModel(
            image: 'https://drive.google.com/uc?export=view&id=1VSL4P3dPaAoc04c5xADLitHb6j-EOAet',
            name: 'Lord Voldemort',
              numberOfItem: cubit.lordVoldemort.length
          ),
          CategoryModel(
            image: 'https://drive.google.com/uc?export=view&id=1f-55GlVI5Gzpe98m8gKY6ExbvjQfWDg5',
            name: 'Neville Longbottom',
              numberOfItem: cubit.nevilleLongbottom.length
          ),
          CategoryModel(
            image: 'https://drive.google.com/uc?export=view&id=1z4S_rdbsvAfdfWjZYG6p4Nf5xHBir24O',
            name: 'Ron Weasley',
              numberOfItem: cubit.ronWeasley.length
          ),
          CategoryModel(
            image: 'https://drive.google.com/uc?export=view&id=1EcqYm4MpFZzvvBMdCyEZnusa2uZ-2v9B',
            name: 'Rubeus Hagrid',
              numberOfItem: cubit.rubeusHagrid.length
          ),
          CategoryModel(
            image: 'https://drive.google.com/uc?export=view&id=1kb4oFhVTZpC-VkUoSaQVcI4rMuvM2mPu',
            name: 'Severus Snape',
              numberOfItem: cubit.severusSnape.length
          ),
          CategoryModel(
            image: 'https://drive.google.com/uc?export=view&id=1W6YDJSnONjjTNeK3np9Z_yx3dPgM9oYt',
            name: 'Sirius Black',
              numberOfItem: cubit.siriusBlack.length
          ),
        ];

        return  Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            itemCount: categories.length,
            itemBuilder: (context, index) =>categoryItem(categories[index],context),
            staggeredTileBuilder: (index) =>const StaggeredTile.count(
                1, 1)
          ),
        );
      },
    );
  }



  Widget categoryItem(CategoryModel model,context)=>InkWell(
    onTap: (){
      navigateTo(context,  ViewCategoryScreen(model: model,));
    },
    child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final screenSize = MediaQuery.of(context).size;
        final double fontSize = screenSize.width * 0.034;
        double radius = constraints.maxWidth / 5;
        return Container(
          color: defColor.withOpacity(0.6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// image
              CircleAvatar(
                radius: radius,
                backgroundImage: CachedNetworkImageProvider(model.image,),
              ),
              /// name
              Padding(
                padding: const EdgeInsets.symmetric(vertical:10),
                child: Text(model.name.toUpperCase(),style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: secondColor
                ),
                ),
              ),
              /// number
              Text('${model.numberOfItem} item',style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: secondColor
              ),
              ),
            ],
          ),
        );
      }
    ),
  );
}
