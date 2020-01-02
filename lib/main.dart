import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart'; // Este material.dart é somente aplicado no Android

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo', // Não visível
      debugShowCheckedModeBanner: false, // retira o debug da tela
      theme: ThemeData(
        primarySwatch: Colors.blue, // Swatch permiti várias tonalidades da cor
      ),
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  var items = new List<Item>();
  HomePage(){
    items = [];
    // items.add(Item(title: "Item 1", done: false));
    // items.add(Item(title: "Item 2", done: true));
    // items.add(Item(title: "Item 3", done: false));
}

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();

  // Adicionar Item na Lista
  void add(){
    if (newTaskCtrl.text.isEmpty) return;

    setState(() {
      widget.items.add(Item(
        title: newTaskCtrl.text, 
        done: false,
        ),
      );
      newTaskCtrl.text = "";
      save(); // Salvar o item
    });
  }

  // Remover Item da Lista
  void remove(int index){
    setState(() {
      widget.items.removeAt(index);
      save(); // Salvar o item
    });
  }

  // Ler Itens
  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    // Ao rodar pela 1ª vez possívelmente estará null - ignorar
    if (data != null){
      Iterable decoded = jsonDecode(data); // Formata em Json
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList(); // map percorre os itens (ex: foreach)
      setState(() {
        widget.items = result;
      });
    }
  }

  // Sempre que trabalhar com SharedPreferences deve ser async
  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  // Construtor para iniciar os itens
  _HomePageState(){
    load();
  }

  @override
  Widget build(BuildContext context) {
    //newTaskCtrl.value = "valor"; // Setar valor
    //newTaskCtrl.clear(); // Limpar input
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTaskCtrl,
          keyboardType: TextInputType.text, // Teclado normal
          //keyboardType: TextInputType.emailAddress, // Teclado com @
          //keyboardType: TextInputType.phone, // Teclado Numérico
          style: TextStyle(
            color: Colors.white, // Alterar Cor do Texto
            fontSize: 18, // Alterar Fonte do Texto
            ), 
            decoration: InputDecoration(
              labelText: "Nova Tarefa",
              labelStyle: TextStyle(
                color: Colors.white,
              ),
            ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, int index){
          final item = widget.items[index];
          return Dismissible( // Remover item da lista
            child: CheckboxListTile(
            title: Text(item.title),
            value: item.done,
            onChanged: (value){ // onChanged > Função
              // Permitir alterar o valor do Checked
              // setState > Função
              setState(() {
                item.done = value;
                save(); // Salvar o item
              });
              print(value); // Mostrar no Console
              },
            ),
            key: Key(item.title),
            background: Container( // Preenche todo
              color: Colors.red.withOpacity(0.2),
            ),
            onDismissed: (direction){
              print(direction);
              remove (index);
            }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add, // Chama a função
        child: Icon(Icons.add), // Icone
        backgroundColor: Colors.pink, // Cor do Fundo
      ),
    );
  }
}