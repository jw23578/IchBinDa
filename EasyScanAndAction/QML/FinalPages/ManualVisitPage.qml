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
        visible: ESAA.isDevelop && opacity > 0
        onClicked: PlacesManager.simulate()
        z: 2
        opacity: view.opacity
    }

    onShowing:
    {
        manualName.text = ""
        if (JW78Utils.isPC)
        {
            PlacesManager.simulate()
            return
        }

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
        anchors.topMargin: ESAA.spacing * 3
        anchors.margins: ESAA.spacing
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: manuelButton.top
        spacing: 1
        model: Places
        clip: true
        delegate: Item
        {
            id: theItem
            opacity: 0
            visible: opacity > 0
            SequentialAnimation
            {
                id: showani

                PauseAnimation {
                    duration: index * 100
                }
                NumberAnimation
                {
                    target: theItem
                    duration: JW78Utils.shortAniDuration
                    property: "opacity"
                    to: 1
                }
            }
            Component.onCompleted: showani.start()

            width: view.width
            height: theColumn.height
            Column {
                id: theColumn

                width: view.width
                Item
                {
                    height: ESAA.spacing
                    width: parent.width
                }

                ESAAText
                {
                    text: place.name
                    width: parent.width
                    font.pixelSize: ESAA.headerFontPixelsize
                    color: JW78APP.headerFontColor
                }
                Item
                {
                    height: ESAA.spacing / 4
                    width: parent.width
                }
                ESAAText
                {
                    font.pixelSize: ESAA.contentFontPixelsize
                    color: JW78APP.contentFontColor
                    elide: Text.ElideRight
                    width: parent.width
                    text: place.adress
                }
                Item
                {
                    height: ESAA.spacing
                    width: parent.width
                }

                Rectangle
                {
                    visible: index < view.count - 1
                    width: parent.width / 6
                    height: 1
                    color: "lightgrey"
                }
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
        theRect.opacity = 0
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
        theRect.opacity = 1
    }

    PageWithBackButton
    {
        clip: true
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
        Rectangle
        {
            id: theRect
            radius: parent.radius
            anchors.fill: parent
            opacity: 1
            visible: opacity > 0
            color: "grey"
            Behavior on opacity {
                NumberAnimation {
                    duration: JW78Utils.longAniDuration * 2
                }
            }
        }

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
