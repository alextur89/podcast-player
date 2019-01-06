import QtQuick 2.0

Column {
    id: delegate
    width: delegate.ListView.view.width

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
}
