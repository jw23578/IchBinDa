import QtQuick 2.12
import QZXing 2.3
import QtMultimedia 5.13
import QtQuick.Controls 2.13

Rectangle
{
    id: scannerpage
    anchors.fill: parent
    function show()
    {
        visible = true
        camera.stop()
        camera.start()
    }

    function close()
    {
        visible = false
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
            //            enabledDecoders: QZXing.DecoderFormat_Aztec
            //                             | QZXing.DecoderFormat_CODABAR
            //                             | QZXing.DecoderFormat_CODE_128
            //                             | QZXing.DecoderFormat_CODE_128_GS1
            //                             | QZXing.DecoderFormat_CODE_39
            //                             | QZXing.DecoderFormat_CODE_93
            //                             | QZXing.DecoderFormat_DATA_MATRIX
            //                             | QZXing.DecoderFormat_EAN_13
            //                             | QZXing.DecoderFormat_EAN_8
            //                             | QZXing.DecoderFormat_ITF
            //                             | QZXing.DecoderFormat_MAXICODE
            //                             | QZXing.DecoderFormat_PDF_417
            //                             | QZXing.DecoderFormat_QR_CODE
            //                             | QZXing.DecoderFormat_RSS_14
            //                             | QZXing.DecoderFormat_RSS_EXPANDED
            //                             | QZXing.DecoderFormat_UPC_A
            //                             | QZXing.DecoderFormat_UPC_E
            //                             | QZXing.DecoderFormat_UPC_EAN_EXTENSION
            enabledDecoders: QZXing.DecoderFormat_QR_CODE
            tryHarder: true
            onTagFound: {
                captureZone.color = "green"
                console.log(tag)
                if (tag.length)
                {
                    ESAA.action(tag)
                    scannerpage.close()
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

        //        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

        //        exposure {
        //            exposureCompensation: -1.0
        //            exposureMode: Camera.ExposureBarcode
        //        }

        //        flash.mode: Camera.FlashRedEyeReduction

        focus.focusMode: Camera.FocusContinuous
        focus.focusPointMode:  Camera.FocusPointAuto

        Component.onCompleted: camera.searchAndLock()
    }

    VideoOutput
    {
        clip: true
        id: output
        autoOrientation: true
        source: camera
        anchors.left: parent.left
        anchors.right: parent.right
        height: width
        focus : visible // to receive focus and capture key events when visible
        filters: [ zxingFilter ]

        fillMode: VideoOutput.PreserveAspectCrop

        MouseArea
        {
            anchors.fill: parent
            onClicked: {
                //                camera.focus.customFocusPoint = Qt.point(mouse.x / width,  mouse.y / height);
                //                camera.focus.focusMode = CameraFocus.FocusMacro;
                //                camera.focus.focusPointMode = CameraFocus.FocusPointCustom;
                console.log(output.orientation)
            }
        }
        Rectangle
        {
            property double leftStartFaktor: 0.2
            property double topStartFaktor: 0.2
            property double widthFaktor: 1 - 2 * leftStartFaktor
            property double heightFaktor: 1 - 2 * topStartFaktor
            id: captureZone
            color: "red"
            opacity: 0.2
            x: output.contentRect.width * leftStartFaktor + output.contentRect.x
            y: output.contentRect.height * topStartFaktor + output.contentRect.y
            width: output.contentRect.width * widthFaktor
            height: output.contentRect.height * heightFaktor
        }
    }

    Button
    {
        anchors.bottom: qrcodebutton.top
        anchors.left: parent.left
        anchors.right: parent.right
        text: "Hilfe"
        onClicked: ESAA.firstStart = true
    }
    Button
    {
        id: qrcodebutton
        anchors.bottom: quitButton.top
        anchors.left: parent.left
        anchors.right: parent.right
        text: "QR-Code erzeugen"
        onClicked: createqrcodepage.visible = true
    }

    Button
    {
        id: quitButton
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        text: "Beenden"
        onClicked: Qt.quit()
    }

    CreateQRCodePage
    {
        id: createqrcodepage
        anchors.fill: parent
        visible: false
        onVisibleChanged:
        {
            if (visible)
            {
                camera.stop()
            }
            else
            {
                camera.start()
            }
        }
    }

    Component.onCompleted:
    {
        show()
    }
}
