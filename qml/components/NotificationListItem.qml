/*
 * Copyright (C) 2025  Sander Klootwijk
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * intouch is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

ListItem {
    id: notificationListItem

    width: parent.width
    height: {
        if (units.gu(4.25) + titleLabel.implicitHeight > units.gu(9)) {
            units.gu(4.25) + titleLabel.implicitHeight
        }
        else {
            units.gu(9)
        }
    }

    UserPictureShape {
        id: userPictureShape

        anchors {
            left: parent.left
            leftMargin: units.gu(2)
            top: parent.top
            topMargin: units.gu(1)
        }

        size: "large"
        userPicture: picture
        userColor: bgColor
    }

    Label {
        id: titleLabel

        width: parent.width - units.gu(15)
        height: implicitHeight
        Layout.fillWidth: true

        anchors {
            left: userPictureShape.right
            leftMargin: units.gu(1)
            top: userPictureShape.top
        }

        text: title

        wrapMode: Text.WordWrap
    }

    Label {
        id: dateLabel

        width: parent.width - units.gu(15)

        anchors {
            left: userPictureShape.right
            leftMargin: units.gu(1)
            top: titleLabel.bottom
        }

        text: formatDateTime(datetimeISO)

        color: theme.palette.normal.backgroundSecondaryText
        textFormat: Text.PlainText
        wrapMode: Text.WordWrap
    }

    Rectangle {
        width: units.gu(1)
        height: units.gu(1)

        anchors {
            right: parent.right
            rightMargin: units.gu(2)
            top: parent.top
            topMargin: units.gu(2)
        }
        
        color: read ? "#00000000" : theme.palette.normal.activity
        border.color: read ? theme.palette.normal.base : theme.palette.normal.activity
        border.width: units.dp(1)
        radius: 50
    }

    onClicked: {
        notificationsPage.notificationsListModel.setProperty(index, "read", true);
        markTopicAsRead(topicID);
        pageStack.push(Qt.resolvedUrl("/pages/TopicPage.qml"), { topicSlug: topicID, initialPostID: postID });
    }
}