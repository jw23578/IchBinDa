import QtQuick 2.0
import ".."
import "../Comp"

ESAAPage
{
    property alias backButton: theBackbutton
    BackButton
    {
        id: theBackbutton
        onClicked: backPressed()
        visible: opacity > 0
        Behavior on opacity {
            NumberAnimation {
                duration: JW78Utils.longAniDuration
            }
        }
    }
}
