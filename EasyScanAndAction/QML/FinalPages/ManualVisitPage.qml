import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../BasePages"
import "../Comp"

PageWithBackButton
{
    id: manualvisitpage
    caption: "Kontaktsituation eintragen"
    function saveVisit(name, adress)
    {
        manualvisitpage.name = name
        manualvisitpage.adress = adress
        ESAA.askYesNoQuestion("Soll ein Besuch bei <br><br><b>" + name + "</b><br><br> eingetragen werden?", visitAccepted, visitNotAccepted)
    }

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
        manualName.text = ""
        MobileExtensions.requestLocationPermission(permissionDenied, permissionGranted)
        if (!MobileExtensions.locationServicesDeniedByUser)
        {
            PlacesManager.update()
        }
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
        opacity: backButton.opacity
        visible: opacity > 0
        anchors.top: parent.top
        anchors.margins: ESAA.spacing
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: manuelButton.top
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
                onClicked: saveVisit(place.name, place.adress)
            }
        }
    }
    Rectangle
    {
        opacity: backButton.opacity / 2
        visible: opacity > 0 && PlacesManager.waitingForPlaces && !locationNotAvailable.visible
        anchors.fill: view
        color: "red"
        ESAAText
        {
            anchors.centerIn: parent
            text: "Umgebungsdaten werden abgerufen"
        }
    }
    Rectangle
    {
        id: locationNotAvailable
        anchors.fill: view
        color: "orange"
        opacity: backButton.opacity
        visible: opacity > 0 && MobileExtensions.locationServicesDeniedByUser
        ESAAText
        {
            anchors.centerIn: parent
            width: parent.width * 8 / 10
            wrapMode: Text.WordWrap
            text: "Die Standortdaten können nicht abgerufen werden, bitte aktivieren sie die Lokalisierung in den " + MobileExtensions.systemName + " Einstellungen."
        }
        onVisibleChanged: {
            if (!visible && manualvisitpage.visible)
            {
                if (!MobileExtensions.locationServicesDeniedByUser)
                {
                    PlacesManager.update()
                }
            }
        }
    }
    CircleButton
    {
        id: manuelButton
        anchors.right: parent.right
        anchors.verticalCenter: backButton.verticalCenter
        anchors.rightMargin: ESAA.spacing
        text: "+"
        onClicked: openManual()
        width: backButton.width * 1.5
    }
    function openManual()
    {
        manuell.x = 0
        manuell.y = 0
        manuell.width = manualvisitpage.width
        manuell.height = manualvisitpage.height
        manuell.opacity = 1
        manuell.radius = 0
        backButton.opacity = 0
    }
    function closeManual()
    {
        manuell.x = manuelButton.x
        manuell.y = manuelButton.y
        manuell.width = manuelButton.width
        manuell.height = manuelButton.height
        manuell.opacity = 0
        manuell.radius = manualvisitpage.width / 2
        backButton.opacity = 1
    }

    PageWithBackButton
    {
        id: manuell
        x: manuelButton.x
        y: manuelButton.y
        width: manuelButton.width
        height: manuelButton.width
        radius: manualvisitpage.width /2
        Behavior on radius {
            NumberAnimation
            {
                duration: JW78Utils.longAniDuration
            }
        }

        Behavior on x {
            NumberAnimation {
                duration: JW78Utils.longAniDuration
            }
        }
        Behavior on y {
            NumberAnimation {
                duration: JW78Utils.longAniDuration
            }
        }
        Behavior on width {
            NumberAnimation {
                duration: JW78Utils.longAniDuration
            }
        }
        Behavior on height {
            NumberAnimation {
                duration: JW78Utils.longAniDuration
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: JW78Utils.longAniDuration
            }
        }
        onBackPressed: closeManual()

        Column
        {
            width: parent.width
            anchors.bottom: saveButton.top
            anchors.bottomMargin: ESAA.spacing
            ESAALineInputWithCaption
            {
                width: parent.width - 2 * ESAA.spacing
                caption: qsTr("Manuelle Eingabe")
                anchors.horizontalCenter: parent.horizontalCenter
                id: manualName
            }
        }

        CentralActionButton
        {
            id: saveButton
            text: "Speichern"
            onClicked:
            {
                if (manualName.displayText == "")
                {
                    ESAA.showMessage("Bitte geben Sie noch eine Bezeichnung für den manuelle Speicherung ein.");
                    return
                }
                saveVisit(manualName.displayText, "")
            }
        }
    }
}
