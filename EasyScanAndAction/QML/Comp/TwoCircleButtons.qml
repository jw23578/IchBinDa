import QtQuick 2.15
import "qrc:/foundation"

Row
{
    signal leftClicked
    signal rightClicked
    anchors.left: parent.left
    anchors.right: parent.right
    property int w: (parent.width - 2 * leftButton.width) / 3
    property alias leftText: leftButton.text
    property alias rightText: rightButton.text
    property alias buttonSize: leftButton.width
    property alias leftEnabled: leftButton.enabled
    property alias rightEnabled: rightButton.enabled

    property alias disabledLeftText: leftButton.disabledText
    property alias disabledRightText: rightButton.disabledText
    property var coverContainer: null
    Item
    {
        width: parent.w
        height: 1
    }
    IDPButtonCircle
    {
        id: leftButton
        onClicked: leftClicked()
        coverContainer: parent.coverContainer
    }
    Item
    {
        width: parent.w
        height: 1
    }
    IDPButtonCircle
    {
        id: rightButton
        onClicked: rightClicked()
        width: leftButton.width
        coverContainer: parent.coverContainer
    }
    Item
    {
        width: parent.w
        height: 1
    }
}
