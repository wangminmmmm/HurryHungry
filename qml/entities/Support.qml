import QtQuick 2.0
import Felgo 3.0
 EntityBase {
  entityType: "support"
  poolingEnabled: true      //池化管理使得在内存中不会销毁与bread相同
  z:1

  Component.onCompleted: console.debug("完成支撑点 ")     //开始游戏时
  Component.onDestruction: console.debug("支撑销毁")

  Image {
    id: sprite
    source: "../../assets/img/support.png"
    width: level.gridSize
    height: 8
    anchors.centerIn: parent
  }


  BoxCollider {                   //站立 块碰撞
    id: collider
    bodyType: Body.Static

    anchors.fill: sprite
  }
}
