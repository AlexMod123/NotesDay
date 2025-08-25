import QtQuick 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15
import QtQuick.Layouts 1.15

GroupBox {
    Layout.fillWidth: true
    Layout.fillHeight: true
    clip: true
    background: Rectangle {
        color: "#ffffff" // Светлый фон GroupBox
        border.color: "#d3d3d3"
    }
    ChartView {
        id: chartView
        anchors.fill: parent
        antialiasing: true
        backgroundColor: "#f5f5f5" // Светлый фон графика
        LineSeries {
            id: metricSeries
            name: "Линия"
            axisX: ValueAxis {
                id: xAxis
                min: 0
                max: 0
                titleText: "Метрики"
            }
            axisY: ValueAxis {
                min: 0; max: 10; titleText: "Значения"
            }

        }

        function update() {
            metricSeries.clear();
            for (var i = 0; i < dbManager.metricsModel().rowCount(); ++i) {
                var x = dbManager.metricsModel().data(dbManager.metricsModel().index(i, 1), dbManager.metricsModel().type_id);
                var y = dbManager.metricsModel().data(dbManager.metricsModel().index(i, 2), dbManager.metricsModel().score);
                metricSeries.append(i, y);
            }
            xAxis.max = dbManager.metricsModel().rowCount() > 0 ? dbManager.metricsModel().rowCount() - 1 : 0

        }

        Connections {
            target: dbManager

            function onCurrentDateChanged() {
                chartView.update()
            }
        }
        Connections {
            target: dbManager.metricsModel()

            function onMetricsChanged() {
                chartView.update()
            }
        }
        Component.onCompleted: {
            chartView.update()
        }
    }
}