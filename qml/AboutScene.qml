import QtQuick 2.0
import Felgo 3.0

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

  //the contains of this scene
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

    //it introduces the operation of this game
    MenuText {
      text: qsTr("Operator:")
    }

    MenuText {
      text: "mouse or arrow by keyboard"
      color: "#000000"
    }
    MenuText {
        color: "#000000"
      text: "control the black's movement"
    }

    Item {
      width: 1
      height: 25
    }

    //it introduces the operation of this game's context
    MenuText {
      text: qsTr("Context:")
    }

    MenuText {
      text: "In the bakery,a coal ball is too much hungry"
      color: "#000000"
    }
    MenuText {
        color: "#000000"
      text: "and if he doesn't eat anything"
    }
    MenuText {
        color: "#000000"
      text: "he will starve to death over time"
    }

    Item {
      width: 1
      height: 25
    }

    //about the author
    MenuText {
      text: qsTr("Author:")
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
