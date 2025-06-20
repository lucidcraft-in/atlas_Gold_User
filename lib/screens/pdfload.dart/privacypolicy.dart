import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Privacypolicy extends StatefulWidget {
  @override
  _PrivacypolicyState createState() => _PrivacypolicyState();
}

class _PrivacypolicyState extends State<Privacypolicy> {
  List userlist = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('privacyPolicy');
    QuerySnapshot querySnapshot;

    try {
      querySnapshot = await collectionReference.get();

      for (var doc in querySnapshot.docs.toList()) {
        Map a = {
          "id": doc.id,
          "name": doc['name'],
        };
        userlist.add(a);
      }
      print(userlist);
    } catch (e) {
      print('Error: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Privacy Policy',
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userlist.isEmpty
              ? Center(
                  child: Text('No data found'),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal, // Horizontal scrolling
                  itemCount: userlist.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(
                          width: 200, // Fixed width for each card
                          height: 300, // Fixed height for each card
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageFullScreen(
                                    imageUrl: userlist[index]['name'],
                                  ),
                                ),
                              );
                            },
                            child: Image.network(
                              userlist[index]['name'], // URL for the image
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    'Failed to load image',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}

class ImageFullScreen extends StatelessWidget {
  final String imageUrl;

  const ImageFullScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(
                'Failed to load image',
                style: TextStyle(color: Colors.red),
              ),
            );
          },
        ),
      ),
    );
  }
}
