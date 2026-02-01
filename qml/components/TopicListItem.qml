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
import "."

ListItem {
    id: topicListItem

    width: parent.width
    height: units.gu(9)

    UserPictureShape {
        id: userPictureShape

        anchors {
            left: parent.left
            leftMargin: units.gu(2)
            verticalCenter: parent.verticalCenter
        }

        size: "large"
        userPicture: picture
        userColor: bgColor
    }

    Label {
        id: titleLabel

        width: pinned == 1 ? parent.width - units.gu(16) : parent.width - units.gu(12)

        anchors {
            left: userPictureShape.right
            leftMargin: units.gu(1)
            top: userPictureShape.top
        }

        text: title

        elide: Text.ElideRight
        font.bold: true
    }

    Item {
        id: postsIcon

        width: units.gu(2.25)
        height: units.gu(2.25)

        anchors {
            left: userPictureShape.right
            leftMargin: units.gu(1)
            top: titleLabel.bottom
        }

        Icon {
            width: units.gu(2)
            height: units.gu(2)

            anchors.centerIn: parent
            
            name: "message"
            color: theme.palette.normal.baseText
        }
    }

    Label {
        id: postsLabel

        width: pinned == 1 ? parent.width - units.gu(19) : parent.width - units.gu(15)
        height: implicitHeight

        anchors {
            left: postsIcon.right
            leftMargin: units.gu(0.5)
            verticalCenter: postsIcon.verticalCenter
        }

        text: postcount
        
        elide: Text.ElideRight
    }

    Item {
        id: dateIcon

        width: units.gu(2.25)
        height: units.gu(2.25)

        anchors {
            left: userPictureShape.right
            leftMargin: units.gu(1)
            top: postsIcon.bottom
        }

        Icon {
            width: units.gu(2)
            height: units.gu(2)

            anchors.centerIn: parent
            
            name: "clock"
            color: theme.palette.normal.baseText
        }
    }

    Label {
        id: dateLabel

        width: pinned == 1 ? parent.width - units.gu(19) : parent.width - units.gu(15)
        height: implicitHeight

        anchors {
            left: dateIcon.right
            leftMargin: units.gu(0.5)
            verticalCenter: dateIcon.verticalCenter
        }

        text: formatDateTime(lastposttimeISO)
        
        elide: Text.ElideRight
    }

    Icon {
        width: units.gu(2)
        height: units.gu(2)

        visible: pinned == 1

        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: units.gu(2)
        }

        name: "pinned"

        color: theme.palette.normal.baseText
    }
        
    onClicked: {
        // Avoid opening deleted topics
        if (deleted	== 0) {
            if (root.loggedIn) {
                markTopicAsRead(topicID);
            }

            pageStack.push(Qt.resolvedUrl("/pages/TopicPage.qml"), { topicSlug: slug });
        }
    }
}