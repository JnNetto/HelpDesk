class NewUser {
  String? _nome;
  String? _email;
  String? _senha;

  NewUser();

  get nome => _nome;

  set nome(value) => _nome = value;

  get email => _email;

  set email(value) => _email = value;

  get senha => _senha;

  set senha(value) => _senha = value;
}
