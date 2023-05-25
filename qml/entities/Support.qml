import QtQuick 2.0
import Felgo 3.0
 EntityBase {
  entityType: "support"
  poolingEnabled: true
  z:1

  Component.onCompleted: console.debug("Support.onCompleted()")
  Component.onDestruction: console.debug("Support.onDestruction()")

  Image {
    id: sprite
    source: "../../assets/img/support.png"

    width: level.gridSize
    height: 8

    anchors.centerIn: parent
  }

  BoxCollider {
    id: collider
    bodyType: Body.Static

    anchors.fill: sprite
  }
}
