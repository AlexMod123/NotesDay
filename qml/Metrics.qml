import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

GroupBox {
    font.pixelSize: 14
    Layout.fillWidth: true
    Layout.preferredHeight: 200
    Layout.minimumWidth: 400
    clip: true
    background: Rectangle {
        color: "#ffffff" // Светлый фон GroupBox
        border.color: "#d3d3d3"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 8
        RowLayout {
            spacing: 10
            Image {
                source: "qrc:/images/images/metrics.png"
                width: 16
                height: 16
                Layout.alignment: Qt.AlignVCenter
                // Component.onCompleted: console.log("Metrics GroupBox icon loaded:", source)
            }
            Label {
                text: "Метрики"
                font.pixelSize: 16
                color: "#000000" // Черный текст
                Layout.alignment: Qt.AlignVCenter
            }
        }
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: dbManager.metricsModel()
            delegate: RowLayout {
                width: ListView.view.width
                spacing: 5
                Label {
                    Layout.preferredWidth: 150
                    text: dbManager.getMetricTypeName(model.type_id)
                    font.pixelSize: 14
                    color: "#000000" // Черный текст
                }
                SpinBox {
                    id: spinboxUpdatable
                    from: 1
                    to: 10
                    value: model.score
                    font.pixelSize: 14
                    contentItem: TextInput {
                        z: 2
                        text: spinboxUpdatable.value
                        color: "black" // Черный цвет для цифр
                        font: Qt.font({pixelSize: 14})
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                        readOnly: false
                        validator: spinboxUpdatable.validator
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                    }
                    background: Rectangle {
                        implicitWidth: 140
                        implicitHeight: 24
                        color: "white"
                    }
                    onValueChanged: if (value !== model.score) dbManager.updateMetric(index, value)
                }
                Button {
                    Layout.preferredWidth: 24 // Минимальная ширина для иконки
                    icon.source: "qrc:/images/images/delete.png"
                    icon.width: 16
                    icon.height: 16
                    icon.color: "#000000"
                    ToolTip.text: "Удалить метрику"
                    ToolTip.visible: hovered
                    ToolTip.delay: 500
                    background: Rectangle {
                        color: "transparent" // Прозрачный фон кнопки
                    }
                    onClicked: dbManager.deleteMetric(index)
                }
            }
            clip: true
            ScrollBar.vertical: ScrollBar {
                background: Rectangle {
                    color: "#100505"
                }
                contentItem: Rectangle {
                    color: "#444444"
                }
            }
        }
        RowLayout {
            spacing: 5
            ComboBox {
                id: metricTypeCombo
                Layout.preferredWidth: 150
                model: dbManager.metricTypesModel()
                textRole: "name"
                valueRole: "id"
                font.pixelSize: 14
                enabled: model && model.rowCount() > 0
                contentItem: Text {
                    text: metricTypeCombo.displayText ? metricTypeCombo.displayText : "Выберите тип"
                    font: metricTypeCombo.font
                    color: "#000000" // Черный текст
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 5
                }
                background: Rectangle {
                    color: "#f5f5f5" // Светлый фон
                    border.color: "#d3d3d3"
                }
                delegate: ItemDelegate {
                    width: metricTypeCombo.width
                    contentItem: Text {
                        text: {model.name ? model.name : "Неизвестно"}
                        font: metricTypeCombo.font
                        color: "#000000" // Черный текст
                        verticalAlignment: Text.AlignVCenter
                    }
                    highlighted: metricTypeCombo.highlightedIndex === index
                    background: Rectangle {
                        color: highlighted ? "#d3d3d3" : "#f5f5f5" // Светло-серый для выделения
                    }
                }
                popup: Popup {
                    y: metricTypeCombo.height
                    width: metricTypeCombo.width
                    implicitHeight: contentItem.implicitHeight
                    background: Rectangle {
                        color: "#f5f5f5" // Светлый фон выпадающего списка
                        border.color: "#d3d3d3"
                    }
                    contentItem: ListView {
                        clip: true
                        implicitHeight: contentHeight
                        model: metricTypeCombo.popup.visible ? metricTypeCombo.delegateModel : null
                        currentIndex: metricTypeCombo.highlightedIndex
                        ScrollIndicator.vertical: ScrollIndicator {
                            background: Rectangle {
                                color: "#f5f5f5"
                            }
                            contentItem: Rectangle {
                                color: "#d3d3d3"
                            }
                        }
                    }
                }
            }
            SpinBox {
                id: metricScoreSpin
                from: 1
                to: 10
                value: 5
                font.pixelSize: 14
                // down.indicator: Rectangle {
                //     x: control.mirrored ? parent.width - width : 0
                //     height: parent.height
                //     color: "transparent"
                //     border.color: "black"
                //     implicitWidth: 16
                //     implicitHeight: 16
                //     Text {
                //         text: "-"
                //         color: "black" // Черный цвет
                //         font: Qt.font({pixelSize: 14, bold: true})
                //         horizontalAlignment: Text.AlignHCenter
                //         verticalAlignment: Text.AlignVCenter
                //     }
                // }
                contentItem: TextInput {
                    z: 2
                    text: metricScoreSpin.value
                    color: "black" // Черный цвет для цифр
                    font: Qt.font({pixelSize: 14})
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    readOnly: false
                    validator: metricScoreSpin.validator
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                }
                // up.indicator: Rectangle {
                //     x: control.mirrored ? 0 : parent.width - width
                //     height: parent.height
                //     implicitWidth: 16
                //     implicitHeight: 16
                //     color: "transparent"
                //     Text {
                //         text: "+"
                //         color: "black" // Черный цвет
                //         font: Qt.font({pixelSize: 14, bold: true})
                //         horizontalAlignment: Text.AlignHCenter
                //         verticalAlignment: Text.AlignVCenter
                //     }
                // }

                background: Rectangle {
                    implicitWidth: 140
                    implicitHeight: 24
                    color: "white"
                }
            }
            Button {
                Layout.preferredWidth: 24 // Минимальная ширина для иконки
                icon.source: "qrc:/images/images/add.png"
                icon.width: 16
                icon.height: 16
                icon.color: "#000000"
                ToolTip.text: "Добавить метрику"
                ToolTip.visible: hovered
                ToolTip.delay: 500
                background: Rectangle {
                    color: "transparent" // Прозрачный фон кнопки
                }
                enabled: metricTypeCombo.model && metricTypeCombo.model.rowCount() > 0
                onClicked: {
                    if (metricTypeCombo.currentValue > 0) {
                        dbManager.addMetric(metricTypeCombo.currentValue, metricScoreSpin.value)
                    }
                }
            }
        }
        RowLayout {
            spacing: 5
            TextField {
                id: newMetricTypeField
                Layout.fillWidth: true
                placeholderText: "Название нового типа метрики"
                font.pixelSize: 14
                color: "#000000" // Черный текст
                placeholderTextColor: "#666666" // Серый для placeholder
                background: Rectangle {
                    color: "#f5f5f5" // Светлый фон
                    border.color: "#d3d3d3"
                }
            }
            Button {
                Layout.preferredWidth: 24 // Минимальная ширина для иконки
                icon.source: "qrc:/images/images/add.png"
                icon.width: 16
                icon.color: "#000000"
                icon.height: 16
                ToolTip.text: "Добавить тип метрики"
                ToolTip.visible: hovered
                ToolTip.delay: 500
                background: Rectangle {
                    color: "transparent" // Прозрачный фон кнопки
                }
                onClicked: {
                    if (newMetricTypeField.text !== "") {
                        dbManager.addMetricType(newMetricTypeField.text)
                        newMetricTypeField.text = ""
                    }
                }
            }
        }
    }

    Connections {
        target: dbManager

        function onMetricTypesChanged() {
            // console.log("Metric types changed, forcing model update")
            metricTypeCombo.model.setQuery("SELECT id, name FROM metric_types ORDER BY id")
            // console.log("Metric types after update, row count:", metricTypeCombo.model.rowCount())
        }
    }
}