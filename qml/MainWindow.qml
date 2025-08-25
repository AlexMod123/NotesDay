import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 1280
    height: 760
    title: "Daily"
    color: "#706f6f" // Светлый фон приложения

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10 // Отступ между блоками

        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            CustomCalendar {
                Layout.preferredWidth: 400
                Layout.fillHeight: true
            }
            Notes {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            Metrics {
                Layout.preferredWidth: 200
                Layout.fillHeight: true
            }
            Chart {
                Layout.preferredWidth: 400
                Layout.fillHeight: true
            }
        }

    }
}