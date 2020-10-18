import QtQuick 2.15
import "Comp"

ESAAPage
{
    signal back
    onBackPressed:
    {
        back()
    }
    caption: "Kontakttagebuch"
    property string qrCodeFileName: ""
    Image
    {
        cache: false
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -ESAA.spacing * 2
        width: parent.width - ESAA.spacing * 4
        height: width
        id: qrImage
        fillMode: Image.PreserveAspectFit
        sourceSize.height: height
        sourceSize.width: width
        source: qrCodeFileName ? "file://" + qrCodeFileName : ""
    }

    BackButton
    {
        id: quitButton
        onClicked: back()
    }
    HelpOverlay
    {
        visible: true
        helpText1: "Diesen Code kannst du von einer anderen IchBinDa!-App scannen lassen." +
                   "<br><br>Dann bekommt ihr beide eine Klartext E-Mail mit Vorname, Name und E-Mail-Adresse des jeweils anderen und könnt euch im Falle des Falles gegenseitig informieren."
        onDoneClick: visible = false
    }
}
