import QtQuick 2.15
import QtQuick.Controls 2.15
import "Comp"

ESAAPage
{
    signal editContactData
    signal close
    signal editQRCode
    signal help
    signal myVisitsClicked
    signal showKontaktTagebuchQRCode;
    caption: "Menü"

    onShowing:
    {
        circleMenue.countVisibles()
        circleMenue.show()
        shareButton.blink(400)
        shareButton.rotate(400)
    }

    CircleButtonsMenue
    {
        id: circleMenue

        anchors.top: parent.top
        anchors.bottom: shareButton.top
        anchors.bottomMargin: ESAA.spacing * 2
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.min(parent.width - 2 * ESAA.spacing, contentWidth)

        buttonTexts: [
            qsTr("QR-Code<br>nanlegen"),
            qsTr("Kontaktdaten<br>bearbeiten"),
            qsTr("<b>IchBinDa!</b><br>im Internet"),
            qsTr("Meine<br>Besuche<br>") + AllVisits.count,
            qsTr("Hilfe"),
            qsTr("Spenden"),
            qsTr("Im Falle<br>des Falles"),
            qsTr("Kontakt<br>tagebuch<br>QR-Code")]
        buttonSmallTopTexts: [
            qsTr("Als Betreiber"),
            qsTr("Als Besucher"),
            "",
            "",
            "",
            "",
            "",
            ""]
        alertAniRunnings: [
            false,
            ESAA.fstname == "" || ESAA.surname == "",
            false,
            false,
            false,
            false,
            false,
            false]
        repeatAlertAnis: [
            false,
            ESAA.fstname == "" || ESAA.surname == "",
            false,
            false,
            false,
            false,
            false,
            false]
        visibles: [
            true,
            true,
            true,
            AllVisits.count > 0,
            true,
            true,
            true,
            true]

        onClicked: {
            console.log(buttonText)
            if (buttonText == buttonTexts[0])
            {
                editQRCode()
                return
            }
            if (buttonText == buttonTexts[1])
            {
                editContactData()
                return
            }
            if (buttonText == buttonTexts[2])
            {
                Qt.openUrlExternally("https://www.app-ichbinda.de")
                return
            }
            if (buttonText == buttonTexts[3])
            {
                myVisitsClicked()
                return
            }
            if (buttonText == buttonTexts[4])
            {
                help()
                return
            }
            if (buttonText == buttonTexts[5])
            {
                Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=M29Q4NYS8DXYJ&source=url")
                return
            }
            if (buttonText == buttonTexts[6])
            {
                Qt.openUrlExternally("https://www.app-ichbinda.de/index.html#for-operator-in-case")
                return
            }
            if (buttonText == buttonTexts[7])
            {
                showKontaktTagebuchQRCode()
                return
            }
        }
    }

    ShareButton
    {
        id: shareButton
    }
    BackButton
    {
        onClicked: close()
    }
    onBackPressed:
    {
        console.log("menuepage back")
        close()
    }
}
