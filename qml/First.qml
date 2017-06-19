import "."

import QtQuick 2.8
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1 as Controls
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0

Rectangle {
    id: page
    width: root.width
    height: root.height

    ListView {
        id: listView
        anchors.fill: parent
        
        model: groceryModel
        delegate: groceryDelegate

        Controls.ScrollIndicator.vertical: Controls.ScrollIndicator { }
    }

    Component {
        id: groceryDelegate

        Item {
            Rectangle {
                width: root.width
                height: 50
                color: groceryDelegateMouseArea.containsMouse ? "#39F" : "white"
                Row {
                    spacing: 20
                    Text { text: qsTr(name) }
                    Text { text: qsTr(String(quantity)) }
                    Text { text: qsTr((unitMass === -1 ? "N/A" : String(unitMass)) + unitMassUnit) }
                    Text { text: qsTr("$ " + String(cost)) }
                    Text { text: qsTr(String(expiracyDate)) }
                }

                MouseArea {
                    id: groceryDelegateMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        console.log(name)
                        entryDialog.open()
                    }
                }
            }
        }
    }

    ListModel {
        id: groceryModel
        ListElement {
            name: "Banana"
            quantity: 4
            unitMass: -1
            unitMassUnit: "kg"
            cost: 5.49
            expiracyDate: "placeholder"
        }
    }

    EntryDialog { id: entryDialog }
}
