#include "podcastlistserialization.h"
#include <QJsonObject>
#include <QFile>
#include <QDir>
#include <QJsonArray>
#include <QJsonDocument>

PodcastListSerialization::PodcastListSerialization()
{
    QStringList initList;
    initList << "meduza.io/rss/podcasts/meduza-v-kurse"
             << "meduza.io/rss/podcasts/tekst-nedeli"
             << "meduza.io/rss/podcasts/dva-po-tsene-odnogo"
             << "meduza.io/rss/podcasts/peremotka"
             << "meduza.io/rss/podcasts/sperva-rodi"
             << "echo.msk.ru/programs/personalno/rss-audio.xml"
             << "podster.fm/rss.xml?pid=48999"
             << "rss.simplecast.com/podcasts/2131/rss";
    if (loadState() == false){
        this->setStringList(initList);
    }
}

PodcastListSerialization::~PodcastListSerialization()
{
    saveState();
}

void PodcastListSerialization::appendString(const QString &string){
    auto ts = this->stringList();
    ts.append(string);
    this->setStringList(ts);
}

void PodcastListSerialization::removeString(const QString &string){
    auto ts = this->stringList();
    ts.removeAll(string);
    this->setStringList(ts);
}

bool PodcastListSerialization::saveState()
{
    QFile file;
    bool ret = false;
    file.setFileName(QDir::toNativeSeparators( QDir::homePath() + "/" + ".podcastplayer.conf") );
    if (file.open(QIODevice::WriteOnly)){
        QJsonObject obj;
        QJsonArray rssArr;
        for (auto& sl: stringList()){
            QJsonValue jv;
            jv = sl;
            rssArr.append(jv);
        }
        obj["rss"] = rssArr;
        QJsonDocument jd;
        jd.setObject(obj);
        if (file.write(jd.toJson()) > 0){
            ret = true;
        }
    }
    file.close();
    return ret;
}

bool PodcastListSerialization::loadState()
{
    bool ret = false;
    QFile file;
    file.setFileName(QDir::toNativeSeparators( QDir::homePath() + "/" + ".podcastplayer.conf") );
    file.open(QIODevice::ReadOnly);
    auto t = file.readAll();
    if (!t.isEmpty()){
        QJsonDocument jd = QJsonDocument::fromJson(t);
        auto obj = jd.object();
        auto rss = obj["rss"].toArray();
        QStringList fromJson;
        for (auto r: rss){
            fromJson.append(r.toString());
        }
        this->setStringList(fromJson);
        ret = true;
    }
    file.close();
    return ret;
}
