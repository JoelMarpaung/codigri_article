import 'package:flutter/material.dart';
import 'package:core/route/routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/bg.jpeg'),
            ),
            accountName: Text('User'),
            accountEmail: Text('User@gmail.com'),
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Article'),
            onTap: () {
              Navigator.pushNamed(context, articlePage);
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, profilePage);
            },
          ),
        ],
      ),
    );
  }
}
