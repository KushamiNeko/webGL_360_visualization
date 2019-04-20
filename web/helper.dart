import "dart:math";
import "room.dart";
import "projection.dart";

//////////////////////////////////////////////////

num degreeToRadian(num degree) {
  return degree * (pi / 180.0);
}

//////////////////////////////////////////////////

num radianToDegree(num radian) {
  return radian * (180.0 / pi);
}

//////////////////////////////////////////////////

List<Room> readBlueprint(Map<String, dynamic> projectionSettings,
    List<Map<String, dynamic>> blueprint) {
  final ProjectionCamera camera = ProjectionCamera.setup(projectionSettings);

  final List<Room> rooms = List();

  for (var setting in blueprint) {
    var room = Room(
      camera: camera,
      img: setting["img"],
      tag: setting["tag"],
      x: setting["x"],
      y: setting["y"],
      z: setting["z"],
      upAxis: setting["upAxis"],
    );

    rooms.add(room);
  }

  return rooms;
}

//////////////////////////////////////////////////
