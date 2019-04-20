import "dart:html";
import "helper.dart";
import "dart:js";
import "room.dart";
import "control.dart";
import "dart:math" as math;

//////////////////////////////////////////////////

class _Camera {
  //num fov = 60;

  num lon = 0;
  num lat = 0;
  num phi = 0;
  num theta = 0;

  num startX = 0;
  num startY = 0;

  num startLon = 0;
  num startLat = 0;

  final num animationSpeed = 0.2;
}

//////////////////////////////////////////////////

class Scene {
  final JsObject _camera = JsObject(context["THREE"]["PerspectiveCamera"],
      [60, window.innerWidth / window.innerHeight, 1, 1000]);

  final JsObject _scene = JsObject(context["THREE"]["Scene"]);

  final JsObject _renderer = JsObject(context["THREE"]["WebGLRenderer"], [
    JsObject.jsify({"antialias": true})
  ]);

  final _Camera _cameraRig = _Camera();

  final MainControl _control;

  bool _listening = false;

  List<Room> _rooms;

//////////////////////////////////////////////////

  Scene({MainControl control, List<Room> rooms})
      : _control = control,
        _rooms = rooms {
    for (Room room in _rooms) {
      _scene.callMethod("add", [room.mesh]);
    }

    _control.changeRoom(_rooms[0]);

    _renderer.callMethod("setPixelRatio", [window.devicePixelRatio]);
    _renderer.callMethod("setSize", [window.innerWidth, window.innerHeight]);
    querySelector("body").append(_renderer["domElement"]);

    window.onResize.listen((Event event) {
      _camera["aspect"] = window.innerWidth / window.innerHeight;
      _camera.callMethod("updateProjectionMatrix");
      _renderer.callMethod("setSize", [window.innerWidth, window.innerHeight]);
    });

    querySelector("body").onMouseDown.listen(_mouse_down);
    querySelector("body").onMouseMove.listen(_mouse_move);
    querySelector("body").onMouseUp.listen(_mouse_up);

    _control.showMap();
  }

//////////////////////////////////////////////////

  void animate() {
    _cameraRig.lat = math.max(-85, math.min(85, _cameraRig.lat));
    _cameraRig.phi = degreeToRadian(90 - _cameraRig.lat);
    _cameraRig.theta = degreeToRadian(_cameraRig.lon);

    _camera["position"]["x"] =
        100 * math.sin(_cameraRig.phi) * math.cos(_cameraRig.theta);
    _camera["position"]["y"] = 100 * math.cos(_cameraRig.phi);
    _camera["position"]["z"] =
        100 * math.sin(_cameraRig.phi) * math.sin(_cameraRig.theta);

    for (Room room in _rooms) {
      if (room.isChanging) {
        room.animate();
      }
    }

    lookAround();

    _control.rotateMapArrow(radianToDegree(_cameraRig.theta));

    _camera.callMethod("lookAt", [_scene["position"]]);

    _renderer.callMethod("render", [_scene, _camera]);

    window.requestAnimationFrame((num highResTime) => animate());
  }

//////////////////////////////////////////////////

  void _mouse_down(MouseEvent event) {
    _cameraRig.startX = event.client.x;
    _cameraRig.startY = event.client.y;

    _cameraRig.startLon = _cameraRig.lon;
    _cameraRig.startLat = _cameraRig.lat;

    _listening = true;
  }

//////////////////////////////////////////////////

  void _mouse_move(MouseEvent event) {
    if (_listening) {
      _cameraRig.lon =
          (event.client.x - _cameraRig.startX) * 0.1 + _cameraRig.startLon;
      _cameraRig.lat =
          (event.client.y - _cameraRig.startY) * 0.1 + _cameraRig.startLat;
    }
  }

//////////////////////////////////////////////////

  void _mouse_up(MouseEvent event) {
    _listening = false;
  }

//////////////////////////////////////////////////

  void lookAround() {
    final List<Room> targets = List();

    for (Room room in _rooms) {
      if (room.tag == _control.currentRoom.tag) {
        continue;
      }

      final JsObject targetDirection = JsObject(context["THREE"]["Vector3"], [
        room.position[0] - _control.currentRoom.position[0],
        room.position[1] - _control.currentRoom.position[1],
        room.position[2] - _control.currentRoom.position[2],
      ]);

      targetDirection.callMethod("normalize");

      JsObject cameraDirection = JsObject(context["THREE"]["Vector3"]);
      _camera.callMethod("getWorldDirection", [cameraDirection]);
      cameraDirection.callMethod("setY", [0]);
      cameraDirection.callMethod("normalize");

      final num dotProduct =
          targetDirection.callMethod("dot", [cameraDirection]);

      final num deltaRadian = math.acos(dotProduct);

      final num deltaDegree = radianToDegree(deltaRadian);

      if (deltaDegree < _control.changeThreshould) {
        targets.add(room);
      }
    }

    if (targets.isEmpty) {
      _control.noEntry();
    } else if (targets.length == 1) {
      _control.showNextRoom(targets[0]);
    } else {
      targets.sort((a, b) {
        var distanceA = math.sqrt(
            math.pow(a.position[0] - _control.currentRoom.position[0], 2) +
                math.pow(a.position[1] - _control.currentRoom.position[1], 2) +
                math.pow(a.position[2] - _control.currentRoom.position[2], 2));

        var distanceB = math.sqrt(
            math.pow(b.position[0] - _control.currentRoom.position[0], 2) +
                math.pow(b.position[1] - _control.currentRoom.position[1], 2) +
                math.pow(b.position[2] - _control.currentRoom.position[2], 2));

        if (distanceA < distanceB) {
          return -1;
        }

        if (distanceA == distanceB) {
          return 0;
        }

        if (distanceA > distanceB) {
          return 1;
        }
      });

      _control.showNextRoom(targets[0]);
    }
  }
}

//////////////////////////////////////////////////
