import QtQuick 2.0
import Felgo 3.0
EntityBase {
  entityType: "bread"
  poolingEnabled: true        //池化管理使得在内存中不会销毁
  z:1

  Image {
    id: sprite
    source: "../../assets/img/bread.png"
    width: 21
    height: 20
    anchors.centerIn: parent
  }

  property alias collider: collider
  BoxCollider {                 // 面包快的碰撞
    id: collider
    bodyType: Body.Static
    anchors.fill: sprite
    sensor: true              //不玩家被碰撞做出物理反应

  }


}
