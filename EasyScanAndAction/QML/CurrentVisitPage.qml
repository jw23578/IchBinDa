import QtQuick 2.15
import "Comp"
import "qrc:/foundation"

ESAAPage
{
    caption: "Du bist hier:"
    signal questionVisitEnd;
    Item
    {
        width: parent.width
        height: parent.height * 1.5 / 10
        Image
        {
            id: logoImage
            height: parent.height
            anchors.top: parent.top
            anchors.topMargin: ESAA.spacing
            anchors.left: parent.left
            anchors.leftMargin: ESAA.spacing
            width: height
            source: LastVisit.logoUrl
            fillMode: Image.PreserveAspectFit
            visible: true
            cache: true
        }
        IDPText
        {
            id: besuchBeginn
            anchors.left: logoImage.right
            anchors.leftMargin: ESAA.spacing
            anchors.right: logoImage.right
            anchors.top: parent.top
            anchors.topMargin: ESAA.spacing
            font.pixelSize: ESAA.fontTextPixelsize * 1.5
            font.bold: true
            wrapMode: Text.WordWrap
            text: JW78Utils.formatTime(LastVisit.begin)
        }
        IDPText
        {
            anchors.left: logoImage.right
            anchors.leftMargin: ESAA.spacing
            anchors.right: logoImage.right
            anchors.top: besuchBeginn.bottom
            font.pixelSize: ESAA.fontTextPixelsize * 1.5
            font.bold: true
            wrapMode: Text.WordWrap
            text: LastVisit.facilityName
        }

        id: headItem
    }
    Flickable
    {
        anchors.top: headItem.bottom
        anchors.bottom: shareButton.top
        anchors.bottomMargin: ESAA.spacing * 2
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.min(parent.width - 2 * ESAA.spacing, contentWidth)
        contentHeight: height
        contentWidth: theGrid.width
        Grid
        {
            id: theGrid
            clip: true
            property int anz: 1 + (LastVisit.websiteURL != "" ? 1 : 0)
                              + (LastVisit.foodMenueURL != "" ? 1 : 0)
                              + (LastVisit.drinksMenueURL != "" ? 1 : 0)
                              + (LastVisit.lunchMenueURL != "" ? 1 : 0)
                              + (LastVisit.individualURL1 != "" ? 1 : 0)
            columns: anz > 4 ? 3 : 2
            rows: 2
            property int buttonSize: JW78Utils.screenWidth / 3
            property int buttonFontPixelSize: ESAA.fontButtonPixelsize
            height: parent.height
            width: buttonSize * columns + spacing * (columns - 1)
            topPadding: ESAA.spacing
            spacing: ESAA.spacing
            //        spacing: (width - columns * buttonSize) / (columns - 1)
            rowSpacing: ESAA.spacing
            IDPButtonCircle
            {
                id: lastTransmissionbutton
                text: qsTr("Letzte<br>Übertragung")
                onClicked: ESAA.showLastTransmission()
                font.pixelSize: theGrid.buttonFontPixelSize
                width: parent.buttonSize
            }
            IDPButtonCircle
            {
                id: websiteButton
                text: qsTr("Webseite<br>öffnen")
                onClicked: ESAA.openUrlORPdf(LastVisit.websiteURL)
                visible: LastVisit.websiteURL != ""
                font.pixelSize: theGrid.buttonFontPixelSize * 1.3
                width: parent.buttonSize
            }
            IDPButtonCircle
            {
                text: qsTr("Speise-<br>karte")
                font.pixelSize: theGrid.buttonFontPixelSize * 1.3
                onClicked: ESAA.openUrlORPdf(LastVisit.foodMenueURL)
                visible: LastVisit.foodMenueURL != ""
                width: parent.buttonSize
            }
            IDPButtonCircle
            {
                text: qsTr("Getränke-<br>karte")
                font.pixelSize: theGrid.buttonFontPixelSize * 1.3
                onClicked: ESAA.openUrlORPdf(LastVisit.drinksMenueURL)
                visible: LastVisit.drinksMenueURL != ""
                width: parent.buttonSize
            }
            IDPButtonCircle
            {
                text: qsTr("Mittags-<br>karte")
                font.pixelSize: theGrid.buttonFontPixelSize * 1.3
                onClicked: ESAA.openUrlORPdf(LastVisit.lunchMenueURL)
                visible: LastVisit.lunchMenueURL != ""
                width: parent.buttonSize
            }
            IDPButtonCircle
            {
                text: LastVisit.individualURL1Caption
                font.pixelSize: theGrid.buttonFontPixelSize * 1.3
                onClicked: ESAA.openUrlORPdf(LastVisit.individualURL1)
                visible: LastVisit.individualURL1 != ""
                width: parent.buttonSize
            }
        }
    }
    ShareButton
    {
        id: shareButton
    }
    IDPButtonCircle
    {
        id: finishVisit
        text: qsTr("Besuch<br>beenden")
        onClicked: questionVisitEnd()
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: JW78Utils.screenWidth / 12
        anchors.bottomMargin: anchors.leftMargin
        buttonFromColor: "orange"
        buttonToColor: "orange"
    }
}
