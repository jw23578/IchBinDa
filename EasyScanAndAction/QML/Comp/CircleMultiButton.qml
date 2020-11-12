import QtQuick 2.0

Item
{
    id: circlemultibutton
    signal openClicked
    signal closeClicked
    property bool open: false
    property int smallWidth: JW78Utils.screenWidth / 6
    property int largeWidth: JW78Utils.screenWidth / 4
    property int targetAngle: 70
    property alias text: mainbutton.text
    property alias button1: option1
    property alias button2: option2
    property alias button3: option3
    property alias button1VisibleMaster: option1.visibleMaster
    property alias button2VisibleMaster: option2.visibleMaster
    property alias button3VisibleMaster: option3.visibleMaster

    visible: opacity > 0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    Item
    {
        id: allButtons
        anchors.centerIn: parent
        CircleButton
        {
            id: mainbutton
            anchors.centerIn: parent
            text: "+"
            onClicked:
            {
                if (circlemultibutton.open)
                {
                    open = false
                    text = "+"
                    closeani1.start()
                    closeClicked()
                }
                else
                {
                    openani1.start()
                    open = true
                    text = "-"
                    openClicked()
                }
            }
        }
        Item
        {
            id: item1
            anchors.centerIn: parent
            width: 0
            height: 0
            CircleButton
            {
                id: option1
                property bool visibleMaster: true
                visible: opacity > 0 && visibleMaster
                width: smallWidth
                opacity: 0
                anchors.horizontalCenter: parent.right
                anchors.verticalCenter: parent.verticalCenter
                rotation: -parent.rotation
                onClicked: mainbutton.clicked()
            }
        }
        Item
        {
            id: item2
            anchors.centerIn: parent
            width: 0
            height: 0
            CircleButton
            {
                id: option2
                property bool visibleMaster: true
                visible: opacity > 0 && visibleMaster
                width: smallWidth
                opacity: 0
                anchors.horizontalCenter: parent.right
                anchors.verticalCenter: parent.verticalCenter
                rotation: -parent.rotation
                onClicked: mainbutton.clicked()
            }
        }
        Item
        {
            id: item3
            anchors.centerIn: parent
            width: 0
            height: 0
            CircleButton
            {
                id: option3
                property bool visibleMaster: true
                visible: opacity > 0 && visibleMaster
                width: smallWidth
                opacity: 0
                anchors.horizontalCenter: parent.right
                anchors.verticalCenter: parent.verticalCenter
                rotation: -parent.rotation
                onClicked: mainbutton.clicked()
            }
        }
    }

    SequentialAnimation
    {
        id: openani1
        ParallelAnimation
        {
            NumberAnimation
            {
                target: mainbutton
                property: "width"
                to: smallWidth
                duration: 200
            }
            NumberAnimation {
                target: item1
                property: "width"
                duration: 200
                to: -2 * largeWidth
            }
            NumberAnimation {
                target: option1
                property: "width"
                duration: 200
                to: largeWidth
            }
            NumberAnimation {
                target: option1
                property: "opacity"
                duration: 200
                to: 1
            }

            NumberAnimation {
                target: item2
                property: "width"
                duration: 200
                to: -2 * largeWidth
            }
            NumberAnimation {
                target: option2
                property: "width"
                duration: 200
                to: largeWidth
            }
            NumberAnimation {
                target: option2
                property: "opacity"
                duration: 200
                to: 1
            }

            NumberAnimation {
                target: item3
                property: "width"
                duration: 200
                to: -2 * largeWidth
            }
            NumberAnimation {
                target: option3
                property: "width"
                duration: 200
                to: largeWidth
            }
            NumberAnimation {
                target: option3
                property: "opacity"
                duration: 200
                to: 1
            }
        }
        ParallelAnimation
        {
            NumberAnimation
            {
                target: allButtons
                property: "anchors.verticalCenterOffset"
                to: smallWidth
                duration: 200
            }

            NumberAnimation
            {
                target: item1
                property: "rotation"
                to: (180 - 2 * targetAngle) / 2
                duration: 200
            }
            NumberAnimation
            {
                target: item2
                property: "rotation"
                to: targetAngle + (180 - 2 * targetAngle) / 2
                duration: 200
            }
            NumberAnimation
            {
                target: item3
                property: "rotation"
                to: targetAngle * 2 + (180 - 2 * targetAngle) / 2
                duration: 200
            }
        }
    }
    SequentialAnimation
    {
        id: closeani1
        ParallelAnimation
        {
            NumberAnimation
            {
                target: allButtons
                property: "anchors.verticalCenterOffset"
                to: 0
                duration: 200
            }
            NumberAnimation
            {
                target: item1
                property: "rotation"
                to: 0
                duration: 200
            }
            NumberAnimation
            {
                target: item2
                property: "rotation"
                to: 0
                duration: 200
            }
            NumberAnimation
            {
                target: item3
                property: "rotation"
                to: 0
                duration: 200
            }
        }
        ParallelAnimation
        {
            NumberAnimation
            {
                target: mainbutton
                property: "width"
                to: largeWidth
                duration: 200
            }
            NumberAnimation {
                target: item1
                property: "width"
                duration: 200
                to: 0
            }
            NumberAnimation {
                target: option1
                property: "width"
                duration: 200
                to: smallWidth
            }
            NumberAnimation {
                target: option1
                property: "opacity"
                duration: 200
                to: 0
            }

            NumberAnimation {
                target: item2
                property: "width"
                duration: 200
                to: 0
            }
            NumberAnimation {
                target: option2
                property: "width"
                duration: 200
                to: smallWidth
            }
            NumberAnimation {
                target: option2
                property: "opacity"
                duration: 200
                to: 0
            }

            NumberAnimation {
                target: item3
                property: "width"
                duration: 200
                to: 0
            }
            NumberAnimation {
                target: option3
                property: "width"
                duration: 200
                to: smallWidth
            }
            NumberAnimation {
                target: option3
                property: "opacity"
                duration: 200
                to: 0
            }
        }
    }
}
