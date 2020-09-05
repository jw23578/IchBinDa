import QtQuick 2.13

Item
{
    property alias contentHeight: theFlickable.contentHeight
    property alias contentItem: theFlickable.contentItem
    property alias contentY: theFlickable.contentY
    Image
    {
        width: ESAA.screenWidth / 10
        height: width
        opacity: 0
        id: upButton
        fillMode: Image.PreserveAspectFit
        anchors.top: parent.top
        anchors.right: parent.right
        mipmap: true
        source: "qrc:/images/pfeil_blau.svg"
        Behavior on opacity {
            NumberAnimation
            {
                duration: 400
            }
        }
        rotation: 90
        z: 1
    }

    Image
    {
        z: 1
        id: downButton
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        fillMode: Image.PreserveAspectFit
        width: ESAA.screenWidth / 10
        height: width
        mipmap: true
        source: "qrc:/images/pfeil_blau.svg"
        Behavior on opacity {
            NumberAnimation
            {
                duration: 400
            }
        }
        rotation: 270
    }
    Flickable
    {
        id: theFlickable
        anchors.fill: parent
        clip: true
        flickableDirection: Flickable.VerticalFlick
        onContentYChanged:
        {
            upButton.opacity = (contentY > contentHeight / 10) ? 1 : 0
            downButton.opacity = (contentY + height > contentHeight / 10 * 9) ? 0 : 1
        }
    }

}
