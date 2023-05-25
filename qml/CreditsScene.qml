import QtQuick 2.0
import Felgo 3.0
//about scene
SceneBase {

  onBackButtonPressed: {
    window.state = "main"
  }

   Keys.onReturnPressed: {
    window.state = "main"
  }

  MultiResolutionImage {
    source: "../assets/img/mainMenuBackground.png"
    anchors.centerIn: parent
  }
//the contains of this secen
  Column {
    anchors.horizontalCenter: parent.horizontalCenter
    y: 10

    MenuText {
      text: qsTr("About")
      font.pixelSize: 35
    }

    Item {
      width: 1
      height: 35
    }

    MenuText {
      text: qsTr("Operator:")//it introduces the operation of this game
    }

    MenuText {
      text: "mouse or arrow"
    }
    MenuText {
      text: "control the black's movement"
    }

    Item {
      width: 1
      height: 25
    }

    MenuText {
      text: qsTr("Context:")//it introduces the operation of this game's context
    }

    MenuText {
      text: "In the bakery,a coal ball is hungry"
    }
    MenuText {
      text: "and if he doesn't eat anything"
    }
    MenuText {
      text: "he will starve to death over time"
    }

    Item {
      width: 1
      height: 25
    }

    MenuText {
      text: qsTr("Author:")//about author
    }

    MenuText {
      text: "wanglingzhi zhenyuhan wangmin"
    }

    Item {
      width: 1
      height: 25
    }
  }


//this button is to back to main menu
  MenuButton {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.gameWindowAnchorItem.bottom
    anchors.bottomMargin: 30

    text: qsTr("Back")

    width: 170 * 0.8
    height: 60 * 0.8

    onClicked: window.state = "main"
  }
}
