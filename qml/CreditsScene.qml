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

  Column {
    anchors.horizontalCenter: parent.horizontalCenter
    y: 10

    MenuText {
      text: qsTr("Credits")
      font.pixelSize: 35
    }

    Item {
      width: 1
      height: 35
    }

    MenuText {
      text: qsTr("Art:")
    }

    MenuText {
      text: "Astrid Handlechner"
    }

    Item {
      width: 1
      height: 25
    }

    MenuText {
      text: qsTr("Sound:")
    }

    MenuText {
      text: "\"Two Fat Gangsters\""
    }

    MenuText {
      text: "(playonloop.com)"
      MouseArea {
        onClicked: nativeUtils.openUrl("http://playonloop.com");
      }
    }

    Item {
      width: 1
      height: 30
    }

    Item {
      width: vplayCredits.width
      height: vplayCredits.height

      Column {
        id: vplayCredits
        width: scene.parent.width
        spacing: 4

        MenuText {
          text: qsTr("Source code available with")
        }
        Item {
          width: parent.width
          height: vplayLogo.height
          Image {
            id: vplayLogo
            anchors.horizontalCenter: parent.horizontalCenter
            source: "../assets/img/felgo.png"

            fillMode: Image.PreserveAspectFit
            height: 50
          }
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