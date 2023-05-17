import QtQuick 2.0
import Felgo 3.0

Scene {
  id: sceneBase
  width: 350
  height: 500

  visible: opacity>0


  Behavior on opacity {

    NumberAnimation { duration: 350 }
  }

}
