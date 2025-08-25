#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

#include "src/databasemanager.h"

int main(int argc, char* argv[])
{
    QApplication app(argc, argv);
    DatabaseManager dbManager;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("dbManager", &dbManager);
    engine.load(":/qml/MainWindow.qml");
    return QApplication::exec();
}
