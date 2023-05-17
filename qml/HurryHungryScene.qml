import QtQuick 2.0
import Felgo 3.0
import "entities"
//this scene is playing scene
SceneBase {
  id: scene

  property alias level: level
  property alias player: level.player
  property alias entityContainer: level
  gridSize: 48

  sceneAlignmentY: "bottom"

  onBackButtonPressed: {
    level.stopGame();
    window.state = "main"
  }

    PhysicsWorld {
    id: physicsWorld
    z: 10

    updatesPerSecondForPhysics: 60
    gravity.y: 60

    velocityIterations: 5
    positionIterations: 5

    debugDrawVisible: false
  }

  ParallaxScrollingBackground {
    id: levelBackground
    anchors.horizontalCenter: parent.horizontalCenter
    y: parent.height-parent.gameWindowAnchorItem.height
    sourceImage: "../assets/img/background-pure.png"
    mirrorSecondImage: false
    movementVelocity: Qt.point(0, level.levelMovementAnimation.velocity)
    running: level.levelMovementAnimation.running
  }

  Level {
    id: level

    onGameLost: {
      console.debug("ChickenOutbreakScene: gameLost()");
      level.stopGame();
      lastScore = player.totalScore;
      player.deaths++;
       window.state = "gameOver"
    }
  }

   Keys.forwardTo: player.controller
//this two is arrows in the playing_scene
   Image {
    source: "../assets/img/arrow-left.png"
    opacity: 0.5
    width: 48
    height: 48
    anchors {
      left: scene.gameWindowAnchorItem.left
      bottom: scene.gameWindowAnchorItem.bottom
      leftMargin: 10
      bottomMargin: 10
    }
  }
  Image {
    source: "../assets/img/arrow-left.png"
    opacity: 0.5
    width: 48
    height: 48
    mirror: true
    anchors {
      right: scene.gameWindowAnchorItem.right
      bottom: scene.gameWindowAnchorItem.bottom
      rightMargin: 10
      bottomMargin: 10
    }
  }
//wo can use mouse to control the player move
  MouseArea {
    anchors.fill: scene.gameWindowAnchorItem
    onPressed: {
      console.debug("onPressed, mouseX", mouseX)
      if(mouseX > scene.gameWindowAnchorItem.width/2)
        player.controller.xAxis = 1;
      else
        player.controller.xAxis = -1;
    }
    onPositionChanged: {
      if(mouseX > scene.gameWindowAnchorItem.width/2)
        player.controller.xAxis = 1;
      else
        player.controller.xAxis = -1;
    }
    onReleased: player.controller.xAxis = 0
  }

  Text {
    x: 5
     anchors.top: scene.gameWindowAnchorItem.top
    anchors.topMargin: 5

    text: qsTr("Score: ") + player.totalScore
    font.family: fontHUD.name
    font.pixelSize: 22
    color: "white"
  }
  function enterScene() {
    level.startGame();
  }


 SimpleButton {
    id: hud
    width: 64
    height: 64
    anchors.top: scene.gameWindowAnchorItem.top
    anchors.right: scene.gameWindowAnchorItem.right
    visible: system.debugBuild
    text: "Menu"
    onClicked: {
      console.debug("Menu button clicked")

      scene.state = "ingameMenu"
    }
  }

  IngameMenu {
    id: ingameMenu

    visible: false
    anchors.centerIn: parent
  }

  onStateChanged: console.debug("Scene.state changed to", state)
  states: [
    State {
      name: ""
      StateChangeScript {
        script: {
          console.debug("scene: entered state ''")
          level.resumeGame();
        }
      }
    },
    State {
      name: "ingameMenu"
      PropertyChanges { target: ingameMenu; visible: true}
      StateChangeScript {
        script: {
          console.debug("scene: entered state 'ingameMenu'")
          level.pauseGame();
        }
      }
    }

  ]
}
