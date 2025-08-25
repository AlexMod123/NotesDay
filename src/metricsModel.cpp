#include "metricsModel.h"
// MetricsModel implementation
void MetricsModel::load(const QString& date)
{
    beginResetModel();
    m_metrics.clear();
    m_date = date;
    QSqlQuery query;
    query.prepare("SELECT id, type_id, score FROM metrics WHERE date = ? ORDER BY id");
    query.addBindValue(date);
    if (query.exec())
    {
        while (query.next())
        {
            m_metrics.append({query.value(0).toInt(), query.value(1).toInt(), query.value(2).toInt()});
        }
    }
    else
    {
    }
    endResetModel();
}

void MetricsModel::addMetric(const int id, const int typeId, const int score)
{
    beginInsertRows(QModelIndex(), m_metrics.size(), m_metrics.size());
    m_metrics.append({id, typeId, score});
    endInsertRows();
    emit metricsChanged();
}

void MetricsModel::updateMetric(const int row, const int score)
{
    if (row < 0 || row >= m_metrics.size()) return;
    m_metrics[row].score = score;
    QModelIndex idx = index(row, 0);
    emit dataChanged(idx, idx, {ScoreRole});
    emit metricsChanged();
}

void MetricsModel::deleteMetric(const int row)
{
    if (row < 0 || row >= m_metrics.size()) return;
    beginRemoveRows(QModelIndex(), row, row);
    m_metrics.removeAt(row);
    endRemoveRows();
    emit metricsChanged();
}

MetricsModel::MetricsModel(QObject* parent) : QAbstractTableModel(parent)
{
}

int MetricsModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid()) return 0;
    return m_metrics.count();
}

int MetricsModel::columnCount(const QModelIndex& parent) const
{
    if (parent.isValid()) return 0;
    return 3; // id, type_id, score
}

QVariant MetricsModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() >= m_metrics.count())
        return QVariant();

    const Metric& metric = m_metrics[index.row()];
    switch (role)
    {
    case IdRole:
        return metric.id;
    case TypeIdRole:
        return metric.typeId;
    case ScoreRole:
        return metric.score;
    case Qt::DisplayRole:
        switch (index.column())
        {
        case 0: return metric.id;
        case 1: return metric.typeId;
        case 2: return metric.score;
        default: return QVariant();
        }
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> MetricsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[TypeIdRole] = "type_id";
    roles[ScoreRole] = "score";
    return roles;
}
