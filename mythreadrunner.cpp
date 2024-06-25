#include "mythreadrunner.h"

MyThreadRunner::MyThreadRunner(QObject *parent): QObject{parent}
{

}

/**
 * @brief MyThreadRunner::start
 * This slot is called from qml and handles the signals ans slots.
 * @param path
 * @param searchName
 */
void MyThreadRunner::start(QString myPath, QString mySearchName)
{
    path = myPath;
    searchName = mySearchName;
    SearchClass *searchObj = new SearchClass();
    QThread *thread = new QThread();
    thread->setObjectName("Worker thread");
    searchObj->moveToThread(thread);

    connect(thread, &QThread::started, this, &MyThreadRunner::sendSignal);
    connect(this, &MyThreadRunner::doWork, searchObj, &SearchClass::search);
    connect(searchObj, &SearchClass::resultList, this, &MyThreadRunner::resultList);
    connect(this, &MyThreadRunner::resultList, searchObj, &SearchClass::deleteLater);

    thread->start();
}

/**
 * @brief MyThreadRunner::start
 * This slot is called when thread is started and emits the doWork Signal
 * with the arguments to start the searching.
 * @param path
 * @param searchName
 */
void MyThreadRunner::sendSignal()
{
    emit doWork(path, searchName);
}
