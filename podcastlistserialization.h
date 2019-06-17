#ifndef PODCASTLISTSERIALIZATION_H
#define PODCASTLISTSERIALIZATION_H

#include <QStringListModel>
#include <QStringList>

class PodcastListSerialization : public QObject
{
    Q_OBJECT
public:
    PodcastListSerialization();
    ~PodcastListSerialization();
    Q_INVOKABLE void appendString(const QString& string);
    Q_INVOKABLE void removeString(const QString& string);
    bool saveState();
    bool loadState();
    Q_INVOKABLE QStringListModel* getModel(){
        return m_model;
    }
private:
    QStringListModel* m_model;
};

#endif // PODCASTLISTSERIALIZATION_H
