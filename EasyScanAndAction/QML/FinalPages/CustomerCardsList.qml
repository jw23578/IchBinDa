import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../Comp"

ESAAPage {
    caption: "Kundenkarten"
    signal newCard;
    signal showCustomerCard(string name, string filename, int index)
    CircleButton
    {
        anchors.right: parent.right
        anchors.top: parent.top
        text: "alle karten<br>löschen"
        visible: JW78APP.isDevelop
        onClicked: JW78APP.deleteAllCustomerCards()
        z: 2
    }
    ESAAFlickable
    {
        id: theFlick
        visible: theRepeater.count > 3
        anchors.margins: ESAA.spacing
        anchors.bottom: newCard.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        contentHeight: theBigColumn.height
        Column
        {
            id: theBigColumn
            width: parent.width
            spacing: ESAA.spacing
            parent: theFlick.contentItem
            Repeater
            {
                id: theRepeater
                model: AllCustomerCards
                Item
                {
                    id: theItem
                    ParallelAnimation
                    {
                        id: deleteAni
                        NumberAnimation
                        {
                            target: theItem
                            property: "x"
                            to: -width
                            duration: JW78Utils.shortAniDuration
                        }
                        NumberAnimation
                        {
                            target: theItem
                            property: "height"
                            to: 0
                            duration: JW78Utils.shortAniDuration
                        }
                        onStopped: JW78APP.deleteCustomerCardByIndex(index)
                    }

                    Component.onCompleted:
                    {
                        console.log("created " + height)
                    }
                    height: theColumn.height
                    width: parent.width
                    Column
                    {
                        id: theColumn
                        width: parent.width
                        property int textWidth: width - cardName.height - JW78APP.spacing
                        Item
                        {
                            height: ESAA.spacing
                            width: parent.width
                        }
                        Item
                        {
                            width: parent.width
                            height: cardName.height
                            Image
                            {
                                height: parent.height
                                width: height
                                id: cardThumbnail
                                source: "file://" + Card.filename
                                fillMode: Image.PreserveAspectFit
                            }

                            ESAAText
                            {
                                text: Card.name
                                x: height + JW78APP.spacing
                                width: theColumn.textWidth
                                font.pixelSize: ESAA.headerFontPixelsize
                                color: JW78APP.headerFontColor
                                id: cardName
                                Behavior on width
                                {
                                    NumberAnimation
                                    {
                                        duration: JW78Utils.shortAniDuration
                                    }
                                }
                            }
                            CircleButton
                            {
                                id: deleteButton
                                anchors.right: parent.right
                                width: theColumn.height
                                anchors.verticalCenter: parent.verticalCenter
                                text: "Löschen"
                                opacity: (cardName.width - theColumn.textWidth) / -theItem.height
                                onClicked: {
                                    theMouseArea.downStartX = 0
                                    deleteAni.start()
                                }
                            }
                        }

                        Item
                        {
                            height: ESAA.spacing
                            width: parent.width
                        }

                        Rectangle
                        {
                            visible: index < theRepeater.count - 1
                            width: parent.width / 6
                            height: 1
                            color: "lightgrey"
                        }
                    }
                    MouseArea
                    {
                        id: theMouseArea
                        anchors.left: parent.left
                        anchors.top: parent.top
                        hoverEnabled: true
                        width: cardName.width
                        height: parent.height
                        anchors.horizontalCenterOffset: cardName.x
                        property bool wasGesture: false
                        onClicked: {
                            if (wasGesture)
                            {
                                return
                            }
                            if (cardName.width < theColumn.textWidth)
                            {
                                cardName.width = theColumn.textWidth
                                theMouseArea.downStartX = 0
                                return
                            }

                            showCustomerCard(Card.name, Card.filename, index)
                        }
                        property int downStartX: 0
                        onPressed:
                        {
                            wasGesture = false
                            downStartX = mouse.x
                            console.log("pressed downStartX: " + downStartX)
                        }
                        onMouseXChanged: {
                            if (downStartX - mouse.x > JW78Utils.screenWidth / 10)
                            {
                                wasGesture = true
                                cardName.width = theColumn.textWidth - theItem.height
                                mouse.accepted = true
                            }
                        }
                        onReleased:
                        {
                            console.log("downStartX: " + downStartX)
                            console.log("mouse.x: " + mouse.x)
                            console.log("diff: " + (downStartX - mouse.x))
                            if (downStartX - mouse.x > JW78Utils.screenWidth / 10)
                            {
                                wasGesture = true
                                cardName.width = theColumn.textWidth - theItem.height
                                mouse.accepted = true
                            }
                        }
                    }
                }
            }
        }

    }
    Item
    {
        id: noCardsItem
        visible: theRepeater.count == 0
        anchors.margins: ESAA.spacing
        anchors.bottom: newCard.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        SwipeView
        {
            id: theSwipeView
            anchors.top: parent.top
            anchors.bottom: indicator.top
            anchors.left: parent.left
            anchors.right: parent.right
            Image
            {
                id: itemA
                opacity: 1 - theSwipeView.contentItem.contentX / width
                source: "qrc:/images/kundenkarten_1.png"
                fillMode: Image.PreserveAspectFit
            }
            Image
            {
                id: itemB
                opacity: 1 - itemA.opacity
                source: "qrc:/images/kundenkarten_2.png"
                fillMode: Image.PreserveAspectFit
            }
        }
        PageIndicator
        {
            id: indicator
            height: JW78APP.spacing
            currentIndex: theSwipeView.currentIndex
            anchors.bottom: parent.bottom
            count: theSwipeView.count
            anchors.horizontalCenter: parent.horizontalCenter
            delegate: Rectangle
            {
                radius: width/ 2
                width: JW78APP.spacing
                height: width
                color: index == indicator.currentIndex ? JW78APP.buttonFromColor : JW78APP.buttonToColor
            }
        }
    }
    Loader
    {
        id: theLoader
        visible: theRepeater.count < 4 && theRepeater.count > 0
        anchors.margins: ESAA.spacing
        anchors.bottom: newCard.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
    }
    onShowing: {
        theLoader.source = ""
        theLoader.source = "../Comp/CustomerCardsSwipe.qml"
    }

    CentralActionButton
    {
        id: newCard
        text: "Neue<br>Karte"
        onClicked: parent.newCard()
    }

    BackButton
    {
        onClicked: backPressed()
    }
}
