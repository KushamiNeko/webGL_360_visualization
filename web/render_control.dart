import "dart:html";
import "dart:js";
import "dart:math" as math;

//////////////////////////////////////////////////

class _Camera {
  num fov = 60;

  num lon = 0;
  num lat = 0;
  num phi = 0;
  num theta = 0;

  final num animation_speed = 0.15;

  num startX = 0;
  num startY = 0;

  num startLon = 0;
  num startLat = 0;
}

//////////////////////////////////////////////////

class Scene {
  final BodyElement _container = querySelector("body");

  final JsObject _threeLoader = JsObject(context["THREE"]["TextureLoader"]);

  final JsObject _threeScene = JsObject(context["THREE"]["Scene"]);

  final JsObject _threeRenderer = JsObject(context["THREE"]["WebGLRenderer"], [
    JsObject.jsify({"antialias": true})
  ]);

  final JsObject _threeCamera = JsObject(context["THREE"]["PerspectiveCamera"],
      [60, window.innerWidth / window.innerHeight, 1, 1000]);

  final JsObject _threeCubeCamera =
      JsObject(context["THREE"]["CubeCamera"], [1, 10000, 512]);

  final _Camera _camera = _Camera();

//////////////////////////////////////////////////

  bool _listening = false;

//////////////////////////////////////////////////

  Scene() {
    _threeCamera["position"]["z"] = 500;

    _threeLoader["crossOrigin"] = "anonymous";

    _threeRenderer.callMethod("setPixelRatio", [window.devicePixelRatio]);

    _threeRenderer
        .callMethod("setSize", [window.innerWidth, window.innerHeight]);

    _container.append(_threeRenderer["domElement"]);

    //_threeCubeCamera["renderTarget"]["texture"]["minFilter"] =
    //context["THREE"]["LinearMipMapLinearFilter"];

    //_threeScene.callMethod("add", [_threeCubeCamera]);

    _container.onMouseDown.listen(_mouse_down);
    _container.onMouseMove.listen(_mouse_move);
    _container.onMouseUp.listen(_mouse_up);

    //window.addEventListener('resize', onWindowResized, false);
    //onWindowResized(null);
  }

//////////////////////////////////////////////////

  JsObject get loader => _threeLoader;

//////////////////////////////////////////////////

  JsObject get scene => _threeScene;

//////////////////////////////////////////////////

  void _mouse_down(MouseEvent event) {
    _camera.startX = event.client.x;
    _camera.startY = event.client.y;

    _camera.startLon = _camera.lon;
    _camera.startLat = _camera.lat;

    _listening = true;
  }

//////////////////////////////////////////////////

  void _mouse_move(MouseEvent event) {
    if (_listening) {
      _camera.lon = (event.client.x - _camera.startX) * 0.1 + _camera.startLon;
      _camera.lat = (event.client.y - _camera.startY) * 0.1 + _camera.startLat;
    }
  }

//////////////////////////////////////////////////

  void _mouse_up(MouseEvent event) {
    _listening = false;
  }

//////////////////////////////////////////////////

  //void _animate(num highResTime) {
  //render();
  //}

//////////////////////////////////////////////////

  void render() {
    //DateTime time = DateTime.now();
    _threeRenderer.callMethod("render", [_threeScene, _threeCamera]);
    return;

    _camera.lat = math.max(-85, math.min(85, _camera.lat));
    _camera.phi =
        context["THREE"]["Math"].callMethod("degToRad", [90 - _camera.lat]);
    _camera.theta =
        context["THREE"]["Math"].callMethod("degToRad", [_camera.lon]);

    num degreeRange =
        (context["THREE"]["Math"].callMethod("radToDeg", [_camera.theta]) % 360)
            .abs();

    _detectChangeThreshold([], degreeRange);
    //_arrow_animation();

    _threeCamera["position"]["x"] =
        100 * math.sin(_camera.phi) * math.cos(_camera.theta);
    _threeCamera["position"]["y"] = 100 * math.cos(_camera.phi);
    _threeCamera["position"]["z"] =
        100 * math.sin(_camera.phi) * math.sin(_camera.theta);

    //if (button_obj.change_done === false) {
    //change_room_animation(
    //room_collection[button_obj.previous_index], room_collection[button_obj.current_index]);
    //}

    _threeCamera.callMethod("lookAt", [_threeScene["position"]]);
    _threeCubeCamera.callMethod("update", [_threeRenderer, _threeScene]);
    _threeRenderer.callMethod("render", [_threeScene, _threeCamera]);

    window.requestAnimationFrame((num highResTime) => render());
  }

//////////////////////////////////////////////////

  void _detectChangeThreshold(List rooms, num degree) {}

//////////////////////////////////////////////////

//function change_threshold_detect(room_collection, degree) {
//for (i = 0; i < total_room; i++) {
//if (i === button_obj.current_index) {
//continue;
//} else {

//var room = room_collection[i];
//var current_positon = new THREE.Vector3(button_obj.current_position[0], 0,
//button_obj.current_position[1]);

//var target_position_data = room.position;
//var target_room_position = new THREE.Vector3(target_position_data[0],
//0, target_position_data[1]);

//var target_direction = new THREE.Vector3();
//target_direction.subVectors(target_room_position, current_positon);
//target_direction.normalize();

//var camera_direction = camera_obj.camera.getWorldDirection();
//camera_direction.setY(0);
//camera_direction.normalize();

//var dot_prod = target_direction.dot(camera_direction);

//var delta_radian = Math.acos(dot_prod);
//var delta_degree = THREE.Math.radToDeg(delta_radian);

//if (delta_degree < button_obj.change_room_threshold) {
//button_obj.button.style.visibility = 'visible';
//button_obj.button.disabled = false;
//button_obj.set_innerHTML(room.tag);
//button_obj.target_index = room.index;
//return;
//} else {
//button_obj.button.style.visibility = 'hidden';
//button_obj.button.disabled = true;
//}
//}
//}
//}

/////////////////////////////////////////////////////////////////////////////////////////////////////

//function onDocumentMouseWheel(event) {
//event.preventDefault();
//event.stopPropagation();

//camera_obj.fov += (event.deltaY / Math.abs(event.deltaY)) * 3.5;

//if (camera_obj.fov < 16) {
//camera_obj.fov = 16;
//}
//if (camera_obj.fov > 70) {
//camera_obj.fov = 70;
//}

//camera_obj.camera.projectionMatrix.makePerspective(camera_obj.fov,
//container.offsetWidth / container.offsetHeight, 1, 1100);
//}

//var background = new MakeRoom(null, 'background', -1, 1, 0, 0);

/////////////////////////////////////////////////////////////////////////////////////////////////////

}
