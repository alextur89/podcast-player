import QtQuick 2.0

Component{
    Item{
        id: delegate
        height: 80
        width: ListView.view.width
        signal indexChanged()

        function getTitle(){
            return titleText.text
        }
        function getLink(){
            return link
        }

        Column{
            id: col
            Text {
                id: titleText
                text: title
                width: delegate.width
                wrapMode: Text.WordWrap
                font.pixelSize: 14
                font.bold: true
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                delegate.ListView.view.currentIndex = index
            }
        }
    }

}
