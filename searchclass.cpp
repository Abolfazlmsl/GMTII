#include "searchclass.h"

SearchClass::SearchClass(QObject *parent)
    : QObject{parent}
{

}

/**
 * @brief SearchClass::search
 * Search the files and folders in the path, which contains
 * the serachName and emit them in a string list.
 * @param path
 * @param searchName
 */
void SearchClass::search(QString path, QString searchName)
{
#ifdef __linux__
    path = "/" + path;
#endif
    qDebug() << QThread::currentThread();
    QStringList stringList;
    if (searchName != ""){
        QDirIterator fileIterator(path, QDirIterator::NoIteratorFlags);

        while (fileIterator.hasNext()) {
            QString filename = fileIterator.next();

            if (filename.contains(searchName, Qt::CaseInsensitive))
            {
                stringList.append(filename);
            }
        }
    }

    emit resultList(stringList);
}
