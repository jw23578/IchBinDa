import QtQuick 2.15
import QtQuick.Controls 2.15

Item
{
    id: theItem
    visible: true
    property var sources: null
    SwipeView
    {
        id: theSwipeView
        anchors.top: parent.top
        anchors.bottom: indicator.top
        anchors.left: parent.left
        anchors.right: parent.right
        Image
        {
            id: itemA
            opacity: 1 - theSwipeView.contentItem.contentX / width
            source: sources[0]
            fillMode: Image.PreserveAspectFit
        }
        Image
        {
            id: itemB
            opacity: 1 - itemA.opacity
            source: sources[1]
            fillMode: Image.PreserveAspectFit
        }
    }
    PageIndicator
    {
        id: indicator
        height: JW78APP.spacing
        currentIndex: theSwipeView.currentIndex
        anchors.bottom: parent.bottom
        count: theSwipeView.count
        anchors.horizontalCenter: parent.horizontalCenter
        delegate: Rectangle
        {
            radius: width/ 2
            width: JW78APP.spacing
            height: width
            color: index == indicator.currentIndex ? JW78APP.buttonFromColor : JW78APP.buttonToColor
        }
    }
}
