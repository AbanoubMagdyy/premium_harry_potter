import 'package:premium_fivver_note_app/components/components.dart';
import 'package:premium_fivver_note_app/layout/layout_screen.dart';
import 'package:premium_fivver_note_app/screens/first_screens/signin_screen.dart';
import 'package:premium_fivver_note_app/shared/register_bloc/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/constants.dart';
import '../../shared/register_bloc/states.dart';
import '../../shared/shared_preferences.dart';
import '../../style/colors.dart';
import '../background_image.dart';
import 'on_boarding_screen.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController name = TextEditingController();
  final TextEditingController birthday = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController code = TextEditingController();
  final gmail = RegExp(r"^[\w\.-]+@gmail\.com$");
  final yahoo = RegExp(r"^[\w\.-]+@yahoo\.com$");
  final outlook = RegExp(r"^[\w\.-]+@outlook\.com$");
  RegisterScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return BlocProvider<RegisterCubit>(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if(state is SuccessCreateProfileLists){
            navigateAndFinish(
              context,
              const LayoutScreen(),
            );
          }
        },
        builder: (context, state) {
          RegisterCubit cubit = RegisterCubit.get(context);
          var profileImage = cubit.profileImage;
          String month = cubit.date.month.toString();
          String day = cubit.date.day.toString();
          if (cubit.date.month < 10) {
            month = '0${cubit.date.month}';
          }
          if (cubit.date.day < 10) {
            day = '0${cubit.date.day}';
          }

          if (cubit.putDate) {
            birthday.text = "${cubit.date.year.toString()}-$month-$day";
          }
          return Scaffold(
            body: WillPopScope(
              onWillPop: () async {
                navigateTo(context,const OnBoardingScreen());
                return false;
              },
              child: BackgroundImage(
                sigma: 8,
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              ///text
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Let\'s get to know you \nEnter your details to continue',
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),

                              ///image
                              if (state is! LeadingUploadProfile)
                                Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 25),
                                      child: InkWell(
                                        onTap: () {
                                          cubit.getImageFromGallery();
                                        },
                                        child: CircleAvatar(
                                          radius: 110,
                                          backgroundColor: secondColor,
                                          child: CircleAvatar(
                                            radius: 100,
                                            backgroundImage: profileImage == null
                                                ? const AssetImage(
                                                    'assets/images/harry_potter.webp',
                                                  )
                                                : FileImage(profileImage)
                                                    as ImageProvider,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: secondColor,
                                        child: IconButton(
                                          onPressed: () {
                                            cubit.getImageFromGallery();
                                          },
                                          icon: const Icon(
                                            Icons.photo,
                                            size: 30,
                                            color: defColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (state is LeadingUploadProfile)
                                Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 25),
                                      child: CircleAvatar(
                                        radius: 100,
                                        backgroundImage: profileImage == null
                                            ? const AssetImage(
                                                'assets/images/harry_potter.webp',
                                              )
                                            : FileImage(profileImage)
                                                as ImageProvider,
                                      ),
                                    ),
                                   defCircularProgress()
                                  ],
                                ),

                              ///name
                              defTextField(
                                controller: name,
                                rightIcon: Icons.person_outline,
                                text: 'name',
                              ),

                              ///birthday
                              defTextField(
                                hideKeyboard: true,
                                onTap: () {
                                  cubit.showTheDate(context: context);
                                },
                                fontSize: 20,
                                controller: birthday,
                                rightIcon: Icons.cake_outlined,
                                text: 'birthday',
                              ),

                              /// email
                              defTextField(
                                  controller: emailController,
                                  rightIcon: Icons.email_outlined,
                                  text: 'email',
                                  keyboard: TextInputType.emailAddress,
                              ),

                              /// password
                              defTextField(
                                controller: password,
                                rightIcon: Icons.lock_outline,
                                leftIcon: cubit.hidePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                text: 'password',
                                hideInput: cubit.hidePassword,
                                leftIconOnPressed: () {
                                  cubit.changeIcon();
                                },
                              ),

                              /// CODE
                              defTextField(
                                controller: code,
                                rightIcon: Icons.code_outlined,
                                text: 'code',
                              ),

                              if (state is LeadingRegister  || state is LeadingCheckTheCode || state is LeadingFetchEmail)
                                defTextButton(
                                  uploadData: true,
                                ),
                              if (state is! LeadingRegister  && state is! LeadingCheckTheCode && state is! LeadingFetchEmail)
                                defTextButton(
                                  uploadData: false,
                                  text: 'START',
                                  onTap: () async {
                                 toast(msg: 'Please wait', isError: false);
                                    if (profileImage == null) {
                                      toast(msg: 'Please choose any photo', isError: false);
                                    } else if (formKey.currentState!.validate() &&
                                        password.text.length > 8) {
                                      if (gmail.hasMatch(emailController.text) ||
                                          yahoo.hasMatch(emailController.text) ||
                                          outlook.hasMatch(emailController.text)) {
                                          var imageSize = calculateTotalFileSizeInGB(cubit.profileImage,false);
                                          if(imageSize <= maximumSizeImagesInGB){
                                         await  checkInternetConnectivity();
                                            if (isConnect) {
                                              var checkEmail =
                                              checkEmailAvailability(emailController.text);
                                              if (await checkEmail) {
                                               await wait();
                                                bool checkTheCode =  await cubit.checkTheCode(code.text,emailController.text);
                                                if(checkTheCode){
                                                  await wait();
                                                  cubit
                                                      .uploadProfileImage(
                                                      email: emailController.text)
                                                      .then(
                                                        (value) async {
                                                          await wait();
                                                          calculateTotalFileSizeInGB(cubit.profileImage,true);
                                                      cubit
                                                          .userRegister(
                                                        email: emailController.text,
                                                        password: password.text,
                                                        name: name.text,
                                                        birthday: birthday.text,
                                                        code: code.text,
                                                      )
                                                          .then(
                                                            (value)  {
                                                              Shared.saveDate(key: 'email', value: emailController.text)?.then((value)  async {
                                                            email = Shared.getDate('email');
                                                            cubit.createProfileLists(emailController.text);
                                                          },
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                }else{
                                                  toast(msg: 'The code entered is incorrect or has already been used', isError: true,);
                                                }
                                              } else {
                                                toast(
                                                  msg:
                                                  'This email has already been used',
                                                  isError: false,);
                                              }
                                            } else {
                                              toast(
                                                msg: 'Please check the Internet',
                                                isError: true,);
                                            }
                                          }else{
                                            toast(
                                              msg: 'The size of the selected images is larger than the specified size. Please choose a smaller size image',
                                              isError: true,);
                                          }



                                      } else {
                                        toast(msg: 'Please check the entered email. We only accept Gmail, Yahoo or Outlook', isError: false,);
                                      }
                                    } else if (password.text.length <= 8) {
                                    toast(msg: 'Password must be more than 8 digits', isError: false);
                                    }
                                  },
                                ),

                              TextButton(
                                onPressed: () {
                                  navigateTo(context, SigninScreen(false));
                                },
                                child: Text(
                                  'Already have an account ?'.toUpperCase(),
                                  style: const TextStyle(
                                      color: defColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
