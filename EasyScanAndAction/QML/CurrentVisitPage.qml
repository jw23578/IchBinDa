import QtQuick 2.15

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
            width: height
            source: LastVisit.logoUrl
            fillMode: Image.PreserveAspectFit
            visible: true
        }
        ESAAText
        {
            anchors.left: logoImage.right
            anchors.right: logoImage.right
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: ESAA.fontTextPixelsize * 1.5
            font.bold: true
            wrapMode: Text.WordWrap
            text: LastVisit.facilityName
        }

        id: headItem
    }
    Grid
    {
        id: theGrid
        property int anz: 2 + (LastVisit.websiteURL != "" ? 1 : 0)
                          + (LastVisit.foodMenueURL != "" ? 1 : 0)
                          + (LastVisit.drinksMenueURL != "" ? 1 : 0)
                          + (LastVisit.lunchMenueURL != "" ? 1 : 0)
                          + (LastVisit.individualURL1 != "" ? 1 : 0)
        columns: anz > 4 ? 3 : 2
        property int buttonSize: ESAA.screenWidth / (columns + 1 + (anz > 3 ? 0 : 0.2))
        property int buttonFontPixelSize: ESAA.fontButtonPixelsize * 0.8
        anchors.top: headItem.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: buttonSize * (columns + 0.5)
        topPadding: spacing / 4
        spacing: (width - columns * buttonSize) / (columns - 1)
        rowSpacing: spacing / 2
        CircleButton
        {
            id: finishVisit
            text: qsTr("Besuch<br>beenden")
            onClicked: questionVisitEnd()
            width: parent.buttonSize
            font.pixelSize: theGrid.buttonFontPixelSize
        }
        CircleButton
        {
            id: lastTransmissionbutton
            text: qsTr("Letzte<br>Übertragung")
            onClicked: ESAA.showLastTransmission()
            font.pixelSize: theGrid.buttonFontPixelSize
            width: parent.buttonSize
        }
        CircleButton
        {
            id: websiteButton
            text: qsTr("Webseite<br>öffnen")
            onClicked: Qt.openUrlExternally(LastVisit.websiteURL)
            visible: LastVisit.websiteURL != ""
            font.pixelSize: theGrid.buttonFontPixelSize * 1.3
            width: parent.buttonSize
        }
        CircleButton
        {
            text: qsTr("Speise-<br>karte")
            font.pixelSize: theGrid.buttonFontPixelSize * 1.3
            onClicked: Qt.openUrlExternally(LastVisit.foodMenueURL)
            visible: LastVisit.foodMenueURL != ""
            width: parent.buttonSize
        }
        CircleButton
        {
            text: qsTr("Getränke-<br>karte")
            font.pixelSize: theGrid.buttonFontPixelSize * 1.3
            onClicked: Qt.openUrlExternally(LastVisit.drinksMenueURL)
            visible: LastVisit.drinksMenueURL != ""
            width: parent.buttonSize
        }
        CircleButton
        {
            text: qsTr("Mittags-<br>karte")
            font.pixelSize: theGrid.buttonFontPixelSize * 1.3
            onClicked: Qt.openUrlExternally(LastVisit.lunchMenueURL)
            visible: LastVisit.lunchMenueURL != ""
            width: parent.buttonSize
        }
        CircleButton
        {
            text: LastVisit.individualURL1Caption
            font.pixelSize: theGrid.buttonFontPixelSize * 1.3
            onClicked: Qt.openUrlExternally(LastVisit.individualURL1)
            visible: LastVisit.individualURL1 != ""
            width: parent.buttonSize
        }
    }
    ShareButton
    {
    }
    BackButton
    {
        onClicked: questionVisitEnd()
    }
}
