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

    /*XmlListModel {
        id: feedModel
        source: "http://" + mainWindow.currentFeed

    }*/

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
            width: 100
            height: 100

            property bool selected: ListView.isCurrentItem
            property real itemSize

            Image {
                anchors.centerIn: parent
                source: image
            }

            Text {
                id: titleText

                anchors {
                    left: parent.left; leftMargin: 20
                    right: parent.right; rightMargin: 20
                    top: parent.top; topMargin: 20
                }

                font { pixelSize: 18; bold: true }
                text: name
                color: selected ? "#ffffff" : "#ebebdd"
                scale: selected ? 1.15 : 1.0
                Behavior on color { ColorAnimation { duration: 150 } }
                Behavior on scale { PropertyAnimation { duration: 300 } }
            }
        }
    }

    /*ScrollBar {
        id: listScrollBar
        orientation: Qt.Vertical
        height: podcasts.height;
        width: 8
        //scrollArea: podcasts;
        anchors.right: podcasts.right
    }*/

}
