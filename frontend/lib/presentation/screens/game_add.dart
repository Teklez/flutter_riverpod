import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domain/game_model.dart';
import 'package:frontend/application/game/game_provider.dart';
import 'package:frontend/presentation/events/game_events.dart';

import 'package:go_router/go_router.dart';

class AddGameForm extends ConsumerStatefulWidget {
  final String buttonName;
  final Game? initialGame;

  const AddGameForm({Key? key, required this.buttonName, this.initialGame})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddGameFormState();
}

class _AddGameFormState extends ConsumerState<AddGameForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _imageUrlController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _publisherController;

  @override
  void initState() {
    super.initState();
    _imageUrlController =
        TextEditingController(text: widget.initialGame?.image ?? '');
    _nameController =
        TextEditingController(text: widget.initialGame?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialGame?.description ?? '');
    _publisherController =
        TextEditingController(text: widget.initialGame?.publisher ?? '');
  }

  String formatCurrentDate() {
    DateTime now = DateTime.now();
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    String month = months[now.month - 1];
    String day = now.day.toString();
    String year = now.year.toString();

    return "$month $day, $year";
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _publisherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.buttonName == 'Add' ? 'Add Game' : 'Edit Game'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50.0, left: 18.0, right: 18.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: "Image URL",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _publisherController,
                  decoration: const InputDecoration(
                    labelText: "Publisher",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a publisher';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('/admin');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                      child: const Text(
                        'Cancel',
                        style:
                            TextStyle(color: Color.fromARGB(255, 211, 63, 63)),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (_formKey.currentState!.validate()) {
                          _saveGame(context);
                        }
                      },
                      child: Text(
                        widget.buttonName,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 47, 211, 151)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveGame(BuildContext context) {
    final game = Game(
      id: widget.initialGame?.id ?? '',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      image: _imageUrlController.text.trim(),
      publisher: _publisherController.text.trim(),
      releaseDate: formatCurrentDate(),
    );

    final gameNotifier = ref.read(gameProvider.notifier);

    if (widget.buttonName == 'Add') {
      // Add new game
      gameNotifier.handleAddGame(AddGame(game));
    } else {
      // Edit existing game
      gameNotifier.handleEditGame(EditGame(game));
    }

    context.go('/admin');
  }
}
