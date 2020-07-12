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
        spacing: (height - 4 * b1.height) / 4

        ESAAButton
        {
            id: b1
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Ich bin\nBetreiber"
            onClicked: betreiberinfo.visible = true
        }
        ESAAButton
        {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Ich bin\nKunde/Besucher"
            onClicked: kundeinfo.visible = true
        }
        ESAAButton
        {
            id: shareButton
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Weiterempfehlen")
            onClicked: ESAA.recommend()
            source: "qrc:/images/share-icon-40146.png"
        }
        ESAAButton
        {
            width: parent.width
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
