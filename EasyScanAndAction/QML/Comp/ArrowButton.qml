import QtQuick 2.15

CircleButton
{
    property bool rightArrow: true
    imageRotation: rightArrow ? 180 : 0
    source: "qrc:/images/back_weiss.svg"
    downSource: "qrc:/images/back_blau.svg"
    width: ESAA.screenWidth / 8
    imageSizeFactor: 0.5
}
