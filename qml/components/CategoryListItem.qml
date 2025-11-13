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
    id: categoryListItem

    width: parent.width
    height: {
        if (units.gu(2.25) + categoryDescriptionLabel.implicitHeight > units.gu(9)) {
            units.gu(2.25) + categoryDescriptionLabel.implicitHeight
        }
        else {
            units.gu(9)
        }
    }

    LomiriShape {
        id: categoryIconShape
        height: units.gu(7)
        width: units.gu(7)

        anchors {
            left: parent.left
            leftMargin: units.gu(2)
            top: parent.top
            topMargin: units.gu(1)
        }

        Image {
            id: categoryIcon

            height: units.gu(4)
            width: units.gu(4)

            anchors.centerIn: parent

            fillMode: Image.PreserveAspectFit
            source: "../icons/" + icon + ".svg"
        }

        ColorOverlay {
            anchors.fill: categoryIcon

            source: categoryIcon
            color: iconColor
        }

        backgroundColor: bgColor
        aspect: LomiriShape.Flat
        radius: "medium"
    }

    Label {
        id: categoryNameLabel

        width: parent.width - units.gu(12)

        anchors {
            left: categoryIconShape.right
            leftMargin: units.gu(1)
            top: categoryIconShape.top
        }

        text: name

        elide: Text.ElideRight
        font.bold: true
    }

    Label {
        id: categoryDescriptionLabel

        width: parent.width - units.gu(12)
        height: implicitHeight
        Layout.fillWidth: true

        anchors {
            left: categoryIconShape.right
            leftMargin: units.gu(1)
            top: categoryNameLabel.bottom
        }

        text: description

        textFormat: Text.PlainText
        wrapMode: Text.WordWrap
    }

    onClicked: {
        pageStack.push(Qt.resolvedUrl("/pages/CategoryPage.qml"), { categorySlug: slug });
    }
}