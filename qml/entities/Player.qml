import QtQuick 2.0

import Felgo 3.0

EntityBase {
  entityType: "player"

  signal leftPressed(variant event)
  signal rightPressed(variant event)
  signal upPressed(variant event)
  signal downPressed(variant event)

  signal died

  property int score: 0                    //初始值
  property int bonusScore: 0
  property int totalScore: score + (bonusScore * bonusScoreForBread)

  property int deaths: 0
  property int bonusScoreForBread: 100

  property alias controller: twoAxisController

  property real upValue: 550
  property real downValue: 5
  property real rightValue: 250
  property real leftValue: -rightValue

  property bool __isJumping: true
  property date lastJumpTime: new Date
  property bool __isLookingRight: true

  onRightValueChanged: console.debug("rightValue changed to", rightValue)

  preventFromRemovalFromEntityManager: true

  Image {           //人物站立
    id: sprite
    source: "../../assets/img/stand.png"
    anchors.centerIn: parent

    width: 40
    height: 35
    visible: false
  }

  Image {            //人物左移
    id: spriteMovement
    source: "../../assets/img/left1.png"
    anchors.centerIn: parent
    mirror: __isLookingRight
    width: sprite.width
    height: sprite.height
    visible: false
  }

  Image {            //人物下滑
    id: spriteFlying
    source: "../../assets/img/down.png"
    anchors.centerIn: parent
    width: 45
    height: 45
    visible: false
  }

  property int blockCollisions: 0

  BoxCollider {
    id: collider
    bodyType: Body.Dynamic
    fixedRotation: true

    linearDamping: 5.0

    friction: 0.6

    restitution: 0

    sleepingAllowed: false

    anchors.fill: sprite

    fixture.onBeginContact: {
      var fixture = other;
      var body = fixture.getBody()
      var collidedEntity = body.target;
      var collidedEntityType = collidedEntity.entityType;
      if(collidedEntityType === "bread") {
        collidedEntity.removeEntity();

        bonusScore++;

        coinSound.play()
      } else if(collidedEntityType === "roost") {
        blockCollisions++;
      }
    }

    fixture.onEndContact: {

      var fixture = other;
      var body = fixture.getBody();
      var collidedEntity = body.target;
      var collidedEntityType = collidedEntity.entityType;
      if(collidedEntityType === "roost") {
        blockCollisions--;
      }
    }
  }

  SoundEffect {           //人物触碰面包声音
    id: coinSound
    source: "../../assets/snd/eat.wav"
  }

  TwoAxisController {
    id: twoAxisController

    onXAxisChanged: {
      console.debug("xAxis changed to", xAxis)
      if(xAxis>0)
        __isLookingRight = true;
      else if(xAxis<0)
        __isLookingRight = false;
    }
  }

  Timer {                     //时间限制
    id: updateTimer
    interval: 60
    running: true
    repeat: true
    onTriggered: {

      var xAxis = controller.xAxis;
      if(xAxis) {
        collider.body.linearVelocity.x = xAxis*rightValue;
      }
    }
  }

  state: {                 //fly状态
    if(blockCollisions==0)
      return "fly";
    else {
      if(controller.xAxis !== 0) {
        return "moveLeftRight";
      }
      return "";
    }
  }

  states: [              //人物状态转换
    State {
      name: ""
      PropertyChanges { target: sprite; visible: true }
    },
    State {
      name: "fly"
      PropertyChanges { target: spriteFlying; visible: true }
    },
    State {
      name: "moveLeftRight"
      PropertyChanges { target: spriteMovement; visible: true }
    }
  ]

}
