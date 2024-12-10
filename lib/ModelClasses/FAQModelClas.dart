import 'package:cloud_firestore/cloud_firestore.dart';

class FAQModelClass{
  String? heading;
  String? description;

  FAQModelClass(this.heading, this.description);
  FAQModelClass.fromDocumentSnapShoot({ required DocumentSnapshot? snapshot})
  {
  heading=snapshot!['heading'];
  description=snapshot!['description'];
  }
}
