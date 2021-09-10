import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Todo{
  int id;
  String what;
  bool done;

  Todo(this.id,this.what):done=false;

  Todo.fromJson(Map<String,dynamic> json)
      : id=json['id'],
        what=json['what'],
        done=json['done'];
  Map<String,dynamic> toJson() =>{
    'id':id,
    'what':what,
    'done':done,
  };

}
class Gatosjj {
  Gatosjj({
    required this.data,
  });


  List<Datum> data;


  factory Gatosjj.fromJson(Map<String, dynamic> json) => Gatosjj(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),

  };
}

class Datum {
  Datum({
    required this.fact,
    required this.length,
  });

  String fact;
  int length;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    fact: json["fact"],
    length: json["length"],
  );

  Map<String, dynamic> toJson() => {
    "fact": fact,
    "length": length,
  };
}




class _MyHomePageState extends State<MyHomePage> {
  late List<Todo> _todos;
  TextEditingController? _textEditingController=TextEditingController();

  @override
  void initState() {
    _readTodos();
    super.initState();
  }

  Future<Todo> fetchAlbum(int n) async {
    final response=await http.get(Uri.parse('https://catfact.ninja/facts?limit=1&max_length=140'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Gatosjj resp=Gatosjj.fromJson(jsonDecode(response.body));
      setState(() {
        _todos.add(Todo(n,resp.data[0].fact.toString()));
      });
      return Todo(1,'gato');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  _readTodos() async{
    try{
    Directory dir=await getApplicationDocumentsDirectory();
    File file=File('${dir.path}/todos.json');
    List json=jsonDecode(await file.readAsString());
    List<Todo> todos=[];
    for (var item in json){
      todos.add(Todo.fromJson(item));
    }
    super.setState(()=> _todos=todos);
    }catch(e){
      setState(()=>_todos=[]);
    }

  }

  @override
  void setState(fn){
    super.setState(fn);
    _writeTodos();
  }

  _writeTodos() async{
    Directory dir=await getApplicationDocumentsDirectory();
    File file=File('${dir.path}/todos.json');
    String jsonText=jsonEncode(_todos);
    await file.writeAsString(jsonText);

  }


  _actulizatodos(Todo jas){
    List<Todo> actualizados=[];
    for(var todo in _todos){
      if(todo.id==jas.id) {
        actualizados.add(jas);
      }else{
        actualizados.add(todo);
      }
    }
    setState(()=>_todos=actualizados);
  }

  _borrarTodos(int nel){
    List<Todo> actualizados=[];
    for(var todo in _todos){
      if(todo.id==-nel) {
      }else{
        actualizados.add(todo);
      }
    }
    setState(()=>_todos=actualizados);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
              color: Colors.blue.shade200,
              borderRadius: BorderRadius.circular(30)
          ),
          child: TextField(
            onChanged: (value){
              if(value.isEmpty){
                setState(() {
                  _readTodos();
                });
              }else{
                super.setState(() {
                  _todos= _todos.where((element) => element.what.contains(value)).toList();
                });
              }

            },
            controller: _textEditingController,
            decoration: InputDecoration(
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintText: 'Buscar tarea'
            ),
          ),
        ),
      ),
      body: Column(
        children:[
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_)=>NuevaTarea())
            ).then((what){
              setState(() {
                if(_todos.isEmpty){
                  _todos.add(Todo(1,what));
                }else{
                  _todos.add(Todo(_todos[_todos.length-1].id+1,what));
                }
              });
            });
            },
            child: const Text('Nueva tarea'),
          ),
        OutlinedButton(
            onPressed: () {
              int v;
              if(_todos.isEmpty){
                fetchAlbum(1);
              }else{
                fetchAlbum(_todos[_todos.length-1].id+1);
              }
            },
            child: const Text('Gatos'),
          ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
            itemCount: _todos.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Checkbox(
                  value: _todos[index].done,
                  onChanged: (checked){
                    setState(() {
                      _todos[index].done=checked!;
                    });

                  },
                ),
                title: Text(_todos[index].what),
                trailing: IconButton(
                    icon:const Icon(Icons.more_vert),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_)=>ActualizaBorra(comienzo: _todos[index]))
                      ).then((actualiza){
                        setState(() {
                          if(actualiza.id>0){
                            _actulizatodos(actualiza);
                          }else{
                            _borrarTodos(actualiza.id);
                          }
                        });
                      });
                    },
                ),
              );
            },
        ),
        ],
          ),

      );
  }
}

class NuevaTarea extends StatefulWidget {
  const NuevaTarea({Key? key}) : super(key: key);

  @override
  _NuevaTareaState createState() => _NuevaTareaState();
}

class _NuevaTareaState extends State<NuevaTarea> {
  TextEditingController _controller=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nueva tarea')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _controller,
            onSubmitted: (what){
              Navigator.of(context).pop(what);
            },
          ),
          ElevatedButton(
              onPressed: (){
                Navigator.of(context).pop(_controller.text);
              },
              child: const Text('Agregar'))

        ],
      ),
    );
  }
}

class ActualizaBorra extends StatefulWidget {
  final Todo comienzo;
  const ActualizaBorra({Key? key,required this.comienzo}) : super(key: key);



  @override
  _ActualizaBorraState createState() => _ActualizaBorraState(comienzo);
}

class _ActualizaBorraState extends State<ActualizaBorra> {
  Todo comienzo;
  _ActualizaBorraState(this.comienzo);

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller=TextEditingController(text: comienzo.what);
    return Scaffold(
      appBar: AppBar(title: Text('Nueva tarea')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _controller,
            onSubmitted: (what){
              Navigator.of(context).pop(Todo(comienzo.id,what));
            },
          ),
          ElevatedButton(
              onPressed: (){
                Navigator.of(context).pop(Todo(comienzo.id,_controller.text));
              },
              child: const Text('Actualizar')),
          ElevatedButton(
              onPressed: (){
                Navigator.of(context).pop(Todo(-comienzo.id,_controller.text));
              },
              child: const Text('Borrar'))

        ],
      ),
    );
  }
}


