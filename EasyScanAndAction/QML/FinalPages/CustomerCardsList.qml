import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../Comp"

ESAAPage {
    caption: "Kundenkarten"
    signal newCard;
    ESAAFlickable
    {
        id: theFlick
        anchors.margins: ESAA.spacing
        anchors.bottom: newCard.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
    }
    CircleButton
    {
        id: newCard
        x: ESAA.screenWidth / 300 * 150 - width / 2
        y: ESAA.screenHeight / 480 * 360 - height / 2
        text: "Neue<br>Karte"
        onClicked: parent.newCard()
    }

    BackButton
    {
        onClicked: backPressed()
    }
}
