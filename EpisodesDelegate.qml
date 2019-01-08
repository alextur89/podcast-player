import QtQuick 2.0

Component{
    Item{
        id: delegate
        height: 100
        width: ListView.view.width
        signal indexChanged()

        function getTitle(){
            return titleText.text
        }

        Column{
            id: col
            Text {
                id: titleText
                text: title
                width: delegate.width
                wrapMode: Text.WordWrap
                font.pixelSize: 16
                font.bold: true
            }
            Text {
                id: descriptionText
                text: description
                width: delegate.width
                wrapMode: Text.WordWrap
                font.pixelSize: 12
                textFormat: Text.StyledText
                horizontalAlignment: Qt.AlignLeft
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
