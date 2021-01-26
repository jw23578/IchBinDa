import QtQuick 2.15
import QtQuick.Controls 2.15
import "Comp"
import "qrc:/foundation"

ESAAPage
{
    signal showTimeEvents
    signal showWorkTimeBrutto
    caption: "Zeiterfassung"
    Flickable
    {
        anchors.top: parent.top
        anchors.bottom: backButton.top
        anchors.bottomMargin: ESAA.spacing * 2
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.min(parent.width - 2 * ESAA.spacing, contentWidth)
        contentHeight: height
        contentWidth: theGrid.width
        Grid
        {
            id: theGrid
            property int buttonSize: JW78Utils.screenWidth / 3
            property int buttonFontPixelSize: ESAA.fontButtonPixelsize
            property int anzahl: 6
            columns: anzahl / 2 + anzahl % 2
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: (buttonSize + spacing) * columns - spacing
            spacing: ESAA.spacing * 2
            rowSpacing: ESAA.spacing * 2
            topPadding: ESAA.spacing * 3
            IDPButtonCircle
            {
                text: "Ereignisse<br>anzeigen"
                onClicked: showTimeEvents()
                width: parent.buttonSize
                font.pixelSize: theGrid.buttonFontPixelSize
            }
            IDPButtonCircle
            {
                text: "Arbeits<br>zeiten<br>(brutto)"
                onClicked: showWorkTimeBrutto()
                width: parent.buttonSize
                font.pixelSize: theGrid.buttonFontPixelSize
            }
        }
    }

    BackButton
    {
        id: backButton
        onClicked: backPressed()
    }
}
