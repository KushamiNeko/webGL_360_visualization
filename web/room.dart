import "dart:js";

import "package:meta/meta.dart";

import "projection.dart";

//////////////////////////////////////////////////

class Room {
  JsObject _texture;
  JsObject _material;
  JsObject _geometry;
  JsObject _mesh;

  String _tag;
  List<num> _position;

  bool _isChanging = false;

  final num _changeSpeed = 0.05;

  void Function() _animate;

  num _nx;
  num _ny;

//////////////////////////////////////////////////

  Room(
      {@required ProjectionCamera camera,
      @required String img,
      @required String tag,
      @required num x,
      @required num y,
      @required num z,
      String upAxis = "y"})
      : _tag = tag {
    if (upAxis.toLowerCase() == "y") {
      _position = [x, 0, z];
    } else if (upAxis.toLowerCase() == "z") {
      _position = [-y, 0, -x];
    } else {
      throw Exception("up axis should be either y or z");
    }

    final JsObject loader = JsObject(context["THREE"]["TextureLoader"]);
    _texture = loader.callMethod("load", [img]);

    _texture["mapping"] = context["THREE"]["SphericalReflectionMapping"];
    _texture["filter"] = context["THREE"]["LinearMipMapLinearFilter"];
    _texture["wrapS"] = context["THREE"]["RepeatWrapping"];
    _texture["wrapT"] = context["THREE"]["RepeatWrapping"];

    _material = JsObject(context["THREE"]["MeshBasicMaterial"], [
      JsObject.jsify({"map": _texture, "transparent": true, "opacity": 0})
    ]);

    _geometry = new JsObject(context["THREE"]["SphereGeometry"], [600, 64, 64]);

    _geometry.callMethod("scale", [-1, 1, 1]);

    _mesh = JsObject(context["THREE"]["Mesh"], [_geometry, _material]);

    final RoomProjection projection =
        RoomProjection(camera: camera, x: x, y: y, z: z, upAxis: upAxis);

    _nx = projection.nx;
    _ny = projection.ny;
  }

//////////////////////////////////////////////////

  num get opacity => _material["opacity"];

//////////////////////////////////////////////////

  num get nx => _nx;

//////////////////////////////////////////////////

  num get ny => _ny;

//////////////////////////////////////////////////

  JsObject get mesh => _mesh;

//////////////////////////////////////////////////

  String get tag => _tag;

//////////////////////////////////////////////////

  List<num> get position => _position;

//////////////////////////////////////////////////

  bool get isChanging => _isChanging;

//////////////////////////////////////////////////

  void Function() get animate => _animate;

//////////////////////////////////////////////////

  set opacity(num newOpacity) {
    if (newOpacity > 1) {
      _material["opacity"] = 1;
    } else if (newOpacity < 0) {
      _material["opacity"] = 0;
    } else {
      _material["opacity"] = newOpacity;
    }
  }

//////////////////////////////////////////////////

  void entering() {
    if (_isChanging) {
      return;
    }

    _isChanging = true;

    _animate = () {
      if (opacity < 1) {
        opacity += _changeSpeed;
      } else {
        _isChanging = false;
      }
    };
  }

//////////////////////////////////////////////////

  void leaving() {
    if (_isChanging) {
      return;
    }

    _isChanging = true;

    _animate = () {
      if (opacity > 0) {
        opacity -= _changeSpeed;
      } else {
        _isChanging = false;
      }
    };
  }

//////////////////////////////////////////////////
}
