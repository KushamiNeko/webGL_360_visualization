import "dart:html";
import "dart:js";

//////////////////////////////////////////////////

class Room {
  JsObject _texture;
  JsObject _material;
  JsObject _geometry;
  JsObject _mesh;

  String _tag;
  List<num> _position;

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
      JsObject.jsify({"map": _texture})
    ]);

    _geometry = new JsObject(context["THREE"]["SphereGeometry"], [600, 64, 64]);

    _geometry.callMethod("scale", [-1, 1, 1]);

    _mesh = JsObject(context["THREE"]["Mesh"], [_geometry, _material]);
  }

//////////////////////////////////////////////////

  set opacity(num newOpacity) => _material["opacity"] = newOpacity;

//////////////////////////////////////////////////

  JsObject get mesh => _mesh;

//////////////////////////////////////////////////

  String get tag => _tag;

//////////////////////////////////////////////////

  List<num> get position => _position;

//////////////////////////////////////////////////
}
