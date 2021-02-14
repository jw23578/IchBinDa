import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../Comp"
import "../BasePages"
import "qrc:/foundation"
import "qrc:/windows"
import "qrc:/javascript/IDPFormatFunctions.js" as FormatFunctions

PageWithBackButton
{
    id: offerHelpPage
    signal helpOfferSaved()
    caption: "Hilfe anbieten"

    function open()
    {
        IDPGlobals.openCovers(helpType)
    }
    function close()
    {
        IDPGlobals.closeCovers(helpType)
    }
    ListModel {
        property int selectedCount: 0
        function countSelected()
        {
            selectedCount = 0;
            for (var i = 0; i < count; ++i)
            {
                if (get(i).selected)
                {
                    selectedCount += 1
                }
            }
        }

        id: theHelpModel
        ListElement
        {
            caption: qsTr("Einkaufen\ngehen")
            selected: false
        }
        ListElement
        {
            caption: qsTr("Medikamente\nabholen")
            selected: false
        }
        ListElement
        {
            caption: qsTr("Post\nwegbringen")
            selected: false
        }
        ListElement
        {
            caption: qsTr("Müll\nentsorgen")
            selected: false
        }
        ListElement
        {
            caption: qsTr("Haustier\nausführen")
            selected: false
        }
        ListElement
        {
            caption: qsTr("Begleitdienst")
            selected: false
        }
        ListElement
        {
            caption: qsTr("Sonstige\nHilfe")
            selected: false
        }
        ListElement
        {
            caption: qsTr("Weiter")
            selected: false
        }
    }
    SwipeView
    {
        id: theSwipeView
        anchors.margins: IDPGlobals.spacing
        anchors.bottom: backButton.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        interactive: false

        Item
        {
            id: helpType
            Column
            {
                anchors.fill: parent
                spacing: IDPGlobals.spacing
                IDPText
                {
                    width: parent.width - 2 * IDPGlobals.spacing
                    text: qsTr("WIE MÖCHTEST DU HELFEN?")
                    font.bold: true
                    fontSizeFactor: 2
                    wrapMode: Text.WordWrap
                    id: caption
                    coverContainer: helpType
                }
                GridView
                {
                    id: gridView
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 2 * cellWidth
                    cellWidth: IDPGlobals.screenWidth / 4 + IDPGlobals.spacing / 2
                    cellHeight: IDPGlobals.screenWidth / 4 + IDPGlobals.spacing / 2
                    height: parent.height - caption.height
                    model: theHelpModel
                    delegate: Item
                    {
                        width: gridView.cellWidth
                        height: gridView.cellHeight
                        IDPButtonCircleOnOff
                        {
                            anchors.centerIn: parent
                            text: model.caption
                            visible: model.caption != qsTr("Weiter")
                            onClicked: model.selected = !model.selected
                            coverContainer: helpType
                        }
                        IDPButtonCircle
                        {
                            anchors.centerIn: parent
                            text: model.caption
                            visible: model.caption == qsTr("Weiter")
                            coverContainer: helpType
                            onClicked:
                            {
                                theHelpModel.countSelected()
                                if (theHelpModel.selectedCount == 0)
                                {
                                    JW78APP.showBadMessage("Bitte wähle mindestens eine Art zu Helfen aus.")
                                    return
                                }
                                theSwipeView.currentIndex = 1
                                IDPGlobals.closeCovers(helpType)
                                IDPGlobals.openCovers(helpOffer)
                            }
                        }
                    }
                }
            }
        }
        Item
        {
            id: helpOffer
            Column
            {
                anchors.fill: parent
                spacing: IDPGlobals.spacing
                IDPText
                {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("DEIN ANGEBOT")
                    font.bold: true
                    fontSizeFactor: 2
                    coverContainer: helpOffer
                }
                ListView
                {
                    id: selectedListView
                    model: theHelpModel
                    property int elemWidth: IDPGlobals.screenWidth / 6 + IDPGlobals.spacing / 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Math.min(parent.width, theHelpModel.selectedCount * elemWidth)
                    height: elemWidth
                    orientation: ListView.Horizontal

                    delegate: Item
                    {
                        visible: model.selected
                        width: visible ? selectedListView.elemWidth : 0
                        height: selectedListView.elemWidth
                        IDPTextCircle {
                            width: IDPGlobals.screenWidth / 6
                            text: model.caption
                            fontSizeFactor: 0.6
                            coverContainer: helpOffer
                        }
                    }
                }
                IDPText
                {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("DEINE DATEN")
                    font.bold: true
                    fontSizeFactor: 2
                    coverContainer: helpOffer
                }
                IDPLineEditWithTopCaption
                {
                    containedCaption: true
                    id: name
                    width: parent.width
                    caption: qsTr("Vorname")
                    text: MainPerson.fstname
                    coverContainer: helpOffer
                }
                IDPLineEditWithTopCaption
                {
                    containedCaption: true
                    id: surname
                    width: parent.width
                    caption: qsTr("Nachname")
                    text: MainPerson.surname
                    coverContainer: helpOffer
                }
                IDPLineEditWithTopCaption
                {
                    containedCaption: true
                    id: phonenumber
                    width: parent.width
                    caption: qsTr("Telefonnummer")
                    text: JW78APP.mobile
                    coverContainer: helpOffer
                }
                IDPLineEditWithTopCaption
                {
                    containedCaption: true
                    id: email
                    width: parent.width
                    caption: qsTr("E-Mail-Adresse")
                    text: MainPerson.emailAdress
                    coverContainer: helpOffer
                }
                IDPText
                {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Wo möchtest du helfen:")
                    coverContainer: helpOffer
                    fontSizeFactor: 1.5
                }
                IDPTextBorder
                {
                    id: location
                    width: parent.width
                    height: email.height
                    text: "Ort wählen"
                    coverContainer: helpOffer
                    onClicked: locationRadius.open()
                }
                IDPButtonCircle
                {
                    text: qsTr("Weiter")
                    coverContainer: helpOffer
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked:
                    {
                        theSwipeView.currentIndex = 2
                        IDPGlobals.closeCovers(helpOffer)
                        IDPGlobals.openCovers(helpTime)
                    }
                }
            }
        }
        Item
        {
            id: helpTime
            Column
            {
                id: helpTimeColumn
                property int elemWidth: width / 5
                property int elemHeight: IDPGlobals.screenHeight / 14
                property int circleSize: elemHeight * 0.9
                property double captionFontSizeFaktor: 0.8
                anchors.fill: parent
                anchors.margins: IDPGlobals.spacing
                IDPText
                {
                    width: parent.width - 2 * IDPGlobals.spacing
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("An welchen Tagen und Tageszeit kannst du deine Hilfe anbieten?")
                    font.bold: true
                    fontSizeFactor: 1.5
                    wrapMode: Text.WordWrap
                    coverContainer: helpTime
                }
                Item
                {
                    height: IDPGlobals.spacing
                    width: parent.width
                }
                Item
                {
                    width: parent.width
                    height: dayColumn.height
                    Column
                    {
                        id: dayColumn
                        visible: true
                        width: parent.width
                        Row
                        {
                            id: timesRow2
                            Item
                            {
                                id: firstTimeItem
                                width: helpTimeColumn.elemWidth
                                height: helpTimeColumn.elemWidth / 2
                            }
                            Item
                            {
                                width: helpTimeColumn.elemWidth
                                height: firstTimeItem.height
                                Column
                                {
                                    width: parent.width
                                    IDPText
                                    {
                                        text: "Vormittag"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        coverContainer: helpTime
                                        font.bold: true
                                        fontSizeFactor: helpTimeColumn.captionFontSizeFaktor
                                    }
                                    IDPText
                                    {
                                        text: "8-11 Uhr"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        coverContainer: helpTime
                                        fontSizeFactor: helpTimeColumn.captionFontSizeFaktor
                                    }
                                }
                            }
                            Item
                            {
                                width: helpTimeColumn.elemWidth
                                height: firstTimeItem.height
                                Column
                                {
                                    width: parent.width
                                    IDPText
                                    {
                                        text: "Mittag"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        coverContainer: helpTime
                                        font.bold: true
                                        fontSizeFactor: helpTimeColumn.captionFontSizeFaktor
                                    }
                                    IDPText
                                    {
                                        text: "11-14 Uhr"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        coverContainer: helpTime
                                        fontSizeFactor: helpTimeColumn.captionFontSizeFaktor
                                    }
                                }
                            }
                            Item
                            {
                                width: helpTimeColumn.elemWidth
                                height: firstTimeItem.height
                                Column
                                {
                                    width: parent.width
                                    IDPText
                                    {
                                        text: "Nachmittag"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        coverContainer: helpTime
                                        font.bold: true
                                        fontSizeFactor: helpTimeColumn.captionFontSizeFaktor
                                    }
                                    IDPText
                                    {
                                        text: "14-17 Uhr"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        coverContainer: helpTime
                                        fontSizeFactor: helpTimeColumn.captionFontSizeFaktor
                                    }
                                }
                            }
                            Item
                            {
                                width: helpTimeColumn.elemWidth
                                height: firstTimeItem.height
                                Column
                                {
                                    width: parent.width
                                    IDPText
                                    {
                                        text: "Abend"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        coverContainer: helpTime
                                        font.bold: true
                                        fontSizeFactor: helpTimeColumn.captionFontSizeFaktor
                                    }
                                    IDPText
                                    {
                                        text: "17-21 Uhr"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        coverContainer: helpTime
                                        fontSizeFactor: helpTimeColumn.captionFontSizeFaktor
                                    }
                                }
                            }
                        }
                        Repeater
                        {
                            id: daysRepeater
                            model: 7
                            Row
                            {
                                property int dayIndex: index
                                height: helpTimeColumn.elemHeight
                                id: dayRow
                                Item
                                {
                                    width: helpTimeColumn.elemWidth
                                    height: helpTimeColumn.elemHeight
                                    IDPTextCircle
                                    {
                                        anchors.centerIn: parent
                                        width: helpTimeColumn.circleSize
                                        text: JW78Utils.shortDayOfWeek(JW78Utils.incDays(new Date(2021, 1, 1), index))
                                        coverContainer: helpTime
                                        fontSizeFactor: 0.8
                                    }
                                }
                                Repeater
                                {
                                    model: 4
                                    id: timesRepeater
                                    Item
                                    {
                                        property int timeIndex: index
                                        width: helpTimeColumn.elemWidth
                                        height: helpTimeColumn.elemHeight
                                        IDPButtonCircleOnOff
                                        {
                                            anchors.centerIn: parent
                                            width: helpTimeColumn.circleSize
                                            coverContainer: helpTime
                                            onClicked: {
                                                var day = new Date(2021, 2, 8)
                                                day.setDate(day.getDate() + dayRow.dayIndex);
                                                var since = null
                                                if (parent.timeIndex == 0)
                                                {
                                                    since = new Date(2021, 2, 8, 8);
                                                }
                                                if (parent.timeIndex == 1)
                                                {
                                                    since = new Date(2021, 2, 8, 11);
                                                }
                                                if (parent.timeIndex == 2)
                                                {
                                                    since = new Date(2021, 2, 8, 14);
                                                }
                                                if (parent.timeIndex == 3)
                                                {
                                                    since = new Date(2021, 2, 8, 17);
                                                }
                                                var until = null
                                                if (parent.timeIndex == 0)
                                                {
                                                    until = new Date(2021, 2, 8, 11);
                                                }
                                                if (parent.timeIndex == 1)
                                                {
                                                    until = new Date(2021, 2, 8, 14);
                                                }
                                                if (parent.timeIndex == 2)
                                                {
                                                    until = new Date(2021, 2, 8, 17);
                                                }
                                                if (parent.timeIndex == 3)
                                                {
                                                    until = new Date(2021, 2, 8, 21);
                                                }

                                                DayTimeSpanModel.addDayTimeSpan(day, since, until)
                                                console.log(dayRow.dayIndex + "  " + parent.timeIndex)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Flickable
                    {
                        id: inividualTimesFlickable
                        visible: !dayColumn.visible
                        width: parent.width
                        height: parent.height
                        contentHeight: timesColumn.height
                        clip: true
                        Column
                        {
                            id: timesColumn
                            Repeater
                            {
                                id: timeRepeater
                                model: DayTimeSpanModel
                                Row
                                {
                                    id: timeRow
                                    spacing: IDPGlobals.spacing
                                    Item
                                    {
                                        width: helpTimeColumn.elemWidth * 1.5
                                        height: helpTimeColumn.elemHeight
                                        IDPTextBorder
                                        {
                                            id: dayButton
                                            anchors.centerIn: parent
                                            height: parent.height - IDPGlobals.spacing
                                            width: parent.width
                                            text: DTS.getDay(DTS.day)
                                            onClicked: {
                                                currentDayButton = dayButton
                                                selectForm.caption = qsTr("Wochentag wählen")
                                                selectForm.delegate = selectForm.circleDelegate
                                                selectForm.model = selectForm.selectModelWeekdays
                                                selectForm.open()
                                            }
                                        }
                                    }
                                    Item
                                    {
                                        width: helpTimeColumn.elemWidth * 1.2
                                        height: helpTimeColumn.elemHeight
                                        IDPTextBorder
                                        {
                                            id: sinceButton
                                            anchors.centerIn: parent
                                            height: parent.height - IDPGlobals.spacing
                                            width: parent.width
                                            text: DTS.getSince(DTS.since)
                                            onClicked: {
                                                currentDTS = DTS
                                                selectTime.since = true
                                                selectTime.open(DTS.since.getHours(), DTS.since.getMinutes())
                                            }
                                        }
                                    }
                                    Item
                                    {
                                        width: helpTimeColumn.elemWidth * 1.2
                                        height: helpTimeColumn.elemHeight
                                        IDPTextBorder
                                        {
                                            id: untilButton
                                            anchors.centerIn: parent
                                            height: parent.height - IDPGlobals.spacing
                                            width: parent.width
                                            text: DTS.getUntil(DTS.until)
                                            onClicked: {
                                                currentDTS = DTS
                                                selectTime.since = false
                                                selectTime.open(DTS.until.getHours(), DTS.until.getMinutes())
                                            }
                                        }
                                    }
                                    Item
                                    {
                                        width: helpTimeColumn.circleSize
                                        height: helpTimeColumn.elemHeight
                                        IDPTextCircle
                                        {
                                            visible: index > 0
                                            anchors.centerIn: parent
                                            width: helpTimeColumn.circleSize
                                            text: "-"
                                            onClicked: timeRepeater.model = timeRepeater.count - 1
                                        }
                                    }
                                }
                            }
                            Item
                            {
                                width: helpTimeColumn.elemWidth
                                height: helpTimeColumn.elemHeight
                                IDPTextCircle
                                {
                                    anchors.centerIn: parent
                                    width: helpTimeColumn.circleSize
                                    text: "+"
                                    onClicked: timeRepeater.model = timeRepeater.count + 1
                                }
                            }
                        }

                    }
                }

                Item
                {
                    width: parent.width
                    height: IDPGlobals.spacing
                }
                IDPText
                {
                    anchors.right: parent.right
                    anchors.rightMargin: IDPGlobals.spacing
                    fontSizeFactor: 1.1
                    text: dayColumn.visible ? qsTr("Uhrzeiten individuell festlegen") :
                                              qsTr("Uhrzeiten schnell festlegen")
                    clickable: true
                    coverContainer: helpTime
                    onClicked:
                    {
                        if (!dayColumn.visible)
                        {
                            question.callbackOpen("Sollen die individuellen Zeiten verworfen werden?",
                                                  function(){console.log("yes")},
                                                  null,
                                                  function(){console.log("abort")})
                            return
                        }
                        dayColumn.visible = !dayColumn.visible
                        cover.visible = false
                    }
                    coverColor: "red"
                }
                Item
                {
                    width: parent.width
                    height: IDPGlobals.spacing
                }
                IDPButtonCircle
                {
                    text: qsTr("Angebot\nerstellen")
                    width: IDPGlobals.screenWidth / 5
                    coverContainer: helpTime
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    BackButton
    {
        visible: theSwipeView.currentIndex > 0 && selectForm.visible == false
        onClicked: {
            if (theSwipeView.currentIndex == 2)
            {
                IDPGlobals.closeCovers(helpTime)
                IDPGlobals.openCovers(helpOffer)
            }

            if (theSwipeView.currentIndex == 1)
            {
                IDPGlobals.closeCovers(helpOffer)
                IDPGlobals.openCovers(helpType)
            }
            theSwipeView.currentIndex = theSwipeView.currentIndex - 1
        }
    }
    property var currentDayButton: null
    IDPSelectForm
    {
        id: selectForm
        anchors.fill: parent
        onSelected: {
            currentDayButton.text = caption
        }
    }
    property var currentDTS: null
    IDPSelectTime
    {
        id: selectTime
        minuteStep: 5
        property bool since: false
        onSelectedHourMinutes: {
            if (since)
            {
                currentDTS.since = new Date(2000, 1, 1, hour, minutes)
            }
            else
            {
                currentDTS.until = new Date(2000, 1, 1, hour, minutes)
            }
        }
    }
    IDPWindowQuestion
    {
        id: question
    }
    IDPWindowLocationRadius {
        id: locationRadius
        BackButton {
           onClicked: parent.close()
        }
        DoneButton {
            onClicked: {
                parent.close()
                location.text = locationRadius.currentPositionText
            }
        }
    }
}
