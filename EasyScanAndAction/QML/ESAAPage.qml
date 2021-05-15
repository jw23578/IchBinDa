import QtQuick 2.15
import "qrc:/foundation"

Background
{
    signal showing;
    signal showed;
    signal hiding;
    signal hided;
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
    property int targetOutY: -height
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
        onStopped: showed()
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
        onStopped: hided()
    }
    property int aniDuration: IDPGlobals.slowAnimationDuration * 2

    ParallelAnimation
    {
        id: moveInYAnimation
        NumberAnimation
        {
            target: thePage
            property: "y"
            to: 0
            duration: thePage.aniDuration
        }

        NumberAnimation {
            target: thePage
            property: "opacity"
            duration: thePage.aniDuration
            to: 1
        }
        onStopped: showed()
    }
    ParallelAnimation
    {
        id: moveOutYAnimation
        NumberAnimation
        {
            target: thePage
            property: "y"
            to: targetOutY
            duration: thePage.aniDuration
        }

        NumberAnimation {
            target: thePage
            property: "opacity"
            duration: thePage.aniDuration
            to: 0
        }
        onStopped: hided()
    }

    function show(moveLeft)
    {
        showing()        
        opacity = 0.8
//        x = moveLeft ? width : -width
//        y = 0
//        moveInAnimation.start()
        x = 0
        y = moveLeft ? -height : height
        moveInYAnimation.start()
    }
    function hide(moveLeft)
    {
        hiding()
//        targetOutX = moveLeft ? -width: width
//        moveOutAnimation.start()
        targetOutY = moveLeft ? -height : height
        moveOutYAnimation.start()
    }
}
