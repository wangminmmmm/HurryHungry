import QtQuick 2.0

import Felgo 3.0

//玩家 个体控制

EntityBase {                                  //玩家角色
  entityType: "player"

  signal leftPressed(variant event)              //检测按下信号
  signal rightPressed(variant event)
  signal upPressed(variant event)
  signal downPressed(variant event)

  signal died

  property int score: 0                 //玩家初始值
  property int bonusScore: 0
  property int totalScore: score + (bonusScore * bonusScoreForBread)
  property int deaths: 0

  property int bonusScoreForBread: 100

  property alias controller: twoAxisController        //左右上下移动xy值 控制 组件

  property real upValue: 5                    //上下移动速率 timer
  property real downValue: 10
  property real rightValue: 200               //左右移动速率 timer
  property real leftValue: -rightValue

  property bool __isJumping: true           // 定义向上/向下
  property date lastJumpTime: new Date
  property bool __isLookingRight: true


  onRightValueChanged: console.debug("右移到", rightValue)   //console检测是否移动

  preventFromRemovalFromEntityManager: true       //管理玩家 实体不被破坏

  Image {                            //站立
    id: sprite
    source: "../../assets/img/stand.png"
    anchors.centerIn: parent
    width: 40
    height: 35
    visible: false
  }
  Image {                            //左移   右相反
    id: spriteMovement
    source: "../../assets/img/left1.png"
    anchors.centerIn: parent
    mirror: __isLookingRight
    width: sprite.width
    height: sprite.height
    visible: false
  }
  Image {                            //下移
    id: spriteFlying
    source: "../../assets/img/down.png"
    anchors.centerIn: parent
    width: 45
    height: 45
    visible: false
  }
  Image {                            //上移
    id: spriteDowning
    source: "../../assets/img/fly.png"
    anchors.centerIn: parent
    width: 45
    height: 45
    visible: false
  }

  property int blockCollisions: 0              //当下块的碰撞数值-> 状态转换 判断玩家下降

  BoxCollider {                               //玩家 碰撞检测
    id: collider
    bodyType: Body.Dynamic          //该组件必须设置的属性 设置为动态值 动态体才能发生与其他相互碰撞

    fixedRotation: true                    //不让使玩家 旋转
    linearDamping: 5.0               //阻尼设置 在支撑物上 降低玩家限速 与摩差力一起使用
    friction: 0.6

    restitution: 0                   //使碰撞物后不会反弹
    sleepingAllowed: false           //当没有碰撞时进入隨眠状态

    anchors.fill: sprite

    fixture.onBeginContact: {              //此属性访问被撞物体的刚开始 碰撞 物理形状
      var fixture = other;
      var body = fixture.getBody()
      var collidedEntity = body.target;
      var collidedEntityType = collidedEntity.entityType;   //得到被撞的具体单个 实体

      if(collidedEntityType === "bread") {       //检测被撞物
        collidedEntity.removeEntity();   //移除bread
        bonusScore++;
        breadSound.play()
      }

      else if(collidedEntityType === "support") {
        blockCollisions++;
      }
    }


    fixture.onEndContact: {              //此属性访问被撞物体结束 碰撞 物理形状
      var fixture = other;
      var body = fixture.getBody();
      var collidedEntity = body.target;
      var collidedEntityType = collidedEntity.entityType;

      if(collidedEntityType === "support") {
        blockCollisions--;
      }
    }

  }


  SoundEffect {                             //吃面包声音
    id: breadSound
    source: "../../assets/snd/eat.wav"
  }



  //移动实体的 x值和y值     根据键盘按下左右 TowAxis控制器
  TwoAxisController {
     id: twoAxisController

    onXAxisChanged: {
      console.debug(" x值左右 移动改变值 ", xAxis)
      if(xAxis>0)
        __isLookingRight = true;
      else if(xAxis<0)
        __isLookingRight = false;
    }

    onYAxisChanged: {
      console.debug(" y值上下 移动改变值 ", yAxis)
      if(yAxis>0)
        __isJumping = true;
      else if(yAxis<0)
        __isJumping = false;
    }

  }

  Timer {                 //用于玩家左右移动计时 速度
    id: updateTimer
    interval: 60
    running: true                   //启动记时器
    repeat: true

    onTriggered: {                  // x和y值改变值根据 属性设置的速率
      var xAxis = controller.xAxis;
      if(xAxis) {
        collider.body.linearVelocity.x = xAxis* rightValue;       //移动的x值*定义的速率  以像素/s为单位
      }

      var yAxis = controller.yAxis;
      if(yAxis) {
        collider.body.linearVelocity.x = yAxis* upValue;
      }
    }

  }


  state: {                               //状态转换
    if(blockCollisions==0)       //支撑物为0时
          return "fly";

    if(controller.yAxis >0)
        return "down";

    else {
      if(controller.xAxis !== 0) {
        return "moveLeftRight";
      }
      return "";
    }

  }

  states: [
    State {
      name: ""         //站立状态
      PropertyChanges { target: sprite; visible: true }
    },
    State {
      name: "fly"       //下降状态
      PropertyChanges { target: spriteFlying; visible: true }
    },
    State {
        name: "down"    //飞翔状态（在调试
        PropertyChanges { target: spriteDowning; visible: true }
     },

    State {
      name: "moveLeftRight"     //左右移动
      PropertyChanges { target: spriteMovement; visible: true }
    }
  ]

}
