import "dart:js";

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

//////////////////////////////////////////////////

  Room({String img, String tag, num x, num y, num z})
      : _tag = tag,
        _position = [x, y, z] {
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
  }

//////////////////////////////////////////////////

  num get opacity => _material["opacity"];

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
