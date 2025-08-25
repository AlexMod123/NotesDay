import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

GroupBox {

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumWidth: 400
    clip: true
    background: Rectangle {
        color: "#ffffff" // Светлый фон GroupBox
        border.color: "#d3d3d3"
    }

    ColumnLayout {

        anchors.fill: parent
        anchors.margins: 5
        spacing: 5
        RowLayout {
            spacing: 5
            Image {
                source: "qrc:/images/images/notes.png"
                width: 16
                height: 16
                Layout.alignment: Qt.AlignVCenter
                // Component.onCompleted: console.log("Notes GroupBox icon loaded:", source)
            }
            Label {
                text: {
                    var date = dbManager.currentDate
                    var dayName = date.toLocaleString(Qt.locale("ru_RU"), "dddd")
                    dayName = dayName.charAt(0).toUpperCase() + dayName.slice(1)
                    return "Заметки за " + date.toLocaleString(Qt.locale("ru_RU"), "d MMMM") + " (" + dayName + ")"
                }
                font.pixelSize: 16
                color: "#000000" // Черный текст
                Layout.alignment: Qt.AlignVCenter
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: dbManager.notesModel()
            delegate: RowLayout {
                width: ListView.view.width
                spacing: 5
                TextArea {
                    Layout.fillWidth: true
                    text: model.text
                    wrapMode: TextArea.Wrap
                    font.pixelSize: 14
                    color: "#000000" // Черный текст
                    background: Rectangle {
                        color: "#f5f5f5" // Светлый фон
                        border.color: "#d3d3d3"
                    }
                    onEditingFinished: if (text !== model.text) dbManager.updateNote(index, text)
                }
                Button {
                    Layout.preferredWidth: 24 // Минимальная ширина для иконки
                    icon.source: "qrc:/images/images/delete.png"
                    icon.width: 16
                    icon.height: 16
                    icon.color: "#000000"
                    ToolTip.text: "Удалить заметку"
                    ToolTip.visible: hovered
                    ToolTip.delay: 500
                    background: Rectangle {
                        color: "transparent" // Прозрачный фон кнопки
                    }
                    onClicked: dbManager.deleteNote(index)
                    // Component.onCompleted: console.log("Delete note button icon:", icon.source)
                }
            }
            clip: true
            ScrollBar.vertical: ScrollBar {
                background: Rectangle { color: "#444444" }
                contentItem: Rectangle { color: "#444444" }
            }
        }
        RowLayout {
            spacing: 5
            TextField {
                id: noteField
                Layout.fillWidth: true
                placeholderText: "Введите заметку"
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
                icon.height: 16
                icon.color: "#000000"
                ToolTip.text: "Добавить заметку"
                ToolTip.visible: hovered
                ToolTip.delay: 500
                background: Rectangle {
                    color: "transparent" // Прозрачный фон кнопки
                }
                onClicked: {
                    if (noteField.text !== "") {
                        dbManager.addNote(noteField.text)
                        noteField.text = ""
                    }
                }
                // Component.onCompleted: console.log("Add note button icon:", icon.source)
            }
        }
    }
}
