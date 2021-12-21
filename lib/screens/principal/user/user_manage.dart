import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';
import 'package:organic/models/user.dart';
import 'package:organic/util/queries/user/user_query.dart';

class UserManage extends StatefulWidget {
  const UserManage({Key? key}) : super(key: key);

  @override
  _UserManageState createState() => _UserManageState();
}

class _UserManageState extends State<UserManage> {
  UserQuery userQuery = UserQuery();

  List<UserLogin> userList = [];

  @override
  void initState() {
    userQuery.getUserCustomers().then((value) {
      setState(() {
        userList = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Text(
              "Administrar usuarios",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: userList.isNotEmpty
                ? userList.map((user) {
                    return UserCard(user: user);
                  }).toList()
                : [
                    Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 2,
                        child: const Text('No hay usuarios'))
                  ],
          )
        ],
      ),
    ));
  }
}

class UserCard extends StatelessWidget {
  const UserCard({Key? key, required this.user}) : super(key: key);

  final UserLogin user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      // * Bordes de la tarjeta
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: Color(0xFFe3e3e3), width: 1, style: BorderStyle.solid)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: kBackgroundColor,
                    child: ClipOval(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          clipBehavior: Clip.antiAlias,
                          child: Text(
                            (user.getEmail() as String)
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                                fontSize: 20, color: kPrimaryWhite),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(180),
                            color: kPrimaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 3,
                                offset: const Offset(
                                    0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // * Nombre del producto

                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 120,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          user.getName(),
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.start,
                          softWrap: true,
                          maxLines: 3,
                          textWidthBasis: TextWidthBasis.parent,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width - 120,
                        child: Text(
                          user.getEmail(),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                          textAlign: TextAlign.start,
                          softWrap: true,
                          maxLines: 3,
                          textWidthBasis: TextWidthBasis.parent,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),

                // * Precio del producto

                const Spacer(),
                // getDropdownMenu()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
