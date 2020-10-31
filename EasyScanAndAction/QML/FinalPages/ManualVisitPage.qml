import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../BasePages"
import "../Comp"
import QtPositioning 5.11

PageWithBackButton
{
    id: manualvisitpage
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
    }
    function permissionDenied()
    {

    }
    function permissionGranted()
    {

    }
    property string name: ""
    property string adress: ""
    function visitAccepted()
    {
        ESAA.saveKontaktsituation(name, adress)
        ESAA.showMessage("Die Kontaktsituation wurde gespeichert.")
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
                onClicked:
                {
                    manualvisitpage.name = place.name
                    manualvisitpage.adress = place.adress
                    ESAA.askYesNoQuestion("Soll ein Besuch bei <br><br><b>" + place.name + "</b><br><br> eingetragen werden?", visitAccepted, visitNotAccepted)
                }
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
    Rectangle
    {
        anchors.fill: view
        color: "orange"
        opacity: 0.5
        ESAAText
        {
            anchors.centerIn: parent
            text: "Die Standortdaten können nicht abgerufen werden, bitte aktivieren sie die Lokalisierung in den " + MobileExtensions.systemName + " Einstellungen."
        }
        visible: MobileExtensions.locationServicesDeniedByUser
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
