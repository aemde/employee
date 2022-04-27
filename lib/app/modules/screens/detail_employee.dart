// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetailEmployee extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String avatar;
  final String email;
  bool favorite = false;

  DetailEmployee({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.email,
    required this.favorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo[700],
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(favorite ? Icons.star : Icons.star_border),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.indigo[700],
                child: Center(
                  heightFactor: 1.3,
                  child: Column(
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          fit: BoxFit.fitHeight,
                          height: 140,
                          width: 140,
                          imageUrl: avatar,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(firstName + " " + lastName,
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ],
                  ),
                ),
              ),
              listTile(
                firstName + " " + lastName,
                "Full Name",
                Icons.person,
                Icons.message,
              ),
              listTile(email, "E-mail", Icons.email, ""),
              listTile("Share employee", "share", Icons.share, ""),
            ],
          ),
        ));
  }

  Card listTile(title, subtitle, leading, trailing) {
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: ListTile(
        title: Text(title,
            style: TextStyle(
              fontSize: 16,
            )),
        subtitle: Text(subtitle),
        leading: leading != ""
            ? Icon(leading, color: Colors.indigo[700])
            : SizedBox(),
        trailing: trailing != "" ? Icon(trailing) : SizedBox(),
      ),
    );
  }
}
