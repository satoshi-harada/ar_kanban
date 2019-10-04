import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ArKanban extends StatefulWidget {
  @override
  _ArKanbanState createState() => _ArKanbanState();
}

class _ArKanbanState extends State<ArKanban> {
  ARKitController arkitController;
  // nodes
  ARKitNode kanbanNode;
  ARKitNode todoAreaNode;
  ARKitNode doneAreaNode;
  // kanban base
  ARKitPlane kanbanBase;
  // task area
  ARKitPlane todoAreaPlane;
  ARKitPlane doneAreaPlane;
  // task
  ARKitPlane task1Plane;
  ARKitPlane task2Plane;
  ARKitText task1Text;

  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('AR Kanban HaZuMu'),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'addtask',
            child: Icon(
              Icons.add,
            ),
            onPressed: addTask,
          ),
        ],
      ),
      body: Container(
        child: ARKitSceneView(
          enableTapRecognizer: true,
          onARKitViewCreated: onARKitViewCreated
        ),
      ));

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onNodeTap = (name) => onNodeTapHandler(name);

    // kanban base
    kanbanNode = _createKanbanBase();
    this.arkitController.add(kanbanNode);
    this.arkitController.add(_createKanbanBaseText());
    // todo area
    todoAreaNode = _createTodoArea();
    this.arkitController.add(todoAreaNode);
    this.arkitController.add(_createTodoAreaText());
    // done area
    doneAreaNode = _createDoneArea();
    this.arkitController.add(doneAreaNode);
    this.arkitController.add(_createDoneAreaText());
    // task
    this.arkitController.add(ARKitNode(name: 'task_parent1'));
    this.arkitController.add(_createTodoTask1(), parentNodeName: 'task_parent1');
    this.arkitController.add(_createTodoTask1Text(), parentNodeName: 'task_parent1');
    this.arkitController.add(ARKitNode(name: 'task_parent2'));
    this.arkitController.add(_createTodoTask2(), parentNodeName: 'task_parent2');
    this.arkitController.add(_createTodoTask2Text(), parentNodeName: 'task_parent2');
  }

  void addTask() {
    double expansionSize = 0.2;
    double positioAdjust = expansionSize / 2;
    // kanban base and todo-done area size up
    kanbanBase.height.value = kanbanBase.height.value + expansionSize + 0.075;
    todoAreaPlane.height.value = todoAreaPlane.height.value + expansionSize;
    doneAreaPlane.height.value = doneAreaPlane.height.value + expansionSize;
    // kanban base and todo-done area position adjust
    kanbanNode.position.value = vector.Vector3(
        kanbanNode.position.value.x,
        kanbanNode.position.value.y - positioAdjust - 0.05,
        kanbanNode.position.value.z
    );
    todoAreaNode.position.value = vector.Vector3(
        todoAreaNode.position.value.x,
        todoAreaNode.position.value.y - positioAdjust,
        todoAreaNode.position.value.z
    );
    doneAreaNode.position.value = vector.Vector3(
        doneAreaNode.position.value.x,
        doneAreaNode.position.value.y - positioAdjust,
        doneAreaNode.position.value.z
    );
    // add new task
    final newTaskPlane = ARKitPlane(
      width: 0.35,
      height: 0.15,
      materials: [
        ARKitMaterial(
          transparency: 1,
          diffuse: ARKitMaterialProperty(color: Colors.white),
        ),
      ],
    );
    final newTaskNode = ARKitNode(
      geometry: newTaskPlane,
      position: vector.Vector3(
          todoAreaNode.position.value.x + 0.025,
          todoAreaNode.position.value.y * 2 - positioAdjust,
          todoAreaNode.position.value.z + 0.1
      ),
    );
    this.arkitController.add(newTaskNode);
  }

  ARKitNode _createKanbanBase() {
    kanbanBase = ARKitPlane(
      width: 1.5,
      height: 1,
      materials: [
        ARKitMaterial(
          transparency: 0.5,
          diffuse: ARKitMaterialProperty(color: Colors.white),
        )
      ],
    );
    return ARKitNode(
      geometry: kanbanBase,
      position: vector.Vector3(0, 0, -2),
    );
  }

  ARKitNode _createKanbanBaseText() {
    final text = ARKitText(
      text: 'AR Kanban App',
      extrusionDepth: 1,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty(color: Colors.blue),
        )
      ],
    );

    return ARKitNode(
      geometry: text,
      position: vector.Vector3(-0.4, 0.3, -1.9),
      scale: vector.Vector3(0.01, 0.01, 0.01),
    );
  }

  ARKitNode _createTodoArea() {
    todoAreaPlane = ARKitPlane(
      width: 0.5,
      height: 0.7,
      materials: [
        ARKitMaterial(
          transparency: 1,
          diffuse: ARKitMaterialProperty(color: Colors.lightBlueAccent),
        )
      ],
    );
    return ARKitNode(
      geometry: todoAreaPlane,
      position: vector.Vector3(-0.3, -0.075, -1.8),
    );
  }

  ARKitNode _createTodoAreaText() {
    final text = ARKitText(
      text: 'ToDo',
      extrusionDepth: 0,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty(color: Colors.white),
        )
      ],
    );
    return ARKitNode(
      geometry: text,
      position: vector.Vector3(-0.4, 0.1, -1.7),
      scale: vector.Vector3(0.0075, 0.0075, 0.01),
    );
  }

  ARKitNode _createTodoTask1() {
    task1Plane = ARKitPlane(
      width: 0.35,
      height: 0.15,
      materials: [
        ARKitMaterial(
          transparency: 1,
          diffuse: ARKitMaterialProperty(color: Colors.white),
        ),
      ],
    );
    return ARKitNode(
      name: 'task_plane1',
      geometry: task1Plane,
      position: vector.Vector3(-0.28, -0.02, -1.7),
    );
  }

  ARKitNode _createTodoTask1Text() {
    task1Text = ARKitText(
      text: 'Task1',
      extrusionDepth: 0,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty(color: Colors.pink),
        )
      ],
    );
    return ARKitNode(
      name: 'task_text1',
      geometry: task1Text,
      position: vector.Vector3(-0.4, -0.07, -1.6),
      scale: vector.Vector3(0.0075, 0.0075, 0.01),
    );
  }

  ARKitNode _createTodoTask2() {
    task2Plane = ARKitPlane(
      width: 0.35,
      height: 0.15,
      materials: [
        ARKitMaterial(
          transparency: 1,
          diffuse: ARKitMaterialProperty(color: Colors.white),
        )
      ],
    );
    return ARKitNode(
      name: 'task_plane2',
      geometry: task2Plane,
      position: vector.Vector3(-0.28, -0.2, -1.7),
    );
  }

  ARKitNode _createTodoTask2Text() {
    final text = ARKitText(
      text: 'Task2',
      extrusionDepth: 0,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty(color: Colors.pink),
        )
      ],
    );
    return ARKitNode(
      name: 'task_text1',
      geometry: text,
      position: vector.Vector3(-0.4, -0.25, -1.6),
      scale: vector.Vector3(0.0075, 0.0075, 0.01),
    );
  }

  ARKitNode _createDoneArea() {
    doneAreaPlane = ARKitPlane(
      width: 0.5,
      height: 0.7,
      materials: [
        ARKitMaterial(
          transparency: 1,
          diffuse: ARKitMaterialProperty(color: Colors.green),
        )
      ],
    );
    return ARKitNode(
      geometry: doneAreaPlane,
      position: vector.Vector3(0.3, -0.075, -1.8),
    );
  }

  ARKitNode _createDoneAreaText() {
    final text = ARKitText(
      text: 'Done',
      extrusionDepth: 0,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty(color: Colors.white),
        )
      ],
    );
    return ARKitNode(
      geometry: text,
      position: vector.Vector3(0.2, 0.1, -1.7),
      scale: vector.Vector3(0.0075, 0.0075, 0.01),
    );
  }

  void onNodeTapHandler(String name) {
    if (name == 'task_plane1') {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: Text('task color change'),
              content: Text('Do you want to change the color of Task1?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('ok'),
                  onPressed: () {
                    task1Plane.materials.value = [
                      ARKitMaterial(
                        transparency: 1,
                        diffuse: ARKitMaterialProperty(color: Colors.yellow),
                      ),
                    ];
                    Navigator.pop<String>(context, 'ok');
                  },
                ),
                FlatButton(
                  child: Text('cancel'),
                  onPressed: () {Navigator.pop<String>(context, 'cancel');},
                )
              ],
            ),
      );
    }
    if (name == 'task_plane2') {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: Text('task delete'),
              content: Text('Do you want to delete Task2?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('ok'),
                  onPressed: (){
                    arkitController.remove('task_parent2');
                    Navigator.pop<String>(context, 'ok');
                  },
                ),
                FlatButton(
                  child: Text('cancel'),
                  onPressed: () {Navigator.pop<String>(context, 'cancel');},
                )
              ],
            ),
      );
    }
  }
}
