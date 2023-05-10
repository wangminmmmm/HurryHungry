import QtQuick 2.0
import Felgo 3.0

SceneBase {
  id: scene

  property alias gameNetworkView: gameNetworkView

  onBackButtonPressed: {
    window.state = "main"
  }

  GameNetworkView {
    id: gameNetworkView
    anchors.fill: scene.gameWindowAnchorItem    


    onBackClicked: {
      window.state = "main"
    }
  }
}
