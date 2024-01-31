import 'package:premium_fivver_note_app/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:premium_fivver_note_app/layout/layout_screen.dart';
import 'package:premium_fivver_note_app/screens/first_screens/register_screen.dart';
import 'package:premium_fivver_note_app/shared/signin_bloc/cubit.dart';
import 'package:premium_fivver_note_app/shared/signin_bloc/states.dart';
import '../../components/constants.dart';
import '../../shared/shared_preferences.dart';
import '../../style/colors.dart';
import '../background_image.dart';
import 'on_boarding_screen.dart';

class SigninScreen extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController resetEmail = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController code = TextEditingController();
  final gmail = RegExp(r"^[\w\.-]+@gmail\.com$");
  final yahoo = RegExp(r"^[\w\.-]+@yahoo\.com$");
  final outlook = RegExp(r"^[\w\.-]+@outlook\.com$");
  final bool cameFromSettings;

  SigninScreen(this.cameFromSettings,{Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => SignInCubit(),
      child: BlocConsumer<SignInCubit, SignInStates>(
        listener: (context, state) async {
          if (state is ErrorSignIn) {
            toast(msg: 'The password or email is wrong', isError: true,);
          }
          if(state is SuccessSignIn){
            bool checkTheNumberCode =  await SignInCubit.get(context).checkTheNumberCode(code.text,emailController.text);
            if(checkTheNumberCode){
              Shared.saveDate(key: 'email', value: emailController.text)?.then((value) {
                email = Shared.getDate('email');
                navigateAndFinish(context, const LayoutScreen());
              });
            }else{
              toast(msg: 'The code is incorrect or the maximum number of logins has been used', isError: true,);
            }
          }
        },
        builder: (context, state) {
          SignInCubit cubit = SignInCubit.get(context);
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: WillPopScope(
              onWillPop: () async {
                navigateTo(context,const OnBoardingScreen());
                return false;
              },
              child: BackgroundImage(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
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
                                'Enter your details to continue',
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                            ),

                            /// email
                            defTextField(
                              controller: emailController,
                              rightIcon: Icons.email_outlined,
                              text: 'Email',
                              keyboard: TextInputType.emailAddress,
                            ),

                            /// PASSWORD
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

                            /// forget password text
                            Align(
                              alignment: Alignment.topRight,
                              child: MaterialButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor: secondColor,
                                      builder: (context){
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          defTextField(
                                            controller: resetEmail,
                                            rightIcon: Icons.email_outlined,
                                            text: 'enter your email',
                                            keyboard: TextInputType.emailAddress,
                                          ),
                                          defTextButton(uploadData: false,
                                              text: 'Reset Your Password',
                                          onTap: () async{
                                           checkInternetConnectivity();
                                            var checkEmail = checkEmailAvailability(resetEmail.text);

                                            if(resetEmail.text.isNotEmpty){
                                              if (gmail.hasMatch(resetEmail.text) ||
                                                  yahoo.hasMatch(resetEmail.text) ||
                                                  outlook.hasMatch(resetEmail.text)){
                                                if(isConnect){
                                                  if(!await checkEmail){
                                                    cubit.resetPassword(resetEmail.text).then((value) {
                                                      toast(msg: 'Check your email', isError: false,);
                                                    },
                                                    );
                                                  }else{
                                                    toast(msg: 'Check that the email is spelled correctly', isError: true,);
                                                  }
                                                }else{
                                                  toast(msg: 'Please check the Internet', isError: true);
                                                }
                                              } else{
                                                toast(msg: 'Please check the entered email. We only accept Gmail, Yahoo or Outlook', isError: false,);
                                              }
                                            }
                                          }
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  );
                                },
                                child: const Text(
                                  'Forget Your Password ?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 17,),
                                ),
                              ),
                            ),


                            if (state is LeadingSignIn || state is LeadingCheckTheNumberCode)
                              defTextButton(
                                uploadData: true,
                              ),

                            if (state is! LeadingSignIn && state is! LeadingCheckTheNumberCode)
                              defTextButton(
                                text: 'START',
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    toast(msg: 'Please wait', isError: false);
                                 await checkInternetConnectivity();
                                    if (isConnect) {
                                          cubit.userLogin(
                                            email: emailController.text,
                                            password: password.text,
                                          );
                                    } else {
                                      toast(msg: 'Please check the Internet', isError: true);
                                    }
                                  }
                                },
                                uploadData: false,
                              ),

                            TextButton(
                              onPressed: () {
                                navigateTo(
                                  context,
                                  RegisterScreen(),
                                );
                              },
                              child: Text(
                                'Don\'t have an account ?'.toUpperCase(),
                                style: const TextStyle(
                                  color: defColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
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
          );
        },
      ),
    );
  }
}
