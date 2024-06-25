#ifndef MYTHREADRUNNER_H
#define MYTHREADRUNNER_H

#include <QObject>
#include <QThread>

#include "searchclass.h"

class MyThreadRunner : public QObject
{
    Q_OBJECT
public:
    explicit MyThreadRunner(QObject *parent = nullptr);

public slots:
    void start(QString myPath, QString mySearchName);
    void sendSignal();

signals:
    void doWork(QString path, QString searchName);
    void resultList(QStringList list);

private:
    QString path;
    QString searchName;

};

#endif // MYTHREADRUNNER_H
