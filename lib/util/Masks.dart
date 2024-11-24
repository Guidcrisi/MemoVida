import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Masks {
  static var horaFormatter = MaskTextInputFormatter(
    mask: '##:##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
}
