import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15
import "qrc:/foundation"

Button
{
    width: JW78Utils.screenWidth / 4
    height: width
    id: control
    font.family: "Roboto-Regular"
    font.pixelSize: ESAA.fontButtonPixelsize * 0.8
    property string smallTopText: ""
    property alias alertAniRunning: alertAni.running
    property bool repeatAlertAni: false;
    property int markGlowRadius: 0
    property alias source: img.source
    property alias downSource: downImg.source
    property color buttonDownColor: ESAA.buttonDownColor
    property color buttonColor: "transparent"
    property int verticalImageOffset: 0
    property double imageSizeFactor: 1
    property alias belowCaption: belowCaptionText.text
    property alias aboveCaption: aboveCaptionText.text
    contentItem: Item {
        IDPText
        {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: control.height / 8
            text: control.smallTopText
            opacity: enabled ? 1.0 : 0.3
            color: control.down ? control.buttonColor : control.buttonDownColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            font.pixelSize: ESAA.fontTextPixelsize / 1.3
            font.family: "Roboto-Thin"

        }
        IDPText
        {
            anchors.centerIn: parent
            text: control.text
            font: control.font
            opacity: enabled ? 1.0 : 0.3
            color: control.down ? ESAA.buttonColor : control.buttonDownColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }
    IDPText
    {
        visible: text != ""
        id: belowCaptionText
        color: ESAA.buttonColor
        font.pixelSize: control.font.pixelSize * 1.3
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
    }
    IDPText
    {
        visible: text != ""
        id: aboveCaptionText
        color: ESAA.buttonColor
        font.pixelSize: control.font.pixelSize * 1.3
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
    }

    background: Rectangle {
        id: background
        color: control.down ? control.buttonDownColor : ESAA.buttonColor
        opacity: enabled ? 1 : 0.3
        border.color:  control.buttonDownColor
        border.width: 1
        radius: width / 2
        Image
        {
            id: img
            anchors.centerIn: parent
            anchors.verticalCenterOffset: verticalImageOffset
            height: parent.height * imageSizeFactor
            width: height
            fillMode: Image.PreserveAspectFit
            mipmap: true
            visible: source != "" && (!control.down || downImg.source != "")
        }
        Image
        {
            id: downImg
            anchors.centerIn: parent
            anchors.verticalCenterOffset: verticalImageOffset
            height: parent.height * imageSizeFactor
            width: height
            fillMode: Image.PreserveAspectFit
            visible: source != "" && control.down
            mipmap: true
        }
    }
    property int pauseDuration: 0
    PauseAnimation {
        id: pauseAni
        duration: pauseDuration
        onStopped: colorAni1.start()
    }

    ColorAnimation {
        property: "buttonColor"
        id: colorAni1
        from: control.buttonColor
        to: control.buttonDownColor
        duration: 100
        onStopped: colorAni2.start()
    }
    ColorAnimation {
        property: "buttonColor"
        id: colorAni2
        from: control.buttonDownColor
        to: control.buttonColor
        duration: 100
    }

    function blink(pause)
    {
        pauseDuration = pause
        pauseAni.start()
    }

    property int pauseDurationRotation: 0
    PauseAnimation {
        id: pauseAniRotation
        duration: pauseDurationRotation
        onFinished: rotationAnimation.start()
    }
    NumberAnimation
    {
        id: rotationAnimation
        target: img
        property: "rotation"
        to: 0
        duration: 1200
        easing.type: Easing.InOutQuint
    }

    function rotate(pause)
    {
        pauseDurationRotation = pause
        img.rotation = -720
        pauseAniRotation.start()
    }
    SequentialAnimation
    {
        id: alertAni
        running: false
        NumberAnimation
        {
            target: control
            property: "markGlowRadius"
            to: 21
            duration: 800
        }
        NumberAnimation
        {
            target: control
            property: "markGlowRadius"
            to: 0
            duration: 800
        }
        onStopped:
        {
            if (repeatAlertAni)
            {
                alertAni.start()
            }
        }
    }
}
