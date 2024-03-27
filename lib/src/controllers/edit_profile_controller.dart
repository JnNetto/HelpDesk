import 'package:flutter/material.dart';
import 'package:help_desk/src/repository/edit_profile_repository.dart';

class EditProfileController extends ChangeNotifier {
  final TextEditingController _nameController = TextEditingController();
  EditProfileRepository editProfileRepository = EditProfileRepository();
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Widget editName(BuildContext context) {
    return AlertDialog(
      title: const Text('Alterar Nome'),
      content: TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          hintText: 'Digite um novo nome',
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            String newName = _nameController.text;
            editProfileRepository.editName(newName);
            Navigator.of(context).pop();
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
