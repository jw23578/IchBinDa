import QtQuick 2.15

CentralActionButton
{
    id: shareButton
    aboveCaption: qsTr("IchBinDa! weiterempfehlen")
    onClicked: ESAA.recommend()
    source: "qrc:/images/share_weiss.svg"
    downSource: "qrc:/images/share_blau.svg"
}
