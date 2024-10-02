import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todoexample extends StatefulWidget {
  const Todoexample({super.key});

  @override
  State<Todoexample> createState() => _TodoexampleState();
}

class _TodoexampleState extends State<Todoexample> {
  List<Map<String,dynamic>> _todoItems=[];
  Color _seleteColor=Colors.blue;
  List<Color> _colorlist =[
    Colors.pink,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
  ];
  @override
  void initState(){
    super.initState();
    _loadToDoItems();
  }
  _loadToDoItems() async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    List<String>? tasks=prefs.getStringList('todoItems');
    List<String>? colors=prefs.getStringList('todoColors');
     if (tasks ! = null && colors ! = null)  {
setState(() {
  _todoItems =List.generate(tasks.length, (index){
    return {
      'task':tasks[index],
      'color':Color(int.parse(colors[index]))
    };
  });
});
    }
  }
  _saveToDoItems() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    List<String> tasks =
    _todoItems.map((item)=>item['task'] as String).toList();
    List<String> colors =_todoItems.map((item)=>(item['color'] as Color).value.toString())
    .toList();
    prefs.setStringList('todoItems', tasks);
    prefs.setStringList('todoItems', colors);
  }
  void _addToDoItem(String task){
    if(task.isNotEmpty){
      setState(() {
        _todoItems.add({'task':task,'color':_seleteColor});
      });
      _saveToDoItems();
    }
  }
  void _removeToDoitem(int index){
    setState(() {
      _todoItems.removeAt(index);
    });
    _saveToDoItems();
  }
  void _promptAddItem(){
    String newTask="";
    showModalBottomSheet(context: context, 
    builder: (BuildContext context){
      return Container(
height: 500,
width: double.infinity,
child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    TextField(decoration: InputDecoration(
      border: OutlineInputBorder()
    ),
    autofocus: true,
    onChanged: (val) {
      newTask =val;
      
    },),
    SizedBox(height: 20),
    Text('pick a task color:'),
    SizedBox(height: 100,
    
      child: ListView.separated(
         separatorBuilder: (context, index){
          return SizedBox(width: 10,);
         },
         scrollDirection: Axis.horizontal, 
         itemCount: _colorlist.length,
         itemBuilder: (context, index) {
           return GestureDetector(
            onTap: (){
              setState(() {
                _seleteColor=_colorlist[index];
              });
            },
            child: CircleAvatar(
              radius: 15,
              backgroundColor: _colorlist[index],
            ),
           );
         },),
    ),
    TextButton(onPressed: (){
      if (newTask.isNotEmpty){
        _addToDoItem(newTask);
        Navigator.of(context).pop();
      }
    }, child: Text("Add"))
  ],
),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TO-DO List"),
      ),
      body: ListView.builder(itemCount: _todoItems.length,
      itemBuilder: (context,index){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: _todoItems[index]['color'],
            ),
            child: Row(
              children: [
                Text(_todoItems[index]['task']),
                Spacer(),
                IconButton(onPressed: ()=> _removeToDoitem(index),
                 icon: Icon(Icons.delete))
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(onPressed: _promptAddItem,
      tooltip: 'Add Task',
      child: Icon(Icons.add),),
    );
  }
}