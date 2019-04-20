import "dart:html";
import "room.dart";

//////////////////////////////////////////////////

class MainControl {
  final num _mapCollapseSize = (window.innerHeight * 0.5).floor();
  final num _mapExpandSize = (window.innerHeight * 0.9).floor();

  final Element _mapContainer = querySelector("#map_container");
  final Element _mapArrow = querySelector("#map_arrow");

  bool _mapIsOpen = false;

  final ButtonElement _roomButton = querySelector("#change_room_button");

  final List<ButtonElement> _mapButtons = List();

  final List<Room> _rooms;

  Room _currentRoom;
  Room _nextRoom;

//////////////////////////////////////////////////

  MainControl({String mapImg, List<Room> rooms}) : _rooms = rooms {
    final ImageElement map = querySelector("#map");
    map.src = mapImg;

    noEntry();

    _roomButton.onClick.listen((MouseEvent event) {
      changeRoom(_nextRoom);
    });

    querySelector("#map_toggle_button").onClick.listen((MouseEvent event) {
      _toggleMap();
    });

    _minimizeMap();

    _projectButtons();
  }

//////////////////////////////////////////////////

  Room get currentRoom => _currentRoom;

//////////////////////////////////////////////////

  num get changeThreshould => 15;

//////////////////////////////////////////////////

  void _projectButtons() {
    for (var room in _rooms) {
      final ButtonElement button = ButtonElement();
      button.innerHtml = room.tag;
      button.classes.add("map_button");

      button.style.left = "${room.nx}%";
      button.style.bottom = "${room.ny}%";

      button.onClick.listen((MouseEvent event) {
        changeRoom(room);
      });

      _mapButtons.add(button);

      _mapContainer.append(button);
    }
  }

//////////////////////////////////////////////////

  void changeRoom(Room newRoom) {
    if (_currentRoom != null && _currentRoom.isChanging) {
      return;
    }

    if (newRoom.isChanging) {
      return;
    }

    _currentRoom?.leaving();
    newRoom?.entering();
    _currentRoom = newRoom;

    _mapArrow.style.left = "${newRoom.nx}%";
    _mapArrow.style.bottom = "${newRoom.ny}%";
  }

//////////////////////////////////////////////////

  void showNextRoom(Room nextRoom) {
    _roomButton.innerHtml = "Go to ${nextRoom.tag}";
    _roomButton.style.opacity = "1";
    _roomButton.disabled = false;
    _nextRoom = nextRoom;
  }

//////////////////////////////////////////////////

  void noEntry() {
    _roomButton.style.opacity = "0";
    _roomButton.disabled = true;
  }

//////////////////////////////////////////////////

  void showMap() {
    _mapContainer.style.opacity = "1.0";
  }

//////////////////////////////////////////////////

  void hideMap() {
    _mapContainer.style.opacity = "0";
  }

//////////////////////////////////////////////////

  void rotateMapArrow(num degree) {
    _mapArrow.style.transform = "rotate(${degree}deg)";
  }

//////////////////////////////////////////////////

  void _maximizeMap() {
    _mapContainer.style.height = "${_mapExpandSize.toString()}px";
    _mapContainer.style.width = "${_mapExpandSize.toString()}px";
    final num mapOffset = (window.innerWidth / 2) - (_mapExpandSize / 2);
    _mapContainer.style.left = "${mapOffset}px";

    _mapButtons.forEach((ButtonElement b) => b.style.opacity = "1");

    _mapIsOpen = true;
  }

//////////////////////////////////////////////////

  void _minimizeMap() {
    _mapContainer.style.height = "${_mapCollapseSize.toString()}px";
    _mapContainer.style.width = "${_mapCollapseSize.toString()}px";
    _mapContainer.style.left = "1%";
    _mapContainer.style.top = "1%";

    _mapButtons.forEach((ButtonElement b) => b.style.opacity = "0");

    _mapIsOpen = false;
  }

//////////////////////////////////////////////////

  void _toggleMap() {
    if (_mapIsOpen) {
      _minimizeMap();
    } else {
      _maximizeMap();
    }
  }

//////////////////////////////////////////////////
}

//////////////////////////////////////////////////
