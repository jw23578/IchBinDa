import QtQuick 2.15
import QZXing 2.3
import QtMultimedia 5.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "Comp"
import "qrc:/foundation"

ESAAPage
{
    caption: "QR-Code scannen"
    captionImageSource: "qrc:/images/headerImage2.svg"
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
        var space = IDPGlobals.spacing * 2
        camera.moveIn(space, 0, parent.width - 2 * space, 0, parent.width / 15,
                      space, ESAA.camTop, parent.width - 2 * space, parent.width - 2* space, parent.width / 15)
        camera.start()
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

    function myHideFunction()
    {
        if (camera == null)
        {
            return;
        }

        camera.stop()
        var space = IDPGlobals.spacing * 2
        camera.moveOut(space, 0, parent.width - 2 * space, 0, parent.width / 15)
    }

    onHiding:
    {
        multiButton.opacity = 0
        myHideFunction()
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
        y: JW78Utils.screenHeight / 480 * 360 - height / 2
        visible: ESAA.isDevelop
        onClicked: goRightClicked()
    }

    HelpOverlay
    {
        helpText1: "Hier kannst du den <b>IchBinDa!</b>-QR-Code des Clubs, Restaurants, Sportvereins, Frisör usw. scannen um deine Kontaktdaten komfortabel und verschlüsselt zu übermitteln." +
                   "<br><br>Über den Button ganz unten kannst du das Menü aufrufen um die App zu erkunden."
        visible: ESAA.firstStart
        onDoneClick: {
            ESAA.firstStartDone()
            myShowFunction()
        }
    }
}
