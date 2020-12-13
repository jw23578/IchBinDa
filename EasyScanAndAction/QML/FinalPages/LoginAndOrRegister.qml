import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../BasePages"
import "../Comp"

PageWithBackButton {
    caption: "Login"
    onShowing:
    {
    }
    onHiding:
    {
    }

    ESAALineInputWithCaption
    {
        caption: "Login (E-Mail)"
        id: loginEMail
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: password.top
        anchors.margins: ESAA.spacing
        font.pixelSize: JW78APP.fontMessageTextPixelsize
    }
    ESAALineInputWithCaption
    {
        caption: "Passwort"
        id: password
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: loginCode.top
        anchors.margins: ESAA.spacing
        font.pixelSize: JW78APP.fontMessageTextPixelsize
    }
    ESAALineInputWithCaption
    {
        caption: "Logincode (statt Passwort)"
        id: loginCode
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: buttons.top
        anchors.margins: ESAA.spacing
        font.pixelSize: JW78APP.fontMessageTextPixelsize
        helpText: "Den Logincode können wir dir an deine E-Mail-Adresse zuschicken wenn du dein Passwort nicht mehr weißt."
        onHelpClicked: ESAA.showMessage(ht)
    }
    TwoCircleButtons
    {
        id: buttons
        anchors.bottom: parent.bottom
        anchors.bottomMargin: JW78APP.spacing * 3
        leftText: "Login"
        rightText: "Registrieren"
    }
}
