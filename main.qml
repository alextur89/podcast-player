import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.XmlListModel 2.0
import QtGraphicalEffects 1.12
import QtMultimedia 5.9

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 800
    height: 600
    title: qsTr("Podcast Player")
    color: "whitesmoke"

    //The MediaPlayer
    MediaPlayer {
        id: player
        source: ""
    }

    PodcastFeeds {
        id: feeds
    }
    property string currentFeed: feeds.get(0).feed//current episode of the podcast
    property bool loading: feedModel.status === XmlListModel.Loading

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
        delegate: PodcastsDelegate{}
    }

    //list model of rss
    XmlListModel {
        id: feedModel
        source: "http://" + mainWindow.currentFeed
        query: "/rss/channel/item"
        namespaceDeclarations: "declare namespace itunes='http://www.itunes.com/dtds/podcast-1.0.dtd';"
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "description"; query: "description/string()" }
        XmlRole { name: "link"; query: "enclosure/@url/string()" }
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
            player.stop()
            timeSlider.to = player.duration
            timeSlider.from = 0
            timeSlider.value = 0
            player.source = currentItem.getLink()

        }
    }

    //Status bar in bottom
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
                    source: (play == false)?"images/play.png":"images/pause.png";
                }
                function startStream(){
                    player.play();
                    control.play = true
                }
                function stopStream(){
                    player.stop();
                    control.play = false
                }
                function pauseStream(){
                    player.pause();
                    control.play = false
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if (!control.play){
                            parent.startStream()
                        }
                        else{
                            parent.pauseStream()
                        }
                    }
                }

            }
            Column{
                Text{
                    id: episodeName
                    text: "Пусто"
                }
                Row{
                    Slider{
                        id: timeSlider
                        from: 1
                        value: 0
                        to: 100
                        width: statusBar.width - playButton.width - durationText.width

                        property bool sync: false
                        onValueChanged: {
                           if (!sync)
                               player.seek(value)
                        }
                        Connections {
                            target: player
                            onPositionChanged: {
                                timeSlider.sync = true
                                timeSlider.value = player.position
                                timeSlider.sync = false
                            }
                        }
                    }
                    Label {
                        id: durationText
                        readonly property int minutes: Math.floor(timeSlider.value / 60000)
                        readonly property int seconds: Math.round((timeSlider.value % 60000) / 1000)
                        text: Qt.formatTime(new Date(2018, 1, 1, 1, minutes, seconds), qsTr("mm:ss"))
                    }
                }
            } 
        }
    }

}
