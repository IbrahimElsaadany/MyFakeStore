import "package:flutter/material.dart";
import "../cubit/cubit.dart";
import "../cubit/states.dart";
List<Widget> buildSettings(
  final BuildContext context,
  {
    required final ShopCubit cubit,
    required final ShopStates state,
  }
){
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController(text:cubit.profileModel!.name),
    emailController = TextEditingController(text:cubit.profileModel!.email),
    phoneController = TextEditingController(text:cubit.profileModel!.phone);
  return <Widget>[
    Container(
      height:200.0,
      decoration:BoxDecoration(
        gradient:LinearGradient(
          begin:Alignment.topCenter,
          end:Alignment.bottomCenter,
          stops:const [0.5,0.5],
          colors:<Color>[
            Theme.of(context).primaryColorLight,
            Theme.of(context).canvasColor
          ]
        )
      ),
      alignment:Alignment.center,
      child: CircleAvatar(
        backgroundColor: Colors.deepOrange,
        radius:60.0,
        child: Text(
          cubit.profileModel!.name[0],
          style:const TextStyle(
            color:Colors.white,
            fontSize:45.0
          )
        )
      ),
    ),
    Form(
      key:formKey,
      child: SingleChildScrollView(
        physics:const BouncingScrollPhysics(),
        padding:const EdgeInsets.symmetric(horizontal:20.0),
        child: Center(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment:CrossAxisAlignment.start,
            children:<Widget>[
              TextFormField(
                controller:nameController,
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
              const SizedBox(height:20.0),
              TextFormField(
                controller:emailController,
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
              const SizedBox(height:20.0),
              TextFormField(
                controller:phoneController,
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
              const SizedBox(height:20.0),
              state is ShopUpdatingProfileState? const Center(child:CircularProgressIndicator()):
              ElevatedButton(
                  style:ElevatedButton.styleFrom(
                    minimumSize:const Size(double.infinity,40.0)
                  ),
                  child:const Text("Update"),
                  onPressed:(){
                    if(formKey.currentState!.validate())
                      cubit.updateProfile(
                      name:nameController.text,
                      email:emailController.text,
                      phone:phoneController.text,
                    );
                  }
                ),
            ]
          ),
        ),
      ),
    )
  ];
}