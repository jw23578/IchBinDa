import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../BasePages"
import "../Comp"

PageWithBackButton {
    id: loginAndOrRegister
    caption: "Login"
    onShowing:
    {
    }
    onHiding:
    {
    }
    signal loginSuccessful

    Connections
    {
        target: ESAA
        function onLoginSuccessful()
        {
            loginAndOrRegister.loginSuccessful()
        }
    }

    property var elemToFocus: null

    function setFocusNow()
    {
        elemToFocus.forceActiveFocus()
    }
    function focusMessage(theMessage, elem)
    {
        elemToFocus = elem
        ESAA.showMessageWithCallback(theMessage, setFocusNow)
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
        helpText: "Den Logincode können wir Dir an Deine E-Mail-Adresse zuschicken wenn Du Dein Passwort nicht mehr weißt.<br><br>Bei Deiner <b>Registrierung</b> bekommst Du ebenfalls einen Code den Du hier eingeben kannst."
        onHelpClicked: ESAA.showMessage(ht)
    }
    TwoCircleButtons
    {
        id: buttons
        anchors.bottom: parent.bottom
        anchors.bottomMargin: JW78APP.spacing * 3
        leftText: "Login"
        onLeftClicked:
        {
            if (loginEMail.displayText == "")
            {
                focusMessage("Bitte gib eine E-Mail mit der du dich registrieren und einloggen möchtest ein.", loginEMail)
                return
            }
            if (!JW78APP.isEmailValid(loginEMail.displayText))
            {
                focusMessage("Bitte gib eine gültige E-Mail-Adresse an.", loginEMail)
                return
            }

            if (password.displayText == "" && loginCode.displayText == "")
            {
                focusMessage("Bitte gib ein Passwort ider Logincode ein.", password)
                return
            }
            JW78APP.login(loginEMail.displayText,
                                     password.displayText,
                                     loginCode.displayText)
        }
        rightText: "Registrieren"
        onRightClicked: {
            if (loginEMail.displayText == "")
            {
                focusMessage("Bitte gib eine E-Mail als Login ein.", loginEMail)
                return
            }
            if (!JW78APP.isEmailValid(loginEMail.displayText))
            {
                focusMessage("Bitte gib eine gültige E-Mail-Adresse an.", loginEMail)
                return
            }

            if (password.displayText == "")
            {
                focusMessage("Bitte gib ein Passwort ein.", password)
                return
            }
            JW78APP.registerAccount(loginEMail.displayText,
                                    password.displayText)
        }
    }
}
