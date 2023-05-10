import QtQuick 2.0
import Felgo 3.0
 EntityBase {
  entityType: "roost"

  poolingEnabled: true

   z:1

  Component.onCompleted: console.debug("Roost.onCompleted()")
  Component.onDestruction: console.debug("Roost.onDestruction()")

  Image {
    id: sprite
    source: "../../assets/img/roost_higher.png"

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
