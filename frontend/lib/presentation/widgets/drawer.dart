import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/events/auth_event.dart';
import 'package:frontend/presentation/states/auth_state.dart';
import 'package:frontend/application/auth/auth_provider.dart';
import 'package:frontend/presentation/widgets/dialogues.dart';
import 'package:go_router/go_router.dart';

class MenuDrawer extends ConsumerStatefulWidget {
  final List<List<String>> menuItems;
  const MenuDrawer({super.key, required this.menuItems});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends ConsumerState<MenuDrawer> {
  Map<String, dynamic> message = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).handleCurrentUser(CurrentUser());
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, state) {
      if (state is AuthSuccess) {
        setState(() {
          message = state.message;
        });
      }
    });

    return Drawer(
      child: Center(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/logo.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.3,
                  colorFilter: ColorFilter.mode(
                      Color.fromARGB(255, 18, 18, 18).withOpacity(0.5),
                      BlendMode.dstATop),
                ),
              ),
              child: const Text('BetEbet'),
            ),
            ..._buildTile(widget.menuItems, context, message)
          ],
        ),
      ),
    );
  }

  List<ListTile> _buildTile(menuItems, context, message) {
    List<ListTile> tiles = [];
    for (var item in menuItems) {
      var icon;
      switch (item[0]) {
        case "Home":
          icon = Icons.home;
          break;
        case "Profile":
          icon = Icons.person;
          break;
        case "About":
          icon = Icons.info;
          break;
        case "Logout":
          icon = Icons.logout;
          break;
        case "Users":
          icon = Icons.people;
          break;
        case "Add Game":
          icon = Icons.add;
          break;
        default:
          icon = Icons.home;
      }
      tiles.add(
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(icon),
              const SizedBox(
                width: 40,
              ),
              Text(item[0]),
            ],
          ),
          onTap: () {
            if (item[0] == "Logout") {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AreYouSureDialogue(data: message, feature: 'logout');
                },
              );
            } else {
              GoRouter.of(context)
                  .push(item[1]); // Using GoRouter for navigation
            }
          },
        ),
      );
    }
    return tiles;
  }
}
