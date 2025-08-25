
#include "notesModel.h"

// NotesModel implementation
int NotesModel::rowCount(const QModelIndex&) const { return m_notes.size(); }

QVariant NotesModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() >= m_notes.size()) return QVariant();
    const Note& note = m_notes[index.row()];
    if (role == IdRole) return note.id;
    if (role == TextRole) return note.text;
    return QVariant();
}

QHash<int, QByteArray> NotesModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[TextRole] = "text";
    return roles;
}

void NotesModel::load(const QString& date)
{
    beginResetModel();
    m_notes.clear();
    m_date = date;
    QSqlQuery query;
    query.prepare("SELECT id, text FROM notes WHERE date = ? ORDER BY id");
    query.addBindValue(date);
    if (query.exec())
    {
        while (query.next())
        {
            m_notes.append({query.value(0).toInt(), query.value(1).toString()});
        }
    }
    else
    {
    }
    endResetModel();
}

void NotesModel::addNote(int id, const QString& text)
{
    beginInsertRows(QModelIndex(), m_notes.size(), m_notes.size());
    m_notes.append({id, text});
    endInsertRows();
}

void NotesModel::updateNote(int row, const QString& text)
{
    if (row < 0 || row >= m_notes.size()) return;
    m_notes[row].text = text;
    QModelIndex idx = index(row, 0);
    emit dataChanged(idx, idx, {TextRole});
}

void NotesModel::deleteNote(int row)
{
    if (row < 0 || row >= m_notes.size()) return;
    beginRemoveRows(QModelIndex(), row, row);
    m_notes.removeAt(row);
    endRemoveRows();
}
