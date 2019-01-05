import QtQuick 2.0

Item {
    id: delegate
    width: delegate.ListView.view.width

    Column {
        width: parent.width
        spacing: 100

        Text {
            id: titleText
            text: title
            width: delegate.width
            height: 50
            wrapMode: Text.WordWrap
            font.pixelSize: 26
            font.bold: true
        }
        /*Text {
            id: descriptionText
            text: description
            width: delegate.width
            height: 50
            wrapMode: Text.WordWrap
            font.pixelSize: 14
            textFormat: Text.StyledText
            horizontalAlignment: Qt.AlignLeft
        }*/
    }


}
