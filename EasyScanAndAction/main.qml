import QtQuick 2.13
import QtQuick.Window 2.13
import "QML"

Window {
    id: mainWindow
    visible: true
    width: 300
    height: 480
    title: qsTr("Ich bin da!")
    property var activePage: null
    property bool moveLeft: true
    Image
    {
        id: backgroundImage
        height: parent.height
        source: "qrc:/images/background2.jpg"
        fillMode: Image.PreserveAspectFit
        Behavior on x {
            NumberAnimation {
                duration: 400
            }
        }
    }
    function moveBackground()
    {
        var step = mainWindow.width / 4
        var tx = moveLeft ? backgroundImage.x - step : backgroundImage.x + step
        if (moveLeft)
        {
            if (tx < -backgroundImage.width + mainWindow.width)
            {
                tx = -backgroundImage.width + mainWindow.width
                moveLeft = false
            }
            backgroundImage.x = tx
            return
        }
        if (tx > 0)
        {
            tx = 0
            moveLeft = true
        }
        backgroundImage.x = tx
    }
    function showNewPage(currentPage, nextPage)
    {
        currentPage.z = 0
        nextPage.z = 1
        if (currentPage === splashscreen)
        {
            headerItem.initialAnimation()
        }
        else
        {
            headerItem.animate()
        }
        var direction = moveLeft
        currentPage.hide(direction)
        nextPage.show(direction)
        moveBackground()
        if (nextPage === scannerpage)
        {
            showCallMenueButton.start()
        }
        else
        {
            hideCallMenueButton.start()
        }
    }

    ESAAHeader
    {
        id: headerItem
        width: parent.width
        height: parent.height / 20
        visible: !agreepage.visible && !splashscreen.visible
    }

    Item
    {
        y: headerItem.height
        id: contentItem
        width: parent.width
        height: parent.height - y
        clip: true
        QuestionPage
        {
            id: questionpage
            onSaveContactData:
            {
                showNewPage(questionpage, scannerpage)
            }
            onAbort:
            {
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
        }
        CreateQRCodePage
        {
            id: createqrcodepage
            onClose: showNewPage(createqrcodepage, scannerpage)
            onShowCode: showNewPage(createqrcodepage, showqrcodepage)
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
                ESAA.locationName = "MeineDaten"
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
    }

    NumberAnimation {
        target: callMenueButton
        property: "anchors.verticalCenterOffset"
        duration: 1000
        easing.type: Easing.InOutQuint
        id: showCallMenueButton
        to: callMenueButton.width / 6
    }
    NumberAnimation {
        target: callMenueButton
        property: "anchors.verticalCenterOffset"
        duration: 1000
        easing.type: Easing.InOutQuint
        id: hideCallMenueButton
        to: width
    }
    Rectangle
    {
        color: ESAA.menueButtonColor
        border.color: ESAA.lineColor
        border.width: 1
        id: callMenueButton
        width: parent.width / 4
        radius: width /2
        height: width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: width
        anchors.verticalCenter: parent.bottom

        Image
        {
            source: "qrc:/images/burgermenue.svg"
            width: parent.width / 4
            height: width
            sourceSize.width: width
            sourceSize.height: height
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -parent.height / 3.3
        }

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                showNewPage(scannerpage, menuepage)
            }
        }
    }


    Message
    {
        id: message
    }
    AgreePage
    {
        id: agreepage
        onAgreed:
        {
            showNewPage(agreepage, firststart)
        }
    }

    SplashScreen
    {
        id: splashscreen
        onSplashDone:
        {
            if (!ESAA.aggrementChecked)
            {
                showNewPage(splashscreen, agreepage)
            }
            else
            {
                showNewPage(splashscreen, scannerpage)
            }
        }
    }
    Connections
    {
        target: ESAA
        onShowMessageSignal: message.show(mt)
        onScanSignal: scannerpage.show()
        onValidQRCodeDetected:
        {
            showNewPage(scannerpage, questionpage)
        }
    }
    Component.onCompleted:
    {
        ESAA.calculateRatios()
        ESAA.spacing = Screen.height / 70
        console.log("Spacing: " + ESAA.spacing)

        console.log("FontButtonPixelSize: " + ESAA.fontButtonPixelsize)
        splashscreen.start()
    }
}
