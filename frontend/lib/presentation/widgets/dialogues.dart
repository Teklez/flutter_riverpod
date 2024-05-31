import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/auth/auth_provider.dart';
import 'package:frontend/application/game/game_provider.dart';
import 'package:frontend/application/review/review_provider.dart';
import 'package:frontend/application/user/users_provider.dart';

import 'package:frontend/domain/users_model.dart';
import 'package:frontend/presentation/events/auth_event.dart';
import 'package:frontend/presentation/events/game_events.dart';
import 'package:frontend/presentation/events/users_event.dart';
import 'package:frontend/presentation/screens/game_add.dart';
import 'package:frontend/presentation/screens/review_edit.dart';

import 'package:frontend/presentation/events/review_event.dart';

import 'package:go_router/go_router.dart';

// EDIT DELETE DIALOGUE
class EditDeleteDialogue extends ConsumerWidget {
  final String route;
  final dynamic data;
  final String feature;

  const EditDeleteDialogue(
      {super.key,
      required this.route,
      required this.data,
      required this.feature});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.edit),
              Text("EDIT"),
            ],
          ),
          onTap: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (feature == 'game') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddGameForm(buttonName: 'Edit', initialGame: data),
                  ),
                );
              } else if (feature == 'review') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewEdit(review: data),
                  ),
                );
              }
            });
          },
        ),
        PopupMenuItem(
          value: 2,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.delete, color: Colors.redAccent),
              Text("DELETE"),
            ],
          ),
          onTap: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) => AreYouSureDialogue(
                  data: data,
                  feature: feature,
                ),
              );
            });
          },
        ),
      ],
    );
  }
}

// BLOCK ROLE
class BlockRole extends ConsumerWidget {
  final User user;
  const BlockRole({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(Icons.block),
              Text(user.status == 'unblocked' ? "BLOCK" : "UNBLOCK"),
            ],
          ),
          onTap: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) {
                  return AreYouSureDialogue(data: user, feature: 'userstatus');
                },
              );
            });
          },
        ),
        PopupMenuItem(
          value: 2,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.change_circle),
              Text("CHANGE ROLE"),
            ],
          ),
          onTap: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) =>
                    AreYouSureDialogue(data: user, feature: 'userrole'),
              );
            });
          },
        ),
      ],
    );
  }
}

// ARE YOU SURE DIALOGUE
class AreYouSureDialogue extends ConsumerWidget {
  final dynamic data;
  final String feature;

  const AreYouSureDialogue(
      {super.key, required this.data, required this.feature});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text("Are you sure?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (feature == 'game') {
              ref
                  .read(gameProvider.notifier)
                  .handleDeleteGame(DeleteGame(data.id));
            } else if (feature == 'userstatus') {
              if (data.status == 'unblocked') {
                data.status = 'blocked';
              } else {
                data.status = 'unblocked';
              }
              ref
                  .read(usersProvider.notifier)
                  .handleChangeStatus(ChangeStatus(data));
            } else if (feature == 'userrole') {
              if (data.roles == 'user') {
                data.roles = 'admin';
              } else {
                data.roles = 'user';
              }
              ref
                  .read(usersProvider.notifier)
                  .handleChangeStatus(ChangeStatus(data));
            } else if (feature == 'logout') {
              ref
                  .read(authProvider.notifier)
                  .handleUserLoggedOut(UserLoggedOut(message: data));
            } else if (feature == 'review') {
              ref.read(reviewProvider.notifier).handleDeleteReview(DeleteReview(
                  reviewId: data['data'].id, gameId: data['gameId']));
            } else if (feature == 'profile') {
              ref.read(authProvider.notifier).handleUserDeleted(data.id);
            }
            Navigator.pop(context);

            if (feature == 'profile') {
              context.go('/register');
            }

            if (feature == 'userstatus') {
              context.go('/users');
            }
            if (feature == 'logout') {
              context.go('/login');
            }
          },
          child: const Text("Yes"),
        ),
      ],
    );
  }
}
