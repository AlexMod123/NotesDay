#include "databasemanager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include <QVariant>
// DatabaseManager implementation
DatabaseManager::DatabaseManager(QObject* parent) : QObject(parent), m_currentDate(QDate::currentDate()),
                                                    m_notesModel(new NotesModel(this)),
                                                    m_metricsModel(new MetricsModel(this)),
                                                    m_metricTypesModel(new MetricTypesModel(this))
{
    initDatabase();
    m_metricTypesModel->setQuery("SELECT id, name FROM metric_types ORDER BY id");
    updateModels();
}

DatabaseManager::~DatabaseManager()
{
}

void DatabaseManager::setCurrentDate(const QDate& date)
{
    if (m_currentDate == date) return;
    m_currentDate = date;
    updateModels();
    emit currentDateChanged();
}

void DatabaseManager::initDatabase()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("stats.db");
    if (!db.open())
    {
        qDebug() << "Database open error:" << db.lastError().text();
        return;
    }
    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS metric_types (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE)");
    query.exec("CREATE TABLE IF NOT EXISTS notes (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, text TEXT)");
    query.exec(
        "CREATE TABLE IF NOT EXISTS metrics (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, type_id INTEGER, score INTEGER)");
}

void DatabaseManager::updateModels()
{
    QString dateStr = m_currentDate.toString("yyyy-MM-dd");
    m_notesModel->load(dateStr);
    m_metricsModel->load(dateStr);
}

double DatabaseManager::calculateAverage(const QDate& date) const
{
    QString dateStr = date.toString("yyyy-MM-dd");
    QSqlQuery query;
    query.prepare("SELECT AVG(score) FROM metrics WHERE date = ?");
    query.addBindValue(dateStr);
    if (query.exec() && query.next())
    {
        return query.value(0).toDouble();
    }
    return 0.0;
}

QColor DatabaseManager::getDayColor(const QDate& date) const
{
    double avg = calculateAverage(date);
    if (avg == 0.0) return QColor(Qt::white);
    int hue = static_cast<int>((avg - 1.0) / 9.0 * 120.0);
    return QColor::fromHsl(hue, 255, 128);
}

void DatabaseManager::addNote(const QString& text)
{
    QString dateStr = m_currentDate.toString("yyyy-MM-dd");
    QSqlQuery query;
    query.prepare("INSERT INTO notes (date, text) VALUES (?, ?)");
    query.addBindValue(dateStr);
    query.addBindValue(text);
    if (query.exec())
    {
        m_notesModel->addNote(query.lastInsertId().toInt(), text);
    }
    else
    {
        qDebug() << "Add note error:" << query.lastError().text();
    }
}

void DatabaseManager::updateNote(const int row, const QString& text)
{
    int id = m_notesModel->data(m_notesModel->index(row, 0), NotesModel::IdRole).toInt();
    QSqlQuery query;
    query.prepare("UPDATE notes SET text = ? WHERE id = ?");
    query.addBindValue(text);
    query.addBindValue(id);
    if (query.exec())
    {
        m_notesModel->updateNote(row, text);
    }
    else
    {
        qDebug() << "Update note error:" << query.lastError().text();
    }
}

void DatabaseManager::deleteNote(const int row)
{
    const int id = m_notesModel->data(m_notesModel->index(row, 0), NotesModel::IdRole).toInt();
    QSqlQuery query;
    query.prepare("DELETE FROM notes WHERE id = ?");
    query.addBindValue(id);
    if (query.exec())
    {
        m_notesModel->deleteNote(row);
    }
    else
    {
        qDebug() << "Delete note error:" << query.lastError().text();
    }
}

void DatabaseManager::addMetricType(const QString& name)
{
    QSqlQuery query;
    query.prepare("INSERT OR IGNORE INTO metric_types (name) VALUES (?)");
    query.addBindValue(name);
    if (query.exec())
    {
        m_metricTypesModel->setQuery("SELECT id, name FROM metric_types ORDER BY id");
        emit metricTypesChanged();
    }
    else
    {
        qDebug() << "Add metric type error:" << query.lastError().text();
    }
}

void DatabaseManager::addMetric(const int typeId, const int score)
{
    QString dateStr = m_currentDate.toString("yyyy-MM-dd");
    QSqlQuery query;
    query.prepare("INSERT INTO metrics (date, type_id, score) VALUES (?, ?, ?)");
    query.addBindValue(dateStr);
    query.addBindValue(typeId);
    query.addBindValue(score);
    if (query.exec())
    {
        m_metricsModel->addMetric(query.lastInsertId().toInt(), typeId, score);
    }
    else
    {
        qDebug() << "Add metric error:" << query.lastError().text();
    }
}

void DatabaseManager::updateMetric(const int row, const int score)
{
    int id = m_metricsModel->data(m_metricsModel->index(row, 0), MetricsModel::IdRole).toInt();
    QSqlQuery query;
    query.prepare("UPDATE metrics SET score = ? WHERE id = ?");
    query.addBindValue(score);
    query.addBindValue(id);
    if (query.exec())
    {
        m_metricsModel->updateMetric(row, score);
    }
    else
    {
        qDebug() << "Update metric error:" << query.lastError().text();
    }
}

void DatabaseManager::deleteMetric(const int row)
{
    int id = m_metricsModel->data(m_metricsModel->index(row, 0), MetricsModel::IdRole).toInt();
    QSqlQuery query;
    query.prepare("DELETE FROM metrics WHERE id = ?");
    query.addBindValue(id);
    if (query.exec())
    {
        m_metricsModel->deleteMetric(row);
    }
    else
    {
        qDebug() << "Delete metric error:" << query.lastError().text();
    }
}

QString DatabaseManager::getMetricTypeName(const int typeId) const
{
    QSqlQuery query;
    query.prepare("SELECT name FROM metric_types WHERE id = ?");
    query.addBindValue(typeId);
    if (query.exec() && query.next())
    {
        return query.value(0).toString();
    }
    return "Неизвестно";
}
