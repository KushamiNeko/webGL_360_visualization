import "scene.dart";
import "room.dart";

//////////////////////////////////////////////////

var mock = {
  "top": {
    "fov": 45,
    "near": 0.1,
    "far": 100,
    "x": 0.36923,
    "y": 6.39093,
    "z": 17.82704,
    "sizeX": 2048,
    "sizeY": 2048,
    "upAxis": "z",
    "img": "images_new/map.png",
  },
  "rooms": [
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
    {
      "tag": "clothes closet",
      "img": "images_new/clothes_closet.jpg",
      "x": -0.25527,
      "y": 7.73812,
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
      "tag": "front door",
      "img": "images_new/front_door.jpg",
      "x": -0.25527,
      "y": 1.11499,
      "z": 1.6,
      "upAxis": "z",
    },
  ]
};

//////////////////////////////////////////////////

void main() {
  final List<Room> rooms = List();
  String map = "";

  mock.forEach((key, value) {
    if (key == "top") {
      var v = value as Map<String, dynamic>;
      map = v["img"];
    }

    if (key == "rooms") {
      for (var v in value) {
        var room = Room(
            img: v["img"],
            tag: v["tag"],
            x: v["x"],
            y: v["y"],
            z: v["z"],
            upAxis: v["upAxis"]);

        rooms.add(room);
      }
    }
  });

  final scene = Scene(rooms: rooms, map: map);

  scene.animate();
}

//////////////////////////////////////////////////
