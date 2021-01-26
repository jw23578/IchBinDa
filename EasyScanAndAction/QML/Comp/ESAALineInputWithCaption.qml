import QtQuick 2.15
import "qrc:/foundation"

FocusScope
{
    id: theItem
    property alias color: input.color
    property alias caption: captionText.text
    property alias text: input.text
    property alias displayText: input.displayText
    property alias inputMethodHints: input.inputMethodHints
    property alias readOnly: input.readOnly
    height: input.height
    property alias inputHeight: input.height
    property alias colorEdit: input.colorEdit
    property alias helpText: input.helpText
    signal helpClicked(string ht)
    property alias font: input.font
    property alias echoMode: input.echoMode

    ESAATextInput
    {
        id: input
        focus: true
        width: parent.width
        onHelpClicked: theItem.helpClicked(ht)
    }
    IDPText
    {
        id: captionText
        anchors.fill: input
        anchors.leftMargin: height / 3
        width: parent.width
        wrapMode: Text.WordWrap
        visible: input.displayText == ""
        color:  input.activeFocus ? "#aaaaaa" : "#555555"
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: input.font.pixelSize * 0.8
    }
    property alias coverContainer: cover.coverContainer
    IDPCover
    {
        id: cover
    }
}
