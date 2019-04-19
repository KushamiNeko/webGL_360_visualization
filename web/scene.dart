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

  num startX = 0;
  num startY = 0;

  num startLon = 0;
  num startLat = 0;

  final num animationSpeed = 0.15;
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

  bool _listening = false;

//////////////////////////////////////////////////

  Scene() {
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
  }

//////////////////////////////////////////////////

  void animate() {
    _cameraRig.lat = math.max(-85, math.min(85, _cameraRig.lat));
    _cameraRig.phi =
        context["THREE"]["Math"].callMethod("degToRad", [90 - _cameraRig.lat]);
    _cameraRig.theta =
        context["THREE"]["Math"].callMethod("degToRad", [_cameraRig.lon]);

    //num degreeRange =
    //(context["THREE"]["Math"].callMethod("radToDeg", [_cameraRig.theta]) % 360)
    //.abs();

    //_detectChangeThreshold([], degreeRange);
    //_arrow_animation();

    _camera["position"]["x"] =
        100 * math.sin(_cameraRig.phi) * math.cos(_cameraRig.theta);
    _camera["position"]["y"] = 100 * math.cos(_cameraRig.phi);
    _camera["position"]["z"] =
        100 * math.sin(_cameraRig.phi) * math.sin(_cameraRig.theta);

    _camera.callMethod("lookAt", [_scene["position"]]);

    _renderer.callMethod("render", [_scene, _camera]);

    window.requestAnimationFrame((num highResTime) => animate());
  }

//////////////////////////////////////////////////

  void addMesh(JsObject mesh) {
    _scene.callMethod("add", [mesh]);
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
}
