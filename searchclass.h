#ifndef SEARCHCLASS_H
#define SEARCHCLASS_H

#include <QObject>
#include <QDirIterator>
#include <QStringList>
#include <QThread>
#include <QDebug>

class SearchClass : public QObject
{
    Q_OBJECT
public:
    explicit SearchClass(QObject *parent = nullptr);

public slots:
    void search(QString path, QString searchName);

signals:
    void resultList(QStringList list);
};

#endif // SEARCHCLASS_H
