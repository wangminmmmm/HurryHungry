import QtQuick 2.0
import Felgo 3.0
//this show gameo scene when you are die
SceneBase {

  onBackButtonPressed: {
    window.state = "main"
  }

  Keys.onReturnPressed: {
    window.state = "main"
  }

  BackgroundImage {
    source: "../assets/img/gameOverScreen.png"
    anchors.centerIn: parent
  }

  Image {
    x: 50
    y: 120
    scale: 0.3
    source: "../assets/img/dead1.png"
  }


  MenuText {
    y: 40
    text: qsTr("Game Over")
    font.pixelSize: 35
  }

  MenuText {
    id: scoreText
    y: 300
    text: qsTr("Your score: ") + lastScore
  }

  MenuText {
    id: newMaximumHighscore
    text: qsTr("New highscore!!!")
    font.pixelSize: 14
    color: "#8f2727"
    visible: true
    anchors.top: scoreText.bottom
    anchors.topMargin: 10
  }

  MenuButton {
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 30
    text: qsTr("Continue")
    onClicked: window.state = "main"
  }

  function enterScene() {

    if(lastScore > maximumHighscore) {
      maximumHighscore = lastScore;
      newMaximumHighscore.visible = true;
    } else
      newMaximumHighscore.visible = false;

     var grains = player.bonusScore;
    var deaths = player.deaths;

    console.log("Collected grains:", grains);

    if (grains >= 10) {
      gameNetwork.unlockAchievement("grains10", true)
    } if (grains >= 25) {
      gameNetwork.unlockAchievement("grains25", true)
    } if (grains >= 50) {
      gameNetwork.unlockAchievement("grains50", true)
    } if (deaths >= 10){
      gameNetwork.unlockAchievement("blackdead", true)
    }


    console.log("Player's death count:", deaths);
  }

}
