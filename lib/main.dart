import 'package:flutter/material.dart';

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
  String what;
  bool done;

  Todo(this.what):done=false;

}

class _MyHomePageState extends State<MyHomePage> {
  late List<Todo> _todos;

  @override
  void initState() {
    _todos=[
      Todo('Primero'),
      Todo('Segundo'),
      Todo('tercero'),
    ];
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children:[
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_)=>NuevaTarea())
            ).then((what){
              setState(() {
                _todos.add(Todo(what));
              });
            });
            },
            child: const Text('Nueva tarea'),
          ),
        OutlinedButton(
            onPressed: () {
              print('Received click');
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
                    onPressed: () {},
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

