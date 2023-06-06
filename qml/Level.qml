import QtQuick 2.0

import Felgo 3.0
import "entities"
import "scripts/levelLogic.js" as LevelLogic

Item {
  id: level
  width: scene.width //350
  height: scene.height//500

   property real gridSize: scene.gridSize//make scecn grids 48

   property int roostColumns: width/gridSize  //stand's number is 350/48

   property real lastY: 0

   property real currentRow: 0

  property alias player: player

  property alias levelMovementAnimation: levelMovementAnimation

  property real levelMovementSpeedMinimum: 20//max and mini speed
  property real levelMovementSpeedMaximum: 90

  property int levelMovementDurationTillMaximum: 30

  property real platformCreationProbability: 0.09

  property real coinCreationPropability: 0.3

  property real windowCreationProbability: 0.05

  property real minimumWindowHeightDifference: 300

  property int rowCount: 15

  property int currentScore: 0

  property int lastWindowY: 0

  property real __yOffsetForWindow: scene.__yOffsetForAbsoluteWindowCoordinates


  signal gameLost

  Component.onCompleted: {//when you game is starting then going creating

    preCreateEntityPool();


  }

  function preCreateEntityPool() {//create entitys

    if(system.isPlatform(System.Meego) || system.isPlatform(System.Symbian))
      return;

    entityManager.createPooledEntitiesFromUrl(Qt.resolvedUrl("entities/Support.qml"), 20);
    entityManager.createPooledEntitiesFromUrl(Qt.resolvedUrl("entities/Bread.qml"), 10);
  }


  function stopGame() {//game over
    levelMovementAnimation.stop();

     entityManager.removeAllEntities();
  }

  function startGame() {//game start
    console.debug("Level: startGame()");

    currentRow = 0;
    lastY = 0;

    level.y = 0;    //stand

    player.x = scene.width/2;
    player.y = 2*gridSize;

    player.score = 0;
    player.bonusScore = 0;//get bread score

    player.controller.xAxis = 0;

    lastWindowY = 0;

    for(var i=5; i<rowCount; i++) {
      LevelLogic.createRandomRowForRowNumber(i);
    }

    levelMovementAnimation.velocity = -levelMovementSpeedMinimum;
    levelMovementAnimation.start();
  }

  Player {
    id: player

    x: scene.width/2
    y: gridSize/2

    z: 1
  }

  Support {
    id: lowerBlock
    entityId: "playerInitialBlock"
    x: scene.width/2
    y: 3.5*gridSize
    preventFromRemovalFromEntityManager: true
  }

//top border and bottom border if player collide then game over
  BorderRegion {
    x: scene.gameWindowAnchorItem.x
    width: 2*scene.gameWindowAnchorItem.width
    variationType: "topRegion"

     height: 20

    property real defaultOffsety: __yOffsetForWindow + height + 60
      y: -level.y - defaultOffsety

    onPlayerCollision: {
      console.debug("PLAYER COLLIDED WITH topRegion, level.y:", level.y, ", player.y:", player.y)
       gameLost();
    }
  }
  BorderRegion {
     width: scene.gameWindowAnchorItem.width*4
    anchors.horizontalCenter: parent.horizontalCenter

    height: 20
    y: -level.y + scene.gameWindowAnchorItem.height

    variationType: "bottomRegion"

    onPlayerCollision: {
      console.debug("PLAYER COLLIDED WITH BorderRegion, level.y:", level.y, ", player.y:", player.y)
      gameLost();
    }
  }

  MovementAnimation {
    id: levelMovementAnimation
    property: "y"
    velocity: -levelMovementSpeedMinimum//- is top and up

    acceleration: -(levelMovementSpeedMaximum-levelMovementSpeedMinimum) / levelMovementDurationTillMaximum//jia speed
    target: level


    minVelocity: -levelMovementSpeedMaximum
  }

  onYChanged: {//by y'change to create rows and calculate score

    var dy = y - lastY;
    if(-dy > gridSize) {

      var amountNewRows = (-dy/gridSize).toFixed();
      console.debug(amountNewRows, "new rows are getting created...")


      for(var i=0; i<amountNewRows; i++) {//use y'long to calculate score
        currentRow++;

        LevelLogic.createRandomRowForRowNumber(currentRow+rowCount);

        lastY -= gridSize
      }
    }

    currentScore = -(level.y/40).toFixed()
    if(currentScore > player.score+4) {
        player.score = currentScore
    }
  }

  function pauseGame() {
    console.debug("pauseGame()")
    levelMovementAnimation.stop();
  }
  function resumeGame() {
    console.debug("resumeGame()")
    levelMovementAnimation.start();
  }

  function restartGame() {
    console.debug("restartGame()")
    stopGame();
    startGame();
  }
}
