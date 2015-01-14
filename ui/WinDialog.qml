import QtQuick 2.0

import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0


Component {
    Dialog {
        id: dialogue

        title: i18n.tr("Win!")
        text: i18n.tr("Congratulations!")

        Button {
            text: i18n.tr("Ok")
            onClicked: PopupUtils.close(dialogue)
        }
    }
}
