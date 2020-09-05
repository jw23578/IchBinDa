import QtQuick 2.0

import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.1

ESAAPage
{
    id: showSendedDataPage
    onShowing: theFlick.contentY = 0
    signal close
    onBackPressed:
    {
        close()
    }
    Rectangle
    {
        id: removeMeLater
        anchors.fill: parent
        color: "white"
    }

    property color textColor: ESAA.buttonColor
    Column
    {
        id: theColumn1
        y: ESAA.spacing * 2
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - parent.width / 10
        spacing: ESAA.spacing / 2
        topPadding: spacing
        Item
        {
            width: parent.width
            height: 1
        }
        ESAAText
        {
            width: parent.width - 2 * ESAA.spacing
            anchors.horizontalCenter: parent.horizontalCenter
            text: LastVisit.facilityName
            color: textColor
            font.pixelSize: ESAA.fontTextPixelsize * 1.5
            font.bold: true
        }
        Item
        {
            width: parent.width
            height: showSendedDataPage.height * 1.5 / 10
            Image
            {
                height: parent.height
                width: height
                source: ESAA.lastVisitLogoUrl
                fillMode: Image.PreserveAspectFit
                visible: true
            }
            Rectangle
            {
                id: colorRect
                x: parent.height
                width: parent.height
                height: parent.height
                color: ESAA.lastVisitColor
                radius: ESAA.radius
            }
            Rectangle
            {
                radius: ESAA.radius
                anchors.left: colorRect.right
                width: parent.height
                height: parent.height
                visible: (ESAA.lastVisitCountX > 0
                          && ESAA.lastVisitCount > 0
                          && ESAA.lastVisitCount % ESAA.lastVisitCountX)
                color: ESAA.lastVisitCountXColor
                Component.onCompleted:
                {
                    console.log("ESAA.lastVisitCountX: " + ESAA.lastVisitCountX)
                    console.log("ESAA.lastVisitCount: " + ESAA.lastVisitCount)
                    console.log((ESAA.lastVisitCountX > 0
                                 && ESAA.lastVisitCount > 0
                                 && ESAA.lastVisitCount % ESAA.lastVisitCountX))
                }
            }
        }

        ESAAText
        {
            id: messageText
            width: parent.width
//            font.pixelSize: ESAA.fontMessageTextPixelsize
            color: textColor
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.horizontalCenter
            text: "Folgende Daten wurden verschlüsselt an " + ESAA.lastVisitLocationContactMailAdress + " übertragen"
        }

    }

    ESAAFlickable
    {
        id: theFlick
        anchors.bottom: closeButton.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: theColumn1.bottom
        contentHeight: theColumn.height * 1.1
        Column
        {
            parent: theFlick.contentItem
            id: theColumn
            y: ESAA.spacing
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - parent.width / 10
            spacing: ESAA.spacing / 2
            topPadding: spacing

            ESAALineInputWithCaption
            {
                caption: qsTr("Vorname")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                focus: true
                id: fstname
                text: ESAA.lastVisitFstname
                color: textColor
                readOnly: true
            }

            ESAALineInputWithCaption
            {
                caption: qsTr("Nachname")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: surname
                text: ESAA.lastVisitSurname
                color: textColor
                readOnly: true
            }

            ESAALineInputWithCaption
            {
                caption: qsTr("Straße")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: street
                text: ESAA.lastVisitStreet
                visible: ESAA.lastVisitStreet != ""
                color: textColor
                readOnly: true
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Hausnummer")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: housenumber
                text: ESAA.lastVisitHousenumber
                visible: ESAA.lastVisitHousenumber != ""
                inputMethodHints: Qt.ImhPreferNumbers
                color: textColor
                readOnly: true
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Postleitzahl")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: zip
                text: ESAA.lastVisitZip
                visible: ESAA.lastVisitZip != ""
                inputMethodHints: Qt.ImhDigitsOnly
                color: textColor
                readOnly: true
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Ort")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: location
                text: ESAA.lastVisitLocation
                visible: ESAA.lastVisitLocation != ""
                color: textColor
                readOnly: true
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("E-Mail-Adresse")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: emailAdress
                text: ESAA.lastVisitEmailAdress
                visible: ESAA.lastVisitEmailAdress != ""
                inputMethodHints: Qt.ImhEmailCharactersOnly
                color: textColor
                readOnly: true
            }
            ESAALineInputWithCaption
            {
                caption: qsTr("Handynummer")
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: mobile
                text: ESAA.lastVisitMobile
                visible: ESAA.lastVisitMobile != ""
                inputMethodHints: Qt.ImhDialableCharactersOnly
                color: textColor
                readOnly: true
            }
            Item
            {
                width: parent.width
                height: 1
            }
        }
    }
    ESAAButton
    {
        id: closeButton
        anchors.margins: ESAA.spacing
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: theColumn.width - ESAA.spacing
        text: "Schließen"
        onClicked: close()
    }
}
