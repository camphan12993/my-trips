import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateTripController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
}
