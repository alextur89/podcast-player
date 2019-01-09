#include "radiostreamer.h"
#include <QString>

RadioStreamer::RadioStreamer()
{
    player = new QMediaPlayer(nullptr, QMediaPlayer::StreamPlayback);
    vol = 100;
}

RadioStreamer::RadioStreamer(const RadioStreamer& cp){
    QObject(nullptr);
    player = new QMediaPlayer(nullptr, QMediaPlayer::StreamPlayback);
    player->setMedia(cp.player->media());
}

void RadioStreamer::play(){
    player->setMedia(QMediaContent(source));
    player->play();
}

void RadioStreamer::stop(){
    player->stop();
}

void RadioStreamer::pause(){
    player->pause();
}

RadioStreamer::~RadioStreamer()
{
    player->stop();
    delete player;
}

void RadioStreamer::setSource(const QString src){
    source = src;
}

QString RadioStreamer::getSource(){
    return source;
}

void RadioStreamer::setVolume(int theVol){
    vol = theVol;
    player->setVolume(vol);
}
int RadioStreamer::getVolume(){
    return vol;
}
