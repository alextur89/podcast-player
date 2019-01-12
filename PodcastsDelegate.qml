import QtQuick 2.0
import QtQuick.Controls 2.4

Rectangle {
    id: delegate
    width: ListView.view.width
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
