import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/triviamodel.dart';
import 'category_disceases.dart';

class DisceaseCategories extends StatelessWidget {

  final CategoryModel  category;
  final Color bgColor;


  const DisceaseCategories({super.key, required this.category, required this.bgColor, });

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryDisceases(name:category.name,  catgoryId: category.id, )));
      },
      child: Container(
        height: 150,
        width: 200,

        decoration: BoxDecoration(
          color: bgColor,
          borderRadius:BorderRadius.circular(18),
          image: DecorationImage(image: NetworkImage(category.image),
            fit:  BoxFit.cover,
          ),
        ),

        child: Column(
          children: [
            Expanded(child: Padding(padding: EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network( category.image,width: double.infinity,fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // image loaded
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },

                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
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
                category.name,
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