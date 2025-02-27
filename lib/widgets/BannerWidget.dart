import 'package:atlas_gold_user/common/colo_extension.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage('assets/images/banner1.jpg'), 
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upto 50% OFF',
              style: TextStyle(
                  color: TColo.primaryColor1,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Text('Bridal Jewellery',
              style: TextStyle(color: TColo.primaryColor1, fontSize: 14)),


              
        ],
      ),
    );
  }
}
