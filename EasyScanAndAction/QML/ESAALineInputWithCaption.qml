import QtQuick 2.0

Item
{
    property alias caption: captionText.text
    property alias text: input.text
    height: caption.length ? captionText.height + input.height : input.height
    ESAAText
    {
        id: captionText
        anchors.top: parent.top
        width: parent.width
    }
    ESAATextInput
    {
        id: input
        anchors.bottom: parent.bottom
        width: parent.width
    }
}
