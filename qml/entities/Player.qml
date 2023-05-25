import QtQuick 2.0

import Felgo 3.0

EntityBase {                                 //玩家角色
  entityType: "player"

  signal leftPressed(variant event)
  signal rightPressed(variant event)
  signal upPressed(variant event)
  signal downPressed(variant event)

  signal died

  property int score: 0                          //初始值
  property int bonusScore: 0
  property int totalScore: score + (bonusScore * bonusScoreForBread)
  property int deaths: 0

  property int bonusScoreForBread: 100

  property alias controller: twoAxisController         //左右上下移动xy值控制

  property real upValue: 550                      //移动站立物 数值
  property real downValue: 5
  property real rightValue: 250
  property real leftValue: -rightValue

  property bool __isJumping: true
  property date lastJumpTime: new Date

  property bool __isLookingRight: true


  onRightValueChanged: console.debug("rightValue changed to", rightValue)

  preventFromRemovalFromEntityManager: true

  Image {                           //站立
    id: sprite
    source: "../../assets/img/stand.png"
    anchors.centerIn: parent
    width: 40
    height: 35
    visible: false
  }

  Image {                           //左移   右相反
    id: spriteMovement
    source: "../../assets/img/left1.png"
    anchors.centerIn: parent
    mirror: __isLookingRight
    width: sprite.width
    height: sprite.height
    visible: false
  }
  Image {                           //上移
    id: spriteFlying
    source: "../../assets/img/down.png"
    anchors.centerIn: parent
    width: 45
    height: 45
    visible: false
  }

  property int blockCollisions: 0              //块的碰撞数值

  BoxCollider {                        //块碰撞
    id: collider
    bodyType: Body.Dynamic
    fixedRotation: true                //旋转

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

        breadSound.play()
      } else if(collidedEntityType === "support") {
        blockCollisions++;
      }
    }

    fixture.onEndContact: {

      var fixture = other;
      var body = fixture.getBody();
      var collidedEntity = body.target;
      var collidedEntityType = collidedEntity.entityType;
      if(collidedEntityType === "support") {
        blockCollisions--;
      }
    }
  }


  SoundEffect {                        //吃面包声音
    id: breadSound
    source: "../../assets/snd/eat.wav"
  }



  //移动实体的 x值和y值     根据键盘按下左右 TowAxis控制器
  TwoAxisController {
     id: twoAxisController

    onXAxisChanged: {
      console.debug(" x值左右移动改变 ", xAxis)
      if(xAxis>0)
        __isLookingRight = true;
      else if(xAxis<0)
        __isLookingRight = false;
    }

    onYAxisChanged: {
      console.debug(" y值上下移动改变 ", yAxis)
      if(yAxis>0)
        __isLookingRight = true;
      else if(yAxis<0)
        __isLookingRight = false;
    }

  }

  Timer {
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

  state: {
    if(blockCollisions==0)
      return "fly";
    else {
      if(controller.xAxis !== 0) {
        return "moveLeftRight";
      }
      return "";
    }
  }

  states: [
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
