#ifndef RADIOSTREAMER_H
#define RADIOSTREAMER_H

#include <QObject>

#include <QtMultimedia/QMediaPlaylist>
#include <QtMultimedia/QMultimedia>
#include <QtMultimedia/QMediaPlayer>
#include <QString>

class RadioStreamer:public QObject {
    Q_OBJECT

    Q_PROPERTY(QString source READ getSource WRITE setSource)
    Q_PROPERTY(int vol READ getVolume WRITE setVolume)

public:
    explicit RadioStreamer();
    RadioStreamer(const RadioStreamer& cp);
    ~RadioStreamer();

    void setSource(const QString src);
    QString getSource();
    Q_INVOKABLE void setVolume(int theVol);
    Q_INVOKABLE int getVolume();

public slots:
    void play();
    void stop();
    void pause();

private:
    QMediaPlayer* player;
    QString source;
    int vol;

};

Q_DECLARE_METATYPE(RadioStreamer)

#endif // RADIOSTREAMER_H
