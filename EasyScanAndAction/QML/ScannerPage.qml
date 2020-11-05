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
    property var multiButton: null

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
        multiButton.opacity = 1
        camera.scan = true
        camera.anchors.top = parent.top
        camera.width = parent.width
        if (!ESAA.isActiveVisit(1))
        {
            camera.stop()
            camera.start()
            camera.searchAndLock()
        }
        camera.height = camera.width
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
        multiButton.opacity = 0
        camera.stop()
    }

    signal playBackClicked
    signal basketClicked
    signal goRightClicked

    function decode(preview) {
        photoPreview.source = preview
        decoder.decodeImageQML(photoPreview);
    }

    ArrowButton
    {
        anchors.right: parent.right
        anchors.rightMargin: ESAA.spacing
        y: ESAA.screenHeight / 480 * 360 - height / 2
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
