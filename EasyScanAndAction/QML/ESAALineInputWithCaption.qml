import QtQuick 2.0

Item
{
    property alias color: captionText.color
    property alias caption: captionText.text
    property alias text: input.text
    property alias displayText: input.displayText
    property alias inputMethodHints: input.inputMethodHints
    property alias readOnly: input.readOnly
    height: caption.length ? captionText.height + input.height : input.height

    ESAAText
    {
        id: captionText
        anchors.top: parent.top
        width: parent.width
        wrapMode: Text.WordWrap
    }
    ESAATextInput
    {
        id: input
        anchors.bottom: parent.bottom
        width: parent.width
    }
}
