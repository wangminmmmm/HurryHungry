import QtQuick 2.0
import Felgo 3.0
import QtMultimedia 5.0

GameWindow {
  id: window
  screenWidth: 640
  screenHeight: 960

  property alias level: scene.level
  property alias player: scene.player
  property int maximumHighscore: 0
  property int lastScore: 0         //save after each score update

  onMaximumHighscoreChanged: {
      gameNetwork.reportScore(maximumHighscore)
  }

  BackgroundMusic {
    id: backgroundMusic
    source: "../assets/snd/bgm.wav"
    autoPlay: true
  }

  FontLoader {                     //字体加载器
    id: fontHUD
    source: "fonts/pf_tempesta_seven_compressed.ttf"
  }


  FelgoGameNetwork {               //调用 最高分qml
   id: gameNetwork

   gameId: 1
   secret: "ultra-strong-password"         //Set this string property to the secret set in the Web Dashboard.

   //read and update the new highscore synchronously
   onUserScoresInitiallySyncedChanged: {
     if(userScoresInitiallySynced) {
       console.debug("the game's user highscore got synced with the server, maximumHighScore:", maximumHighscore, ", userHighscoreForCurrentActiveLeaderboard:", gameNetwork.userHighscoreForCurrentActiveLeaderboard)

        if(maximumHighscore>0 && maximumHighscore > gameNetwork.userHighscoreForCurrentActiveLeaderboard) {
         console.debug("there was a highscore reached in a previous version before game was used upload it to the server now..")

         gameNetwork.reportScore(maximumHighscore)
       } else if(gameNetwork.userHighscoreForCurrentActiveLeaderboard > maximumHighscore) {
         console.debug("there was a higher score reached on a different device update the local maximumHighscore now")
          maximumHighscore = gameNetwork.userHighscoreForCurrentActiveLeaderboard
       }
     }
   }

  onNewHighscore: {
     if(!system.publishBuild) {
      nativeUtils.displayMessageBox("New highscore reached for leaderboard " + leaderboard + ": " + Math.round(highscore))
     }
   }
  }

  MainScene {
    id: mainScene
    opacity: 0
  }

  HurryHungryScene {
    id: scene
    opacity: 0
    onVisibleChanged: console.debug("GameScene changed visible to", visible)
  }

  GameOverScene {
    id: gameOverScene
    opacity: 0
  }

  AboutScene {
    id: aboutScene
     opacity: 0
  }


   EntityManager {
    id: entityManager
    entityContainer: scene.entityContainer
    poolingEnabled: true
   }

   property string lastActiveState: ""

  onStateChanged: {

    console.debug("HunrryHungryMain: changed state to", state)

    if(state === "main")
      activeScene = mainScene;
    else if(state === "game")
      activeScene = scene;
    else if(state === "gameOver")
      activeScene = gameOverScene;
    else if(state === "about")
      activeScene = aboutScene;

    lastActiveState = state;
  }

  state: "main"                 //场景状态
   states: [
    State {
      name: "main"
       PropertyChanges { target: mainScene; opacity: 1}

    },
    State {
      name: "game"
      PropertyChanges { target: scene; opacity: 1}
      StateChangeScript {
        script: {
          console.debug("entered state 'game'")
          scene.enterScene();
        }
      }
    },
    State {
      name: "gameOver"
      PropertyChanges { target: gameOverScene; opacity: 1}
      StateChangeScript {
        script: {
          console.debug("entered state 'gameOver'")
          gameOverScene.enterScene();
        }
      }
    },
    State {
      name: "about"
      PropertyChanges { target: aboutScene; opacity: 1}
    }
  ]
}
