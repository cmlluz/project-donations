/// Tradutor de erros do Firebase para português brasileiro
/// Foco em mensagens de erro voltadas para o usuário final
class FirebaseErrorTranslator {
  static const Map<String, String> _errorMessages = {
    // Erros de Autenticação - Firebase Auth
    'user-not-found':
        'Email não cadastrado. Verifique o email ou crie uma conta.',
    'wrong-password': 'Senha incorreta. Tente novamente.',
    'invalid-email': 'Email inválido. Verifique o formato do email.',
    'user-disabled':
        'Esta conta foi desabilitada. Entre em contato com o suporte.',
    'too-many-requests':
        'Muitas tentativas de login. Aguarde um momento e tente novamente.',
    'weak-password': 'Senha muito fraca. Use pelo menos 6 caracteres.',
    'email-already-in-use':
        'Este email já está sendo usado. Tente fazer login ou use outro email.',
    'invalid-credential':
        'Dados de login inválidos. Verifique seu email e senha.',
    'network-request-failed':
        'Sem conexão com a internet. Verifique sua conexão.',
    'requires-recent-login':
        'Por segurança, faça login novamente para continuar.',
    'user-token-expired': 'Sua sessão expirou. Faça login novamente.',
    'account-exists-with-different-credential':
        'Já existe uma conta com este email usando outro método de login.',

    // Erros de Validação de Dados
    'invalid-verification-code': 'Código de verificação inválido.',
    'missing-verification-code': 'Digite o código de verificação.',
    'expired-action-code': 'Código expirado. Solicite um novo código.',
    'invalid-action-code': 'Código inválido. Verifique e tente novamente.',

    // Erros de Firestore - Banco de Dados
    'permission-denied': 'Você não tem permissão para acessar este conteúdo.',
    'not-found': 'Informação não encontrada.',
    'unavailable': 'Serviço temporariamente indisponível. Tente novamente.',
    'deadline-exceeded': 'Operação demorou muito. Tente novamente.',
    'cancelled': 'Operação cancelada.',
    'unauthenticated': 'Você precisa estar logado para acessar este conteúdo.',
    'already-exists': 'Esta informação já existe.',

    // Erros de Storage - Upload de Arquivos
    'storage/object-not-found': 'Arquivo não encontrado.',
    'storage/quota-exceeded': 'Limite de armazenamento excedido.',
    'storage/unauthenticated':
        'Você precisa estar logado para enviar arquivos.',
    'storage/unauthorized': 'Você não tem permissão para enviar este arquivo.',
    'storage/canceled': 'Upload cancelado.',
    'storage/retry-limit-exceeded':
        'Muitas tentativas. Tente novamente mais tarde.',
    'storage/invalid-checksum': 'Arquivo corrompido. Tente enviar novamente.',
    'storage/server-file-wrong-size':
        'Erro no upload. Tente enviar o arquivo novamente.',

    // Erros Gerais
    'unknown': 'Erro inesperado. Tente novamente.',
    'internal-error': 'Erro interno do sistema. Tente novamente.',
    'invalid-argument': 'Dados inválidos fornecidos.',
    'operation-not-allowed': 'Operação não permitida.',
  };

  /// Traduz código de erro do Firebase para português
  static String translate(String errorCode) {
    // Remove prefixos comuns dos códigos de erro
    final cleanCode = errorCode
        .toLowerCase()
        .replaceAll('firebase_auth/', '')
        .replaceAll('firebase_core/', '')
        .replaceAll('firestore/', '')
        .replaceAll('storage/', '');

    return _errorMessages[cleanCode] ??
        _errorMessages[errorCode] ??
        'Ocorreu um erro inesperado. Tente novamente.';
  }

  /// Traduz exceção do Firebase para mensagem amigável ao usuário
  static String translateException(dynamic exception) {
    if (exception == null) return 'Erro inesperado. Tente novamente.';

    String errorMessage = exception.toString().toLowerCase();

    // Extrai e traduz códigos de erro mais comuns do Firebase Auth
    if (errorMessage.contains('user-not-found'))
      return translate('user-not-found');
    if (errorMessage.contains('wrong-password'))
      return translate('wrong-password');
    if (errorMessage.contains('invalid-email'))
      return translate('invalid-email');
    if (errorMessage.contains('email-already-in-use'))
      return translate('email-already-in-use');
    if (errorMessage.contains('weak-password'))
      return translate('weak-password');
    if (errorMessage.contains('too-many-requests'))
      return translate('too-many-requests');
    if (errorMessage.contains('network-request-failed'))
      return translate('network-request-failed');
    if (errorMessage.contains('invalid-credential'))
      return translate('invalid-credential');
    if (errorMessage.contains('user-disabled'))
      return translate('user-disabled');
    if (errorMessage.contains('requires-recent-login'))
      return translate('requires-recent-login');

    // Erros de Firestore
    if (errorMessage.contains('permission-denied'))
      return translate('permission-denied');
    if (errorMessage.contains('not-found')) return translate('not-found');
    if (errorMessage.contains('unauthenticated'))
      return translate('unauthenticated');
    if (errorMessage.contains('unavailable')) return translate('unavailable');
    if (errorMessage.contains('deadline-exceeded'))
      return translate('deadline-exceeded');

    // Erros de Storage
    if (errorMessage.contains('storage/') &&
        errorMessage.contains('quota-exceeded')) {
      return translate('storage/quota-exceeded');
    }
    if (errorMessage.contains('storage/') &&
        errorMessage.contains('unauthorized')) {
      return translate('storage/unauthorized');
    }
    if (errorMessage.contains('storage/') &&
        errorMessage.contains('object-not-found')) {
      return translate('storage/object-not-found');
    }

    // Mensagem genérica para erros não mapeados
    return 'Ocorreu um erro inesperado. Tente novamente.';
  }

  /// Validadores de formulário com mensagens em português

  /// Valida email
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email é obrigatório';
    }

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email.trim())) {
      return 'Digite um email válido';
    }

    return null;
  }

  /// Valida senha
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (password.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }

    return null;
  }

  /// Valida nome completo
  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Nome é obrigatório';
    }

    if (name.trim().length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }

    return null;
  }

  /// Valida campo obrigatório
  static String? validateRequired(String? value, [String fieldName = 'Campo']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  /// Valida confirmação de senha
  static String? validatePasswordConfirmation(
      String? password, String? confirmation) {
    if (confirmation == null || confirmation.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }

    if (password != confirmation) {
      return 'Senhas não coincidem';
    }

    return null;
  }
}
