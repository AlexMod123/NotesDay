
#ifndef DAILY_NOTESMODEL_H
#define DAILY_NOTESMODEL_H
#include <QObject>
#include <QAbstractListModel>
#include <QSqlQuery>


class NotesModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles { IdRole = Qt::UserRole + 1, TextRole };

    NotesModel(QObject* parent = nullptr) : QAbstractListModel(parent)
    {
    }

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    void load(const QString& date);
    void addNote(int id, const QString& text);
    void updateNote(int row, const QString& text);
    void deleteNote(int row);

private:
    struct Note
    {
        int id;
        QString text;
    };

    QList<Note> m_notes;
    QString m_date;
};


#endif //DAILY_NOTESMODEL_H
