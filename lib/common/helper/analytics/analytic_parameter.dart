class ParameterConstants {
  ParameterConstants._();

  static const String separator = ',';
  static const maxLengthParameter = 500;

  static const String obscureText = 'obscure_text';
  static const String userId = 'user_id';
}

abstract class AnalyticParameter {
  Map<String, Object> get parameters;
}

class ObscureTextParameter extends AnalyticParameter {
  ObscureTextParameter({
    required this.obscureText,
  });

  final bool obscureText;

  @override
  Map<String, Object> get parameters => {
        ParameterConstants.obscureText: obscureText.toString(),
      };
}
