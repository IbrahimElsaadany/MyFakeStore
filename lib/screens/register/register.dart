import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "cubit/cubit.dart";
import "cubit/states.dart";
import "../shop/shop.dart";
import "../../../shared/components.dart";
import "../../../network/local/cache_helper.dart";
class Register extends StatelessWidget{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController(),
    _emailController = TextEditingController(), _phoneController = TextEditingController(),
    _passwordController = TextEditingController();
  Register({super.key});
  @override
  Scaffold build(final BuildContext context)
  =>Scaffold(
    appBar:AppBar(),
    body:Padding(
      padding: const EdgeInsets.symmetric(horizontal:20.0),
      child: Form(
        key:_formKey,
        child: Center(
          child: SingleChildScrollView(
            physics:const BouncingScrollPhysics(),
            child: BlocProvider<RegisterCubit>(
              create:(final BuildContext context)=>RegisterCubit(),
              child: Column(
                mainAxisAlignment:MainAxisAlignment.center,
                crossAxisAlignment:CrossAxisAlignment.start,
                children:<Widget>[
                  Text(
                    "Register",
                    style:Theme.of(context).textTheme.headlineLarge
                  ),
                  Text(
                    "ٌDidn't register yet?\nHurry up to browse our fake offers!",
                    style:Theme.of(context).textTheme.displaySmall
                  ),
                  const SizedBox(height:30.0),
                  TextFormField(
                    controller:_nameController,
                    keyboardType:TextInputType.name,
                    decoration:InputDecoration(
                      labelText:"Name",
                      prefixIcon:const Icon(Icons.person_outlined),
                      border:OutlineInputBorder(
                        borderRadius:BorderRadius.circular(20.0),
                      )
                    ),
                    validator:(String? val){
                      if(val!.isEmpty) return "Name can't be empty.";
                      else if(RegExp(r"[0-9A-Za-z ]+").hasMatch(val))
                        return val[0]==' '?"Name can't start with space.":null;
                      return "Name can consist only of alphabetics, numbers and spaces.";
                    }
                  ),
                  const SizedBox(height:15.0),
                  TextFormField(
                    controller:_emailController,
                    keyboardType:TextInputType.emailAddress,
                    decoration:InputDecoration(
                      labelText:"Email",
                      prefixIcon:const Icon(Icons.email_outlined),
                      border:OutlineInputBorder(
                        borderRadius:BorderRadius.circular(20.0),
                      )
                    ),
                    validator:(String? val){
                      if(val!.isEmpty) return "Email can't be empty.";
                      else if(RegExp(r"[0-9A-z.]+@[A-Za-z]+\.[A-Za-z]+").hasMatch(val)) return null;
                      return "Not valid email.";
                    }
                  ),
                  const SizedBox(height:15.0),
                  TextFormField(
                    controller:_phoneController,
                    keyboardType:TextInputType.phone,
                    decoration:InputDecoration(
                      labelText:"Phone",
                      prefixIcon:const Icon(Icons.phone_outlined),
                      border:OutlineInputBorder(
                        borderRadius:BorderRadius.circular(20.0),
                      )
                    ),
                    validator:(String? val){
                      if(val!.isEmpty) return "Phone number can't be empty.";
                      else if(RegExp(r"^\+?\d{3,}$").hasMatch(val)) return null;
                      return "Not valid phone number.";
                    }
                  ),
                  const SizedBox(height:15.0),
                  BlocBuilder<RegisterCubit,RegisterStates>(
                    builder:(final BuildContext context,final RegisterStates state){
                      final RegisterCubit cubit = BlocProvider.of<RegisterCubit>(context);
                      return TextFormField(
                        controller:_passwordController,
                        keyboardType:TextInputType.visiblePassword,
                        obscureText:cubit.isObscure,
                        decoration:InputDecoration(
                          labelText:"Password",
                          prefixIcon:const Icon(Icons.lock_outline),
                          suffixIcon:IconButton(
                            icon:Icon(cubit.isObscure?Icons.visibility_outlined:Icons.visibility_off_outlined),
                            onPressed:()=>cubit.changeVisibility()
                          ),
                          border:OutlineInputBorder(
                            borderRadius:BorderRadius.circular(20.0),
                          ),
                        ),
                        validator:(String? val)=>val!.length<5?"Password must be of 6 characters or more.":null
                      );
                    }
                  ),
                  const SizedBox(height:15.0),
                  BlocConsumer<RegisterCubit,RegisterStates>(
                    listener:(final BuildContext context,final RegisterStates state){
                      if(state is RegisterSuccessState){
                        showToast(status:state.status,message:state.message);
                        if(state.token!=null){
                          CacheHelper.prefs.setString("token",token=state.token!);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder:(final BuildContext context)=>const Shop()
                            ),
                            (Route<dynamic> route)=>false
                          );
                        }
                      }
                      else if(state is RegisterErrorState)
                        showToast(message:"Check your internet connection!");
                    },
                    buildWhen:(final RegisterStates previous,final RegisterStates current)
                    =>current is! RegisterChangeVisibilityState,
                    builder: (final BuildContext context,final RegisterStates state)
                    =>state is RegisterLoadingState? const Center(child:CircularProgressIndicator()):
                    ElevatedButton(
                        style:ElevatedButton.styleFrom(
                          minimumSize:const Size(double.infinity,40.0)
                        ),
                        child:const Text("REGISTER"),
                        onPressed:(){
                          if(_formKey.currentState!.validate()){
                            FocusManager.instance.primaryFocus?.unfocus();
                            BlocProvider.of<RegisterCubit>(context).register(
                              name:_nameController.text,
                              email:_emailController.text,
                              phone:_phoneController.text,
                              password:_passwordController.text
                            );
                          }
                        }
                      )
                  ),
                ]
              ),
            ),
          ),
        ),
      ),
    )
  );
}