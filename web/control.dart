import "dart:html";
import "room.dart";

//////////////////////////////////////////////////

class MainControl {
  final ButtonElement _button = querySelector("#change_room_button");

  Room _currentRoom;
  Room _nextRoom;

//////////////////////////////////////////////////

  MainControl() {
    noEntry();

    _button.onClick.listen((MouseEvent event) {
      changeRoom(_nextRoom);
    });
  }

//////////////////////////////////////////////////

  Room get currentRoom => _currentRoom;

//////////////////////////////////////////////////

  num get changeThreshould => 15;

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
  }

//////////////////////////////////////////////////

  void showNextRoom(Room nextRoom) {
    _button.innerHtml = "Go to ${nextRoom.tag}";
    _button.style.visibility = "visible";
    _button.disabled = false;
    _nextRoom = nextRoom;
  }

//////////////////////////////////////////////////

  void noEntry() {
    _button.style.visibility = "hidden";
    _button.disabled = true;
  }

//////////////////////////////////////////////////
}

//////////////////////////////////////////////////
