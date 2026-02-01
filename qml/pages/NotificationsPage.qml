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
import QtWebEngine 1.11
import "../components"

Page {
    id: notificationsPage

    property alias notificationsListModel: notificationsListModel

    property bool notificationsLoading: false
    property bool unread: false
    property int currentPage: 0
    property int pageCount: 0

    header: PageHeader {
        id: notificationsPageHeader
        title: i18n.tr("Notifications")

        leadingActionBar.actions: [
            Action {
                iconName: "back"
                onTriggered: {
                    pageStack.pop();
                    notificationsFlickable.contentY = 0;
                    fetchNotifications(1);
                }
            }
        ]
    }

    ProgressBar {
        visible: notificationsLoading

        anchors {
            top: notificationsPageHeader.bottom
            left: parent.left
            right: parent.right
        }

        indeterminate: true
    }

    ListModel {
        id: notificationsListModel
    }

    Flickable {
        id: notificationsFlickable

        anchors {
            fill: parent
            topMargin: notificationsPageHeader.height
        }

        contentWidth: notificationsColumn.width
        contentHeight: notificationsColumn.height

        Column {
            id: notificationsColumn

            width: notificationsPage.width

            Repeater {
                model: notificationsListModel
                delegate: NotificationListItem {}
            }
        }

        onAtYEndChanged: {
            if (currentPage < pageCount && !notificationsLoading) {
                fetchNotifications(currentPage + 1);
            }
        }
    }

    Scrollbar {
        id: notificationsScrollbar

        flickableItem: notificationsFlickable
        align: Qt.AlignTrailing
    }

    function fetchNotifications(page) {
        notificationsLoading = true;
        
        webEngineViewPage.accountWebView.runJavaScript(`
                    (function() {
                        var xhr = new XMLHttpRequest;
                        xhr.open("GET", "https://forums.ubports.com/api/notifications?page=${page}", true);

                        xhr.onreadystatechange = function() {
                            if (xhr.readyState === XMLHttpRequest.DONE) {
                                if (xhr.status === 200) {
                                    console.warn(xhr.responseText);
                                } else {
                                    console.warn("Failed to fetch notifications:", xhr.status, xhr.statusText);
                                }
                            }
                        };

                        xhr.send();
                    })();
                `);
    }

    function parseNotifications(msg) {
        let data = JSON.parse(msg);
        let notifications = data.notifications;

        let hasUnread = false;

        currentPage = data.pagination.currentPage;
        pageCount = data.pagination.pageCount;

        if (currentPage === 1) {
            notificationsListModel.clear();
        }

        for (let i = 0; i < notifications.length; i++) {
            notificationsListModel.append({
                "title": notifications[i].bodyShort,
                "datetimeISO": notifications[i].datetimeISO,
                "read": notifications[i].read,
                "picture": notifications[i].user.picture == null ? "" : "https://forums.ubports.com/" + notifications[i].user.picture,
                "username": notifications[i].user.username,
                "bgColor": notifications[i].user["icon:bgColor"],
                "usernameText": notifications[i].user["icon:text"],
                "topicID": notifications[i].tid,
                "postID": notifications[i].pid
            });

            if (!notifications[i].read) {
                hasUnread = true;
            }
        }

        notificationsPage.unread = hasUnread;

        notificationsLoading = false;
    }
}