import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../BasePages"
import "../Comp"

PageWithBackButton
{
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
        function onRequestLoginCodeSuccessful()
        {
            loginAndOrRegister.state = "enterCode"
            password.forceActiveFocus()
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

    property color smallButtonDownColor: JW78APP.buttonFromColor
    property color bigButtonDownColor: JW78APP.buttonDownColor
    property color offFromColor: JW78APP.disabledButtonFromColor
    property color offToColor: JW78APP.disabledButtonToColor
    property int smallWidth: JW78Utils.screenWidth / 4.5
    property int bigWidth: JW78Utils.screenWidth / 4
    property int smallFontPixelSize: JW78APP.fontButtonPixelsize * 0.6
    property int bigFontPixelSize: JW78APP.fontButtonPixelsize * 0.8
    property double topButtonY: inputColumn.y + inputColumn.height + ESAA.spacing * 2
    property double topButtonX: (parent.width - bigWidth) / 2
    property double bottomButtonY: backButton.y - smallWidth - ESAA.spacing
    property double buttonLeftX: ((parent.width / 3) - smallWidth) / 2
    property double buttonCenterX: parent.width / 3 + buttonLeftX
    property double buttonRightX: parent.width / 3 * 2 + buttonLeftX
    Item {
        id: textArea
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: inputColumn.top
        ESAAText
        {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - 2 * JW78APP.spacing
            x: parent.width
            id: codeText
            text: "Einen Code bekommst du nach der Registrierung oder wenn du dein Passwort vergessen hast. Wenn du den Code mit deinem Login eingibst wirst du direkt eingeloggt."
            wrapMode: Text.WordWrap
            visible: opacity > 0
            opacity: 0
            Behavior on opacity {
                NumberAnimation {
                    duration: JW78Utils.shortAniDuration
                }
            }
            Behavior on x {
                NumberAnimation {
                    duration: JW78Utils.shortAniDuration
                }
            }
        }
        ESAAText
        {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - 2 * JW78APP.spacing
            x: parent.width
            id: forgotPasswordText
            text: "Gib hier deine E-Mail-Adresse ein mit der du registriert bist und klicke dann auf \"Passwort vergessen\" dann schicken wir dir einen Code zu, mit dem du dich direkt einloggen kannst."
            wrapMode: Text.WordWrap
            visible: opacity > 0
            opacity: 0
            Behavior on opacity {
                NumberAnimation {
                    duration: JW78Utils.shortAniDuration
                }
            }
            Behavior on x {
                NumberAnimation {
                    duration: JW78Utils.shortAniDuration
                }
            }
        }
        ESAAText
        {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - 2 * JW78APP.spacing
            x: parent.width
            id: registerText
            text: "Für die Registrierung brauchen wir von dir eine E-Mail-Adresse als Login und ein Passwort."
            wrapMode: Text.WordWrap
            visible: opacity > 0
            opacity: 0
            Behavior on opacity {
                NumberAnimation {
                    duration: JW78Utils.shortAniDuration
                }
            }
            Behavior on x {
                NumberAnimation {
                    duration: JW78Utils.shortAniDuration
                }
            }
        }

    }

    Column
    {
        id: inputColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -parent.height / 10
        anchors.margins: ESAA.spacing
        spacing: ESAA.spacing
        ESAALineInputWithCaption
        {
            caption: "Login (E-Mail)"
            id: loginEMail
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: JW78APP.fontMessageTextPixelsize
        }
        ESAALineInputWithCaption
        {
            echoMode: TextInput.Password
            visible: opacity > 0
            anchors.left: parent.left
            anchors.right: parent.right
            caption: "Passwort"
            id: password
            font.pixelSize: JW78APP.fontMessageTextPixelsize
            Behavior on opacity {
                NumberAnimation {
                    duration: JW78Utils.shortAniDuration
                }
            }
            Behavior on height {
                NumberAnimation {
                    duration: JW78Utils.shortAniDuration
                }
            }
        }
    }
    CircleButtonWithBehavior
    {
        id: loginButton
        text: "Login"
        x: topButtonX
        y: topButtonY
        width: bigWidth
        font.pixelSize: bigFontPixelSize
        buttonDownColor: bigButtonDownColor
        onClicked:
        {
            if (loginAndOrRegister.state != "")
            {
                loginAndOrRegister.state = ""
                return
            }
            if (loginEMail.displayText == "")
            {
                focusMessage("Bitte gib die E-Mail-Adresse ein mit der du dich einloggen möchtest ein.", loginEMail)
                return
            }
            if (!JW78APP.isEmailValid(loginEMail.displayText))
            {
                focusMessage("Bitte gib eine gültige E-Mail-Adresse an.", loginEMail)
                return
            }

            if (password.displayText == "")
            {
                focusMessage("Bitte gib dein Passwort ein.", password)
                return
            }
            JW78APP.login(loginEMail.displayText,
                          password.text,
                          "")
        }
    }
    CircleButtonWithBehavior
    {
        id: registerButton
        text: "Registrieren"
        x: buttonLeftX
        y: bottomButtonY
        buttonFromColor: offFromColor
        buttonToColor: offToColor
        width: smallWidth
        font.pixelSize: smallFontPixelSize
        buttonDownColor: smallButtonDownColor
        onClicked:
        {
            if (loginAndOrRegister.state != "register")
            {
                loginAndOrRegister.state = "register"
                return
            }
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
                                    password.text)
        }
    }
    CircleButtonWithBehavior
    {
        id: forgotPasswordButton
        text: "Passwort\nvergessen"
        x: buttonCenterX
        y: bottomButtonY
        buttonFromColor: offFromColor
        buttonToColor: offToColor
        width: smallWidth
        font.pixelSize: smallFontPixelSize
        buttonDownColor: smallButtonDownColor
        onClicked:
        {
            if (loginAndOrRegister.state != "forgotPassword")
            {
                loginAndOrRegister.state = "forgotPassword"
                return
            }
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
            JW78APP.requestLoginCode(loginEMail.displayText)
        }
    }
    CircleButtonWithBehavior
    {
        id: enterCodeButton
        text: "Code\neingeben"
        x: buttonRightX
        y: bottomButtonY
        buttonFromColor: offFromColor
        buttonToColor: offToColor
        width: smallWidth
        font.pixelSize: smallFontPixelSize
        buttonDownColor: smallButtonDownColor
        onClicked:
        {
            if (loginAndOrRegister.state != "enterCode")
            {
                loginAndOrRegister.state = "enterCode"
                return
            }
            if (loginEMail.displayText == "")
            {
                focusMessage("Bitte gib die E-Mail-Adresse ein mit der du dich einloggen möchtest ein.", loginEMail)
                return
            }
            if (!JW78APP.isEmailValid(loginEMail.displayText))
            {
                focusMessage("Bitte gib eine gültige E-Mail-Adresse an.", loginEMail)
                return
            }

            if (password.displayText == "")
            {
                focusMessage("Bitte gib deinen Code ein.", password)
                return
            }
            JW78APP.login(loginEMail.displayText,
                          "",
                          password.text)
        }
    }
    states: [
        State {
            name: "register"
            PropertyChanges {
                target: registerButton
                x: topButtonX
                y: topButtonY
                buttonFromColor: JW78APP.buttonFromColor
                buttonToColor: JW78APP.buttonToColor
                width: bigWidth
                font.pixelSize: bigFontPixelSize
                buttonDownColor: bigButtonDownColor
            }
            PropertyChanges {
                target: loginButton
                x: buttonLeftX
                y: bottomButtonY
                buttonFromColor: offFromColor
                buttonToColor: offToColor
                width: smallWidth
                font.pixelSize: smallFontPixelSize
                buttonDownColor: smallButtonDownColor
            }
            PropertyChanges {
                target: forgotPasswordButton
                x: buttonCenterX
                y: bottomButtonY
                buttonFromColor: offFromColor
                buttonToColor: offToColor
                width: smallWidth
                font.pixelSize: smallFontPixelSize
                buttonDownColor: smallButtonDownColor
            }
            PropertyChanges {
                target: enterCodeButton
                x: buttonRightX
                y: bottomButtonY
                buttonFromColor: offFromColor
                buttonToColor: offToColor
                width: smallWidth
                font.pixelSize: smallFontPixelSize
                buttonDownColor: smallButtonDownColor
            }
            PropertyChanges {
                target:  registerText
                x: JW78APP.spacing
                opacity: 1
            }
        },
        State {
            name: "forgotPassword"
            PropertyChanges {
                target: loginButton
                x: buttonLeftX
                y: bottomButtonY
                buttonFromColor: offFromColor
                buttonToColor: offToColor
                width: smallWidth
                font.pixelSize: smallFontPixelSize
                buttonDownColor: smallButtonDownColor
            }
            PropertyChanges {
                target: registerButton
                x: buttonCenterX
                y: bottomButtonY
                buttonFromColor: offFromColor
                buttonToColor: offToColor
                width: smallWidth
                font.pixelSize: smallFontPixelSize
                buttonDownColor: smallButtonDownColor
            }
            PropertyChanges {
                target: forgotPasswordButton
                x: topButtonX
                y: topButtonY
                buttonFromColor: JW78APP.buttonFromColor
                buttonToColor: JW78APP.buttonToColor
                width: bigWidth
                font.pixelSize: bigFontPixelSize
                buttonDownColor: bigButtonDownColor
            }
            PropertyChanges {
                target: enterCodeButton
                x: buttonRightX
                y: bottomButtonY
                buttonFromColor: offFromColor
                buttonToColor: offToColor
                width: smallWidth
                font.pixelSize: smallFontPixelSize
                buttonDownColor: smallButtonDownColor
            }
            PropertyChanges {
                target: password
                height: 0
                opacity: 0
            }
            PropertyChanges {
                target: forgotPasswordText
                opacity: 1
                x: JW78APP.spacing
            }
        },
        State {
            name: "enterCode"
            PropertyChanges {
                target: loginButton
                x: buttonLeftX
                y: bottomButtonY
                buttonFromColor: offFromColor
                buttonToColor: offToColor
                width: smallWidth
                font.pixelSize: smallFontPixelSize
                buttonDownColor: smallButtonDownColor
            }
            PropertyChanges {
                target: registerButton
                x: buttonCenterX
                y: bottomButtonY
                buttonFromColor: offFromColor
                buttonToColor: offToColor
                width: smallWidth
                font.pixelSize: smallFontPixelSize
                buttonDownColor: smallButtonDownColor
            }
            PropertyChanges {
                target: forgotPasswordButton
                x: buttonRightX
                y: bottomButtonY
                buttonFromColor: offFromColor
                buttonToColor: offToColor
                width: smallWidth
                font.pixelSize: smallFontPixelSize
                buttonDownColor: smallButtonDownColor
            }
            PropertyChanges {
                target: enterCodeButton
                x: topButtonX
                y: topButtonY
                buttonFromColor: JW78APP.buttonFromColor
                buttonToColor: JW78APP.buttonToColor
                width: bigWidth
                font.pixelSize: bigFontPixelSize
                buttonDownColor: bigButtonDownColor
            }
            PropertyChanges {
                target: password
                text: ""
                caption: "Code"
                echoMode: TextInput.Normal
            }
            PropertyChanges
            {
                target: codeText
                opacity: 1
                x: JW78APP.spacing
            }
        }

    ]
    Component.onCompleted:
    {
        topButtonY = inputColumn.y + inputColumn.height + JW78APP.spacing
    }
}
