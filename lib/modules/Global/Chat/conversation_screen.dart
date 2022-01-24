import 'package:flutter/material.dart';
import 'package:mostaqbal_masr/modules/Global/Chat/input_field_widget.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) =>
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(color: Colors.teal,),
                        ),
                  ),
                ),
              ),
              InputFieldWidget(),
            ],
          ),
    );
  }
}
