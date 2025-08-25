
#ifndef DAILY_METRICSMODEL_H
#define DAILY_METRICSMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QSqlQuery>
#include <QDateTime>
#include <QSqlError>

class MetricsModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    explicit MetricsModel(QObject* parent = nullptr);

    enum MetricRoles
    {
        IdRole = Qt::UserRole + 1,
        TypeIdRole,
        ScoreRole
    };

    Q_ENUM(MetricRoles)
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    int columnCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    void load(const QString& date);
    void addMetric(int id, int typeId, int score);
    void updateMetric(int row, int score);
    void deleteMetric(int row);

private:
    struct Metric
    {
        int id;
        int typeId;
        int score;
    };

    QList<Metric> m_metrics;
    QString m_date;
signals:
    void metricsChanged();
};


#endif //DAILY_METRICSMODEL_H
