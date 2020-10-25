import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../BasePages"
import "../Comp"
import QtPositioning 5.11

PageWithBackButton
{
    caption: "Kontaktsituation eintragen"
    CircleButton
    {
        anchors.right: parent.right
        anchors.top: parent.top
        text: "oldenburg<br>simulieren"
        visible: ESAA.isDevelop
        onClicked: PlacesManager.simulate()
        z: 2
    }

    onShowing:
    {
        MobileExtensions.requestLocationPermission(permissionDenied, permissionGranted)
        PlacesManager.update()
//        positionsource.active = true
    }
    function permissionDenied()
    {

    }
    function permissionGranted()
    {

    }

    function visitAccepted()
    {
        console.log("ja")
        ESAA.showMessage("Der Besuch wurde gespeichert.")
        backPressed()
    }
    function visitNotAccepted()
    {
        console.log("nein")
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
            MouseArea
            {
                anchors.fill: parent
                onClicked: ESAA.askYesNoQuestion("Soll ein Besuch bei " + place.name + " eingetragen werden?", visitAccepted, visitNotAccepted)
            }
        }
    }
    Rectangle
    {
        anchors.fill: view
        color: "red"
        opacity: 0.5
        ESAAText
        {
            anchors.centerIn: parent
            text: "Umgebungsdaten werden abgerufen"
        }
        visible: PlacesManager.waitingForPlaces
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
