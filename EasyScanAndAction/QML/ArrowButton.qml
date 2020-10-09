import QtQuick 2.15

CircleButton
{
    property bool rightArror: true
    rotation: rightArror ? 180 : 0
    source: "qrc:/images/back_weiss.svg"
    downSource: "qrc:/images/back_blau.svg"
    width: ESAA.screenWidth / 6
    imageSizeFactor: 0.5
}
