import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.15
import "QML"

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 300
    height: 480
    title: qsTr("Ich bin da!")
    property var activePage: null
    function showNewPage(currentPage, nextPage)
    {
        if (currentPage != null)
        {
            currentPage.z = 0
            currentPage.hide(direction)
        }
        var direction = true
        nextPage.z = 1
        nextPage.show(direction)
        splashheader.headerText = nextPage.caption
        if (nextPage === scannerpage)
        {
            showCallMenueButton.start()
        }
        else
        {
            hideCallMenueButton.start()
        }
        nextPage.forceActiveFocus()
    }
    Item
    {
        focus: true
        Keys.onReleased:
        {
            console.log("Key pressed: "+event.key)
            if (event.key == Qt.Key_Back)
            {
                console.log("Back button pressed.  Stack depth ")
                event.accepted = true
            }
            else
            {
                event.accepted = false
            }
        }
    }
    Item
    {
        id: header
        width: parent.width
        height: parent.height / 20
    }

    ContentBackground
    {
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    Item
    {
        anchors.top: header.bottom
        id: contentItem
        width: parent.width
        height: parent.height - y
        clip: true
        QuestionPage
        {
            id: questionpage
            onClose:
            {
                showNewPage(questionpage, sendedDataPage)

            }
            onAbort:
            {
                showNewPage(questionpage, scannerpage)
            }
        }
        ScannerPage
        {
            id: scannerpage
            onQuestionVisitEnd:
            {
                console.log("123")
                showNewPage(scannerpage, visitEndPage)
            }
        }
        FirstStart
        {
            id: firststart
            onStartNow:
            {
                showNewPage(firststart, scannerpage)
            }
            onEditContactData:
            {
                ESAA.facilityName = "MeineDaten"
                showNewPage(firststart, questionpage)
            }
        }
        CreateQRCodePage
        {
            id: createqrcodepage
            onClose: showNewPage(createqrcodepage, scannerpage)
            onShowCode:
            {
                showqrcodepage.facilityName = createqrcodepage.theFacilityName
                showqrcodepage.sendEMailTo = createqrcodepage.theContactReceiveEMail
                showNewPage(createqrcodepage, showqrcodepage)
            }
        }
        ShowQRCode
        {
            id: showqrcodepage
            qrCodeFileName: createqrcodepage.qrCodeFileName
            onBack: showNewPage(showqrcodepage, createqrcodepage)
        }

        MenuePage
        {
            id: menuepage
            onClose:
            {
                showNewPage(menuepage, scannerpage)
            }
            onEditContactData:
            {
                ESAA.facilityName = "MeineDaten"
                showNewPage(menuepage, questionpage)
            }
            onEditQRCode:
            {
                showNewPage(menuepage, createqrcodepage)
            }
            onHelp:
            {
                showNewPage(menuepage, firststart)
            }
        }
        AgreePage
        {
            id: agreepage
            onAgreed:
            {
                showNewPage(agreepage, firststart)
            }
        }
    }

    NumberAnimation {
        target: callMenueButton
        property: "anchors.verticalCenterOffset"
        duration: 1000
        easing.type: Easing.InOutQuint
        id: showCallMenueButton
        to: 0 // callMenueButton.width / 6
    }
    NumberAnimation {
        target: callMenueButton
        property: "anchors.verticalCenterOffset"
        duration: 1000
        easing.type: Easing.InOutQuint
        id: hideCallMenueButton
        to: width
    }
    CircleButton
    {
        id: callMenueButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.bottom
        verticalImageOffset: -height / 4
        imageSizeFactor: 0.7
        source: "qrc:/images/menue_weiss.svg"
        downSource: "qrc:/images/menue_blau.svg"
        onClicked:
        {
            showNewPage(scannerpage, menuepage)
        }
    }

    ESAASendedDataPage
    {
        id: sendedDataPage
        onClose: showNewPage(sendedDataPage, scannerpage)
    }
    VisitEndQuestion
    {
        id: visitEndPage
        onEndVisit:
        {
            ESAA.finishVisit()
            showNewPage(visitEndPage, scannerpage)
        }
        onClose:
        {
            showNewPage(visitEndPage, scannerpage)
        }
    }
    SplashHeader
    {
        id: splashheader
        onSplashDone:
        {
            if (!ESAA.aggrementChecked)
            {
                showNewPage(null, agreepage)
            }
            else
            {
                showNewPage(null, scannerpage)
            }
        }
    }
    Message
    {
        id: message
    }
    BadMessage
    {
        id: badMessage
    }


    Connections
    {
        target: ESAA
        onShowSendedData: showNewPage(scannerpage, sendedDataPage)
        onShowMessageSignal: message.show(mt)
        onShowBadMessageSignal: badMessage.show(mt)
        onScanSignal: scannerpage.show()
        onValidQRCodeDetected:
        {
            showNewPage(scannerpage, questionpage)
        }
    }
    Component.onCompleted:
    {
        ESAA.screenHeight = height
        ESAA.screenWidth = width
        ESAA.calculateRatios()
        console.log("Spacing: " + ESAA.spacing)
        console.log("FontButtonPixelSize: " + ESAA.fontButtonPixelsize)
    }
    onClosing: {
        close.accepted = false
    }
}
