import QtQuick 2.15
import "qrc:/foundation"

IDPButtonCircle
{
    source: "qrc:/images/back_weiss.svg"
    downSource: "qrc:/images/back_blau.svg"
    width: JW78Utils.screenWidth / 8
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.leftMargin: width / 3
    anchors.bottomMargin: anchors.leftMargin
    imageSizeFactor: 0.5
}
