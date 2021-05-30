import QtQuick 2.15
import QtQuick.Controls 2.15
import "Comp"
import "qrc:/foundation"

ESAAPage
{
    id: message
    signal close;
    signal endVisit;
    caption: "Besuch beenden"
    showMenueButton: false
    onBackPressed:
    {
        close()
    }

    IDPText
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
        anchors.bottomMargin: ESAA.spacing * 2.5
        leftText: "Ja"
        onLeftClicked: endVisit()
        rightText: "Nein"
        onRightClicked: close()
    }
}
