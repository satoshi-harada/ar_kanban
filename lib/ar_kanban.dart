import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ArKanban extends StatefulWidget {
  @override
  _ArKanbanState createState() => _ArKanbanState();
}

class _ArKanbanState extends State<ArKanban> {
  ARKitController arkitController;
  ARKitPlane task1Plane;
  ARKitPlane task2Plane;

  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('AR Kanban App'),
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

    this.arkitController.add(_createKanbanBase());
    this.arkitController.add(_createKanbanBaseText());
    this.arkitController.add(_createTodoArea());
    this.arkitController.add(_createTodoAreaText());
    this.arkitController.add(_createTodoTask1());
    this.arkitController.add(_createTodoTask1Text());
    this.arkitController.add(_createTodoTask2());
    this.arkitController.add(_createTodoTask2Text());
    this.arkitController.add(_createDoneArea());
    this.arkitController.add(_createDoneAreaText());
  }

  ARKitNode _createKanbanBase() {
    final plane = ARKitPlane(
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
      geometry: plane,
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
    final plane = ARKitPlane(
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
      geometry: plane,
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
      name: 'Task1',
      geometry: task1Plane,
      position: vector.Vector3(-0.28, -0.02, -1.7),
    );
  }

  ARKitNode _createTodoTask1Text() {
    final text = ARKitText(
      text: 'Task1',
      extrusionDepth: 0,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty(color: Colors.pink),
        )
      ],
    );
    return ARKitNode(
      geometry: text,
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
      name: 'Task2',
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
      geometry: text,
      position: vector.Vector3(-0.4, -0.25, -1.6),
      scale: vector.Vector3(0.0075, 0.0075, 0.01),
    );
  }

  ARKitNode _createDoneArea() {
    final plane = ARKitPlane(
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
      geometry: plane,
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
    switch (name) {
      // Task1
      case 'Task1':
        task1Plane.materials.value = [
          ARKitMaterial(
            transparency: 1,
            diffuse: ARKitMaterialProperty(color: Colors.yellow),
          ),
        ];
        break;
      // Task2
      case 'Task2':
        task2Plane.materials.value = [
          ARKitMaterial(
            transparency: 1,
            diffuse: ARKitMaterialProperty(color: Colors.blueGrey),
          ),
        ];
        break;
    }

    // dialog
    if (name == 'Task1' || name == 'Task2') {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(content: Text('You tapped on $name')),
      );
    }
  }
}
