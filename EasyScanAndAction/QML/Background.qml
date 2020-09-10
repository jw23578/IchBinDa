import QtQuick 2.15

Rectangle
{
    color: "white"
//    Image
//    {
//        anchors.left: parent.left
//        anchors.right: parent.right
//        anchors.bottom: bgImage1.top
//        mipmap: true
//        source: "qrc:/images/background.png"
//        fillMode: Image.PreserveAspectFit
//    }
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
