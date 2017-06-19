import QtQuick 2.8
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4

Rectangle {
    id: page
    width: root.width
    height: root.height

    PieMenu {
        id: pieMenu

        MenuItem {
            text: "Action 1"
            onTriggered: print("Action 1")
        }
        MenuItem {
            text: "Action 2"
            onTriggered: print("Action 2")
        }
        MenuItem {
            text: "Action 3"
            onTriggered: print("Action 3")
        }
    }

    Label {
        width: 0.6*parent.width
        wrapMode: Label.Wrap
        horizontalAlignment: Qt.AlignHCenter
        anchors.horizontalCenter: page.horizontalCenter
        anchors.verticalCenter: page.verticalCenter
        anchors.verticalCenterOffset: 50
        text: "BusyIndicator is used to indicate activity while content is being loaded,"
              + " or when the UI is blocked waiting for a resource to become available."
    }

    BusyIndicator {
        anchors.horizontalCenter: page.horizontalCenter
        anchors.verticalCenter: page.verticalCenter
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: pieMenu.popup(mouseX, mouseY)
    }
}
