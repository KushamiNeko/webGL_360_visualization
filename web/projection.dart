import "dart:math";

import "package:meta/meta.dart";

import "helper.dart";

//////////////////////////////////////////////////

List<num> _newIdentityMatrix() {
  List<num> matrix = List<num>.filled(16, 0, growable: false);

  matrix[0] = 1.0;
  matrix[5] = 1.0;
  matrix[10] = 1.0;
  matrix[15] = 1.0;

  return matrix;
}

//////////////////////////////////////////////////

class ProjectionCamera {
  num _fov;
  num _sizeX;
  num _sizeY;
  num _near;
  num _far;

  List<num> _position;

  List<num> _perspective;
  List<num> _camT;

//////////////////////////////////////////////////

  ProjectionCamera(
      {@required num fov,
      @required num near,
      @required num far,
      @required num sizeX,
      @required num sizeY,
      @required num x,
      @required num y,
      @required num z,
      String upAxis = "y"})
      : _fov = fov,
        _near = near,
        _far = far,
        _sizeX = sizeX,
        _sizeY = sizeY {
    if (upAxis.toLowerCase() == "y") {
      //_position = [x, y, z];
      _position = [x * 100, y * 100, z * 100];
    } else if (upAxis.toLowerCase() == "z") {
      _position = [x * 100, y * 100, z * 100];
    } else {
      throw Exception("up axis should be either y or z");
    }

    _getCamT();
    _getPerspective();
  }

//////////////////////////////////////////////////

  ProjectionCamera.setup(Map<String, dynamic> settings)
      : this(
          fov: settings["fov"],
          near: settings["near"],
          far: settings["far"],
          sizeX: settings["sizeX"],
          sizeY: settings["sizeY"],
          x: settings["x"],
          y: settings["y"],
          z: settings["z"],
          upAxis: settings["upAxis"],
        );

//////////////////////////////////////////////////

  List<num> get perspective => _perspective;

//////////////////////////////////////////////////

  List<num> get camT => _camT;

//////////////////////////////////////////////////

  num get aspectRatio => _sizeX / _sizeY;

//////////////////////////////////////////////////

  void _getCamT() {
    var t = _newIdentityMatrix();

    t[12] = -_position[0];
    t[13] = -_position[1];
    t[14] = -_position[2];

    var id = _newIdentityMatrix();

    _camT = List<num>.filled(16, 0, growable: false);

    var index = 0;

    for (var col = 0; col < 4; col++) {
      for (var row = 0; row < 4; row++) {
        var sum = 0;

        for (var i = 0; i < 4; i++) {
          sum += t[i + col * 4] * id[row + i * 4];
        }

        _camT[index] = sum;
        index++;
      }
    }
  }

//////////////////////////////////////////////////

  void _getPerspective() {
    var matrix = List<num>.filled(16, 0, growable: false);
    var fovRadian = degreeToRadian(_fov);
    var viewRange = tan((fovRadian / 2.0) * _near);

    var sx =
        (2.0 * _near) / (viewRange * aspectRatio + viewRange * aspectRatio);
    var sy = _near / viewRange;
    var sz = -(_far + _near) / (_far - _near);
    var pz = -(2.0 * _far * _near) / (_far - _near);

    matrix[0] = sx;
    matrix[5] = sy;
    matrix[10] = sz;
    matrix[14] = pz;
    matrix[11] = -1.0;

    _perspective = matrix;
  }

//////////////////////////////////////////////////
}

//////////////////////////////////////////////////

class RoomProjection {
  ProjectionCamera _camera;
  List<num> _position;

  num _nx;
  num _ny;
  num _nz;
  num _nw;

//////////////////////////////////////////////////

  RoomProjection(
      {@required ProjectionCamera camera,
      @required num x,
      @required num y,
      @required num z,
      String upAxis = "y"})
      : _camera = camera {
    if (upAxis.toLowerCase() == "y") {
      //_position = [x, 0, z];
      _position = [x * 100, y * 100, z * 100];
    } else if (upAxis.toLowerCase() == "z") {
      _position = [x * 100, y * 100, z * 100];
    } else {
      throw Exception("up axis should be either y or z");
    }

    _calculate();
  }

//////////////////////////////////////////////////

  RoomProjection.setup(ProjectionCamera camera, Map<String, dynamic> setting)
      : this(
          camera: camera,
          x: setting["x"],
          y: setting["y"],
          z: setting["z"],
          upAxis: setting["upAxis"],
        );

//////////////////////////////////////////////////

  num get nx => _nx;

//////////////////////////////////////////////////

  num get ny => _ny;

//////////////////////////////////////////////////

  num get nz => _nz;

//////////////////////////////////////////////////

  void _calculate() {
    var v = List<num>.filled(4, 0, growable: false);
    v[0] = _position[0];
    v[1] = _position[1];
    v[2] = 0.0;
    v[3] = 1.0;

    v[0] = _camera.camT[0] * v[0] +
        _camera.camT[4] * v[1] +
        _camera.camT[8] * v[2] +
        _camera.camT[12] * v[3];
    v[1] = _camera.camT[1] * v[0] +
        _camera.camT[5] * v[1] +
        _camera.camT[9] * v[2] +
        _camera.camT[13] * v[3];
    v[2] = _camera.camT[2] * v[0] +
        _camera.camT[6] * v[1] +
        _camera.camT[10] * v[2] +
        _camera.camT[14] * v[3];
    v[3] = _camera.camT[3] * v[0] +
        _camera.camT[7] * v[1] +
        _camera.camT[11] * v[2] +
        _camera.camT[15] * v[3];

    var vc = List<num>.filled(4, 0, growable: false);

    vc[0] = _camera.perspective[0] * v[0] +
        _camera.perspective[4] * v[1] +
        _camera.perspective[8] * v[2] +
        _camera.perspective[12] * v[3];
    vc[1] = _camera.perspective[1] * v[0] +
        _camera.perspective[5] * v[1] +
        _camera.perspective[9] * v[2] +
        _camera.perspective[13] * v[3];
    vc[2] = _camera.perspective[2] * v[0] +
        _camera.perspective[6] * v[1] +
        _camera.perspective[10] * v[2] +
        _camera.perspective[14] * v[3];
    vc[3] = _camera.perspective[3] * v[0] +
        _camera.perspective[7] * v[1] +
        _camera.perspective[11] * v[2] +
        _camera.perspective[15] * v[3];

    _nx = vc[0];
    _ny = vc[1];
    _nz = vc[2];
    _nw = vc[3];

    _nx = ((_nx / _nw) + 1.0) / 2.0;
    _ny = ((_ny / _nw) + 1.0) / 2.0;
    _nz = ((_nz / _nw) + 1.0) / 2.0;

    _nx *= 100.0;
    _ny *= 100.0;
    _nz *= 100.0;
  }

//////////////////////////////////////////////////
}

//////////////////////////////////////////////////
