import "dart:html";

//////////////////////////////////////////////////

class MapControl {
  final num _collapse_size = (window.innerHeight * 0.5).floor();
  final num _expand_size = (window.innerHeight * 0.9).floor();

  final Element _container = querySelector("#map_container");
  final ImageElement _map = querySelector("#map");
  final Element _arrow = querySelector("#map_arrow");

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
    _container.style.opacity = "1.0";
  }

//////////////////////////////////////////////////

  void hide() {
    _container.style.opacity = "0";
  }

//////////////////////////////////////////////////

  void rotateArrow(num degree) {
    _arrow.style.transform = "rotate(${degree}deg)";
  }

//////////////////////////////////////////////////

  set src(String img) => _map.src = img;

//////////////////////////////////////////////////

  void _expand() {
    _container.style.height = "${_expand_size.toString()}px";
    _container.style.width = "${_expand_size.toString()}px";
    final num map_offset = (window.innerWidth / 2) - (_expand_size / 2);
    _container.style.left = "${map_offset}px";

    _opened = true;
  }

//////////////////////////////////////////////////

  void _collapse() {
    _container.style.height = "${_collapse_size.toString()}px";
    _container.style.width = "${_collapse_size.toString()}px";
    _container.style.left = "1%";
    _container.style.top = "1%";

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
