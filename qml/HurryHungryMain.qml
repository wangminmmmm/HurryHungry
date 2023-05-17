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
    source: "../assets/snd/bg-slow.wav"
     autoPlay: true
  }

  FontLoader {
    id: fontHUD
    source: "fonts/pf_tempesta_seven_compressed.ttf"
  }


  FelgoGameNetwork {
   id: gameNetwork

   gameId: 1
   secret: "ultra-strong-password"

   gameNetworkView: vplayGameNetworkScene.gameNetworkView
   facebookItem: facebook
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
       description: "The chicken dies 10 times in a row"
       descriptionAfterUnlocking: "The chicken died 10 times in a row"
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
     if(!system.publishBuild) {
      nativeUtils.displayMessageBox("New highscore reached for leaderboard " + leaderboard + ": " + Math.round(highscore))
     }
   }

    onFacebookSuccessfullyConnected: {
     nativeUtils.displayMessageBox(qsTr("Facebook Connected"), qsTr("You just successfully connected to facebook, congrats!"))
   }
   onFacebookSuccessfullyDisconnected: {
     nativeUtils.displayMessageBox(qsTr("Facebook Disconnected"), qsTr("You just successfully disconnected from facebook..."))
   }
   onFacebookConnectionError: {
      nativeUtils.displayMessageBox(qsTr("Facebook Error"), JSON.stringify(error))
   }


  }


  Facebook {

    id: facebook

     appId: "624554907601397"

    readPermissions: ["email", "read_friendlists"]
    publishPermissions: ["publish_actions"]

  }



   Flurry {
    id: flurry
    apiKey: "9PH383W92BYDK6ZYVSDV"
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

  FelgoGameNetworkScene {
    id: vplayGameNetworkScene
    opacity: 0
  }

   EntityManager {
    id: entityManager
    entityContainer: scene.entityContainer
    poolingEnabled: true
   }

   property string lastActiveState: ""

  onStateChanged: {

    console.debug("ChickenBreakoutMain: changed state to", state)

    if(state === "main")
      activeScene = mainScene;
    else if(state === "game")
      activeScene = scene;
    else if(state === "gameOver")
      activeScene = gameOverScene;
    else if(state === "credits")
      activeScene = creditsScene;
    else if(state === "gameNetwork")
      activeScene = vplayGameNetworkScene;

    if(lastActiveState === "main") {
      flurry.endTimedEvent("Display.Main");
    } else if(lastActiveState === "game") {
      flurry.endTimedEvent("Display.Game");


      flurry.logEvent("Game.Finished", { "score": lastScore, "collectedBread" : player.bonusScore, "scoreForBread": player.bonusScore*player.bonusScoreForBread })

    } else if(lastActiveState === "gameOver") {
      flurry.endTimedEvent("Display.GameOver");
    } else if(lastActiveState === "credits") {
      flurry.endTimedEvent("Display.Credits");
    } else if(lastActiveState === "gameNetwork") {
        flurry.endTimedEvent("Display.FelgoGameNetwork");
    }

    if(state === "main") {
      flurry.logTimedEvent("Display.Main");
    } else if(state === "game") {
      flurry.logTimedEvent("Display.Game");
    } else if(state === "gameOver") {
      flurry.logTimedEvent("Display.GameOver");
    } else if(state === "credits") {
      flurry.logTimedEvent("Display.Credits");
    } else if(state === "gameNetwork") {
      flurry.logTimedEvent("Display.FelgoGameNetwork");
    }

    lastActiveState = state;
  }

  state: "main"
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
    },
    State {
      name: "gameNetwork"
      PropertyChanges { target: vplayGameNetworkScene; opacity: 1}

    }
  ]
}
