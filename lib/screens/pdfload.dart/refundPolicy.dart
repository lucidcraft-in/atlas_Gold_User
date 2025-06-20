import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class RefundPolicyPage extends StatefulWidget {
  @override
  _RefundPolicyPageState createState() => _RefundPolicyPageState();
}

class _RefundPolicyPageState extends State<RefundPolicyPage> {
  List<Map<String, dynamic>> userlist = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('refundPolicy');
    QuerySnapshot querySnapshot;

    try {
      querySnapshot = await collectionReference.get();

      for (var doc in querySnapshot.docs.toList()) {
        Map<String, dynamic> data = {
          "id": doc.id,
          "url": doc['name'], // URL to file
          "fileType": doc['fileType'], // "image" or "pdf"
        };
        userlist.add(data);
      }
      print(userlist); // Debugging
    } catch (e) {
      print('Error fetching data: $e');
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
        title: const Text('Refund Policy'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userlist.isEmpty
              ? Center(child: Text('No data found'))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: userlist.length,
                    itemBuilder: (context, index) {
                      String fileUrl = userlist[index]['url'];
                      String fileType = userlist[index]['fileType'];

                      return Column(
                        children: [
                          SizedBox(
                            width: 200,
                            height: 300,
                            child: GestureDetector(
                              onTap: () {
                                if (fileType == "pdf") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PdfViewerScreen(pdfUrl: fileUrl),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ImageFullScreen(imageUrl: fileUrl),
                                    ),
                                  );
                                }
                              },
                              child: fileType == "pdf"
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.picture_as_pdf,
                                              size: 50, color: Colors.red),
                                          SizedBox(height: 10),
                                          Text(
                                            'Open PDF',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Image.network(
                                      fileUrl,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    (loadingProgress
                                                        .expectedTotalBytes!)
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                ),
    );
  }
}

class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;

  const PdfViewerScreen({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Viewer"),
        backgroundColor: Colors.black,
      ),
      body: const PDF().cachedFromUrl(
        pdfUrl,
        placeholder: (progress) =>
            Center(child: CircularProgressIndicator(value: progress / 100)),
        errorWidget: (error) => Center(
            child: Text("Failed to load PDF",
                style: TextStyle(color: Colors.red))),
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
