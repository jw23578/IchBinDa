import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../Comp"
import "../BasePages"
import "qrc:/windows"
import "qrc:/foundation"

PageWithBackButton
{
    caption: "Meine Hilfe"
    id: thePage
    states: [State {
            name: "offerHelp"
            PropertyChanges {
                target: theOfferPage
                visible: true
            }
            PropertyChanges {
                target: thePage
                caption: "Neue Hilfe anbieten"

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
    onShowed: theOfferPage.open()
    onHided: theOfferPage.close()
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
                    Column
                    {
                        anchors.fill: parent
                        ListView
                        {
                            id: offerTypesListView
                            model: HelpOffer.getOfferTypesCount()
                            property int elemWidth: IDPGlobals.screenWidth / 6 + IDPGlobals.spacing / 2
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: Math.min(parent.width, HelpOffer.getOfferTypesCount() * elemWidth)
                            height: elemWidth
                            orientation: ListView.Horizontal

                            delegate: Item
                            {
                                width: offerTypesListView.elemWidth
                                height: offerTypesListView.elemWidth
                                IDPTextCircle {
                                    width: IDPGlobals.screenWidth / 6
                                    text: qsTr(HelpOffer.getOfferType(index))
                                    fontSizeFactor: 0.6
                                }
                            }
                        }
                        IDPText
                        {
                            id: helpOfferCaption
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width - 2 * ESAA.spacing
                            text: HelpOffer.caption
                            elide: Text.ElideRight
                        }
                        IDPText
                        {
                            id: helpOfferDecription
                            horizontalAlignment: Text.AlignLeft
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width - 2 * ESAA.spacing
                            height: width / 2
                            text: HelpOffer.description
                            wrapMode: Text.WordWrap
                            clip: true
                        }
                        ListView
                        {
                            id: dayTimeSpanView
                            model: HelpOffer.getDayTimeSpans()
                            property int elemWidth: IDPGlobals.screenWidth / 6 + IDPGlobals.spacing / 2
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: Math.min(parent.width, HelpOffer.getOfferTypesCount() * elemWidth)
                            height: elemWidth
                            orientation: ListView.Horizontal

                            delegate: Item
                            {
                                width: offerTypesListView.elemWidth
                                height: offerTypesListView.elemWidth
                                IDPTextCircle {
                                    width: IDPGlobals.screenWidth / 6
                                    text: index
                                    fontSizeFactor: 0.6
                                }
                            }

                        }
                    }
                    IDPButtonCircleMulti
                    {
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        mainButtonLargeWidth: IDPGlobals.screenWidth / 7
                        id: theMultiButton
                        visibleMasters: [false, true, true]
                        texts: ["", qsTr("Bearbeiten"), qsTr("Löschen")]
                        yMoveOnOpen: 0
                        xMoveOnOpen: -JW78Utils.screenWidth / 3
                        clickEvents: [null, null,
                            function() {
                                question.callbackOpen("Soll das Hilfeangebot gelöscht werden?",
                                                      function() {
                                                          if (index == 0 && theRepeater.count > 1)
                                                          {
                                                              theSwipeView2.currentIndex = 1
                                                              deleteOfferByIndex(0)
                                                              return
                                                          }
                                                          deleteOfferByIndex(index)
                                                      }, function() {})
                            }, null]
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
        onClicked: {
            theOfferPage.open()
            parent.state = "offerHelp"
        }
    }
    IDPWindowQuestion {
        id: question
    }
}
