import 'package:hive/hive.dart';

class LocalPost{

  var box = Hive.box("post");

   savePost(Map data){
    box.add(data);
   }


 List<dynamic> getPost(){
  return  box.values.toList();
  }
}