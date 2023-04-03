import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = TextEditingController();
  bool searching = false;
  @override
  void dispose() {
    super.dispose();
    //controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Search for user',
            border: InputBorder.none,
          ),
          onFieldSubmitted: (value) {
            setState(() {
              searching = true;
            });
          },
        ),
      ),
      body: searching
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('userSettings')
                  .where(
                    'Username',
                    isGreaterThanOrEqualTo: controller.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    final user = (snapshot.data! as dynamic).docs[index];
                    return ListTile(
                      title: Text(user['Username']),
                      leading: CachedNetworkImage(
                        imageUrl: user['PhotoUrl'],
                        imageBuilder: (context, imageProvider) => Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      onTap: () {},
                    );
                  },
                );
              },
            )
          : Container(),
    );
  }
}
