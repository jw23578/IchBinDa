import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../BasePages"
import "../Comp"
import "qrc:/foundation"

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

    IDPButtonCircle
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
                    duration: Math.max(0, index * 100)
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
            Column
            {
                id: theColumn
                width: view.width
                Item
                {
                    height: ESAA.spacing
                    width: parent.width
                }

                IDPText
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
                IDPText
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
        id: noLocationFound
        anchors.fill: view
        color: "white"
        opacity: backButton.opacity
        visible: opacity > 0 && Places.count == 0
        IDPText
        {
            anchors.centerIn: parent
            width: parent.width * 8 / 10
            wrapMode: Text.WordWrap
            text: "An deinem aktuellen Standort wurden leider keine Locations gefunden. Bitte trag deinen Besuch über den Plus-Button ein."
            font.pixelSize: JW78APP.fontMessageTextPixelsize
        }
    }
    Rectangle
    {
        opacity: backButton.opacity
        visible: opacity > 0 && PlacesManager.waitingForPlaces && !locationNotAvailable.visible
        anchors.fill: view
        color: "white"
        AnimatedImage
        {
            source: "qrc:/images/loading.gif"
            anchors.centerIn: parent
            id: waitImage
            width: parent.width / 2
            height: width
        }

        IDPText
        {
            anchors.horizontalCenter: waitImage.horizontalCenter
            anchors.top: waitImage.bottom
            anchors.topMargin: JW78APP.spacing
            text: "Bitte warten, die Umgebungsdaten werden abgerufen"
            width: parent.width * 8 / 10
            font.pixelSize: JW78APP.fontMessageTextPixelsize
            wrapMode: Text.WordWrap
        }
    }
    Rectangle
    {
        id: locationNotAvailable
        anchors.fill: view
        color: "orange"
        opacity: backButton.opacity
        visible: opacity > 0 && MobileExtensions.locationServicesDeniedByUser
        IDPText
        {
            anchors.centerIn: parent
            width: parent.width * 8 / 10
            wrapMode: Text.WordWrap
            text: "Die Standortdaten können nicht abgerufen werden, bitte aktivieren sie die Lokalisierung in den " + MobileExtensions.systemName + " Einstellungen."
            font.pixelSize: JW78APP.fontMessageTextPixelsize
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
    IDPButtonCircle
    {
        id: manuelButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: ESAA.spacing
        text: "+"
        onClicked: openManual()
        width: backButton.width * 1.5
    }
    function openManual()
    {
        manuell.opened = true
        manuell.opacity = 1
        manuell.radius = 0
        backButton.opacity = 0
        theRect.opacity = 0
    }

    function closeManual()
    {
        manuell.opened = false
        manuell.opacity = 0
        manuell.radius = manualvisitpage.width / 2
        backButton.opacity = 1
        theRect.opacity = 1
    }

    PageWithBackButton
    {
        clip: true
        property bool opened: false
        id: manuell
        x: opened ? 0 : manuelButton.x
        y: opened ? 0 : manuelButton.y
        width: opened ? manualvisitpage.width : manuelButton.width
        height: opened ? manualvisitpage.height : manuelButton.width

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

        Flickable
        {
            width: parent.width
            anchors.top: parent.top
            anchors.bottom: saveButton.top
            anchors.margins: JW78APP.spacing
            contentHeight: theColumn2.height
            id: theFlickable
            Column
            {
                id: theColumn2
                width: parent.width
                spacing: JW78APP.spacing
                Item
                {
                    width: parent.width
                    height: Math.max(0, theFlickable.height - infoText.height - manualName.height - 2 * JW78APP.spacing)
                }

                IDPText
                {
                    id: infoText
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 2 * JW78APP.spacing
                    wrapMode: Text.WordWrap
                    text: qsTr("Der gesuchte Aufenthaltsort war nicht dabei? Gib hier einfach eine Bezeichnung für deinen Standort ein:")
                    font.pixelSize: JW78APP.fontMessageTextPixelsize
                }
                IDPLineEditWithCaption
                {
                    containedCaption: true
                    width: parent.width - 2 * JW78APP.spacing
                    caption: qsTr("Name des Geschäfts oder Orts")
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: manualName
                    font.pixelSize: JW78APP.fontMessageTextPixelsize
                }
            }
        }

        CentralActionButton
        {
            id: saveButton
            text: qsTr("Kontakt<br>situation<br>Speichern")
            onClicked:
            {
                if (manualName.displayText == "")
                {
                    ESAA.showMessage("Bitte geben Sie noch eine Bezeichnung für die manuelle Speicherung ein.");
                    return
                }
                saveVisit(manualName.displayText, "")
            }
        }
    }
}
