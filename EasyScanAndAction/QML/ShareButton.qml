import QtQuick 2.0

CircleButton
{
    id: shareButton
    x: ESAA.screenWidth / 300 * 150 - width / 2
    y: ESAA.screenHeight / 480 * 360 - height / 2
    aboveCaption: qsTr("IchBinDa! weiterempfehlen")
    onClicked: ESAA.recommend()
    source: "qrc:/images/share_weiss.svg"
    downSource: "qrc:/images/share_blau.svg"
}
