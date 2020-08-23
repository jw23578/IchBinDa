import QtQuick 2.12
import QZXing 2.3
import QtMultimedia 5.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.0

ESAAPage
{
    id: scannerpage
    onShowing:
    {
        console.log("show scanner")
        if (!ESAA.isActiveVisit(ESAA.lastVisitDateTime))
        {
            camera.stop()
            camera.start()
            camera.searchAndLock()
        }
        shareButton.rotate(400)
    }

    onHiding:
    {
        camera.stop()
    }

    signal playBackClicked;
    signal basketClicked;

    function decode(preview) {
        photoPreview.source = preview
        decoder.decodeImageQML(photoPreview);
    }

    NumberAnimation
    {
        id: animateOutputMargins
        to: 0
        target: output
        property: "anchors.margins"
    }

    QZXingFilter {
        id: zxingFilter
        decoder {
            enabledDecoders: QZXing.DecoderFormat_QR_CODE
            tryHarder: true
            onTagFound: {
                console.log(tag)
                if (tag.length)
                {
                    ESAA.action(tag)
                }
            }
        }
        captureRect: {
            // setup bindings
            output.contentRect;
            output.sourceRect;
            if (output.orientation == 90 || output.orientation == 270)
            {
                return output.mapRectToSource(
                            output.mapNormalizedRectToItem(
                                Qt.rect(captureZone.topStartFaktor,
                                        captureZone.leftStartFaktor,
                                        captureZone.heightFaktor,
                                        captureZone.widthFaktor)));
            }

            return output.mapRectToSource(
                        output.mapNormalizedRectToItem(
                            Qt.rect(captureZone.leftStartFaktor,
                                    captureZone.topStartFaktor,
                                    captureZone.widthFaktor,
                                    captureZone.heightFaktor)));
        }
    }
    Camera
    {
        id: camera                
//        focus.focusMode: Camera.FocusContinuous
//        focus.focusPointMode:  Camera.FocusPointAuto
    }
    Timer
    {
        interval: 1000
        running: camera.cameraState == Camera.ActiveState
        repeat: true
        onTriggered:
        {
            console.log("hello")
            camera.searchAndLock()
        }
    }

    ESAAText
    {
        id: headertext
        anchors.top: parent.top
        anchors.topMargin: ESAA.spacing
        anchors.bottomMargin: ESAA.spacing
        anchors.horizontalCenter: parent.horizontalCenter
        text: "QR-Code einlesen"
//        horizontalAlignment: Text.horizontalCenter
    }
    Item
    {
        anchors.top: headertext.bottom
        id: scanneritem
        width: parent.width
        height: width
        Rectangle
        {
            clip: true
            radius: width / 15
            anchors.centerIn: parent
            width: parent.width * 9 / 10
            height: width
            id: the_rect
            VideoOutput
            {
                id: output
                autoOrientation: true
                source: camera
                anchors.fill: parent
                focus : visible // to receive focus and capture key events when visible
                filters: [ zxingFilter ]

                fillMode: VideoOutput.PreserveAspectCrop
//                layer.enabled: true
//                layer.effect:
//                    OpacityMask
//                {
//                    maskSource: the_rect
//                }
                property double leftStartFaktor: 0.2
                property double topStartFaktor: 0.2
                property double widthFaktor: 1 - 2 * leftStartFaktor
                property double heightFaktor: 1 - 2 * topStartFaktor
                Rectangle
                {
                    id: topRect
                    height: captureZone.y
                    width: parent.width
                    opacity: 0.4
                    color: ESAA.backgroundTopColor
                }
                Rectangle
                {
                    id: bottomRect
                    y: parent.height - height
                    height: parent.height - captureZone.y - captureZone.height
                    width: parent.width
                    opacity: 0.4
                    color: ESAA.backgroundTopColor
                }
                Rectangle
                {
                    id: leftRect
                    y: captureZone.y
                    height: captureZone.height
                    width: captureZone.x
                    opacity: 0.4
                    color: ESAA.backgroundTopColor
                }
                Rectangle
                {
                    id: rightRect
                    y: captureZone.y
                    height: captureZone.height
                    x: parent.width - width
                    width: parent.width - captureZone.x - captureZone.width
                    opacity: 0.4
                    color: ESAA.backgroundTopColor
                }

                Item
                {
                    id: captureZone
                    x: output.contentRect.width * parent.leftStartFaktor + output.contentRect.x
                    y: output.contentRect.height * parent.topStartFaktor + output.contentRect.y
                    width: output.contentRect.width * parent.widthFaktor
                    height: output.contentRect.height * parent.heightFaktor
                }
                ESAAButton
                {
                    id: finishVisit
                    width: parent.width * 0.8
                    anchors.centerIn: parent
                    text: qsTr("Besuch beenden")
                    onClicked:
                    {
                        ESAA.finishVisit()
                        camera.start()
                        shareButton.rotate(400)
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: ESAA.isActiveVisit(ESAA.lastVisitDateTime);
                }
            }
        }
    }
    Item
    {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.top: scanneritem.bottom
        anchors.right: parent.right
        ESAAButton
        {
            id: shareButton
            width: parent.width * 0.8
            anchors.centerIn: parent
            anchors.verticalCenterOffset: lastTransmissionbutton.visible ? -lastTransmissionbutton.height : 0
            text: qsTr("Weiterempfehlen")
            onClicked: ESAA.recommend()
            source: "qrc:/images/share-icon-40146.png"
        }
        ESAAButton
        {
            id: lastTransmissionbutton
            width: parent.width * 0.8
            anchors.top: shareButton.bottom
            anchors.topMargin: ESAA.spacing
            text: qsTr("Letzte Übertragung anzeigen")
            onClicked: ESAA.showLastTransmission()
            anchors.horizontalCenter: parent.horizontalCenter
            visible: ESAA.data2send.length > 0
        }
    }
    Component.onCompleted: camera.stop()
}
