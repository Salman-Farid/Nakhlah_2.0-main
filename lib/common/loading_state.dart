import 'package:flutter/material.dart';
class LoadingState extends StatelessWidget{const LoadingState({super.key,this.message='Loading...'});final String message;@override Widget build(BuildContext context)=>Center(child:Column(mainAxisSize:MainAxisSize.min,children:[const CircularProgressIndicator(),const SizedBox(height:12),Text(message)]));}
