#ifndef PODCASTLISTSERIALIZATION_H
#define PODCASTLISTSERIALIZATION_H

#include <QStringListModel>
#include <QStringList>

class PodcastListSerialization : public QStringListModel
{
public:
    PodcastListSerialization();
    ~PodcastListSerialization();
    void appendString(const QString& string);
    void removeString(const QString& string);
    bool saveState();
    bool loadState();
private:
};

#endif // PODCASTLISTSERIALIZATION_H
