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

    ESAAText
    {
        id: messageText
        anchors.centerIn: parent
        width: parent.width * 8 / 10
        font.pixelSize: ESAA.fontMessageTextPixelsize
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        horizontalAlignment: Text.horizontalCenter
        text: "Soll der Besuch beendet werden?"
        color: ESAA.buttonColor
    }
    TwoCircleButtons
    {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: ESAA.spacing
        leftText: "Ja"
        onLeftClicked: endVisit()
        rightText: "Nein"
        onRightClicked: close()
    }
}
