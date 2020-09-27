import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.13
import "QML"

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 300
    height: 480
    title: qsTr("Ich bin da!")
    property var previousPage: null
    property var theCurrentPage: null
    function showNewPage(currentPage, nextPage)
    {
        if (currentPage == nextPage)
        {
            return;
        }

        theCurrentPage = nextPage;
        previousPage = currentPage
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
                if (previousPage == firststart)
                {
                    showNewPage(questionpage, scannerpage)
                    return;
                }
                showNewPage(questionpage, sendedDataPage)
            }
            onAbort:
            {
                if (previousPage == menuepage)
                {
                    showNewPage(questionpage, previousPage)
                    return
                }
                if (previousPage == firststart)
                {
                    showNewPage(questionpage, previousPage)
                    return;
                }
                showNewPage(questionpage, scannerpage)
            }
        }
        ScannerPage
        {
            id: scannerpage
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
            onClose: showNewPage(createqrcodepage, menuepage)
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
        MyVisitsPage
        {
            id: myvisitspage
            onClose: showNewPage(myvisitspage, menuepage)
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
            onMyVisitsClicked: showNewPage(menuepage, myvisitspage)
        }
        AgreePage
        {
            id: agreepage
            onAgreed:
            {
                showNewPage(agreepage, firststart)
            }
        }
        CurrentVisitPage
        {
            id: currentVisitPage
    //        y: 0
    //        x: ESAA.isActiveVisit(changeCounter) ? 0 : -width
    //        Behavior on x {
    //            NumberAnimation {
    //                duration: 300
    //            }
    //        }
    //        width: parent.width
    //        height: parent.height
    //        z: 0
    //        visible: true
    //        opacity: 1
    //        property int changeCounter: 0
    //        Timer
    //        {
    //            interval: 10000
    //            repeat: true
    //            running: true
    //            onTriggered: currentVisitPage.changeCounter += 1
    //        }
            onQuestionVisitEnd:
            {
                showNewPage(currentVisitPage, visitEndPage)
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
        visible: !ESAA.firstStart
        alertAniRunning: ESAA.fstname == "" || ESAA.surname == ""
        repeatAlertAni: ESAA.fstname == "" || ESAA.surname == ""
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
        onClose: showNewPage(sendedDataPage, currentVisitPage)
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
            showNewPage(visitEndPage, currentVisitPage)
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
                if (ESAA.isActiveVisit(0))
                {
                    showNewPage(null, currentVisitPage)
                }
                else
                {
                    showNewPage(null, scannerpage)
                }
            }
        }
        onHelpClicked: showNewPage(theCurrentPage, firststart)
    }
    Message
    {
        id: message
        z: 2
    }
    BadMessage
    {
        id: badMessage
        z: 2
    }
    WaitMessage
    {
        id: waitMessage
        z: 2
    }


    Connections
    {
        target: ESAA
        onShowSendedData: showNewPage(scannerpage, sendedDataPage)
        onShowWaitMessageSignal: waitMessage.show(mt)
        onHideWaitMessageSignal: waitMessage.hide()
        onShowMessageSignal: message.show(mt)
        onShowBadMessageSignal: badMessage.show(mt)
        onScanSignal: scannerpage.show()
        onValidQRCodeDetected:
        {
            if (theCurrentPage == questionpage)
            {
                return;
            }

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
        console.log("vorname: " + ESAA.vorname)
    }
    onClosing: {
        close.accepted = false
    }
    Connections {
      target: Qt.application
      onStateChanged:
      {
          if (Qt.application.state == Qt.ApplicationActive)
          {
              ESAA.dummyGet()
          }
      }
    }
}
