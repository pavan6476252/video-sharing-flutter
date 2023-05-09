import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final replyTextControllerProvider =
    StateProvider<TextEditingController>((ref) => TextEditingController());
