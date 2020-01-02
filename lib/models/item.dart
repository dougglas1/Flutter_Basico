// Pode-se criar um Json e converter para o formato Dart
// https://javiercbk.github.io/json_to_dart/

// Modelo - Objeto
class Item{
  String title;
  bool done;

  // Construtor
  Item({this.title, this.done});

  // Converter de Json
  Item.fromJson(Map<String, dynamic> json){
    title = json['title'];
    done = json['done'];
  }

  // Converter para Json
  Map<String, dynamic> toJson(){
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['title'] = this.title;
  data['done'] = this.done;
  return data;
  }
}
