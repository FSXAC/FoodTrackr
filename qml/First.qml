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

    // list view for all the groceries
     ListView {
         id: listView
         anchors.fill: parent
        
         model: groceryModel
         delegate: groceryDelegate

         Controls.ScrollIndicator.vertical: Controls.ScrollIndicator { }
     }

     // grocery delegate
     Component {
         id: groceryDelegate

         Item {
             id: delegateItem
             width: listView.width; height: 40
             clip: true

             Rectangle {
                 anchors.fill: parent
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

    // model (template) for each grocery item
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
        ListElement {
            name: "Orange"
            quantity: 1
            unitMass: -1
            unitMassUnit: "kg"
            cost: 2.00
            expiracyDate: "placeholder"
        }
        ListElement {
            name: "Maple Syrup"
            quantity: 1
            unitMass: 6
            unitMassUnit: "kg"
            cost: 10.45
            expiracyDate: "placeholder"
        }
    }

    EntryDialog { id: entryDialog }
}
