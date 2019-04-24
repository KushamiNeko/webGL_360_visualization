import "helper.dart";
import "room.dart";
import "scene.dart";
//import "control.dart";

//////////////////////////////////////////////////

var mock = {
  "map": "images_new/map.png",
  "projection": {
    "fov": 45,
    "near": 0.1,
    "far": 100,
    "x": 0.36923,
    "y": 6.39093,
    "z": 17.82704,
    "sizeX": 2048,
    "sizeY": 2048,
    "upAxis": "z",
  },
  "rooms": [
    {
      "tag": "front door",
      "img": "images_new/front_door.jpg",
      "x": -0.25527,
      "y": 1.11499,
      "z": 1.6,
      "upAxis": "z",
    },
    {
      "tag": "shoes closet",
      "img": "images_new/shoes_closet.jpg",
      "x": -0.25527,
      "y": 4.13063,
      "z": 1.6,
      "upAxis": "z",
    },
    {
      "tag": "clothes closet",
      "img": "images_new/clothes_closet.jpg",
      "x": -0.25527,
      "y": 7.73812,
      "z": 1.6,
      "upAxis": "z",
    },
    {
      "tag": "cash counter",
      "img": "images_new/cash_counter.jpg",
      "x": -0.79681,
      "y": 9.72238,
      "z": 1.6,
      "upAxis": "z",
    },
    {
      "tag": "toilet",
      "img": "images_new/toilet.jpg",
      "x": 2.15423,
      "y": 10.03155,
      "z": 1.6,
      "upAxis": "z",
    },
  ]
};

//////////////////////////////////////////////////

void main() {
  final String map = mock["map"];
  final Map<String, dynamic> projectionSettings = mock["projection"];
  final List<Map<String, dynamic>> blueprint = mock["rooms"];

  final List<Room> rooms = readBlueprint(projectionSettings, blueprint);

  final Scene scene = Scene(map: map, rooms: rooms);

  scene.animate();
}

//////////////////////////////////////////////////
