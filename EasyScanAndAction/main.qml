import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtMultimedia 5.15
import "QML"
import "QML/Comp"
import "QML/FinalPages"
import "QML/BasePages"

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
        if (nextPage === scannerpage || nextPage == timemainpage)
        {
            hideAndShowCallMenueButton.start()
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
                if (previousPage == menuepage)
                {
                    showNewPage(questionpage, previousPage)
                    return
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
        TimeMain
        {
            id: timemainpage
            onBackPressed: showNewPage(timemainpage, scannerpage)
        }
        SaveCustomerCard
        {
            id: savecustomercard
            onBackPressed: showNewPage(theCurrentPage, takepicturepage)
            onCardSaved: showNewPage(theCurrentPage, customercardslist)
        }


        ShowCustomerCard
        {
            id: showcustomercard
            onBackPressed: showNewPage(theCurrentPage, customercardslist)
        }

        CustomerCardsList
        {
            id: customercardslist
            onBackPressed: showNewPage(theCurrentPage, scannerpage)
            onNewCard: showNewPage(theCurrentPage, takepicturepage)
            onShowCustomerCard:
            {
                showcustomercard.imageFilename = "file:" + filename
                showNewPage(theCurrentPage, showcustomercard)
            }
        }
        CamVideoScan
        {
            z: 10
            id: theCamera
            onTagFound: scannerpage.tagFound(tag)
            onImageSaved: takepicturepage.saveTheImage(filename)
        }
        ManualVisitPage
        {
            id: manualvisitpage
            onBackPressed: showNewPage(theCurrentPage, scannerpage)
        }

        CircleMultiButton
        {
            z: 11
            opacity: 0
            id: theMultiButton
            x: scannerpage.x + ESAA.screenWidth / 300 * 150 - width / 2
            y: ESAA.screenHeight / 480 * 360 - height / 2
            visible: !ESAA.firstStart && scannerpage.visible
            button1.text: "Kunden<br>karten"
            button1.onClicked: showNewPage(scannerpage, customercardslist)
            button2.onClicked: ESAA.recommend()
            button2.source: "qrc:/images/share_weiss.svg"
            button2.downSource: "qrc:/images/share_blau.svg"
            button3.text: "Kontakt<br>situation<br>eintragen"
            button3.onClicked: showNewPage(theCurrentPage, manualvisitpage)
            onOpenClicked: hideCallMenueButton.start()
            onCloseClicked: hideAndShowCallMenueButton.start()
        }

        ScannerPage
        {
            id: scannerpage
            camera: theCamera
            multiButton: theMultiButton
            onGoRightClicked: showNewPage(scannerpage, timemainpage)
        }
        TakePicturePage
        {
            id: takepicturepage
            targetFileName: ESAA.tempTakenPicture
            camera: theCamera
            caption: "Neue Kundenkarte"
            onBackPressed: showNewPage(theCurrentPage, customercardslist)
            function saveTheImage(filename)
            {
                console.log("image saved: " + filename)
                savecustomercard.imageFilename = ""
                savecustomercard.imageFilename = "file:" + filename
                showNewPage(theCurrentPage, savecustomercard)
            }
        }
        FirstStart
        {
            id: firststart
            onStartNow:
            {
                showNewPage(firststart, scannerpage)
            }
            onBack: showNewPage(firststart, menuepage)
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
            logoUrl: createqrcodepage.theLogoUrl
            qrCodeFileName: createqrcodepage.qrCodeFileName
            onBack: showNewPage(showqrcodepage, createqrcodepage)
        }
        MyVisitsPage
        {
            id: myvisitspage
            onClose: showNewPage(myvisitspage, menuepage)
        }
        ShowKontaktTagebuchQRCode
        {
            id: showKontaktTagebuchQRCode
            onBack: showNewPage(showKontaktTagebuchQRCode, menuepage)
        }
        TimeRecordingEvents
        {
            id: timerecordingevents
            onBackPressed: showNewPage(timerecordingevents, timerecordmenuepage)
        }
        WorkTimeSpans
        {
            id: worktimespans
            onBackPressed: showNewPage(worktimespans, timerecordmenuepage)
        }

        TimeRecordingMenue
        {
            id: timerecordmenuepage
            onBackPressed: showNewPage(timerecordmenuepage, timemainpage)
            onShowTimeEvents: showNewPage(timerecordmenuepage, timerecordingevents)
            onShowWorkTimeBrutto: showNewPage(timerecordmenuepage, worktimespans)
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
            onShowKontaktTagebuchQRCode:
            {
                showKontaktTagebuchQRCode.qrCodeFileName = qrKontaktTagebuchQRCodeFilename
                showNewPage(menuepage, showKontaktTagebuchQRCode)
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

    SequentialAnimation
    {
        id: hideAndShowCallMenueButton
        NumberAnimation {
            target: callMenueButton
            property: "anchors.verticalCenterOffset"
            duration: 500
            easing.type: Easing.InOutQuint
            to: width
        }
        NumberAnimation {
            target: callMenueButton
            property: "anchors.verticalCenterOffset"
            duration: 500
            easing.type: Easing.InOutQuint
            to: 0 // callMenueButton.width / 6
        }
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
            if (theCurrentPage == timemainpage)
            {
                showNewPage(timemainpage, timerecordmenuepage)
                return
            }

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
    YesNoQuestionPage
    {
        id: yesnoquestion
        z: 2
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
        onYesNoQuestion: yesnoquestion.show(mt, yescallback, nocallback)
        onShowSendedData: showNewPage(scannerpage, sendedDataPage)
        onShowWaitMessageSignal: waitMessage.show(mt)
        onHideWaitMessageSignal: waitMessage.hide()
        onShowMessageSignal: message.show(mt, callback)
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
        theCamera.stop()
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
