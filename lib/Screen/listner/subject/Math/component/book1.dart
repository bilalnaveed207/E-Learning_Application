// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:education/Screen/instructor/Subject/Component/add_book.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'dart:async';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
//
// class Book1 extends StatefulWidget {
//   Book1({Key? key, this.id,this.type}) : super(key: key);
//   String? id;
//   String ?type;
//
//   @override
//   State<Book1> createState() => _Book1State();
// }
//
// class _Book1State extends State<Book1> {
//
//   getVi() async {
//     var da = await FirebaseFirestore.instance
//         .collection('Subjects')
//         .doc(widget.id)
//         .collection('Data')
//         .doc()
//         .get()
//         .then((value) {
//       print('###################################');
//       print(value.get('Item'));
//     });
//     // print('###################################');
//     // print(da);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//
//       body:  StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('Subjects')
//               .doc(widget.id)
//               .collection('Data').where('type', isEqualTo: widget.type)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if(!snapshot.hasData){
//               return Center(
//                 child:CircularProgressIndicator(),
//               );
//             }
//             return ListView.builder(
//
//               shrinkWrap: true,
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context,i){
//                 final sampleUrl =  snapshot.data!.docs[i]['item'];
//
//                 String? pdfFlePath;
//
//                 Future<String> downloadAndSavePdf() async {
//                   final directory = await getApplicationDocumentsDirectory();
//                   final file = File('${directory.path}/sample.pdf');
//                   if (await file.exists()) {
//                     return file.path;
//                   }
//                   final response = await http.get(Uri.parse(sampleUrl));
//                   await file.writeAsBytes(response.bodyBytes);
//                   return file.path;
//                 }
//
//                 void loadPdf() async {
//                   pdfFlePath = await downloadAndSavePdf();
//                   setState(() {});
//                 }
//                 return Column(
//
//
//                 );
//               },
//             );
//           }
//       ),
//
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education/Screen/instructor/Subject/Component/add_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Book1 extends StatefulWidget {
  Book1({Key? key, this.id, this.type}) : super(key: key);
  String? id;
  String? type;

  @override
  State<Book1> createState() => _Book1State();
}

class _Book1State extends State<Book1> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Subjects')
              .doc(widget.id)
              .collection('Data')
              .where('type', isEqualTo: widget.type)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, i) {
                  final sampleUrl = snapshot.data!.docs[i]['item'];
                  final nameBook = snapshot.data!.docs[i]['name'];

                  return Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Get.to(ViewPage(
                            url: sampleUrl,
                            bookName: nameBook,
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            // alignment: Alignment.center,
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [

                                Center(
                                  child: Text(
                                    nameBook,
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class ViewPage extends StatefulWidget {
  final url;
  final bookName;

  const ViewPage({
    Key? key,
    required this.url,
    required this.bookName,
  }) : super(key: key);

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  @override
  void initState() {
    print('----------------------');
    print(widget.url.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.bookName),
      ),
      body: Container(
        child: PDF(
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: false,
          onError: (error) {
            print(error.toString());
          },
          onPageError: (page, error) {
            print('$page: ${error.toString()}');
          },
        ).cachedFromUrl(widget.url.toString()),
      ),
    );
  }
}
