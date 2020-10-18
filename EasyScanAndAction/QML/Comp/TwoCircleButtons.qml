import QtQuick 2.15

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
    Item
    {
        width: parent.w
        height: 1
    }
    CircleButton
    {
        id: leftButton
        onClicked: leftClicked()
    }
    Item
    {
        width: parent.w
        height: 1
    }
    CircleButton
    {
        id: rightButton
        onClicked: rightClicked()
        width: leftButton.width
    }
    Item
    {
        width: parent.w
        height: 1
    }
}
