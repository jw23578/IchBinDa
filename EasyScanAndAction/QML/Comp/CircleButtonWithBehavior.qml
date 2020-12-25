import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15

CircleButton
{
    animationDuration: JW78Utils.shortAniDuration
    Behavior on x {
        NumberAnimation {
            duration: animationDuration
        }
    }
    Behavior on y {
        NumberAnimation {
            duration: animationDuration
        }
    }
    Behavior on width {
        NumberAnimation {
            duration: animationDuration
        }
    }

}
