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
    id: postListItem

    width: parent.width
    height: contentLabel.height + units.gu(13.5)

    UserPictureShape {
        id: userPictureShape

        anchors {
            left: parent.left
            leftMargin: units.gu(2)
            top: parent.top
            topMargin: units.gu(2)
        }

        size: "small"
        userPicture: picture
        userColor: bgColor
    }

    Label {
        id: usernameLabel

        width: parent.width - units.gu(12)

        anchors {
            left: userPictureShape.right
            leftMargin: units.gu(1)
            top: userPictureShape.top
            topMargin: -units.gu(0.25)
        }

        text: username

        elide: Text.ElideRight
        font.bold: true
    }

    Label {
        id: timestampLabel

        width: parent.width - units.gu(12)
        height: implicitHeight

        anchors {
            left: userPictureShape.right
            leftMargin: units.gu(1)
            top: usernameLabel.bottom
            topMargin: -units.gu(0.25)
        }

        text: formatDateTime(timestampISO)
        color: theme.palette.normal.backgroundSecondaryText

        elide: Text.ElideRight
    }

    Label {
        id: contentLabel
        
        width: parent.width - units.gu(4)
        height: implicitHeight
        Layout.fillWidth: true

        anchors {
            top: userPictureShape.bottom
            topMargin: units.gu(2)
            horizontalCenter: parent.horizontalCenter
        }

        text: content
        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        onLinkActivated: Qt.openUrlExternally(link)
    }

    Item {
        id: actionsItem

        width: parent.width
        height: units.gu(6)

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }

        Row {
            width: implicitWidth
            height: units.gu(4)

            anchors {
                right: parent.right
                rightMargin: units.gu(2)
                verticalCenter: parent.verticalCenter
            }

            MouseArea {
                id: voteUpButton

                width: units.gu(2)
                height: units.gu(4)

                enabled: false

                Icon {
                    width: units.gu(1.75)
                    height: units.gu(1.75)

                    anchors.centerIn: parent

                    color: theme.palette.normal.baseText
                    name: "go-up"
                }
            }

            Label {
                id: votesLabel

                width: units.gu(3)
                height: units.gu(4)

                anchors.verticalCenter: parent.verticalCenter

                color: theme.palette.normal.activity
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                textSize: Label.Small
                text: votes
            }

            MouseArea {
                id: voteDownButton

                width: units.gu(2)
                height: units.gu(4)

                enabled: false

                Icon {
                    width: units.gu(1.75)
                    height: units.gu(1.75)

                    anchors.centerIn: parent

                    color: theme.palette.normal.baseText
                    name: "go-down"
                }
            }

            Item {
                width: units.gu(2)
                height: units.gu(4)
            }

            MouseArea {
                id: urlButton

                width: units.gu(2)
                height: units.gu(4)

                onClicked: Qt.openUrlExternally("https://forums.ubports.com/post/" + pid);

                Icon {
                    width: units.gu(1.75)
                    height: units.gu(1.75)

                    anchors.centerIn: parent

                    color: theme.palette.normal.baseText
                    name: "stock_link"
                }
            }

            Item {
                width: units.dp(1)
                height: units.gu(4)
            }
        }
    }
}