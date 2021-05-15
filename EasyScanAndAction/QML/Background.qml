import QtQuick 2.15
import "qrc:/foundation"

Rectangle
{
    color: "white"
    id: background
    Image
    {
        id: bgImage1
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 8 / 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: ESAA.spacing
        mipmap: true
        source: "qrc:/images/background.png"
        fillMode: Image.PreserveAspectFit
    }
}
