import QtQuick 2.0
import Felgo 3.0
 EntityBase {                       //支撑物
  entityType: "support"
  poolingEnabled: true
  z:1

  Component.onCompleted: console.debug("Support.onCompleted()")
  Component.onDestruction: console.debug("Support.onDestruction()")

  Image {                        //支撑照片
    id: sprite
    source: "../../assets/img/support.png"
    width: level.gridSize
    height: 10
    anchors.centerIn: parent
  }


  BoxCollider {
    id: collider
    bodyType: Body.Static

    anchors.fill: sprite
  }
}
