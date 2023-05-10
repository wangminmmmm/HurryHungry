import QtQuick 2.0
import Felgo 3.0

Scene {
  id: sceneBase
  width: 320
  height: 480

  visible: opacity>0


  Behavior on opacity {

    NumberAnimation { duration: 350 }
  }

}
