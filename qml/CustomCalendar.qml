import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

GroupBox {
    // title: "Календарь"
    Layout.preferredWidth: 400
    Layout.fillHeight: true
    clip: true
    background: Rectangle {
        color: "#ffffff" // Светлый фон GroupBox
        border.color: "#d3d3d3"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 2 // Уменьшенное расстояние
        RowLayout {
            spacing: 5
            Image {
                source: "qrc:/images/images/calendar.png"
                width: 16
                height: 16
                Layout.alignment: Qt.AlignVCenter
                // Component.onCompleted: console.log("Calendar GroupBox icon loaded:", source)
            }
            Label {
                text: "Календарь"
                font.pixelSize: 16
                color: "#000000" // Черный текст
                Layout.alignment: Qt.AlignVCenter
            }
        }
        // Навигация по месяцам
        RowLayout {
            Layout.fillWidth: true
            spacing: 5
            Button {
                Layout.preferredWidth: 24
                icon.source: "qrc:/images/images/arrow-left.png" // Иконка для предыдущего месяца
                icon.width: 16
                icon.height: 16
                icon.color: "#000000"
                ToolTip.text: "Предыдущий месяц"
                ToolTip.visible: hovered
                ToolTip.delay: 500
                background: Rectangle {
                    color: "transparent" // Прозрачный фон кнопки
                }
                onClicked: {
                    var newDate = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1)
                    dbManager.currentDate = newDate
                    currentDate = newDate
                }
                // Component.onCompleted: console.log("Previous button icon:", icon.source)
            }
            Label {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: currentDate.toLocaleString(Qt.locale(), "MMMM yyyy")
                font.bold: true
                font.pixelSize: 16
                color: "#000000" // Черный текст
            }
            Button {
                Layout.preferredWidth: 24
                icon.source: "qrc:/images/images/arrow-right.png" // Иконка для следующего месяца
                icon.width: 16
                icon.height: 16
                icon.color: "#000000"
                ToolTip.text: "Следующий месяц"
                ToolTip.visible: hovered
                ToolTip.delay: 500
                background: Rectangle {
                    color: "transparent" // Прозрачный фон кнопки
                }
                onClicked: {
                    var newDate = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1)
                    dbManager.currentDate = newDate
                    currentDate = newDate
                }
                // Component.onCompleted: console.log("Next button icon:", icon.source)
            }
        }

        // Заголовки дней недели
        Grid {
            Layout.fillWidth: true
            columns: 7
            spacing: 2
            Repeater {
                model: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
                Rectangle {
                    width: (parent.width - parent.spacing * 6) / 7
                    height: 30
                    color: "#f5f5f5" // Светлый фон
                    Label {
                        anchors.centerIn: parent
                        text: modelData
                        font.bold: true
                        font.pixelSize: 12
                        color: "#000000" // Черный текст
                    }
                }
            }
        }

        // Сетка дней месяца
        Grid {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 7
            spacing: 2
            clip: true
            Repeater {
                model: 42 // 6 недель × 7 дней
                Rectangle {
                    width: Math.max((parent.width - parent.spacing * 6) / 7, 30) // Минимальная ширина 30
                    height: width // Квадратные ячейки
                    color: {
                        var day = index - firstDayOffset + 1
                        if (day < 1 || day > daysInMonth) return "#f5f5f5" // Пустые ячейки
                        var date = new Date(currentDate.getFullYear(), currentDate.getMonth(), day)
                        var color = dbManager.getDayColor(date)
                        return color ? color : "#ffffff" // Белый фон по умолчанию
                    }
                    border.color: {
                        var day = index - firstDayOffset + 1
                        if (day < 1 || day > daysInMonth) return "transparent"
                        var date = new Date(currentDate.getFullYear(), currentDate.getMonth(), day)
                        var today = new Date()
                        var isToday = date.toDateString() === today.toDateString()
                        var isSelected = date.toDateString() === dbManager.currentDate.toDateString()
                        return isToday ? "#ef9472" : isSelected ? "#76bdf5" : "transparent"
                    }
                    border.width: border.color !== "transparent" ? 2 : 0
                    Label {
                        anchors.centerIn: parent
                        text: {
                            var day = index - firstDayOffset + 1
                            return (day < 1 || day > daysInMonth) ? "" : day
                        }
                        font.pixelSize: 16
                        color: "#000000" // Черный текст
                    }
                    MouseArea {
                        anchors.fill: parent
                        enabled: {
                            var day = index - firstDayOffset + 1
                            return day >= 1 && day <= daysInMonth
                        }
                        onClicked: {
                            var day = index - firstDayOffset + 1
                            dbManager.currentDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), day)
                            currentDate = dbManager.currentDate
                        }
                    }
                }
            }
        }
    }

    property date currentDate: dbManager.currentDate
    property int daysInMonth: new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0).getDate()
    property date firstDayOfMonth: new Date(currentDate.getFullYear(), currentDate.getMonth(), 1)
    property int firstDayOffset: (firstDayOfMonth.getDay() + 6) % 7 // Смещение для понедельника
}