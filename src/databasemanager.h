#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QDate>
#include <QColor>
#include "metricsModel.h"
#include "notesModel.h"
#include "metricTypesModel.h"


class DatabaseManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QDate currentDate READ currentDate WRITE setCurrentDate NOTIFY currentDateChanged)

public:
    explicit DatabaseManager(QObject* parent = nullptr);
    ~DatabaseManager();
    QDate currentDate() const { return m_currentDate; }
    void setCurrentDate(const QDate& date);
    Q_INVOKABLE QColor getDayColor(const QDate& date) const;
    Q_INVOKABLE void addNote(const QString& text);
    Q_INVOKABLE void updateNote(int row, const QString& text);
    Q_INVOKABLE void deleteNote(int row);
    Q_INVOKABLE QAbstractListModel* notesModel() { return m_notesModel; }
    Q_INVOKABLE void addMetricType(const QString& name);
    Q_INVOKABLE QSqlQueryModel* metricTypesModel() { return m_metricTypesModel; }
    Q_INVOKABLE void addMetric(int typeId, int score);
    Q_INVOKABLE void updateMetric(int row, int score);
    Q_INVOKABLE void deleteMetric(int row);
    Q_INVOKABLE QAbstractTableModel* metricsModel() { return m_metricsModel; }
    // Q_INVOKABLE QAbstractListModel* metricsModel() { return m_metricsModel; }
    Q_INVOKABLE QString getMetricTypeName(int typeId) const;
signals:
    void currentDateChanged();
    void metricTypesChanged();

private:
    QDate m_currentDate;
    NotesModel* m_notesModel;
    MetricsModel* m_metricsModel;
    MetricTypesModel* m_metricTypesModel;
    void initDatabase();
    void updateModels();
    double calculateAverage(const QDate& date) const;
};

#endif // DATABASEMANAGER_H
