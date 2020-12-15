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
    width: 300
    height: 480
    id: mainWindow
    visible: true
    title: qsTr("Ich bin da!")
    property var previousPage: null
    property var theCurrentPage: null
    function funcShowKontaktTagebuchQRCode()
    {
        if (ESAA.fstname == "")
        {
            ESAA.showMessage("Bitte gib vorher noch deinen Vornamen in deinen Kontaktdaten ein.")
            return;
        }
        if (ESAA.surname == "")
        {
            ESAA.showMessage("Bitte gib vorher noch deinen Nachnamen in deinen Kontaktdaten ein.")
            return;
        }
        if (ESAA.emailAdress == "")
        {
            ESAA.showMessage("Bitte gib vorher noch deine E-Mail-Adresse in deinen Kontaktdaten ein.")
            return;
        }
        showKontaktTagebuchQRCode.qrCodeFileName = ESAA.generateKontaktTagebuchQRCode()
        showNewPage(theCurrentPage, showKontaktTagebuchQRCode)
    }

    function showNewPage(currentPage, nextPage)
    {
        if (currentPage == nextPage)
        {
            return;
        }
        theMultiButton.close()

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
            hideAndShowCallMenueButton.stop()
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
        height: parent.height / 16
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
                showcustomercard.index = index
                showNewPage(theCurrentPage, showcustomercard)
            }
        }
        EngagementStartPage
        {
            id: engagementstart
            onBackPressed: showNewPage(theCurrentPage, scannerpage)
            onOfferHelpClicked: {
                if (!JW78APP.loggedIn)
                {
                    loginAndOrRegister.goodPage = engagementOfferPage
                    loginAndOrRegister.backPage = engagementstart
                    showNewPage(theCurrentPage, loginAndOrRegister)
                    return
                }
                showNewPage(theCurrentPage, engagementOfferPage)
            }

        }
        EngagementOfferPage
        {
            id: engagementOfferPage
            onBackPressed: showNewPage(theCurrentPage, previousPage)
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
            x: scannerpage.x + JW78Utils.screenWidth / 300 * 150 - width / 2
            y: JW78Utils.screenHeight / 480 * 360 - height / 2
            visible: !ESAA.firstStart && scannerpage.visible
            texts: ["Kunden<br>karten", "", "Kontakt<br>situation<br>eintragen",
                "Kontakt<br>tagebuch<br>QR-Code", "Engagement"]
            optionCount: JW78APP.isDevelop ? 5 : 4
            yMoveOnOpen: JW78APP.isDevelop ? -smallWidth : smallWidth
            stepAngle: JW78APP.isDevelop ? 72 : 60
            clickEvents: [function() {showNewPage(scannerpage, customercardslist)},
            function() {ESAA.recommend()},
            function() {showNewPage(theCurrentPage, manualvisitpage)},
            function() {funcShowKontaktTagebuchQRCode()},
            function() {showNewPage(theCurrentPage, engagementstart)}]
            sources: ["", "qrc:/images/share_weiss.svg"]
            downSources: ["", "qrc:/images/share_blau.svg"]
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
        LoginAndOrRegister
        {
            id: loginAndOrRegister
            property var goodPage: null
            property var backPage: null
            onBackPressed: showNewPage(theCurrentPage, backPage)
            onLoginSuccessful: {
                showNewPage(theCurrentPage, goodPage)
                previousPage = backPage
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
            onBack: showNewPage(showKontaktTagebuchQRCode, previousPage)
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
            onShowKontaktTagebuchQRCode: funcShowKontaktTagebuchQRCode()
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

        function onYesNoQuestion(mt, yescallback, nocallback)
        {
            yesnoquestion.show(mt, yescallback, nocallback)
        }
        function onShowSendedData()
        {
            showNewPage(scannerpage, sendedDataPage)
        }
        function onShowWaitMessageSignal(mt)
        {
            waitMessage.show(mt)
        }
        function onHideWaitMessageSignal()
        {
            waitMessage.hide()
        }
        function onShowMessageSignal(mt, callback)
        {
            message.show(mt, callback)
        }
        function onShowBadMessageSignal(mt)
        {
            badMessage.show(mt)
        }
        function onValidQRCodeDetected()
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
        JW78Utils.screenHeight = height
        JW78Utils.screenWidth = width
        theCamera.stop()
        ESAA.calculateRatios()
    }
    onClosing: {
        close.accepted = false
    }
    Connections {
        target: Qt.application
        function onStateChanged()
        {
            if (Qt.application.state == Qt.ApplicationActive)
            {
                ESAA.dummyGet()
            }
        }
    }

    /*    Connections {
        target: Qt.inputMethod
        onVisibleChanged: {
//            if (!Qt.inputMethod.visible) rc.y = root.height-rc.height-dp(10)
            console.log("inputmthod.visible: " + Qt.inputMethod.visible)
            console.log("screenheight: " + JW78Utils.screenHeight)
            mainWindow.height = JW78Utils.screenHeight - Qt.inputMethod.keyboardRectangle.height / JW78Utils.getDevicePixelRatio()
            console.log("mainWindow.height2: " + mainWindow.height)
        }
        onKeyboardRectangleChanged: {
            console.log("keyboardRectangle.height: " + Qt.inputMethod.keyboardRectangle.height)
            mainWindow.height = JW78Utils.screenHeight - Qt.inputMethod.keyboardRectangle.height / JW78Utils.getDevicePixelRatio()
            console.log("mainWindow.height: " + mainWindow.height)
//            if (Qt.inputMethod.visible) {
//                rc.y = rc.y - 10 // keyboardY - (rc.height + dp(30) + _defaultNavBarHeight)
//                _keyY = rc.y
//            }
        }
    } */
}
