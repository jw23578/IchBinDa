import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtMultimedia 5.15
import "QML"
import "QML/Comp"
import "QML/FinalPages"
import "QML/BasePages"
import "qrc:/foundation"
import "qrc:/widgets"
import "qrc:/windows"

ApplicationWindow
{
    IDPWindowLocationRadius
    {
        z: 1000
        y: 0
        opacity: 1
        id: devDings
        property bool inDev: visible
        visible: true
    }
    width: 300
    height: 480
    id: mainWindow
    visible: true
    title: qsTr("Ich bin da!")
    property var previousPage: null
    property var theCurrentPage: null
    function funcShowKontaktTagebuchQRCode()
    {
        if (MainPerson.fstname == "")
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

    property var pages: []

    function popPage()
    {
        pages.pop() // das ist immer theCurrentPage
        var lastPage = pages.pop()
        if (lastPage == loginAndOrRegister)
        {
            lastPage = pages.pop()
        }

        showNewPage(theCurrentPage, lastPage)
    }

    function showNewPage(currentPage, nextPage)
    {
        if (nextPage === scannerpage && cameraLoader.active == false)
        {
            cameraLoader.active = true
            return
        }
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
        pages.push(nextPage)
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

    ParallelAnimation {
        id: openProfile
        property int aniDuration: IDPGlobals.slowAnimationDuration
        NumberAnimation {
            target: theMultiButton
            property: "opacity"
            duration: openProfile.aniDuration
            to: 0
        }
        NumberAnimation {
            duration: openProfile.aniDuration
            target: rotation
            property: "angle"
            to: 35
        }
        NumberAnimation {
            duration: openProfile.aniDuration
            target: area1Hider
            property: "opacity"
            to: 0.3
        }
        SequentialAnimation
        {
            PauseAnimation {
                duration:  openProfile.aniDuration / 2
            }
            ParallelAnimation
            {
                NumberAnimation {
                    duration: openProfile.aniDuration
                    target: area2
                    property: "x"
                    to: 0
                }
                NumberAnimation {
                    duration: openProfile.aniDuration
                    target: area2
                    property: "opacity"
                    to: 0.9
                }
            }
        }
    }
    ParallelAnimation {
        id: closeProfile
        property int aniDuration: IDPGlobals.slowAnimationDuration
        NumberAnimation {
            duration: closeProfile.aniDuration
            target: area2
            property: "x"
            to: -area2.width
        }
        NumberAnimation {
            duration: closeProfile.aniDuration
            target: area2
            property: "opacity"
            to: 0
        }
        SequentialAnimation
        {
            PauseAnimation {
                duration:  closeProfile.aniDuration / 2
            }
            ParallelAnimation
            {
                NumberAnimation {
                    duration: closeProfile.aniDuration
                    target: rotation
                    property: "angle"
                    to: 0
                }
                NumberAnimation {
                    duration: closeProfile.aniDuration
                    target: area1Hider
                    property: "opacity"
                    to: 0
                }
                NumberAnimation {
                    target: theMultiButton
                    property: "opacity"
                    duration: openProfile.aniDuration
                    to: 1
                }
            }
        }
    }

    Item
    {
        id: area1
        anchors.fill: parent
        clip: true
        Rectangle {
            z: 100
            id: area1Hider
            anchors.fill: parent
            visible: opacity > 0
            opacity: 0
            MouseArea
            {
                anchors.fill: parent
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
                onBackPressed: popPage()
            }
            SaveCustomerCard
            {
                id: savecustomercard
                onBackPressed: {
                    var space = IDPGlobals.spacing * 2
                    cameraLoader.item.moveIn(space, 0, parent.width - 2 * space, 0, parent.width / 15,
                                             space, JW78Utils.screenHeight / 16 + IDPGlobals.spacing, parent.width - 2 * space, parent.width - 2* space, parent.width / 15)
                    takePictureForm.activate(cameraLoader.item, customercardslist.imageSaved, false)
                }
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
                function imageSaved(filename)
                {
                    console.log("saved: " + filename)
                    savecustomercard.imageFilename = "file:/"  + filename
                    cameraLoader.item.moveOut(cameraLoader.item.fromX,
                                              cameraLoader.item.fromY,
                                              cameraLoader.item.fromWidth,
                                              cameraLoader.item.fromHeight,
                                              cameraLoader.item.fromRadius)
                    showNewPage(theCurrentPage, savecustomercard)
                }
                onNewCard:
                {
                    var space = IDPGlobals.spacing * 2
                    cameraLoader.item.moveIn(space, 0, parent.width - 2 * space, 0, parent.width / 15,
                                             space, JW78Utils.screenHeight / 16 + IDPGlobals.spacing, parent.width - 2 * space, parent.width - 2* space, parent.width / 15)
                    takePictureForm.activate(cameraLoader.item, imageSaved, false)
                }
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
                onWantToHelpClicked: {
                    if (!JW78APP.loggedIn)
                    {
                        wantToHelpLoader.load()
                        loginAndOrRegister.goodPage = wantToHelpLoader.item
                        loginAndOrRegister.backPage = engagementstart
                        showNewPage(theCurrentPage, loginAndOrRegister)
                        return
                    }
                    wantToHelpLoader.goWantToHelp()
                    //                    showNewPage(theCurrentPage, myHelpOffersPage)
                }
            }
            Loader {
                anchors.fill: parent
                id: wantToHelpLoader
                function load()
                {
                    source = "qrc:/QML/FinalPages/WantToHelpPage.qml"
                }

                function goWantToHelp()
                {
                    load()
                    showNewPage(theCurrentPage, item)
                }
                Connections {
                    target: wantToHelpLoader.item
                    function onShowMyHelpOffersClicked()
                    {
                        myHelpOffersLoader.goMyHelpOffers()
                    }
                    function onCreateNewHelpOfferClicked()
                    {
                        myHelpOffersLoader.goMyHelpOffers()
                    }
                    function onSearchNeededHelpClicked()
                    {
                        console.log("hello3")
                    }
                    function onBackPressed()
                    {
                        popPage()
                    }

                }
            }
            Loader
            {
                anchors.fill: parent
                id: myHelpOffersLoader
                function load()
                {
                    source = "qrc:/QML/FinalPages/MyHelpOffersPage.qml"
                }

                function goMyHelpOffers()
                {
                    load()
                    showNewPage(theCurrentPage, item)
                }
                Connections
                {
                    target: myHelpOffersLoader.item
                    function onBackPressed()
                    {
                        popPage()
                    }
                }
            }
            ManualVisitPage
            {
                id: manualvisitpage
                onBackPressed: showNewPage(theCurrentPage, scannerpage)
            }

            ScannerPage
            {
                id: scannerpage
                camera: cameraLoader.item
                multiButton: theMultiButton
                onGoRightClicked: showNewPage(scannerpage, timemainpage)
            }

            LoginAndOrRegister
            {
                id: loginAndOrRegister
                //            opacity: 1
                //            x: 0
                //            y: 0
                //            z: 500
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

        IDPButtonCircle
        {
            id: callMenueButton
            visible: !ESAA.firstStart
            alertAniRunning: MainPerson.fstname == "" || ESAA.surname == ""
            repeatAlertAni: MainPerson.fstname == "" || ESAA.surname == ""
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
            onProfileIconClicked:
            {
                openProfile.start()
                scannerpage.myHideFunction()
            }

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
                        if (devDings.inDev)
                        {
                            return
                        }
                        showNewPage(null, scannerpage)
                    }
                }
            }
            onHelpClicked: showNewPage(theCurrentPage, firststart)
        }
        transform: Rotation {
            id: rotation
            origin.x: 0
            origin.y: height / 2
            axis {
                x: 0
                y: 1
                z: 0
            }
            angle: 0
        }
    }
    ItemProfile
    {
        id: area2
        width: parent.width
        height: parent.height
        x: -width
        onXChanged:
        {
            if (x == 0)
            {
                open()
            }
        }
        function profileImageSaved(filename)
        {
            setProfileImageSource("file:/" + filename)
            cameraLoader.item.moveOut(area2.image.x, area2.image.y, area2.image.width, area2.image.width, area2.image.radius)
        }

        onProfileImageClicked: {
            cameraLoader.item.moveIn(area2.image.x, area2.image.y, area2.image.width, area2.image.width, area2.image.radius,
                                     IDPGlobals.spacing * 2, IDPGlobals.spacing * 6, parent.width - 4 * IDPGlobals.spacing, parent.width - 4 * IDPGlobals.spacing,
                                     (parent.width - 2 * IDPGlobals.spacing) / 2)
            takePictureForm.activate(cameraLoader.item, profileImageSaved, true)
        }
        onBackButtonClicked:
        {
            close()
            closeProfile.start()
            if (theCurrentPage == scannerpage)
            {
                scannerpage.myShowFunction()
            }
        }
    }
    Background
    {
        id: takePictureForm
        anchors.fill: parent
        visible: opacity > 0
        opacity: 0
        property var camVideoScan: null
        property var imageSavedCallback: null
        function callbackProxy(filename)
        {
            deactivate()
            imageSavedCallback(filename)
        }

        property string targetFileName: ""
        Behavior on opacity {
            NumberAnimation {
                duration: IDPGlobals.slowAnimationDuration
            }
        }
        function activate(camVideoScan, imageSavedCallback, circle)
        {
            takePictureForm.opacity = 1
            takePictureForm.imageSavedCallback = imageSavedCallback
            takePictureForm.camVideoScan = camVideoScan
            camVideoScan.scan = false
            targetFileName = ESAA.tempTakenPicture
            camVideoScan.start()
            camVideoScan.height = camVideoScan.width
        }
        function deactivate()
        {
            cameraLoader.item.stop()
            opacity = 0
        }
        CentralActionButton
        {
            id: takePictureButton
            text: "Foto<br>aufnehmen"
            onClicked: cameraLoader.item.captureToFile(takePictureForm.targetFileName, takePictureForm.callbackProxy)
        }
        BackButton
        {
            onClicked:
            {
                cameraLoader.item.moveOut(cameraLoader.item.fromX,
                                          cameraLoader.item.fromY,
                                          cameraLoader.item.fromWidth,
                                          cameraLoader.item.fromHeight,
                                          cameraLoader.item.fromRadius)
                takePictureForm.deactivate()
            }
        }
    }
    Loader
    {
        active: false
        id: cameraLoader
        z: 10
        source: "qrc:/QML/Comp/CamVideoScan.qml"
        asynchronous: false
        onLoaded: {
            item.stop()
            showNewPage(theCurrentPage, scannerpage)
        }
        Connections {
            target: cameraLoader.item
            function onTagFound(tag) {
                scannerpage.tagFound(tag)
            }
        }
    }

    IDPButtonCircleMulti
    {
        z: 11
        opacity: 0
        id: theMultiButton
        x: scannerpage.x + JW78Utils.screenWidth / 300 * 150 - width / 2
        y: JW78Utils.screenHeight / 480 * 360 - height / 2
        visible: !ESAA.firstStart && scannerpage.visible && opacity > 0
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

    YesNoQuestionPage
    {
        id: yesnoquestion
        z: 20
    }
    Message
    {
        id: message
        z: 20
    }
    BadMessage
    {
        id: badMessage
        z: 20
    }
    WaitMessage
    {
        id: waitMessage
        z: 20
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
        console.log("completed")
        JW78Utils.screenHeight = height
        JW78Utils.screenWidth = width
        ESAA.calculateRatios()
        IDPGlobals.spacing = JW78APP.spacing
        IDPGlobals.screenWidth = width
        IDPGlobals.screenHeight = height
        IDPGlobals.buttonCircleFontPixelSize = JW78APP.fontButtonPixelsize * 0.8
        IDPGlobals.textFontColor = ESAA.fontColor
        IDPGlobals.textFontPixelSize = ESAA.fontTextPixelsize
        IDPGlobals.fontFamily = "Roboto-Regular"
        IDPGlobals.fontPixelSizeInput = JW78APP.fontInputPixelsize
        IDPGlobals.roundedDesignRadius = JW78APP.radius
        IDPGlobals.defaultBorderColor = JW78APP.lineInputBorderColor
        IDPGlobals.buttonCircleDownColor = JW78APP.buttonDownColor
        IDPGlobals.buttonCircleFromColor = JW78APP.buttonFromColor
        IDPGlobals.buttonCircleToColor = JW78APP.buttonToColor
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
