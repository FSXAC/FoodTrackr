import QtQuick 2.8
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
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

    Dialog {
        id: entryDialog
        modality: Qt.WindowModal
        title: "Enter new item"
        standardButtons: StandardButton.Ok | StandardButton.Cancel

        onButtonClicked: {
            if (clickedButton === StandardButton.Ok) {
                // add new entry
                groceryModel.append({
                    "name": itemName.text,
                    "quantity": itemQty.value,
                    "unitMass": itemWeight.value,
                    "unitMassUnit": itemWeightUnit.value,
                    "cost": itemPriceSubtotal.value,
                    "expiracyDate": itemExpiracy.text
                })
            }
        }

        function updatePrice(updater) {
            if (itemByQty.checked) {
                // quantity only
                if (updater === itemQty || updater === itemPriceEachQty || updater === itemByQty) {
                    itemPriceSubtotal.value = itemQty.value * itemPriceEachQty.value;
                } else if (updater === itemPriceSubtotal) {
                    itemPriceEachQty.value = itemPriceSubtotal.value / itemQty.value;
                }
            } else if (itemByMass.checked) {
                // mass only
                if (updater === itemWeight || updater === itemPriceEachWeight || updater === itemByMass) {
                    itemPriceSubtotal.value = itemWeight.value * itemPriceEachWeight.value;
                } else if (updater === itemPriceSubtotal) {
                    itemPriceEachWeight.value = itemPriceSubtotal.value / itemWeight.value;
                }
            } else if (itemByBoth.checked) {
                // both quality and mass
                if (updater === itemQty || updater === itemWeight || updater === itemByQty || updater === itemByMass || updater === itemByBoth) {
                   itemPriceSubtotal.value = itemQty.value * itemWeight.value * itemPriceEachWeight.value;
                } else if (updater === itemPriceEachQty) {
                   itemPriceEachWeight.value = itemPriceSubtotal.value / itemWeight.value
                } else if (updater === itemPriceEachWeight) {
                   itemPriceEachQty.value = itemWeight.value * itemPriceEachWeight.value
                }
                itemPriceSubtotal.value = itemQty.value * itemWeight * itemPriceEachWeight.value;
            }
        }

        ColumnLayout {
            id: column
            width: parent ? parent.width : 100

            Label {
                text: qsTr("Enter a new grocery item")
                Layout.columnSpan: 2
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }

            GridLayout {
                columns: 3
                columnSpacing: 20;

                // Row 1
                Label { text: "Item:" }
                RowLayout {
                    Layout.columnSpan: 2;
                    Button {
                        id: itemIcon
                        text: "Icon"
                    }
                    TextField {
                        id: itemName;
                        Layout.fillWidth: true
                        placeholderText: qsTr("<i>Name of item</i>")
                    }
                }

                // Row 2
                Label { text: "Measure:" }
                ExclusiveGroup { id: itemQtySelector }
                RowLayout {
                    Layout.columnSpan: 2
                    RadioButton { id: itemByQty; exclusiveGroup: itemQtySelector; onCheckedChanged: entryDialog.updatePrice(this); text: "By quantity"; checked: true }
                    RadioButton { id: itemByMass; exclusiveGroup: itemQtySelector; onCheckedChanged: entryDialog.updatePrice(this); text: "By weight" }
                    RadioButton { id: itemByBoth; exclusiveGroup: itemQtySelector; onCheckedChanged: entryDialog.updatePrice(this); text: "Both"; enabled: false }
                }

                // Row 3
                Label { text: "Amount:" }
                RowLayout {
                    Label { text: "Quantity:" }
                    SpinBox {
                        enabled: itemByQty.checked | itemByBoth.checked
                        id: itemQty
                        minimumValue: 1
                        onValueChanged: entryDialog.updatePrice(this)
                        onEnabledChanged: if (!itemByQty.checked) value = 1;
                    }
                }
                RowLayout {
                    Label { text: "Weight:" }
                    SpinBox {
                        enabled: itemByMass.checked | itemByBoth.checked
                        id: itemWeight
                        decimals: 3
                        onValueChanged: entryDialog.updatePrice(this)
                    }
                    ComboBox {
                        id: itemWeightUnit
                        enabled: itemByMass.checked | itemByBoth.checked
                        model: [ "kg", "g", "lb", "oz" ]
                    }
                }

                // Row 4
                Label { text: "Cost:" }
                RowLayout {
                    Layout.columnSpan: 2
                    SpinBox {
                        id: itemPriceEachQty
                        enabled: itemByQty.checked | itemByBoth.checked
                        decimals: 2
                        maximumValue: 999
                        prefix: qsTr("$ ")
                        suffix: qsTr(" each")
                        stepSize: 1
                        onValueChanged: entryDialog.updatePrice(this)
                    }
                    SpinBox {
                        id: itemPriceEachWeight
                        enabled: itemByMass.checked | itemByBoth.checked
                        decimals: 2
                        maximumValue: 999
                        prefix: qsTr("$ ")
                        suffix: qsTr(" /" + itemWeightUnit.currentText )
                        stepSize: 1
                        onValueChanged: entryDialog.updatePrice(this)
                    }
                    SpinBox {
                        id: itemPriceSubtotal
                        decimals: 2
                        maximumValue: 999
                        prefix: qsTr("$ ")
                        suffix: qsTr(" total")
                        stepSize: 1
                        onValueChanged: entryDialog.updatePrice(this)
                    }
                }

                // Row 5
                Label { text: "Expiracy:" }
                ColumnLayout {
                    Layout.columnSpan: 2
                    Slider {
                        id: itemExpiracy

                        property var today: new Date()

                        Layout.fillWidth: true
                        minimumValue: 1
                        maximumValue: 30
                        tickmarksEnabled: true
                        updateValueWhileDragging: true
                        stepSize: 1

                        onValueChanged: updateDate();

                        function updateDate() {
                            var expDate = new Date();
                            expDate.setDate(today.getDate() + itemExpiracy.value);
                            itemExpiracyDate.text = "Expires on " + Qt.formatDateTime(expDate, "yyyy-MM-dd")
                        }
                    }

                    Label {
                        id: itemExpiracyDays
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr(itemExpiracy.value + (itemExpiracy.value == 1 ? " day" : " days"));
                    }

                    Label {
                        id: itemExpiracyDate
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Expires on " + Qt.formatDateTime(itemExpiracy.today + 7, "yyyy-MM-dd")
                    }
                }
            }
        }
    }
}
