//
// Created by alex on 25.08.2025.
//

#ifndef DAILY_METRICTYPESMODEL_H
#define DAILY_METRICTYPESMODEL_H
#include <QObject>
#include <QSqlQueryModel>

class MetricTypesModel : public QSqlQueryModel
{
    Q_OBJECT

public:
    enum Roles { IdRole = Qt::UserRole + 1, NameRole };

    MetricTypesModel(QObject* parent = nullptr) : QSqlQueryModel(parent)
    {
    }

    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
};


#endif //DAILY_METRICTYPESMODEL_H