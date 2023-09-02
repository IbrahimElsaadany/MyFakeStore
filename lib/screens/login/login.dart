import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../shared/components.dart";
import "../../network/local/cache_helper.dart";
import "../register/register.dart";
import "../shop/shop.dart";
import "cubit/states.dart";
import "cubit/cubit.dart";
class Login extends StatelessWidget{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(),
                              _passwordController = TextEditingController();
  Login({super.key});
  @override
  BlocProvider build(final BuildContext context)
  =>BlocProvider<LoginCubit>(
    create:(final BuildContext context)=>LoginCubit(),
    child: Scaffold(
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal:20.0),
        child: Form(
          key:_formKey,
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment:CrossAxisAlignment.start,
            children:<Widget>[
              Text(
                "Login",
                style:Theme.of(context).textTheme.headlineLarge
              ),
              Text(
                "Login now to browse our fake offers!",
                style:Theme.of(context).textTheme.displaySmall
              ),
              const SizedBox(height:30.0),
              TextFormField(
                controller:_emailController,
                keyboardType:TextInputType.emailAddress,
                decoration:InputDecoration(
                  labelText:"ُEmail",
                  prefixIcon:const Icon(Icons.email_outlined),
                  border:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(20.0),
                  )
                ),
                validator:(String? val){
                  if(val!.isEmpty) return "Email can't be empty.";
                  else if(RegExp(r"[A-z0-9.]+@[A-Za-z]+\.[A-Za-z]+").hasMatch(val)) return null;
                  return "Not valid email.";
                }
              ),
              const SizedBox(height:15.0),
              BlocBuilder<LoginCubit,LoginStates>(
                builder:(final BuildContext context,final LoginStates state){
                  final LoginCubit cubit = BlocProvider.of<LoginCubit>(context);
                  return TextFormField(
                    controller:_passwordController,
                    keyboardType:TextInputType.visiblePassword,
                    obscureText:cubit.isObscure,
                    validator:(String? val)=>val!.length<5?"Password must be of 6 characters or more.":null,
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
                  );
                }
              ),
              const SizedBox(height:15.0),
              BlocConsumer<LoginCubit,LoginStates>(
                listener:(final BuildContext context,final LoginStates state){
                  if(state is LoginSuccessState){
                    showToast(status:state.status,message:state.message);
                    if(state.token!=null){
                      CacheHelper.prefs.setString("token",token=state.token!);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:(final BuildContext context)=>const Shop()
                        )
                      );
                    }
                  }
                  else if(state is LoginErrorState)
                    showToast(message:state.message);
                },
                buildWhen:(final LoginStates previous, final LoginStates current)
                =>current is! LoginChangeVisibilityState,
                builder: (final BuildContext context,final LoginStates state)
                =>state is LoginLoadingState? const Center(child:CircularProgressIndicator()):
                ElevatedButton(
                  style:ElevatedButton.styleFrom(
                    minimumSize:const Size(double.infinity,40.0)
                  ),
                  child:const Text("LOGIN"),
                  onPressed:(){
                    if(_formKey.currentState!.validate()){
                      FocusManager.instance.primaryFocus?.unfocus();
                      BlocProvider.of<LoginCubit>(context).login(
                      email:_emailController.text,
                      password:_passwordController.text
                      );
                    }
                  }
                )
              ),
              Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children:<Widget>[
                  const Text("Don't have an account?"),
                  TextButton(
                    child:const Text("Register now!"),
                    onPressed:()=>Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:(final BuildContext context)=>Register()
                      )
                    )
                  )
                ]
              )
            ]
          ),
        ),
      )
    ),
  );
}