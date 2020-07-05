import QtQuick 2.13
import QtQuick.Controls 2.13

ESAAPage
{
    signal startNow
    Column
    {
        anchors.fill: parent
        anchors.margins: ESAA.spacing
        topPadding: spacing / 2
        spacing: (height - 3 * b1.height) / 3
        ESAAButton
        {
            id: b1
            width: parent.width
            font.pixelSize: parent.height / 14
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Ich bin\nBetreiber"
            onClicked: betreiberinfo.visible = true
        }
        ESAAButton
        {
            width: parent.width
            font.pixelSize: parent.height / 14
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Ich bin\nKunde/Besucher"
            onClicked: kundeinfo.visible = true
        }
        ESAAButton
        {
            width: parent.width
            font.pixelSize: parent.height / 14
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Ich möchte\ndirekt loslegen"
            onClicked: startNow()
        }
    }
    Rectangle
    {
        id: betreiberinfo
        visible: false
        anchors.fill: parent
        ESAAButton
        {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            text: "Los geht's"
            onClicked: startNow()
        }
    }
    Rectangle
    {
        id: kundeinfo
        visible: false
        anchors.fill: parent
        ESAAButton
        {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            text: "Los geht's"
            onClicked: startNow()
        }
    }
}
