import QtQuick 2.15
import "qrc:/foundation"

IDPButtonCircle
{
    property bool rightArrow: true
    imageRotation: rightArrow ? 180 : 0
    source: "qrc:/images/back_weiss.svg"
    downSource: "qrc:/images/back_blau.svg"
    width: JW78Utils.screenWidth / 8
    imageSizeFactor: 0.5
}
