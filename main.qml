import QtQuick 2.9
import QtQuick.Window 2.2
import "Feeds.qml"

Window {
    id: mainWindow
    visible: true
    width: 800
    height: 480
    title: qsTr("Podcast Player")

    property string currentFeed: feeds.get(0).feed

    Feeds { id: feeds }

    XmlListModel {
        id: feedModel
        source: "http://" + mainWindow.currentFeed

    }
}
