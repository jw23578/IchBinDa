import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import "qrc:/foundation"
import "qrc:/widgets"
import "Comp"

Item
{
    function open()
    {
        IDPGlobals.openCovers(profileRectangle)
    }
    function close()
    {
        IDPGlobals.closeCovers(profileRectangle)
    }
    function leave()
    {
        theMultiButton.close()
        backButtonClicked()
    }
    function setProfileImageSource(path)
    {
        profileImage.source = ""
        profileImage.source = path
    }

    signal backButtonClicked()
    signal profileImageClicked()
    opacity: 0

    property alias image: profileImage

    Rectangle {
        id: profileRectangle

        anchors.fill: parent
        IDPFlickable
        {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: backbutton.top
            anchors.margins: JW78APP.spacing
            id: theFlickable
            Column
            {
                width: theFlickable.width
                parent: theFlickable.contentItem
                spacing: IDPGlobals.spacing
                IDPCircleImage
                {
                    cache: false
                    id: profileImage
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width / 3
                    height: width
                    source: "qrc:/images/noProfileImage.svg"
                    onClicked: profileImageClicked()
                    coverContainer: profileRectangle
                }

                IDPLineEditWithTopCaption
                {
                    width: parent.width
                    caption: qsTr("Vorname")
                    text: MainPerson.fstname
                    containedCaption: true
                    coverContainer: profileRectangle
                    id: fstname
                }
                IDPLineEditWithTopCaption
                {
                    width: parent.width
                    caption: qsTr("Nachname")
                    text: MainPerson.surname
                    containedCaption: true
                    id: surname
                    coverContainer: profileRectangle
                }
                IDPLineEditWithTopCaption
                {
                    width: parent.width
                    caption: qsTr("Straße")
                    text: MainPerson.street
                    containedCaption: true
                    id: street
                    coverContainer: profileRectangle
                }
                IDPLineEditWithTopCaption
                {
                    width: parent.width
                    caption: qsTr("Hausnummer")
                    text: MainPerson.housenumber
                    containedCaption: true
                    id: housenumber
                    coverContainer: profileRectangle
                }
                IDPLineEditWithTopCaption
                {
                    width: parent.width
                    caption: qsTr("PLZ")
                    text: MainPerson.zip
                    containedCaption: true
                    id: zip
                    coverContainer: profileRectangle
                }
                IDPLineEditWithTopCaption
                {
                    width: parent.width
                    caption: qsTr("Ort")
                    text: MainPerson.location
                    containedCaption: true
                    id: location
                    coverContainer: profileRectangle
                }
            }
        }
        IDPButtonCircleMulti
        {
            function logoutYes()
            {
                leave()
            }
            function logoutNo()
            {

            }

            id: theMultiButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: JW78APP.spacing * 3
            visibleMasters: [false, false, true, false]
            texts: ["", "", qsTr("Logout"), ""]
            yMoveOnOpen: JW78Utils.screenWidth / 8
            clickEvents: [null, null,
                function() {
                    JW78APP.askYesNoQuestion(qsTr("Möchtest du dich wirklich ausloggen?"), logoutYes, logoutNo)
                    JW78APP.loggedIn = false
                    JW78APP.loginTokenString = ""
                }, null]
        }

        BackButton
        {
            id: backbutton
            onClicked: leave()
        }
    }
}
