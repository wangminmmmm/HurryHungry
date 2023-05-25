import QtQuick 2.0
import Felgo 3.0
import "entities"

//正在游戏场景 游戏内场景

SceneBase {
  id: scene

  property alias level: level
  property alias player: level.player
  property alias entityContainer: level
  gridSize: 48

  sceneAlignmentY: "bottom"         //基于底部位置垂直

  onBackButtonPressed: {
    level.stopGame();
    window.state = "main"
  }

    PhysicsWorld {         //物理世界组件包含所有物理实体 设置玩家 重力
    id: physicsWorld
    z: 10

    updatesPerSecondForPhysics: 60  //更新的频率
    gravity.y: 60

    velocityIterations: 5         //迭代次数  更新
    positionIterations: 5

    debugDrawVisible: false
  }

    //视差滚动背景使用一个多分辨率图像实例 创建无限的可滚动背景
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
      console.debug("HurryHungryScene: gameLost()");
      level.stopGame();
      lastScore = player.totalScore;
      player.deaths++;
       window.state = "gameOver"
    }

  }


   Keys.forwardTo: player.controller        //for 鼠标控制玩家 mousearea 移动x y值

   Image {                            //鼠标点击 控制人物角色左右移动 照片
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
    mirror: true                  //左右镜相翻转
    anchors {
      right: scene.gameWindowAnchorItem.right
      bottom: scene.gameWindowAnchorItem.bottom
      rightMargin: 10
      bottomMargin: 10
    }
  }

   MouseArea {                         //鼠标控制组件
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



  Text {                                //当前实时得分
    x: 5
    anchors.top: scene.gameWindowAnchorItem.top
    anchors.topMargin: 5

    text: qsTr("Score: ") + player.totalScore   //分数显示
    font.family: fontHUD.name
    font.pixelSize: 22
    color: "white"

  }


   function enterScene() {
    level.startGame();
  }


}
