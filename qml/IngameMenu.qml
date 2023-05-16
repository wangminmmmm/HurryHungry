import QtQuick 2.0
import Felgo 3.0
Column {
  spacing: 2
  anchors.centerIn: parent


  MenuButton {
    text: qsTr("Resume")
    onClicked: scene.state = ""
  }

  MenuButton {
    text: qsTr("Restart")
    onClicked: {
      level.restartGame();
      scene.state = ""
    }
  }


  MenuButton {
    text: qsTr("Toggle Physics Debug")
    onClicked: {
      physicsWorld.debugDrawVisible = !physicsWorld.debugDrawVisible
    }
  }

  MenuButton {
    text: vplayScheduler.schedulingMethod === VPlayScheduler.None ? qsTr("Current Scheduler: every update") : qsTr("Current Scheduler: accumulated")
    onClicked: {
      if(vplayScheduler.schedulingMethod === VPlayScheduler.None)
        vplayScheduler.schedulingMethod = VPlayScheduler.Accumulated
      else
        vplayScheduler.schedulingMethod = VPlayScheduler.None
    }
  }

  MenuButton {
    text: qsTr("Toggle Background Movement")
    onClicked: {
      levelBackground.running = !levelBackground.running
    }
  }
}
