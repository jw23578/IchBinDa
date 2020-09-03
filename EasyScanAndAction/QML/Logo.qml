import QtQuick 2.15

Item
{
    property alias claimImageX: claimImage.x
    property int qrCodeOffset: 0
    property alias qrCodeOpacity: qrCodeImage.opacity
    property int animationDuration: 200
    Behavior on qrCodeOffset {
        NumberAnimation
        {
            id: moveQRCode
        }
    }
    Image
    {
        id: qrCodeImage
        width: parent.width / 2
        opacity: 0
        Behavior on opacity {
            NumberAnimation
            {
                duration: animationDuration
            }
        }

        anchors.centerIn: parent
        anchors.horizontalCenterOffset: qrCodeOffset
        anchors.verticalCenterOffset: parent.height / 12
        source: "qrc:/images/logoQR_1024x1024.png"
        mipmap: true
        fillMode: Image.PreserveAspectFit
    }
    Image
    {
        id: claimImage
        width: qrCodeImage.width / 580.0 * 364.0
        source: "qrc:/images/logoClaim_1024x1024.png"
        mipmap: true
        fillMode: Image.PreserveAspectFit
        x: -width
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -height / 10
        Behavior on x {
            NumberAnimation {
                duration: animationDuration
            }
        }
    }
}
