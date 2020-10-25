import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../BasePages"
import "../Comp"
import QtPositioning 5.11

PageWithBackButton {
    onShowing:
    {
        MobileExtensions.requestLocationPermission(permissionDenied, permissionGranted)
//        positionsource.active = true
    }
    function permissionDenied()
    {

    }
    function permissionGranted()
    {

    }

    ListView
    {
        id: view
        anchors.top: parent.top
        anchors.topMargin: ESAA.spacing
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: backButton.top
        anchors.bottomMargin: ESAA.spacing
        spacing: 1
        model: Places
        clip: true
        delegate: Item {
            width: view.width
            height: view.height / 8
            ESAAText
            {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: ESAA.spacing
                text: place.name
                font.pixelSize: ESAA.fontTextPixelsize * 1.1
            }
            ESAAText
            {
                anchors.left: parent.left
                anchors.leftMargin: ESAA.spacing
                anchors.bottom: parent.bottom
                anchors.bottomMargin: ESAA.spacing / 4
                font.pixelSize: ESAA.fontTextPixelsize * 0.9
                text: place.adress
            }

            Rectangle
            {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: "black"
            }
        }
    }

//    onHiding: positionsource.active = false
//    PositionSource
//    {
//        active: false
//        id: positionsource
//        updateInterval: 1000
//        onPositionChanged:
//        {
//            if (!position.longitudeValid)
//            {
//                return;
//            }
//            console.log("latitude: " + position.coordinate.latitude)
//            console.log("longitude: " + position.coordinate.longitude)
//        }
//    }
}
