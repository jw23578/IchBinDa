import QtQuick 2.15
import QtMultimedia 5.15
import "../Comp"

PageWithBackButton {
    id: thePage
    property string targetFileName: ""
    signal imageSaved(string filename);
    property var camera: null
//    Camera {
//        id: camera
//        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

//        exposure {
//            exposureCompensation: -1.0
//            exposureMode: Camera.ExposurePortrait
//        }

//        flash.mode: Camera.FlashRedEyeReduction

//        imageCapture {
//            onImageSaved: {
//                console.log("Saved");
//                thePage.imageSaved(thePage.targetFileName)
//            }
//        }
//    }

    VideoOutput {
        id: output
        autoOrientation: true
        source: null
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: takePictureButton.top
        anchors.margins: ESAA.spacing
        focus: visible // to receive focus and capture key events when visible
    }
    CentralActionButton
    {
        id: takePictureButton
        text: "Foto<br>aufnehmen"
        onClicked: camera.captureToLocation(targetFileName)
    }
    onShowing:
    {
        camera.targetFileName = ESAA.tempTakenPicture
        camera.scan = false
        camera.start()
    }
    onHiding:
    {
        camera.stop()
    }
}
