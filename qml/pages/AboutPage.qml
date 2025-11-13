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

Page {
    id: aboutPage

    header: PageHeader {
        id: aboutPageHeader

        title: i18n.tr("About")
    }

    Flickable {
        id: aboutFlickable

        anchors {
            fill: parent
            topMargin: aboutPageHeader.height
        }
        
        contentHeight: aboutCloumn.height

        Column {
            id: aboutCloumn
            
            width: parent.width
            
            spacing: units.gu(2)

            Item {
                width: parent.height
                height: units.gu(2)
            }

            LomiriShape {
                width: units.gu(15)
                height: units.gu(15)
                
                anchors.horizontalCenter: parent.horizontalCenter
                
                radius: "large"
                
                source: Image {
                    mipmap: true
                    source: "../icons/logo.svg"
                }
            }

            Item {
                width: nameAndVersionLayout.width
                height: nameAndVersionLayout.height
                
                anchors.horizontalCenter: parent.horizontalCenter

                ListItemLayout {
                    id: nameAndVersionLayout
                    
                    padding {
                        top: units.gu(0)
                        bottom: units.gu(2)
                    }

                    title.text: i18n.tr("InTouch")
                    title.font.pixelSize: units.gu(3)
                    title.color: theme.palette.normal.backgroundText
                    title.horizontalAlignment: Text.AlignHCenter

                    subtitle.text: i18n.tr("Version") + " " + root.version

                    subtitle.color: theme.palette.normal.backgroundTertiaryText
                    subtitle.font.pixelSize: units.gu(1.75)
                    subtitle.horizontalAlignment: Text.AlignHCenter
                }
            }
            Column {
                width: parent.width
                Repeater {
                    id: listViewAbout
                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    model: [
                    { name: i18n.tr("Source code"), url: "https://github.com/sanderklootwijk/intouch" },
                    { name: i18n.tr("Report issues"),  url: "https://github.com/sanderklootwijk/intouch/issues" }
                    ]

                    delegate: ListItem {
                        ListItemLayout {
                            title.text : modelData.name
                            ProgressionSlot {
                                width:units.gu(2)
                            }
                        }
                        onClicked: Qt.openUrlExternally(modelData.url)
                    }
                }
            }
        }
    }
}

