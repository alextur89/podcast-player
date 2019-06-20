import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.XmlListModel 2.0
import QtGraphicalEffects 1.12
import QtMultimedia 5.9
import QtQuick.Dialogs 1.2

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 800
    height: 600
    title: qsTr("Podcast Player v" + Qt.application.version)
    color: "whitesmoke"

    //The MediaPlayer
    MediaPlayer {
        id: player
        source: ""
    }

    property string currentFeed: podcastmodel.data(podcastmodel.index(0, 0))
    property bool loading: feedModel.status === XmlListModel.Loading

    //list of podcasts
    ListView {
        id: podcasts
        property int itemWidth: 150

        width: itemWidth
        height: parent.height - statusBar.height
        orientation: ListView.Vertical
        anchors.top: parent.top
        model: podcastmodel
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
            playButton.stopStream()
            timeSlider.value = 0
            player.source = currentItem.getLink()
        }
    }

    Rectangle{
        id: addRss
        height: 64
        width: 64
        x: parent.width - addRss.width - 20
        y: parent.height - addRss.height - statusBar.height - 20
        color: "transparent"
        Image {
            id: pi
            source: "images/plus.png"
            height: 64
            width: 64
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                dialogAddRss.visible = true
            }
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
            if (name.slice(0,1) === '\n'){
                name = name.slice(1,name.length)
            }
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
            Rectangle{
                id: seekLeft
                height: 48
                width: 48
                x:8
                y:8
                Image {
                    id: sl
                    source: "images/seek_left.png"
                    height: 48
                    width: 48
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        player.seek(player.position - 15000)
                    }
                }
            }
            Rectangle{
                id: seekRight
                height: 48
                width: 48
                x:8
                y:8
                Image {
                    id: sr
                    source: "images/seek_right.png"
                    height: 48
                    width: 48
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        player.seek(player.position + 15000)
                    }
                }
            }

            Column{
                Text{
                    id: episodeName
                    text: "Пусто"
                    y: 0
                    x: 0
                    height: 20
                }
                Row{
                    Slider{
                        id: timeSlider
                        to: player.duration
                        width: statusBar.width - playButton.width - durationText.width - volumeSlider.width - volumeText.width - (seekLeft.width + seekRight.width)

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
                    Slider{
                        id: volumeSlider
                        from: 0
                        to: 100
                        width: 100
                        value: 100

                        onValueChanged: {
                               player.volume = value / 100
                        }
                    }
                    Label {
                        id: volumeText
                        text: Math.floor(volumeSlider.value) + '%'

                    }
                }
            } 
        }
    }
    Dialog {
        id: dialogAddRss
        visible: false
        title: "Add RSS"

        standardButtons: Dialog.Apply | Dialog.Cancel

        TextInput{
            id: newRss
            color: "black"
            text: currentFeed
            cursorVisible: true
            focus: true
        }

        onApply:
        {
            if (newRss.text.slice(0,7) == "http://"){
                newRss.text = newRss.text.slice(7,newRss.text.length)
            }
            else if (newRss.text.slice(0,8) == "https://"){
                newRss.text = newRss.text.slice(8,newRss.text.length)
            }
            feeds.appendString(newRss.text)
            visible = false
        }
    }

}
