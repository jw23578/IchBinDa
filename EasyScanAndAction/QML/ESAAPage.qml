import QtQuick 2.0

Item
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
    Rectangle
    {
        visible: false
        anchors.fill: parent
        opacity: 0.8
        color: ESAA.backgroundTopColor
    }
    id: thePage
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


//    gradient: theGradient
//    property var theGradient: Gradient
//    {
//        GradientStop { position: 0.0; color: ESAA.backgroundTopColor }
//        GradientStop { position: 1.0; color: ESAA.backgroundBottomColor }
//    }

}
