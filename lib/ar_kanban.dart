import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ArKanban extends StatefulWidget {
  @override
  _ArKanbanState createState() => _ArKanbanState();
}

class _ArKanbanState extends State<ArKanban> {
  ARKitController arkitController;
  List<ARKitNode> nodes = [];
  int taskNumber = 1;

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
          enablePanRecognizer: true,
          onARKitViewCreated: onARKitViewCreated
        ),
      ));

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onNodeTap = (name) => _onTapHandler(name);
    this.arkitController.onNodePan = (pan) => _onPanHandler(pan);

    // base area plane
    final basePlane = _createKanbanBase();
    this.arkitController.add(basePlane);
    this.nodes.add(basePlane);

    // base area text
    final baseText = _createKanbanBaseText();
    this.arkitController.add(baseText, parentNodeName: 'base_area_plane');
    this.nodes.add(baseText);

    // todo area plane
    final todoAreaPlane = _createTodoArea();
    this.arkitController.add(todoAreaPlane, parentNodeName: 'base_area_plane');
    this.nodes.add(todoAreaPlane);

    // todo area text
    final todoAreaText = _createTodoAreaText();
    this.arkitController.add(todoAreaText, parentNodeName: 'todo_area_plane');
    this.nodes.add(todoAreaText);

    // done area plane
    final doneAreaPlane = _createDoneArea();
    this.arkitController.add(doneAreaPlane, parentNodeName: 'base_area_plane');
    this.nodes.add(doneAreaPlane);

    // done area text
    final doneAreaText = _createDoneAreaText();
    this.arkitController.add(doneAreaText, parentNodeName: 'done_area_plane');
    this.nodes.add(doneAreaText);
  }

  void addTask() {
    final sizeUpHeightValue = 0.4;
    final laneNodeNames = ['todo', 'done'];
    double todoAreaPlaneHeight;

    // area plane size up
    final baseAreaPlaneNode = nodes.firstWhere((n) => n.name == 'base_area_plane');
    if (baseAreaPlaneNode != null) {
      // height size up
      final ARKitPlane kanbanBasePlane = baseAreaPlaneNode.geometry;
      kanbanBasePlane.height.value = kanbanBasePlane.height.value + sizeUpHeightValue / 2;
    }
    for (var laneNodeName in laneNodeNames) {
      final laneAreaPlaneNode = nodes.firstWhere((n) => n.name == (laneNodeName + '_area_plane'));
      if (laneAreaPlaneNode != null) {
        // height size up
        final ARKitPlane leanAreaPlane = laneAreaPlaneNode.geometry;
        leanAreaPlane.height.value = leanAreaPlane.height.value + sizeUpHeightValue / 2;
        todoAreaPlaneHeight = leanAreaPlane.height.value;
      }
    }

    // add new task
    final newTaskPlaneNode = ARKitNode(
      name: 'task_plane' + taskNumber.toString(),
      geometry: ARKitPlane(
        width: 0.35,
        height: 0.15,
        materials: [
          ARKitMaterial(
            transparency: 1,
            diffuse: ARKitMaterialProperty(color: Colors.white),
          ),
        ],
      ),
      position: vector.Vector3(0, (todoAreaPlaneHeight / 2) - (sizeUpHeightValue * (taskNumber)) , 0.01),
    );
    this.arkitController.add(newTaskPlaneNode, parentNodeName: 'todo_area_plane');
    nodes.add(newTaskPlaneNode);

    final newTaskTextNode = ARKitNode(
      name: 'task_text' + taskNumber.toString(),
      geometry: ARKitText(
        text: 'Task' + taskNumber.toString(),
        extrusionDepth: 0,
        materials: [
          ARKitMaterial(
            diffuse: ARKitMaterialProperty(color: Colors.pink),
          )
        ],
      ),
      position: vector.Vector3(-0.125,-0.05,0.02),
      scale: vector.Vector3(0.0075, 0.0075, 0.01),
    );
    this.arkitController.add(newTaskTextNode, parentNodeName: 'task_plane' + taskNumber.toString());
    nodes.add(newTaskTextNode);

    // all task position adjust
    for (var targetNode in nodes) {
      if (targetNode.name.contains('task_plane')) {
        final position = vector.Vector3(
          targetNode.position.value.x,
          targetNode.position.value.y + 0.1,
          targetNode.position.value.z,
        );
        targetNode.position.value = position;
      }
    }

    // area text position adjust
    final baseAreaTextNode = nodes.firstWhere((n) => n.name == 'base_area_text');
    if (baseAreaTextNode != null) {
      // position adjust
      final position = vector.Vector3(
        baseAreaTextNode.position.value.x,
        baseAreaTextNode.position.value.y + (sizeUpHeightValue / 4),
        baseAreaTextNode.position.value.z,
      );
      baseAreaTextNode.position.value = position;
    }
    for (var laneNodeName in laneNodeNames) {
      final laneAreaTextNode = nodes.firstWhere((n) => n.name == (laneNodeName + '_area_text'));
      if (laneAreaTextNode != null) {
        // position adjust
        final position = vector.Vector3(
          laneAreaTextNode.position.value.x,
          laneAreaTextNode.position.value.y + (sizeUpHeightValue / 4) - 0.0075,
          laneAreaTextNode.position.value.z,
        );
        laneAreaTextNode.position.value = position;
      }
    }

    taskNumber++;
  }

  ARKitNode _createKanbanBase() {
    return ARKitNode(
      name: 'base_area_plane',
      geometry: ARKitPlane(
        width: 1.5,
        height: 1,
        materials: [
          ARKitMaterial(
            transparency: 0.5,
            diffuse: ARKitMaterialProperty(color: Colors.white),
          )
        ],
      ),
      position: vector.Vector3(0, 0, -2),
    );
  }

  ARKitNode _createKanbanBaseText() {
    return ARKitNode(
      name: 'base_area_text',
      geometry: ARKitText(
        text: 'AR Kanban HaZuMu',
        extrusionDepth: 1,
        materials: [
          ARKitMaterial(
            diffuse: ARKitMaterialProperty(color: Colors.orange),
          )
        ],
      ),
      position: vector.Vector3(-0.55, 0.3, 0.1),
      scale: vector.Vector3(0.01, 0.01, 0.05),
    );
  }

  ARKitNode _createTodoArea() {
    return ARKitNode(
      name: 'todo_area_plane',
      geometry: ARKitPlane(
        width: 0.5,
        height: 0.7,
        materials: [
          ARKitMaterial(
            transparency: 1,
            diffuse: ARKitMaterialProperty(color: Colors.lightBlueAccent),
          )
        ],
      ),
      position: vector.Vector3(-0.3, -0.075, 0.1),
    );
  }

  ARKitNode _createTodoAreaText() {
    return ARKitNode(
      name: 'todo_area_text',
      geometry: ARKitText(
        text: 'ToDo',
        extrusionDepth: 0,
        materials: [
          ARKitMaterial(
            diffuse: ARKitMaterialProperty(color: Colors.white),
          )
        ],
      ),
      position: vector.Vector3(-0.075, 0.2, 0.2),
      scale: vector.Vector3(0.0075, 0.0075, 0.01),
    );
  }

  ARKitNode _createDoneArea() {
    return ARKitNode(
      name: 'done_area_plane',
      geometry: ARKitPlane(
        width: 0.5,
        height: 0.7,
        materials: [
          ARKitMaterial(
            transparency: 1,
            diffuse: ARKitMaterialProperty(color: Colors.green),
          )
        ],
      ),
      position: vector.Vector3(0.3, -0.075, 0.1),
    );
  }

  ARKitNode _createDoneAreaText() {
    return ARKitNode(
      name: 'done_area_text',
      geometry: ARKitText(
        text: 'Done',
        extrusionDepth: 0,
        materials: [
          ARKitMaterial(
            diffuse: ARKitMaterialProperty(color: Colors.white),
          )
        ],
      ),
      position: vector.Vector3(-0.125, 0.2, 0.2),
      scale: vector.Vector3(0.0075, 0.0075, 0.01),
    );
  }

  // Nodeをタップしたときの動作を定義（タスクの削除）
  void _onTapHandler(String name) {
    final tapedNode = nodes.firstWhere((n) => n.name == name);
    if (tapedNode != null && tapedNode.name.contains('task_plane')) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: Text('タスクの削除'),
              content: Text('このタスクを削除しますか？'),
              actions: <Widget>[
                FlatButton(
                  child: Text('ok'),
                  onPressed: (){
                    arkitController.remove(name);
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

  // Nodeをパンしたときの動作を定義（タスクの横移動）
  void _onPanHandler(List<ARKitNodePanResult> pan) {
    for (var panNode in pan) {
      final node = nodes.firstWhere((n) => n.name == panNode.nodeName);
      if (node != null && node.name.contains('task_plane')) {
        final position = vector.Vector3(
          panNode.translation.x / 180,
          panNode.translation.y / -180,
          node.position.value.z
        );
        node.position.value = position;
      }
    }
  }
}
