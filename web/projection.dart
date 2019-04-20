import "helper.dart";
import "dart:math";

//////////////////////////////////////////////////

List<num> newIdenitytyMatrix() {
  List<num> matrix = List<num>.filled(16, 0, growable: false);

  matrix[0] = 1.0;
  matrix[5] = 1.0;
  matrix[10] = 1.0;
  matrix[15] = 1.0;

  return matrix;
}

//////////////////////////////////////////////////

class TopCamera {
  num fov;
  num sizeX;
  num sizeY;
  num near;
  num far;

  List<num> position;
  List<num> perspective;

  List<num> camT;

//////////////////////////////////////////////////

  TopCamera({num x, num y, num z, String upAxis = "y"}) {
    if (upAxis.toLowerCase() == "y") {
      position = [x, 0, z];
    } else if (upAxis.toLowerCase() == "z") {
      position = [-y, 0, -x];
    } else {
      throw Exception("up axis should be either y or z");
    }

    _getTranslation();
    _getPerspective();
  }

//////////////////////////////////////////////////

  num get aspectRatio => sizeX / sizeY;

//////////////////////////////////////////////////

  void _getTranslation() {
    var t = newIdenitytyMatrix();

    t[12] = -position[0];
    t[13] = -position[1];
    t[14] = -position[2];

    var id = newIdenitytyMatrix();

    camT = List<num>.filled(16, 0, growable: false);

    var index = 0;

    for (var col = 0; col < 4; col++) {
      for (var row = 0; row < 4; row++) {
        var sum = 0;

        for (var i = 0; i < 4; i++) {
          sum += t[i + col * 4] * id[row + i * 4];
        }

        camT[index] = sum;
        index++;
      }
    }
  }

//////////////////////////////////////////////////

  void _getPerspective() {
    var matrix = List<num>.filled(16, 0, growable: false);
    var fovRadian = degreeToRadian(fov);
    var viewRange = tan((fovRadian / 2.0) * near);

    var sx = (2.0 * near) / (viewRange * aspectRatio + viewRange * aspectRatio);
    var sy = near / viewRange;
    var sz = -(far + near) / (far - near);
    var pz = -(2.0 * far * near) / (far - near);

    matrix[0] = sx;
    matrix[5] = sy;
    matrix[10] = sz;
    matrix[14] = pz;
    matrix[11] = -1.0;

    perspective = matrix;
  }

//////////////////////////////////////////////////
}

//////////////////////////////////////////////////

class RoomCamera {
  TopCamera _camera;
  List<num> _position;

  num _nx;
  num _ny;
  num _nz;
  num _nw;

//////////////////////////////////////////////////

  RoomCamera({TopCamera camera, num x, num y, num z, String upAxis = "y"})
      : _camera = camera {
    if (upAxis.toLowerCase() == "y") {
      _position = [x, 0, z];
    } else if (upAxis.toLowerCase() == "z") {
      _position = [-y, 0, -x];
    } else {
      throw Exception("up axis should be either y or z");
    }
  }

//////////////////////////////////////////////////

  void calculate() {
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
  }

//////////////////////////////////////////////////
}

//////////////////////////////////////////////////
