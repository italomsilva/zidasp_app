class CpfValidator {
  static bool isValid(String? cpf) {
    if (cpf == null || cpf.isEmpty) {
      return false;
    }

    // Removendo formatação
    String numbers = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbers.length != 11) {
      return false;
    }

    // Verificando se todos os dígitos são iguais (ex: 111.111.111-11)
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) {
      return false;
    }

    // Validação do primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(numbers[i]) * (10 - i);
    }
    int digit1 = 11 - (sum % 11);
    if (digit1 >= 10) digit1 = 0;

    if (int.parse(numbers[9]) != digit1) {
      return false;
    }

    // Validação do segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(numbers[i]) * (11 - i);
    }
    int digit2 = 11 - (sum % 11);
    if (digit2 >= 10) digit2 = 0;

    if (int.parse(numbers[10]) != digit2) {
      return false;
    }

    return true;
  }
}
