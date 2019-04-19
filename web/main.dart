import "dart:html";
import "dart:js";

import "scene.dart";
import "room.dart";
import "map.dart";

//////////////////////////////////////////////////

void main() {
  final _ = MapControl();

  final Scene scene = Scene();
  final Room room = Room(img: "images/kitchen.jpg");

  scene.addMesh(room.mesh);

  scene.animate();
}

//////////////////////////////////////////////////
