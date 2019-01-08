import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.XmlListModel 2.0
import QtGraphicalEffects 1.12

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 800
    height: 480
    title: qsTr("Podcast Player")
    color: "whitesmoke"

    property string currentFeed: feeds.get(0).feed
    property bool loading: feedModel.status === XmlListModel.Loading

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
        height: parent.height - statusBar.height
        orientation: ListView.Vertical
        anchors.top: parent.top
        model: feeds
        spacing: 3
        delegate: Rectangle {
            width: parent.width
            height: 120
            color: "whitesmoke"

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
            BusyIndicator {
                scale: 0.8
                visible: parent.ListView.isCurrentItem && mainWindow.loading
                anchors.centerIn: parent
            }
        }

    }

    //list of the podcast's episodes
    ListView {
        id: episodesList
        width: parent.width - podcasts.width;
        height: parent.height - statusBar.height
        anchors.left: podcasts.right
        highlight: Rectangle { color: "gainsboro"; radius: 5 }
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
        onCurrentIndexChanged: {
            statusBar.setEpisodeName(currentItem.getTitle())
        }
    }
    Rectangle{
        id: statusBar
        color: "white"
        height: 64
        width: mainWindow.width
        y: parent.height - 64
        function setEpisodeName(name){
            episodeName.text = name;
        }

        Row{
            id: row
            Rectangle{
                id: playButton
                color: "#ff8000"
                radius: 25
                height: 64
                width: 64
                x:0
                y:0
                Image {
                    id: control
                    property bool play: false
                    source: "images/play.png"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if (!control.play){
                            control.source = "images/pause.png"
                        }
                        else{
                            control.source = "images/play.png"
                        }
                        control.play = !control.play
                    }
                }

            }
            Column{
                Text{
                    id: episodeName
                    text: "Пусто"
                }
                Slider{
                    id: timeSlider
                    from: 1
                    value: 0
                    to: 100
                    width: statusBar.width - playButton.width
                }
            }
        }
    }
}
