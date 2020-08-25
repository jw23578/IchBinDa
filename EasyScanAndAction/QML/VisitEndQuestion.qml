import QtQuick 2.0
import QtQuick.Controls 2.13

ESAAPage
{
    id: message
    signal close;
    signal endVisit;

    Image
    {
        anchors.fill: parent
        source: "qrc:/images/messageBackground.jpg"
        fillMode: Image.PreserveAspectCrop
        Rectangle
        {
            anchors.fill: parent
            color: "red"
            opacity: 0.3
        }
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
    }

    ESAAButton
    {
        id: endVisitButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: closeButton.top
        anchors.bottomMargin: parent.width / 10
        text: "ja"
        onClicked: endVisit()
    }
    ESAAButton
    {
        id: closeButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.width / 10
        text: "schließen"
        onClicked: close()
    }
}
