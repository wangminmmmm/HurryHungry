import QtQuick 2.0
import Felgo 3.0

EntityBase {
  entityType: "henhouseWindow"

  poolingEnabled: true

  Image {
    id: sprite
    source: "../../assets/img/window3.png"

    width: 64
    height: 60

  }

  property alias collider: collider
  BoxCollider {
    id: collider
    bodyType: Body.Static

    anchors.fill: sprite
    sensor: true

  }

}
