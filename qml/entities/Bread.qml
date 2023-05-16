import QtQuick 2.0
import Felgo 3.0


EntityBase {
  entityType: "bread"

  poolingEnabled: true


  z:1

  Image {
    id: sprite
    source: "../../assets/img/bread.png"

    width: 21
    height: 20

    anchors.centerIn: parent
  }

  property alias collider: collider
  BoxCollider {
    id: collider
    bodyType: Body.Static

    anchors.fill: sprite

    sensor: true

  }

}
