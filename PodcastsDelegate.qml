import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.XmlListModel 2.0
import QtQuick.Dialogs 1.2


Rectangle {
    id: delegate
    width: ListView.view.width
    height: 120
    color: "whitesmoke"

    property bool selected: ListView.isCurrentItem
    property real itemSize
    property string url: display

    //list model of rss
    XmlListModel {
        id: xmlmodel
        source: "http://" +  display
        query: "/rss/channel"
        namespaceDeclarations: "declare namespace itunes='http://www.itunes.com/dtds/podcast-1.0.dtd';"
        XmlRole { name: "image"; query: "image/url/string()"}
        onStatusChanged: {
            if (status == XmlListModel.Ready)
                reloadLogos()
        }
    }


    function getImage(){
        return xmlmodel.get(0).image
    }

    Image {
        id: logo
        anchors.left: parent.left
        height: 120
        width: 120
        scale: selected ? 1.15 : 1.0
        Behavior on scale { PropertyAnimation { duration: 300 } }
        onStatusChanged: {
            if (status == Image.Error){
                source =  "images/unknown.png"
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            reloadLogos()
            parent.ListView.view.currentIndex = index
            if (mainWindow.currentFeed == display)
                feedModel.reload()
            else
                mainWindow.currentFeed = display
        }
        onPressAndHold: {
            dialogRemove.visible = true
        }

    }

    BusyIndicator {
        scale: 0.8
        visible: parent.ListView.isCurrentItem && mainWindow.loading
        anchors.centerIn: parent

    }

    function reloadLogos(){
        logo.source = getImage()
    }

    Dialog {
        id: dialogRemove
        visible: false
        title: "Remove RSS"

        standardButtons: Dialog.Apply | Dialog.Cancel

        Text{
            color: "black"
            text: "Are you sure to remove the RSS?"
        }

        onApply:
        {
            feeds.removeString(url)
            visible = false
        }
    }

}
