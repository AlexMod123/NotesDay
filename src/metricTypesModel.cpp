

#include "metricTypesModel.h"

// MetricTypesModel implementation
QVariant MetricTypesModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid()) return QVariant();
    if (role == IdRole)
    {
        return QSqlQueryModel::data(index.sibling(index.row(), 0));
    }
    if (role == NameRole)
    {
        return QSqlQueryModel::data(index.sibling(index.row(), 1));
    }
    return QSqlQueryModel::data(index, role);
}

QHash<int, QByteArray> MetricTypesModel::roleNames() const
{
    QHash<int, QByteArray> roles = QSqlQueryModel::roleNames();
    roles[IdRole] = "id";
    roles[NameRole] = "name";
    return roles;
}
