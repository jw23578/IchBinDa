import QtQuick 2.0
import QtQuick.Controls 2.13

ESAAPage
{
    id: message
    signal close;
    signal endVisit;
    onBackPressed:
    {
        close()
    }

    Rectangle
    {
        id: removeMeLater
        anchors.fill: parent
        color: "white"
    }

    ESAAText
    {
        id: messageText
        anchors.centerIn: parent
        width: parent.width * 8 / 10
        font.pixelSize: ESAA.fontMessageTextPixelsize
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        horizontalAlignment: Text.horizontalCenter
        text: "Soll der Besuch beendet werden?"
        color: ESAA.textColor
    }

    ESAAButton
    {
        id: endVisitButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: closeButton.top
        anchors.bottomMargin: parent.width / 10
        text: "Ja"
        onClicked: endVisit()
    }
    ESAAButton
    {
        id: closeButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.width / 10
        text: "Abbrechen"
        onClicked: close()
    }
}
