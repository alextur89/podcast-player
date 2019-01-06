import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.XmlListModel 2.0

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 800
    height: 480
    title: qsTr("Podcast Player")

    property string currentFeed: feeds.get(0).feed

    PodcastFeeds { id: feeds }

    XmlListModel {
        id: feedModel
        source: "http://" + mainWindow.currentFeed
        query: "/rss/channel/item"
        namespaceDeclarations: "declare namespace itunes='http://www.itunes.com/dtds/podcast-1.0.dtd';"
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "description"; query: "description/string()" }
        XmlRole { name: "link"; query: "link/string()" }
    }

    //list of podcasts
    ListView {
        id: podcasts
        property int itemWidth: 150

        width: itemWidth
        height: parent.height
        orientation: ListView.Vertical
        anchors.top: parent.top
        model: feeds
        spacing: 3
        delegate: Rectangle {
            width: parent.width
            height: 120

            property bool selected: ListView.isCurrentItem
            property real itemSize

            Image {
                anchors.left: parent.left
                source: image
                height: 120
                width: 120

                scale: selected ? 1.15 : 1.0
                Behavior on scale { PropertyAnimation { duration: 300 } }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    parent.ListView.view.currentIndex = index
                    if (mainWindow.currentFeed == feed)
                        feedModel.reload()
                    else
                        mainWindow.currentFeed = feed
                }
            }
        }
    }

    //list of the podcast's episodes
    ListView {
        id: episodesList
        width: parent.width - podcasts.width;
        height: parent.height
        anchors.left: podcasts.right
        highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        focus: true
        model: feedModel
        delegate: EpisodesDelegate{}
        spacing: 20
        ScrollBar {
            width: parent.width - podcasts.itemWidth
            anchors.right: mainWindow.right
            anchors.top: mainWindow.top
            anchors.bottom: mainWindow.bottom
        }
    }

}
