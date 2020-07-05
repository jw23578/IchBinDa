import QtQuick 2.13

ESAAPage
{
    signal splashDone
    id: splashscreen
    opacity: 1
    y: 0
    Column
    {
        anchors.fill: parent
        Item
        {
            height: parent.height / 3
            width: parent.width
            Text
            {
                id: t1
                anchors.horizontalCenterOffset: parent.width
                anchors.centerIn: parent
                text: "Ich"
                font.pixelSize: parent.height * 3 / 5
                color: ESAA.fontColor
            }
        }
        Item
        {
            height: parent.height / 3
            width: parent.width
            Text
            {
                id: t2
                anchors.horizontalCenterOffset: -parent.width
                anchors.centerIn: parent
                text: "bin"
                font.pixelSize: parent.height * 3 / 5
                color: ESAA.fontColor
            }
        }
        Item
        {
            height: parent.height / 3
            width: parent.width
            Text
            {
                id: t3
                anchors.horizontalCenterOffset: parent.width
                anchors.centerIn: parent
                text: "da!"
                font.pixelSize: parent.height * 3 / 5
                color: ESAA.fontColor
            }
        }
    }
    ParallelAnimation
    {
        id: animation
        NumberAnimation
        {
            target: t1
            property: "anchors.horizontalCenterOffset"
            to: 0
            duration: 300
        }
        NumberAnimation
        {
            target: t2
            property: "anchors.horizontalCenterOffset"
            to: 0
            duration: 300
        }
        NumberAnimation
        {
            target: t3
            property: "anchors.horizontalCenterOffset"
            to: 0
            duration: 300
        }
    }
    PauseAnimation {
        id: hidePause
        duration: 800
        onFinished: splashDone()
    }

    PauseAnimation
    {
        id: pause
        duration: 200
        onFinished:
        {
            hidePause.start()
            animation.start()
        }
    }
    function start()
    {
        pause.start()
    }
}
