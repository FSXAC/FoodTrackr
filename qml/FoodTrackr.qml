import "."
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Food Trackr v0.0")

    menuBar: MenuBar {
        Menu {
            title: "&File"
            MenuItem { text: "Import"}
            MenuItem { text: "Export" }
        }

        Menu {
            title: "&Edit"
            MenuItem {text: "New entry"}
        }
    }

    statusBar: StatusBar {
        RowLayout {
            anchors.fill: parent
            Label { text: "Read Only" }
            ProgressBar {
                indeterminate: true
                Layout.alignment: Qt.AlignRight
            }
        }
    }

    toolBar: ToolBar {
        z: 1
        RowLayout {
            anchors.fill: parent
            ToolButton { text: "New entry"; iconSource: "qrc:/images/grass.png" }
//            ToolBarSeparator { }
//            ToolButton { text: "world"; }
//            Item { Layout.fillWidth: true }
//            Button { text: "test" }
        }
    }

    Controls.SwipeView {
        id: root
        anchors.fill: parent
        currentIndex: -1

        First { }
        Second { }
    }

    Controls.PageIndicator {
        id: indicator
        count: root.count
        currentIndex: root.currentIndex
        anchors.bottom: root.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
