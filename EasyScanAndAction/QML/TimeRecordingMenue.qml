import QtQuick 2.15
import QtQuick.Controls 2.15

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
            property int buttonSize: ESAA.screenWidth / 3
            property int buttonFontPixelSize: ESAA.fontButtonPixelsize
            property int anzahl: 6
            columns: anzahl / 2 + anzahl % 2
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: (buttonSize + spacing) * columns - spacing
            spacing: ESAA.spacing * 2
            rowSpacing: ESAA.spacing * 2
            topPadding: ESAA.spacing * 3
            CircleButton
            {
                text: "Ereignisse<br>anzeigen"
                onClicked: showTimeEvents()
                width: parent.buttonSize
                font.pixelSize: theGrid.buttonFontPixelSize
            }
            CircleButton
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
