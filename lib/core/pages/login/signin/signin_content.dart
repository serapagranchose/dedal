import 'package:dedal/components/button/custom_button.dart';
import 'package:dedal/components/text_fields/main_text_field.dart';
import 'package:dedal/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SigninContent extends StatefulWidget {
  const SigninContent({
    required this.validate,
    this.isError,
    super.key,
  });

  final void Function(String email, String password) validate;
  final bool? isError;

  @override
  SigninContentyState createState() => SigninContentyState();
}

class SigninContentyState extends State<SigninContent> {
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    child: const Icon(Icons.close_rounded),
                    onTap: () => context.pop()),
              ),
            ],
          ),
          MainTextFields(
            title: 'Votre Email',
            placeholder: 'exemple@test.idk',
            onChanged: (String value) => setState(() {
              _email = value;
            }),
            border: widget.isError ?? false ? Colors.red.shade900 : null,
          ),
          Column(
            children: [
              MainTextFields(
                title: 'Votre mot de passe',
                onChanged: (String value) => setState(() {
                  _password = value;
                }),
                border: widget.isError ?? false
                    ? Colors.red.shade900
                    : SharedColorPalette().main,
              ),
              if (widget.isError ?? false)
                Text(
                  'Email ou mot de passe incorrect',
                  style: TextStyle(color: Colors.red.shade900),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomStringButton(
              context: context,
              disabled: !(RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(_email) &&
                  RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])(?=.{8,})+")
                      .hasMatch(_password)),
              onTap: (c) async => widget.validate.call(_email, _password),
              text: 'Connexion',
            ),
          ),
        ],
      );
}
