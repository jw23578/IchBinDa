import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../Comp"
import "../BasePages"

PageWithBackButton
{
    caption: "Hilfe anbieten"
    id: thePage
    states: [State {
            name: "offerHelp"
            PropertyChanges {
                target: theOfferPage
                visible: true
            }
        }
    ]
    property int changeCounter: 1
    EngagementOfferPage
    {
        x: 0
        y: 0
        id: theOfferPage
        onBackPressed: {
            if (MyHelpOffers.count == 0)
            {
                parent.backPressed()
                return
            }
            thePage.state = ""
        }
        onHelpOfferSaved: {
            thePage.state = ""
        }
        opacity: 1
        visible: MyHelpOffers.count == 0
    }
    function deleteOfferByIndex(index)
    {
        HelpOfferManager.deleteHelpOfferByIndex(index);
        thePage.state = ""
    }


    Item
    {

        visible: !theOfferPage.visible
        anchors.margins: ESAA.spacing
        anchors.bottom: addHelpButton.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        SwipeView
        {
            id: theSwipeView2
            anchors.top: parent.top
            anchors.bottom: indicator.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: JW78APP.spacing
            clip: true
            Repeater
            {
                id: theRepeater
                model: MyHelpOffers
                delegate: Rectangle {
                    opacity: 1 - Math.abs((index * width - theSwipeView2.contentItem.contentX) / width)
                    id: card1Item
                    ESAAText
                    {
                        id: helpOfferCaption
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width - 2 * ESAA.spacing
                        text: HelpOffer.caption
                        elide: Text.ElideRight
                    }
                    ESAAText
                    {
                        id: helpOfferDecription
                        anchors.left: parent.left
                        anchors.top: helpOfferCaption.bottom
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.margins: ESAA.spacing
                        text: HelpOffer.description
                        wrapMode: Text.WordWrap
                    }
                    CircleButton
                    {
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        text: "Löschen"
                        onClicked: {
                            if (index == 0 && theRepeater.count > 1)
                            {
                                theSwipeView2.currentIndex = 1
                                deleteOfferByIndex(0)
                                return
                            }
                            deleteOfferByIndex(index)
                        }
                    }
               }
            }
        }
        PageIndicator
        {
            id: indicator
            height: JW78APP.spacing
            currentIndex: theSwipeView2.currentIndex
            anchors.bottom: parent.bottom
            count: theSwipeView2.count
            anchors.horizontalCenter: parent.horizontalCenter
            delegate: Item {
                width: JW78APP.spacing
                height: width
                Rectangle
                {
                    anchors.centerIn: parent
                    radius: width/ 2
                    width: index == indicator.currentIndex ? JW78APP.spacing : JW78APP.spacing / 2
                    Behavior on width {
                        NumberAnimation {
                            duration: JW78Utils.shortAniDuration
                        }
                    }

                    height: width
                    color: index == indicator.currentIndex ? JW78APP.buttonFromColor : JW78APP.buttonToColor
                }
            }
        }
    }
    CentralActionButton
    {
        id: addHelpButton
        text: "Weitere Hilfe\nanbietem"
        visible: !theOfferPage.visible
        onClicked: parent.state = "offerHelp"
    }
}
