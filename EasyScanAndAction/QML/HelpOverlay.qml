import QtQuick 2.0
import "Comp"

Item
{
    signal doneClick;
    anchors.fill: parent
    property alias helpText1: infotext.text
    Rectangle
    {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: editButton.top
        anchors.topMargin: -ESAA.spacing
    }

    Rectangle
    {
        anchors.top: infotext.top
        anchors.topMargin: -ESAA.spacing
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        opacity: 0.8
        color: ESAA.buttonColor
    }

    ESAAText
    {
        id: infotext
        width: parent.width - 2 * ESAA.spacing
        anchors.centerIn: parent
        wrapMode: Text.WordWrap
        font.pixelSize: ESAA.fontMessageTextPixelsize
        color: "white"
        text: "Hier kannst du den QR-Code des Clubs, Restaurants, Sportvereins, Frisör usw. scannen um deine Kontaktdaten komfortabel und verschlüsselt zu übermitteln." +
              "<br><br>Über den Button ganz unten kannst du das Menü aufrufen um die App zu erkunden."
    }

    TransparentCircleButton
    {
        id: editButton
        anchors.bottom: parent.bottom
        anchors.margins: ESAA.spacing
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Verstanden")
        onClicked: doneClick()
    }
}
