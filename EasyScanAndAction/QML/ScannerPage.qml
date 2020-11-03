import QtQuick 2.15
import QZXing 2.3
import QtMultimedia 5.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "Comp"

ESAAPage
{
    caption: "QR-Code einlesen"
    property var camera: null
    property var manualVisitButton: null

    id: scannerpage

    function tagFound(tag)
    {
        console.log(tag)
        if (tag.length)
        {
            ESAA.action(tag)
        }
    }
    function myShowFunction()
    {
        manualVisitButton.visible = true
        camera.scan = true
        camera.anchors.top = parent.top
        camera.width = parent.width
        camera.height = camera.width
        shareButton.rotate(400)
        if (!ESAA.isActiveVisit(1))
        {
            camera.stop()
            camera.start()
            camera.searchAndLock()
        }
    }

    onShowing:
    {
        ESAA.setIchBinDaScheme()
        console.log("show scanner")
        if (ESAA.firstStart)
        {
            return
        }
        myShowFunction()
    }



    onHiding:
    {
        manualVisitButton.visible = false
        camera.stop()
    }

    signal playBackClicked
    signal basketClicked
    signal goRightClicked
    signal goCustomerCards

    function decode(preview) {
        photoPreview.source = preview
        decoder.decodeImageQML(photoPreview);
    }

    ShareButton
    {
        id: shareButton
        visible: !ESAA.firstStart
    }
    CircleButton
    {
        visible: ESAA.isDevelop
        onClicked: goCustomerCards()
        text: "Kunden<br>karten"
        anchors.verticalCenter: shareButton.verticalCenter
        x: (shareButton.x - width) / 2
    }

    ArrowButton
    {
        anchors.right: parent.right
        anchors.rightMargin: ESAA.spacing
        anchors.verticalCenter: shareButton.verticalCenter
        visible: ESAA.isDevelop
        onClicked: goRightClicked()
    }

    HelpOverlay
    {
        helpText1: "Hier kannst du den QR-Code des Clubs, Restaurants, Sportvereins, Frisör usw. scannen um deine Kontaktdaten komfortabel und verschlüsselt zu übermitteln." +
                   "<br><br>Über den Button ganz unten kannst du das Menü aufrufen um die App zu erkunden."
        visible: ESAA.firstStart
        onDoneClick: {
            ESAA.firstStartDone()
            myShowFunction()
        }
    }
}
