import QtQuick 2.15
import QtQuick.Controls 2.15
import "Comp"
import "qrc:/foundation"

ESAAPage
{
    id: showSendedDataPage
    onShowing: theFlick.contentY = 0
    signal close
    onBackPressed:
    {
        close()
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
        IDPText
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
                source: LastVisit.logoUrl
                fillMode: Image.PreserveAspectFit
                visible: true
            }
            Rectangle
            {
                id: colorRect
                x: parent.height
                width: parent.height
                height: parent.height
                color: LastVisit.color
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

        IDPText
        {
            id: messageText
            width: parent.width
//            font.pixelSize: ESAA.fontMessageTextPixelsize
            color: textColor
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.horizontalCenter
            text: "Folgende Daten wurden verschlüsselt an " + LastVisit.facilityName + " übertragen"
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
            width: parent.width
            spacing: ESAA.spacing / 2
            topPadding: spacing
            IDPTextBorder
            {
                horizontalAlignment: Text.AlignLeft
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                id: fstname
                text: LastVisit.fstname + " " + LastVisit.surname
                color: textColor
            }
            IDPTextBorder
            {
                horizontalAlignment: Text.AlignLeft
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                text: ESAA.lastVisitStreet + " " + ESAA.lastVisitHousenumber
                color: textColor
                visible: text.trim().length > 0
            }
            IDPTextBorder
            {
                horizontalAlignment: Text.AlignLeft
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                text: ESAA.lastVisitZip + " " + ESAA.lastVisitLocation
                color: textColor
                visible: text.trim().length > 0
            }

            IDPTextBorder
            {
                horizontalAlignment: Text.AlignLeft
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                text: ESAA.lastVisitEmailAdress
                visible: ESAA.lastVisitEmailAdress != ""
                color: textColor
            }
            IDPTextBorder
            {
                horizontalAlignment: Text.AlignLeft
                width: parent.width - 2 * ESAA.spacing
                anchors.horizontalCenter: parent.horizontalCenter
                text: ESAA.lastVisitMobile
                visible: ESAA.lastVisitMobile != ""
                color: textColor
            }
            Item
            {
                width: parent.width
                height: 1
            }
        }
    }
    IDPButtonCircle
    {
        id: closeButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: ESAA.spacing
        text: "Schließen"
        onClicked: close()
    }
}
