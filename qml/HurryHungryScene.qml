import QtQuick 2.0
import Felgo 3.0
import "entities"

//正在游戏场景 游戏内场景

SceneBase {
  id: scene

  property alias level: level
  property alias player: level.player
  property alias entityContainer: level   //创建出的实体容器

  gridSize: 48
  sceneAlignmentY: "bottom"         //基于底部位置垂直


  PhysicsWorld {            //场景中 物理世界组件包含所有物理实体 设置玩家 重力
    id: physicsWorld
    z: 10

    updatesPerSecondForPhysics: 60  //更新的频率
    gravity.y: 60

    velocityIterations: 5         //速度迭代次数  更新
    positionIterations: 5

    debugDrawVisible: false    //隐藏在物理世界里的调试
  }


   //视差滚动背景使用一个多分辨率图像实例 创建无限的可滚动背景
  ParallaxScrollingBackground {
    id: levelBackground
    anchors.horizontalCenter: parent.horizontalCenter
    y: parent.height-parent.gameWindowAnchorItem.height

    sourceImage: "../assets/img/background-pure.png"

    mirrorSecondImage: false          //使其不指定第二个镜像图片

    //用于设置运动的方向和速度
    movementVelocity: Qt.point(0, level.levelMovementAnimation.velocity)
    running: level.levelMovementAnimation.running    //向下滚动
  }


  Level {
    id: level

    onGameLost: {
      console.debug("在游戏内部 调用gameover界面 ");
      level.stopGame();
      lastScore = player.totalScore;
      player.deaths++;
       window.state = "gameOver"
    }

  }


   Keys.forwardTo: player.controller         //定义玩家 鼠标控制玩家  mousearea 移动x y值

   //鼠标点击 控制人物角色左右移动 照片
   Image {                               // 左边鼠标
    source: "../assets/img/arrow-left.png"
    opacity: 0.5               //透明度
    width: 48
    height: 48
    anchors {
      left: scene.gameWindowAnchorItem.left
      bottom: scene.gameWindowAnchorItem.bottom
      leftMargin: 10
      bottomMargin: 10
    }
  }

   Image {                             //右边鼠标
    source: "../assets/img/arrow-left.png"
    opacity: 0.5
    width: 48
    height: 48
    mirror: true                       //镜相翻转成向右
    anchors {
      right: scene.gameWindowAnchorItem.right
      bottom: scene.gameWindowAnchorItem.bottom
      rightMargin: 10
      bottomMargin: 10
    }

  }

   MouseArea {                          //鼠标控制组件 鼠标点击产生变化
    anchors.fill: scene.gameWindowAnchorItem

    onPressed: {
      console.debug( "鼠标控制左右被 按下 ", mouseX)

      if(mouseX > scene.gameWindowAnchorItem.width/2)     // 判断鼠标按下的为向左/向右
        player.controller.xAxis = 1;    //在界面右边
      else
        player.controller.xAxis = -1;
    }

    onPositionChanged: {                                  //在鼠标位置变化时候 控制其左右
      if(mouseX > scene.gameWindowAnchorItem.width/2)
        player.controller.xAxis = 1;
      else
        player.controller.xAxis = -1;
    }

    onReleased: player.controller.xAxis = 0           //鼠标松开 玩家水平变化值为0
  }




  Text {                                //当前实时得分显示
    x: 5
    anchors.top: scene.gameWindowAnchorItem.top
    anchors.topMargin: 5

    text: qsTr("Score: ") + player.totalScore   //分数显示

    font.family: fontHUD.name       //字体设置 使用主界面字体设置
    font.pixelSize: 22
    color: "white"

  }

   function enterScene() {
    level.startGame();
  }


}
