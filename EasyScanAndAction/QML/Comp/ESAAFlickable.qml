import QtQuick 2.15

Item
{
    function ensureVisible(item) {
        var ypos = item.mapToItem(contentItem, 0, 0).y
        var ext = item.height + ypos
        if ( ypos < contentY // begins before
                || ypos > contentY + height // begins after
                || ext < contentY // ends before
                || ext > contentY + height) { // ends after
            // don't exceed bounds
            contentY = Math.max(0, Math.min(ypos - height + item.height, contentHeight - height))
        }
    }
    property alias contentHeight: theFlickable.contentHeight
    property alias contentItem: theFlickable.contentItem
    property alias contentY: theFlickable.contentY
    Image
    {
        width: ESAA.screenWidth / 10
        height: width
        opacity: 0
        visible: opacity > 0
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
        MouseArea
        {
            anchors.fill: parent
            onClicked: theFlickable.flick(0, ESAA.screenHeight)
            enabled: parent.visible
        }
    }

    Image
    {
        z: 1
        id: downButton
        visible: opacity > 0
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
        MouseArea
        {
            anchors.fill: parent
            onClicked: theFlickable.flick(0, -ESAA.screenHeight)
            enabled: parent.visible
        }
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
    Component.onCompleted:
    {
        upButton.opacity = (contentY > 0) && (contentY > contentHeight / 10) ? 1 : 0
        downButton.opacity = (contentY + height > contentHeight / 10 * 9) ? 0 : 1
    }
}
