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
  property int lastScore: 0
  Component.onCompleted: {
  }
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


  FelgoGameNetwork {                  //调用 最高分qml
   id: gameNetwork

   gameId: 1
   secret: "ultra-strong-password"


   achievements: [

     Achievement {
       key: "grains10"
       name: "Hobby Collector"
       iconSource: "../assets/img/achievement_10grains.png"
       target: 10
       points: 10
       description: "Collect at least 10 grains in one game"
       descriptionAfterUnlocking: "Collected at least 10 grains in one game"
     },
     Achievement {
       key: "grains25"
       name: "Passionate Collector"
       iconSource: "../assets/img/achievement_25grains.png"
       target: 25
       points: 25
       description: "Collect at least 25 grains in one game"
       descriptionAfterUnlocking: "Collected at least 25 grains in one game"
     },
     Achievement {
       key: "grains50"
       name: "Obsessed Collector"
       iconSource: "../assets/img/achievement_50grains.png"
       target: 50
       points: 50
       description: "Collect at least 50 grains in one game"
       descriptionAfterUnlocking: "Collected at least 50 grains in one game"
     },
     Achievement {
       key: "balckdead"
       name: "Empty Henhouse"
       iconSource: "../assets/img/achievement_blackdead.png"
       target: 10
       points: 15
       description: "The balck dies 10 times in a row"
       descriptionAfterUnlocking: "The black died 10 times in a row"
     }
   ]

   onUserScoresInitiallySyncedChanged: {
     if(userScoresInitiallySynced) {
       console.debug("the Felgo Game Network user highscore got synced with the server, maximumHighScore:", maximumHighscore, ", userHighscoreForCurrentActiveLeaderboard:", gameNetwork.userHighscoreForCurrentActiveLeaderboard)

        if(maximumHighscore>0 && maximumHighscore > gameNetwork.userHighscoreForCurrentActiveLeaderboard) {
         console.debug("there was a highscore reached in a previous version before Felgo Game Network was used - upload it to the server now..")

         gameNetwork.reportScore(maximumHighscore)
       } else if(gameNetwork.userHighscoreForCurrentActiveLeaderboard > maximumHighscore) {
         console.debug("there was a higher score reached on a different device - update the local maximumHighscore now")
          maximumHighscore = gameNetwork.userHighscoreForCurrentActiveLeaderboard
       }


     }
   }

   onAchievementUnlocked: {
     if(!system.publishBuild) {
      nativeUtils.displayMessageBox("Achievement unlocked with key " + key)
     }
   }

   onNewHighscore: {
     if(!system.publishBuild) {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
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

  CreditsScene {
    id: creditsScene
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
    else if(state === "credits")
      activeScene = creditsScene;

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
      name: "credits"
      PropertyChanges { target: creditsScene; opacity: 1}
    }
  ]
}
