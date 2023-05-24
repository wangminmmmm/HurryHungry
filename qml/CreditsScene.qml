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
<<<<<<< HEAD
      width: vplayCredits.width
      height: vplayCredits.height

      Column {
        id: vplayCredits
        width: scene.parent.width
        spacing: 4

        MenuText {
          text: qsTr("Source code available with")
        }

        MenuText {
          text: qsTr("Build your own game in minutes!")
        }
      }

      MouseArea {
        anchors.fill: vplayCredits
        onClicked: {

          nativeUtils.openUrl("https://felgo.com/showcases/?utm_medium=game&utm_source=chickenoutbreak&utm_campaign=chickenoutbreak#chicken_outbreak");
        }
      }
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
