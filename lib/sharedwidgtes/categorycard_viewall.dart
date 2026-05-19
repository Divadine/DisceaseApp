import 'package:discese_dictionary/models/triviamodel.dart';
import 'package:flutter/material.dart';

import 'category_disceases.dart';

class CategorycardViewall extends StatelessWidget {

  final CategoryModel categorynames;
  const CategorycardViewall({super.key,required this.categorynames});


  @override
  Widget build (BuildContext context){
    return GestureDetector(

      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryDisceases(name:categorynames.name,  catgoryId: categorynames.id, )));
      },
      child: Container(
        height: 170,
        width: 170,
        decoration: BoxDecoration(
          image:DecorationImage(image: NetworkImage(categorynames.image),fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          children: [
            Expanded(child: Padding(padding: EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network( categorynames.image,width: double.infinity,fit: BoxFit.contain,),
              ),
            )
            ),

            //diseaseText
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Text(
                categorynames.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}