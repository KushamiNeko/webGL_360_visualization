import "scene.dart";
import "room.dart";

//////////////////////////////////////////////////

void main() {
  final livingRoom =
      Room(img: "images/living_room.jpg", tag: "living room", x: 0, y: 0, z: 0);

  final kitchen =
      Room(img: "images/kitchen.jpg", tag: "kitchen", x: 250, y: 0, z: 0);

  final workingRoom = Room(
      img: "images/living_room_02.jpg",
      tag: "working room",
      x: 0,
      y: 0,
      z: -250);

  final rooms = [livingRoom, kitchen, workingRoom];

  final scene = Scene(rooms: rooms);

  scene.animate();
}

//////////////////////////////////////////////////
