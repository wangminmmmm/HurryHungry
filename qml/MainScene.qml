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

  Connections {
      target: activeScene === mainScene ? nativeUtils : null
      onMessageBoxFinished: {
        console.debug("the user confirmed the Ok/Cancel dialog with:", accepted)
        if(accepted && exitDialogShown) {
          Qt.quit()
        } else if(accepted && vplayLinkShown) {
          flurry.logEvent("MainScene.Show.VPlayWeb")
          nativeUtils.openUrl("https://felgo.com/showcases/?utm_medium=game&utm_source=chickenoutbreak&utm_campaign=chickenoutbreak#chicken_outbreak");
        }


        exitDialogShown = false
        vplayLinkShown = false
      }
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
      text: qsTr("Highscores")

      width: 170 * 0.8
      height: 60 * 0.8

      onClicked: {
        window.state = "gameNetwork"
        gameNetwork.showLeaderboard()
      }
    }

//    MenuButton {
//      text: qsTr("Game Center")

//      width: 170 * 0.8
//      height: 60 * 0.8

//      // this button opens the gamecenter leaderboards - only show it if the gamecenter is available (so iOS only)
//      // still show the Game Center button, as on iOS it is also very popular!
//      // on iOS VPGN and GameCenter both can be used together
//      visible: gameCenter.authenticated

//      onClicked: {
//          flurry.logEvent("GameCenter.Show")
//          gameCenter.showLeaderboard();
//      }
//    }

    MenuButton {
      text: qsTr("Credits")

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

  /*Image {
   id: logo
    anchors.right: mainScene.gameWindowAnchorItem.right
    anchors.rightMargin: 10
    anchors.bottom: mainScene.gameWindowAnchorItem.bottom
    anchors.bottomMargin: 10
    source: "../assets/img/felgo-logo.png"
    fillMode: Image.PreserveAspectFit
    height: 55

    MouseArea {
      anchors.fill: parent
      onClicked: {
        vplayLinkShown = true
        flurry.logEvent("MainScene.ShowDialog.VPlayWeb")
        nativeUtils.displayMessageBox(qsTr("Felgo"), qsTr("This game is built with Felgo. The source code is available in the free Felgo SDK - so you can build your own Chicken Outbreak in minutes! Visit Felgo.net now?"), 2)
      }
    }

    SequentialAnimation {
      running: true
      loops: -1
      NumberAnimation { target: logo; property: "opacity"; to: 0.1; duration: 1200 }
      NumberAnimation { target: logo; property: "opacity"; to: 1; duration: 1200 }
    }
  }*/

  Keys.onReturnPressed: {
    window.state = "game"
  }
}
