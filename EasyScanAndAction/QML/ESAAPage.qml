import QtQuick 2.15

Rectangle
{
    signal showing;
    signal hiding;
    signal backPressed
    focus: true
    property string caption: ""
    Keys.onReleased:
    {
        if (event.key == Qt.Key_Back)
        {
            console.log("Back button pressed.")
            event.accepted = true
            backPressed()
            return
        }
        event.accepted = false
    }
    id: thePage
    color: "white"
    property int targetOutX: -width
    width: parent.width
    height: parent.height
    opacity: 0
    visible: opacity > 0
    y: height
    function isActive()
    {
        return y < height;
    }
    ParallelAnimation
    {
        id: moveInAnimation
        NumberAnimation
        {
            target: thePage
            property: "x"
            to: 0
            duration: 400
        }

        NumberAnimation {
            target: thePage
            property: "opacity"
            duration: 400
            to: 1
        }
    }
    ParallelAnimation
    {
        id: moveOutAnimation
        NumberAnimation
        {
            target: thePage
            property: "x"
            to: targetOutX
            duration: 600
        }

        NumberAnimation {
            target: thePage
            property: "opacity"
            duration: 600
            to: 0
        }
    }

    function show(moveLeft)
    {
        showing()        
        opacity = 0.8
        x = moveLeft ? width : -width
        y = 0
        moveInAnimation.start()
    }
    function hide(moveLeft)
    {
        targetOutX = moveLeft ? -width: width
        hiding()
        moveOutAnimation.start()
    }
    Image
    {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bgImage1.top
        mipmap: true
        source: "qrc:/images/background.png"
        fillMode: Image.PreserveAspectFit
    }
    Image
    {
        id: bgImage1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        mipmap: true
        source: "qrc:/images/background.png"
        fillMode: Image.PreserveAspectFit
    }
}
