import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Domain/game_model.dart';

final gameFormProvider = ChangeNotifierProvider((ref) => GameFormNotifier());

class GameFormNotifier extends ChangeNotifier {
  late String _name;
  late String _publisher;
  late String _releaseDate;

  String get name => _name;
  String get publisher => _publisher;
  String get releaseDate => _releaseDate;

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setPublisher(String value) {
    _publisher = value;
    notifyListeners();
  }

  void setReleaseDate(String value) {
    _releaseDate = value;
    notifyListeners();
  }

  void submit() {
    // Submit form data to backend
  }
}

class AddGameForm extends StatelessWidget {
  const AddGameForm({Key? key, required this.buttonName, this.initialGame})
      : super(key: key);

  final String buttonName;
  final Game? initialGame;

  @override
  Widget build(BuildContext context) {
    final gameForm = context.read(gameFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              initialValue: initialGame?.name ?? '',
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: gameForm.setName,
            ),
            TextFormField(
              initialValue: initialGame?.publisher ?? '',
              decoration: InputDecoration(labelText: 'Publisher'),
              onChanged: gameForm.setPublisher,
            ),
            TextFormField(
              initialValue: initialGame?.releaseDate ?? '',
              decoration: InputDecoration(labelText: 'Release Date'),
              onChanged: gameForm.setReleaseDate,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                gameForm.submit();
              },
              child: Text(buttonName),
            ),
          ],
        ),
      ),
    );
  }
}
