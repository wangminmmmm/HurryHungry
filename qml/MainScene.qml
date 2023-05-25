import QtQuick 2.0
import Felgo 3.0

SceneBase {
  id: mainScene

  property bool exitDialogShown: false
  property bool vplayLinkShown: false

  onBackButtonPressed: {
    exitDialogShown = true
    nativeUtils.displayMessageBox(qsTr("Really quit the game?"), "", 2);
  }



  MultiResolutionImage {
    source: "../assets/img/mainMenuBackground.png"
    anchors.centerIn: parent
  }

  Column {
    spacing: 15
    anchors.horizontalCenter: parent.horizontalCenter
    y: 5

    MenuText {
      text: qsTr("Hunrry Hungry")
      font.pixelSize: 35
    }

    MenuText {
      text: qsTr("Highscore: ") + gameNetwork.userHighscoreForCurrentActiveLeaderboard
    }


    Item {
      width: 1
      height: 0
    }

    MenuButton {
      text: qsTr("Play")
      onClicked: window.state = "game"
      textSize: 30
    }

    Item {
      width: 1
      height: 25
    }    


    MenuButton {
      text: qsTr("About")

      width: 170 * 0.8
      height: 60 * 0.8

      onClicked: window.state = "credits";
    }

    MenuButton {
      text: settings.soundEnabled ? qsTr("Sound on") : qsTr("Sound off")

      width: 170 * 0.8
      height: 60 * 0.8

      onClicked: {
        settings.soundEnabled = !settings.soundEnabled
        settings.musicEnabled = settings.soundEnabled
      }


    }
  }


  Keys.onReturnPressed: {
    window.state = "game"
  }
}
