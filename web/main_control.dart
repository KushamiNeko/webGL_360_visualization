import "dart:html";
import "dart:js";
import "render_control.dart";

class RoomControl {
  final ButtonElement _button = querySelector("#change_room_bottom");

  //final num _changeSpeed = 0.05;
  //final num _changeThreshold = 15;

  bool changeCompleted = true;

  //num _index;
  String _current_room_tag;
  //String _previous_room_tag;

  List<num> _position;

  RoomControl(this._current_room_tag) {
    _button.style.visibility = "hidden";
    _button.disabled = true;
  }

  String get tag => _current_room_tag;

  num get changeSpeed => 0.05;

  num get changeThreshold => 15;

  //List<num> get position => _position;

  set position(List<num> newPosition) {
    if (newPosition.length != 3) {
      throw Exception("Invalid position");
    }

    _position[0] = newPosition[0];
    _position[1] = newPosition[1];
    _position[2] = newPosition[2];
  }

  set roomTarget(String roomTag) {
    _button.innerHtml = "Go to ${roomTag}";
  }
}

//function MainControl(room_tag, current_index) {
//this.button = document.getElementById('btn');
//this.button.style.visibility = 'hidden';
//this.button.disabled = true;

//this.current_tag = room_tag;

//this.previous_index = current_index;
//this.current_index = current_index;
//this.current_position = [0, 0];

//this.target_index = -1;

//this.change_done = true;
//this.change_speed = 0.05;

//this.change_room_threshold = 15;

//this.set_innerHTML = function(tag) {
//this.button.innerHTML = 'Go to ' + tag;
//};

//this.set_current_position = function(position_data) {
//this.current_position[0] = position_data[0];
//this.current_position[1] = position_data[1];
//}

class Room {
  final JsObject _sphere =
      new JsObject(context["THREE"]["SphereGeometry"], [200, 64, 64]);

  JsObject _material = new JsObject(context["THREE"]["MeshBasicMaterial"]);

  //JsObject _material;
  JsObject _texture;

  JsObject _mesh;
  Scene _scene;

  String _tag;
  List<num> _position;

  Room(
      {Scene scene,
      String imgFile,
      String tag,
      num x,
      num y,
      num z,
      String upAxis = "y"})
      : _scene = scene,
        _tag = tag,
        _position = [x, y, z] {
    //_texture = scene.loader.callMethod("load", [imgFile]);
    final JsObject loader = new JsObject(context["THREE"]["TextureLoader"]);
    _texture = loader.callMethod("load", [imgFile]);
    //_texture["mapping"] = context["THREE"]["SphericalReflectionMapping"];
    //_texture["filter"] = context["THREE"]["LinearMipMapLinearFilter"];
    //_texture["wrapS"] = context["THREE"]["RepeatWrapping"];
    //_texture["wrapT"] = context["THREE"]["RepeatWrapping"];

    //_material = JsObject(context["THREE"]["MeshBasicMaterial"], [
    //JsObject.jsify({"map": _texture, "transparent": true})
    //]);

    _material["map"] = _texture;
    //_material["transparent"] = true;
    //_material["opacity"] = 1.0;

    _mesh = new JsObject(context["THREE"]["Mesh"], [_sphere, _material]);
    //_mesh["scale"]["x"] = -1;

    _scene.scene.callMethod("add", [_mesh]);
  }

  set opacity(num newOpacity) => _material["opacity"] = newOpacity;

  String get tag => _tag;

  List<num> get position => _position;
}

//function MakeRoom(file, tag, index, init_opacity, x, z) {
//var geo = new THREE.SphereGeometry(600, 64, 64);
//this.material = new THREE.MeshBasicMaterial();
//this.material.transparent = true;

//if (file !== null) {
//this.texture = loader.load(file);
//this.texture.mapping = THREE.SphericalReflectionMapping;
//this.texture.filter = THREE.LinearMipMapLinearFilter;
//this.texture.wrapS = THREE.RepeatWrapping;
//this.texture.wrapT = THREE.RepeatWrapping;

//this.material.map = this.texture;
//}

//this.mesh = new THREE.Mesh(geo, this.material);
//this.mesh.scale.x = -1;
//scene.add(this.mesh);

//this.set_opacity = function(opacity) {
//this.material.opacity = opacity;
//}

//this.tag = tag;
//this.index = index;

//this.position = [x, z];

//this.material.opacity = init_opacity;
//}
