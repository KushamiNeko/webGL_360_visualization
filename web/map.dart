import "dart:html";

//////////////////////////////////////////////////

class MapControl {
  static final num _collapse_size = (window.innerHeight * 0.5).floor();
  static final num _expand_size = (window.innerHeight * 0.9).floor();

  static final Element _map = querySelector("#map_container");

  bool _opened = false;

//////////////////////////////////////////////////

  MapControl() {
    _collapse();
    querySelector("#map_toggle_button").onClick.listen((MouseEvent event) {
      _toggle();
    });
  }

//////////////////////////////////////////////////

  void show() {
    _map.style.opacity = "1.0";
  }

//////////////////////////////////////////////////

  void hide() {
    _map.style.opacity = "0";
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

  void _toggle() {
    if (_opened) {
      _collapse();
    } else {
      _expand();
    }
  }

//////////////////////////////////////////////////
}

//////////////////////////////////////////////////
