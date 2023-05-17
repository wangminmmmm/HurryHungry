

import QtQuick 2.0
import Felgo 3.0

Image {
  id: button
  width: 170
  height: 60
  source: "../assets/img/button.png"

  anchors.horizontalCenter: parent.horizontalCenter

  property alias text: buttonText.text
  property alias textColor: buttonText.color
  property alias textSize: buttonText.font.pixelSize
  property alias textItem: buttonText
  property alias font: buttonText.font

  signal clicked

  Text {
    id: buttonText
    anchors.centerIn: parent
    font.pixelSize: 22
    color: "#FFC9C9"

    font.family: fontHUD.name
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    onClicked: button.clicked()
  }
}
