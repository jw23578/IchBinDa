import QtQuick 2.15
import "qrc:/foundation"

Row
{
    signal leftClicked
    signal rightClicked
    anchors.left: parent.left
    anchors.right: parent.right
    property int w: (parent.width - 2 * leftButton.width) / 3
    property alias buttonSize: leftButton.width
    property alias leftEnabled: leftButton.enabled
    property alias rightEnabled: rightButton.enabled
    property alias leftSource: leftButton.source
    property alias leftImagesize: leftButton.imagesize
    property alias rightSource: rightButton.source
    property alias rightImagesize: rightButton.imagesize
    property alias leftCircle: leftButton
    property alias rightCircle: rightButton

    property var coverContainer: null
    Item
    {
        width: parent.w
        height: 1
    }
    IDPCircleImage
    {
        id: leftButton
        width: IDPGlobals.screenWidth / 4
        onClicked: leftClicked()
        coverContainer: parent.coverContainer
    }
    Item
    {
        width: parent.w
        height: 1
    }
    IDPCircleImage
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
