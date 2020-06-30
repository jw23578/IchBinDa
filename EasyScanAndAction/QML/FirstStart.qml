import QtQuick 2.0
import QtQuick.Controls 2.13

Rectangle
{
//    Background
//    {

//    }

    anchors.fill: parent
    Column
    {
        anchors.fill: parent
        Item
        {
            width: parent.width
            height: parent.height / 4
            ESAAText
            {
                anchors.centerIn: parent
                text: ESAA.appName
                font.pointSize: screen.height / 40
            }
        }
        Item
        {
            width: parent.width
            height: parent.height / 4
            ESAAText
            {
                anchors.centerIn: parent
                text: "Ich bin\nAnbieter"
                font.pointSize: screen.height / 50
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked: betreiberinfo.visible = true
            }
        }
        Rectangle
        {
            color: "grey"
            width: parent.width
            height: parent.height / 4
            ESAAText
            {
                anchors.centerIn: parent
                text: "Ich bin\nKunde/Besucher"
                font.pointSize: screen.height / 50
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked: kundeinfo.visible = true
            }
        }
        Item
        {
            width: parent.width
            height: parent.height / 4
            ESAAText
            {
                anchors.centerIn: parent
                text: "Ich will\ndirekt loslegen"
                font.pointSize: screen.height / 50
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked: ESAA.firstStartDone();
            }
        }
    }
    Rectangle
    {
        id: betreiberinfo
        visible: false
        anchors.fill: parent
        Button
        {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            text: "Los geht's"
            onClicked: ESAA.firstStartDone()
        }
    }
    Rectangle
    {
        id: kundeinfo
        visible: false
        anchors.fill: parent
        Button
        {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            text: "Los geht's"
            onClicked: ESAA.firstStartDone()
        }
    }
}
