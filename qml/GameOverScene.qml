import QtQuick 2.0
import Felgo 3.0

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
    id:gameover
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
    id:restart
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 30
    text: qsTr("Continue")
    onClicked: {
        backgroundMusic.play();
        window.state = "main";
    }
  }

  SoundEffect {
    id: gameoverSound
    source: "../assets/snd/lose.wav"
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
      gameNetwork.unlockAchievement("blackdead", true);
    }

    if(player.deaths){
        backgroundMusic.stop();
        gameoverSound.play();
    }

    console.log("Player's death count:", deaths);
  }

}
