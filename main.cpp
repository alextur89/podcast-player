#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "podcastlistserialization.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setApplicationVersion(QString("0.0.3"));

    qmlRegisterType<PodcastListSerialization>("com.podcastplayer.podcastsmodel", 1, 0, "PodcastsModel");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
