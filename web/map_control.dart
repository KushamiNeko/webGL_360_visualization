import 'dart:html';

//////////////////////////////////////////////////

class MapControl {
  static final num _collapse_size = (window.innerHeight * 0.5).floor();
  static final num _expand_size = (window.innerHeight * 0.9).floor();

  static final Element _map = querySelector("#map_container");

  bool _opened = false;

//////////////////////////////////////////////////

  MapControl() {
    _collapse();
  }

//////////////////////////////////////////////////

  void _expand() {
    _map.style.height = "${_expand_size.toString()}px";
    _map.style.width = "${_expand_size.toString()}px";
    final num map_offset = (window.innerWidth / 2) - (_expand_size / 2);
    _map.style.left = "${map_offset}px";

    _opened = true;
  }

//////////////////////////////////////////////////

  void _collapse() {
    _map.style.height = "${_collapse_size.toString()}px";
    _map.style.width = "${_collapse_size.toString()}px";
    _map.style.left = "1%";
    _map.style.top = "1%";

    _opened = false;
  }

//////////////////////////////////////////////////

  void toggle() {
    if (_opened) {
      _collapse();
    } else {
      _expand();
    }
  }
}

//////////////////////////////////////////////////

class Arrow {
  final Element _arrow = querySelector("#arrow");

  num _index;

  Arrow(this._index) {
    _arrow.style.left = "";
    _arrow.style.bottom = "";
  }

  set index(num index) {
    _index = index;
    _arrow.style.left = "";
    _arrow.style.bottom = "";
  }
}

//function Get2DArrow(current_index) {
//this.arrow = document.getElementById('arrow');

//this.current_index = current_index;

//this.set_position = function(index) {
//this.current_index = index;
//this.arrow.style.left = button2D_collection[index].position[0] - 1 + '%';
//this.arrow.style.bottom = button2D_collection[index].position[1] - 1 + '%';
//}

//this.arrow.style.left = button2D_collection[current_index].position[0] - 1 + '%';
//this.arrow.style.bottom = button2D_collection[current_index].position[1] - 1 + '%';
//}

//////////////////////////////////////////////////

class MapButton {
  num left;
  num bottom;
  String tag;

  final ButtonElement button = ButtonElement();

  MapButton(this.tag, this.left, this.bottom) {
    button.style.left = "${left}%";
    button.style.bottom = "${bottom}%";
  }
}
