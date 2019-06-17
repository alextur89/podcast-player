#include "podcastlistserialization.h"
#include <QJsonObject>
#include <QFile>
#include <QDir>
#include <QJsonArray>
#include <QJsonDocument>

PodcastListSerialization::PodcastListSerialization()
{
    m_model = new QStringListModel(this);
    QStringList initList;
    initList << "meduza.io/rss/podcasts/meduza-v-kurse"
             << "meduza.io/rss/podcasts/tekst-nedeli"
             << "meduza.io/rss/podcasts/dva-po-tsene-odnogo";
    if (loadState() == false){
        m_model->setStringList(initList);
    }
}

PodcastListSerialization::~PodcastListSerialization()
{
    saveState();
}

void PodcastListSerialization::appendString(const QString &string){
    auto ts = m_model->stringList();
    ts.append(string);
    m_model->setStringList(ts);
}

void PodcastListSerialization::removeString(const QString &string){
    auto ts = m_model->stringList();
    ts.removeAll(string);
    m_model->setStringList(ts);
}

bool PodcastListSerialization::saveState()
{
    QFile file;
    bool ret = false;
    file.setFileName(QDir::toNativeSeparators( QDir::homePath() + "/" + ".podcastplayer.conf") );
    if (file.open(QIODevice::WriteOnly)){
        QJsonObject obj;
        QJsonArray rssArr;
        for (auto& sl: m_model->stringList()){
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
        m_model->setStringList(fromJson);
        ret = true;
    }
    file.close();
    return ret;
}
