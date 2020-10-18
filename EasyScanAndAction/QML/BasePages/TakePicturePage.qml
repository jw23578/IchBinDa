import QtQuick 2.15
import QtMultimedia 5.15
import "../Comp"

PageWithBackButton {
    Camera {
        id: camera

        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposurePortrait
        }

        flash.mode: Camera.FlashRedEyeReduction

        imageCapture {
            onImageCaptured: {
                photoPreview.source = preview  // Show the preview in an Image
            }
        }
    }

    VideoOutput {
        source: camera
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: takePictureButton.top
        anchors.margins: ESAA.spacing
        focus: visible // to receive focus and capture key events when visible
    }
    CircleButton
    {
        id: takePictureButton
        x: ESAA.screenWidth / 300 * 150 - width / 2
        y: ESAA.screenHeight / 480 * 360 - height / 2
        text: "Foto<br>aufnehmen"
    }
    onShowing: camera.start()
    onHiding: camera.stop()
    Component.onCompleted: camera.stop()
}
